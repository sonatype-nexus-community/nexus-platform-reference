## Docker Environment

This folder is setup to build the Integration Service container. 
- You'll need to modify the config.yml file to point to your SSC instance and set the login credentials.
- You'll need to list your apps in the mappings.json file
  - If apps / versions don't exisit within SSC they will be created
- You may want to modify the config.yml file for the cron expression which defaults to 'every 6 hrs at 12 and 6'. 

The rest of the defaults are set to work for the demo environment assuming you set the SSC and IQ pw's to match.

## Non-Docker Environment

If you want to run this JAR the old fashioned way, the files you need are in the 'files' folder in addition to the Parser plugin in the SSC folder.

Modify the start script to reference the JAR (it's renamed when copied into the container to simplify things so gthe script references IntSvc.jar instead of the full name.

The start script can also remove the entropy to speed up container start times
Change...
java -jar -Djava.security.egd=file:/dev/./urandom intsvc.jar 

to...
Java -jar SonatypeFortifyIntegration*.jar
