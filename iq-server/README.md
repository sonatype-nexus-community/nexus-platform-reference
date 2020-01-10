# Custom Nexus IQ Server Image

A Dockerfile for creating a custom image based on [the Official Image](https://hub.docker.com/r/sonatype/nexus-iq-server)

```
FROM sonatype/nexus-iq-server
COPY config.yml /opt/sonatype/iq-server/

HEALTHCHECK CMD curl http://localhost:8071/ping
```

The key is make a copy of this folder so you can customize the `config.yml` with settings for your Demo, PoC or Test environment.

I provide this build script (excuse my weak unix foo) as a portable example of the process. It is expected to be invoked with one paramer, a version number. To make it 'portable' I am using the $USER to grab your username on the computer but this can be hardcoded easily enough for non-unix system or if you simply want a different name.

```
SCRIPTNAME=${0##*/}

#Update this with your dockerhub username or user with push pernmission to your private repo
DOCKERNAME=$USER

function print_usage() {
    echo "Please provide a version number for tagging"
    echo "$SCRIPTNAME <version>  e.g. build-iq.sh 1.41"
}

#a lot can still go wrong here but it's a start...
if [ "$1" != "" ]; then
    docker build -t $DOCKERNAME/demo-iq-server:$1 .
    docker tag $DOCKERNAME/demo-iq-server:$1 $DOCKERNAME/demo-iq-server:latest
    docker tag $DOCKERNAME/demo-iq-server:latest mycompany.com:5000/$DOCKERNAME/demo-iq-server:$1
    docker tag $DOCKERNAME/demo-iq-server:latest mycompany.com:5000/$DOCKERNAME/demo-iq-server:latest
else
    print_usage 
    exit 1
fi
```

Separately, I've added a `push-iq.sh` script that uses the same idiom but to push your custom image to a private registry, in my case a local Nexus with a private repo listening on port 5000. The idea here is the build and publish are often separate steps in a pipeline to allow for testing to occur. Should the image fail any testing, it wouldn't get published.

Lastly, there is a docker-compose file that looks just like the one up a level but now wants to deploy your custom image.
