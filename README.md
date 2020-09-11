# Nexus Platform with Docker Support, behind Nginx

This is a template for deploying Nexus Repository Manager and Nexus IQ Server behind an NGINX proxy to offload SSL using Docker Compose. Additional itegrations are also in this reference but are be commented out to simplify the initial experience.

I also add a few aliases to my /etc/hosts file to simulate DNS from outside of docker host but the apps are accessible over http wtihout them. If you're on Windows the file is here, c:\windows\system32\drivers\etc\hosts.

```
127.0.0.1      localhost iq-server nexus registry jira jenkins ssc
```

## Operations

I've set my Docker Desktop to use 4 CPU's, 4 GB of Ram with a 1GB swap.

Here is a [cheatsheat](https://www.cheatography.com/gambit/cheat-sheets/docker/) for the Docker Command line.

But I highly reccomend you use VSCode with the Docker extension installed as it provides easy visibility and management of images and containers. I live in VSCode to manage docker images, edit the project, and start/stop my environment. https://code.visualstudio.com/docs/azure/docker

#### URL's

- Nexus Repo Web UI with SSL accessible via https://nexus
- Nexus Repo Web UI over http via http://localhost:8081
- Nexus IQ Server accessible via http://localhost:8070 or https://iq-server
- Docker proxy group registry accessible via https://registry
- Docker Private Registry accessible via registry:5000  (docker push, not browser. Don't forget to docker login, I always do ;-)

 _NOTE: I'm using a self-signed cert so you'll need to click past tha the first time using HTTPS. Chrome can be particularly difficult but this [article](https://medium.com/@dblazeski/chrome-bypass-net-err-cert-invalid-for-development-daefae43eb12) can help_

#### Persistent Volumes

One last thing before we get started. I've created a convention of putting all of the persistent volumes in a hidden folder in my home folder. This where you'll find the persistent volumes for most everything except Jenkins which uses the ~/.jenkins folder for setting and workspaces. If you can't see these hidden folders in your Finder, press Command+Shift+Period to toggle on/off
```
~/.demo-pv
  + /iq-data
  + /iq-logs
  + /nexus-data
```

It's not clear to me how these work on a windows machine but check your settings for shared drives in Docker Settings. For info check out Getting Started at: https://docs.docker.com/docker-for-windows/


## Initial Setup

#### First lets start NXRM
```
docker-compose up -d nexus   #Start just the 'nexus' service  
```
It can take a minute or two to start. To view the logs I tend to use Kitematic or via the Docker extension in VSCode. Once it is started you should be able to hit it via http://localhost:8081 or if you've updated your /etc/hosts file, http://nexus:8081. Nginx isn't running yet so we can do https with SSL yet.

You'll need to ge the password from ~/.demo-pv/nexus-data to log in the first time.

#### Now lets start IQ
```
➜ docker-compose up -d iq-server
Creating network "npr_default" with the default driver
Creating npr_iq-server_1 ... done
```
The first thing we see is that docke-compose creates 'network', named 'npr_default' (because I put the project in a folder named npr to shorten the name). If you haven't changed the folder name you'll see 'nexus_platform_reference_default' for a network name. This is the same network that NXRM was put on so they'll be able to talk to each other.

Now you can log in as admin/admin123 at http://localhost:8070. The first thing you're greated with in IQ is the need to install a license. You'll also want to install that license into NXRM if you have a license for Firewall or NXRM Pro. In Nexus RM you can configure NXRM to talk to IQ at http://iq-server:8070, the reason iq-server is also in etc/hosts is so that when you click on a firewall link, it will also resolve in your browser (which is outside of docker and doesn't have the same DNS suuport, so we just mimic it). If you haven't updated your /etc/hosts file yet, now is the time! ;-)

Since this project supports training and PoC environments, we have externalized the config.yml file from the container by mounting the project folder in addition to the persistent volumes. I already set the BaseURL in this projects config.yml file, but if you want or need to make a change to it all you have to do is stop the container, make and edit then restart to pick up the changes.

The last piece is to start the Nginx proxy assuming you've already edited your etc.hosts file ;-)
```
docker-compose up -d demo
```
This container makes it's own self-signed cert so you'll have to push past the warning in your browser. If Chrome doesn't want to let you past you just need to click on the window and type "thisisusafe" ENTER.

You should now have a fully functioning Nexus Platform

To stop, use docker-compose:

```
docker-compose down
```

Subsequent runs can use docker-compose to start the 'demo' service which is nginx which in turn depends on IQ and NXRM

```
docker-compose up -d demo      #Starts NXRM and IQ with nginx because of the 'depends on' parameter
```

One of the advantages of docker-compose, in addition to all the typing it saves, when you run 'docker-compose down' it cleans up everything as well. It both stops and removes all of the containers and finishes by removing the network it created.

```
➜ docker-compose down                                                            
Stopping npr_demo_1      ... done
Stopping npr_iq-server_1 ... done
Stopping npr_nexus_1     ... done
Removing npr_demo_1      ... done
Removing npr_iq-server_1 ... done
Removing npr_nexus_1     ... done
Removing network npr_default
```

#### Docker CLI equivalent

If your more of a CLI person, here are all of the commands you'd have to run to recreate what 'docker-compose up -d demo does:
```
docker network create npr_default
docker run --network=npr_default -v ~/.demo-pv/nexus-data:/nexus-data -p 8081:8081 -p 18443:18443 sonatype/nexus3:3.23.0
docker run --network=npr_default -v ~/.demo-pv/iq-data:/sonatype-work -v ~/.demo-pv/iq-logs:/opt/sonatype/nexus-iq-server/log -v .:/etc/nexus-iq-server/ -p 8070:8070 -p 8071:8071 sonatype/nexus-iq-server:1.91.0
docker run --network=npr_default -p 443:443 -p 5000:5000 -p 8011:8011 sonatype-se/sonatype_nginx-proxy:2.6.3 <-- Note- this needs to be built and tagged first
```
#### SSL Certificates

The Ngnix docker image build process generates insecure SSL certificates with fake location information and CNAME of localhost. Understand the risks of using these SSL certificates before proceeding. A deployed solution should use a valid CA certificate.

## Advanced

There are additional services defined within the docker-compose file, some commented out but other ready to run. In addition to Jenkins that was mentioned earlier, there are also services defined for Victoria, Clair, Anchore, JIRA, and Webhook Listener examples.

#### Upgrading Software

#### Jenkins

We use the Blueocean image for Jenkins. If you already had a working local install figure out where the jenkins_home folders is/was. For me it was in my home folder ~/.jenkins but I think newer versions may have used another user account. Either move your old install to ~/.jenkins or update the pv in the docker-compose file to point to where it is.

I run Jenkins outside of Docker (local app) which allow it to hit the Nexus repo through Nginx so Docker repos work. Jenkins is also in the docker-compose file and can be run from there too. It is set to use the same jenkins work folder so you can even switch back and forth.


#### JIRA
Here we use the public JIRA image so I just followed their documentation. Once running go through the wizard and you'll need to gewt a license from Atlassian ( https://www.atlassian.com/purchase/product/jira-software ). It is $10/yr for a 10 user license of JIRA Software 'Server'.

JIRA will come up on localhost:8080 but I've added jira to etc/host to match the docker dns name. You should be able to hit at http://jira:8080 and then set it's base url to match to make the 'gadgets' error go away.

#### Microfocus Software Security Center (SSC)
The container for this is in a private MF repo that you need to have access to and is targeted for Micro Focus and Sonatype technical sales and training folks. Once you have access and a trial license here is how to get it running

Start the container, maybe all by itself, with ```docker-compose up ssc``` and watch the logs for this:
```
MySQL setup=> An empty or uninitialized MySQL volume is detected in /fortify=> Installing MySQL ...=> Done!
MySQL schema creation
DB running, creating users + applying schema
mysql: [Warning] Using a password on the command line interface can be insecure.
DB init done
shutting db down
SSC setup
Waiting for license..
```
...copy your valid fortify.license file to ./demo-pv/fortify and the installation will finish.

Go to http://localhost:8888/ssc to log in for the first time (admin/admin). It will ask you to change your password, make a note as you'll need it for the ```iqproperties``` file in the Integration Service project.

#### SSC Integration Service
The integration Service is a stand alone application/process that can extract data from IQ and send it to SSC. You can download the same bundle we provide to customers at the Micro Focus Marketplace ( https://marketplace.microfocus.com/fortify/category/Opensource ). The download bundle will have it's own instruction for installing the plugin and how to configure and run the service. This project will try to stay up-to-date with the releases but for testing or upgrades you may need to drop in new binaries. Both binaries (parser plugin and intsvc) in this project should be the latest ones

I suggest mapping you webgoat app to the Bill Paymenrt Processer as it is really webgoat data underneath so all together it should be fairly coherent.

To Start the Integration Service you can use ```docker-compose up -d intSvc```. This will start the iq-server, if it isn't already running, and the SSC container along with the integration.

Note the image build for the intSvc as it needs to move files into the the image being built. If you need to make changes to thoise files you'll need to either delete your image and rebuild or bump the version number, I prefer the later.
