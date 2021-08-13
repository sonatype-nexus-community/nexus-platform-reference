# Nexus Platform on Docker

This repo contains "enough" to get a the Sonatype Nexus Platform suite of products up and running locally with a "standard" configuration on Docker.

Ideal if you want to get hand on quickly :-)

You can of course override configuration - including adding a trial licnese if you have one to experiecne all features. If you don't have a trial license and would like one [contact Sonatype](https://www.sonatype.com).

# What is the Nexus Platform?

When we refer to the Nexus Platform, we actually refer to three of Sonatype's core-products and their associated add-on packs. These are:

1. Neuxs Repository (either [Neuxs Repository OSS](https://www.sonatype.com/products/repository-oss) or [Nexus Repository Pro](https://www.sonatype.com/products/repository-pro?))
2. [Nexus Lifecycle](https://www.sonatype.com/products/open-source-security-dependency-management) and it's add-on packs:
    - [Advanced Development Pack](https://www.sonatype.com/product/advanced-development-pack)
    - [Advanced Legal Pack](https://www.sonatype.com/products/advanced-legal-pack)
    - [Infrastructure as Code Pack](https://www.sonatype.com/product/infrastructure-as-code)
3. [Nexus Firewall](https://www.sonatype.com/products/firewall)

For the full suite of products - check out [www.sonatype.com](https://www.sonatype.com).

# Pre-requisites

You'll need the following locally to get started:

1. Docker (tested against Docker version 20.10.7, but should work with 19.03.0+)
2. Gradle (tested against Gradle 6.9)

# Pre-defined Template Architectures

| Gradle Task Name | Nexus Platform                                | Nexus Repo                               | Nexus Lifecycle                        | Description                                                                                       |
| ---------------- | --------------------------------------------- | ---------------------------------------- | -------------------------------------- | ------------------------------------------------------------------------------------------------- |
| `nexusPlatform`  | Yes - [here](http://nexus-platform.localhost) | No                                       | No                                     | Both Nexus Repository and Nexus Lifecycle available behind an nGinx reverse proxy.                |
| `noReverseProxy` | No                                            | Yes - [here](http://repo.localhost:8081) | Yes - [here](http://iq.localhost:8070) | Both Nexus Repository and Nexus Lifecycle available directly via `localhost` addressed over HTTP. |


# Quick Start

This project is shipped with a number of pre-defined template architectures - pick the one that you want to try!

One you've picked your preferred template architecture to test from the table above note it's **Gradle Name** and substitue in the below comands. The below commands use the ***nexusPlatform*** template architecture.

**NOTE:** You might wish to read the **Detailed Configuration** section below if you have a trial license to apply.

## Starting the Platform

Execute the gradle task `nexusPlatform` + `Up` - use the task name for your chosen architecture.

```
gradle -q nexusPlatformUp

nginx-proxy uses an image, skipping
neuxs-iq-server uses an image, skipping
nexus-repository uses an image, skipping
Creating network "35d98ba76ac5c547b0ca539f5815d3e9_nexus-platform-reference_main_default" with the default driver
Creating 35d98ba76ac5c547b0ca539f5815d3e9_nexus-platform-reference_main_neuxs-iq-server_1 ...
Creating 35d98ba76ac5c547b0ca539f5815d3e9_nexus-platform-reference_main_nexus-repository_1 ...
Creating 35d98ba76ac5c547b0ca539f5815d3e9_nexus-platform-reference_main_nginx-proxy_1      ...
Creating 35d98ba76ac5c547b0ca539f5815d3e9_nexus-platform-reference_main_nginx-proxy_1      ... done
Creating 35d98ba76ac5c547b0ca539f5815d3e9_nexus-platform-reference_main_nexus-repository_1 ... done
Creating 35d98ba76ac5c547b0ca539f5815d3e9_nexus-platform-reference_main_neuxs-iq-server_1  ... done

============================================================
  _________                     __
  /   _____/ ____   ____ _____ _/  |_ ___.__.______   ____
  \_____  \ /  _ \ /    \\__  \\   __<   |  |\____ \_/ __ \
  /        (  <_> )   |  \/ __ \|  |  \___  ||  |_> >  ___/
 /_______  /\____/|___|  (____  /__|  / ____||   __/ \___  >
          \/           \/     \/     \/     |__|        \/
============================================================

Access your local Nexus Platform at http://nexus-platform.localhost
```

### Stopping the Platform

Execute the gradle task `nexusPlatform` + `Down` - use the task name for your chosen architecture.

```
gradle nexusPlatformDown
```

### Local Cleanup

This removes some generated (templated) configuration and libraries that are downloaded. If you have issues, run this before running `gradle mainComposeUp`.

```
gradle clean
```

# Detailed Configuration

This section details some key elements about the "shipped" configuration for the Nexus Platform. You are of course free to modify, but we've aimed to give a good broad setup that doesn't have external dependencies. For example, we haven't enabled any ties to an LDAP server.

## Global Configuration

These are some cross-cutting platform configurations that you might wish to tweak.

### Sonatype Product License

By defaul you can copy your license file to `config/sontype-license-all.lic` to have your license applied during startup. You can change this by setting the `NEXUS_LICENSE_PATH` gradle property.

```
gradle nexusPlatformUp -PNEXUS_LICENSE_PATH=/path/to/my.lic
```

If you don't have a license, Nexus Repository will operated without the Pro Feature and IQ Server will ask you to add a license when you first log in.

### Docker Persistent Volumes

We utilise Docker Volumes to ensure your *data* is not inside the Docker Containers and persists between executions. Also helpful to test upgrades.

By default we'll use the empty `data` folder in this repository to put all Docker Volumes. You can override this to your preferred location by either changing the value in `gradle.properties` or by passing the property at invokation time:

```
gradle nexusPlatformUp -PDOCKER_ROOT_VOLUME_MOUNT_POINT=/path/to/where/i/want/docker/volumes
```

### Default Admin Password

Docker Secrets are utilised to load and set the initial password for the `admin` user in both Nexus Repository and Nexus Lifecycle. You can change the password by editing the contents of `config/admin_password`.

## Nexus Repository

We are currently using Nexus Repository version 3.33.0 (latest as of 13-Aug-2021). You can change this by setting the `NEXUS_REPOSITORY_VERSION` gradle property.

Example:
```
gradle nexusPlatformUp -PNEXUS_REPOSITORY_VERSION=3.32.0
```

## Nexus Lifecycle

We are currently using Nexus IQ Server version 121 (latest as of 13-Aug-2021). You can change this by setting the `NEXUS_IQ_SERVER_VERSION` gradle property.

Example:
```
gradle nexusPlatformUp -PNEXUS_IQ_SERVER_VERSION=1.120.0
```

# Common Issues / Gotchas

1. If the `Up` command fails - it might be because some of the ports that we are going to use on localhost are already being used - check you're not running anything already that is listening on ports 80, 2480, 8070, 8071 and 8080

# Acknowledgments

This project makes use of the following open source libraries/plugins:
1. [gradle-docker-compose-plugin](https://github.com/avast/gradle-docker-compose-plugin) which is licensed under MIT License and is Copyright (c) 2016 Avast
2. [nexus-casc-plugin](https://github.com/asharapov/nexus-casc-plugin) which is licensed under MIT License and is Copyright 2019 Sven Tschui

# License
    Copyright 2019-Present Sonatype Inc.
    
    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at
    
        http://www.apache.org/licenses/LICENSE-2.0
    
    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.


# The Fine Print
    It is worth noting that this is NOT SUPPORTED by Sonatype, and is a contribution of ours to the open source community (read: you!)

    Remember:

    - Use this contribution at the risk tolerance that you have
    - Do NOT file Sonatype support tickets related to this project
    - DO file issues here on GitHub, so that the community can pitch in
    - Phew, that was easier than I thought. Last but not least of all:

    Have fun creating and using this utility to quikcly get hands-on with Nexus Repository and Nexus Lifecycle. We are glad to have you here!