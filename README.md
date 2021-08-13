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

| Gradle Name      | Nexus Platform                                | Nexus Repo                               | Nexus Lifecycle                        | Description                                                                                       |
| ---------------- | --------------------------------------------- | ---------------------------------------- | -------------------------------------- | ------------------------------------------------------------------------------------------------- |
| `main`           | Yes - [here](http://nexus-platform.localhost) | No                                       | No                                     | Both Nexus Repository and Nexus Lifecycle available behind an nGinx reverse proxy.                |
| `noReverseProxy` | No                                            | Yes - [here](http://repo.localhost:8081) | Yes - [here](http://iq.localhost:8070) | Both Nexus Repository and Nexus Lifecycle available directly via `localhost` addressed over HTTP. |


# Quick Start

This project is shipped with a number of pre-defined template architectures - pick the one that you want to try!

One you've picked your preferred template architecture to test from the table above note it's **Gradle Name** and substitue in the below comands. The below commands use the ***noReverseProxy*** template architecture.

**NOTE:** You might wish to read the **Detailed Configuration** section below if you have a trial license to apply.

## Starting the Platform

```
gradle noReverseProxyComposeUp
```

### Stopping the Platform

```
gradle noReverseProxyComposeDown
```

# Detailed Configuration

This section details some key elements about the "shipped" configuration for the Nexus Platform. You are of course free to modify, but we've aimed to give a good broad setup that doesn't have external dependencies. For example, we haven't enabled any ties to an LDAP server.

## Global Configuration

These are some cross-cutting platform configurations that you might wish to tweak.

### Sonatype Product License

By default, copy your license file to `config/sontype-license-all.lic` to have your license applied during startup. You can also override this by passing the full path to your license file as a gradle property:

```
gradle noReverseProxyComposeUp -PNEXUS_LICENSE_PATH=/path/to/my.lic
```

### Docker Persistent Volumes

We utilise Docker Volumes to ensure your *data* is not inside the Docker Containers and persists between executions. Also helpful to test upgrades.

By default we'll use the empty `data` folder in this repository to put all Docker Volumes. You can override this to your preferred location by either changing the value in `gradle.properties` or by passing the property at invokation time:

```
gradle noReverseProxyComposeUp -PDOCKER_ROOT_VOLUME_MOUNT_POINT=/path/to/where/i/want/docker/volumes
```

### Default Admin Password

We utilise Docker Secrets to load and set the initial password for the `admin` user in both Nexus Repository and Nexus Lifecycle. You can change the password by editing the contents of `config/admin_password`.

## Nexus Repository

*Coming soon*

## Nexus Lifecycle

*Coming soon*


# Acknowledgments

This project makes use of the following open source libraries/plugins:
1. [gradle-docker-compose-plugin](https://github.com/avast/gradle-docker-compose-plugin) which is licensed under MIT License and is Copyright (c) 2016 Avast
2. [nexus-casc-plugin](https://github.com/asharapov/nexus-casc-plugin) which is licensed under MIT License and is Copyright 2019 Sven Tschui

# The Fine Print

This is a community project and is **NOT OFFICIALLY SUPPORTED** by Sonatype - it is purely a contribution to the open source community (read: you!).

Remember:
- Use this contribution at the risk tolerance that you have
- Do NOT file Sonatype support tickets related to to this project
- DO file issues here on GitHub, so that the community can pitch in :-)