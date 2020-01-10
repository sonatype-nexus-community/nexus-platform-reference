#!/bin/bash

#Note: defaults creds are baked in so this will work on a fresh instance
nexus() {
java -jar nexus-cli-0.2.0-SNAPSHOT-shaded.jar \
  -s http://localhost:8070 $@
}


# another example for exporting, I used this to get the policies 
# I provided which is based on the sample set plus some tweaks I like to make.
# Enhanced architecture-quality to match teh SSSC report plus set a default
# continuous monitoring phase to Operate. Some new categories, 3rd party and High Compliance
echo "Exporting policies"
nexus policy exportPolicies -o $1

# Note need to pass in filename

