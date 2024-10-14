# Sonatype Platform on Docker

This repo contains `docker-compose` files associated sample configuration for quickly standing up a number of *Reference Architectures* for the Sonatype Platform components.

Ideal if you want to get hands on quickly :-)

Unless you have a license from [Sonatype](https://www.sonatype.com), you will only be able to use [Nexus Repository OSS](https://www.sonatype.com/products/repository-oss).

If you don't have a trial license and would like one [contact Sonatype](https://www.sonatype.com).

# What is the Sonatype Platform?

When we refer to the Sonatype Platform, we actually refer to three of Sonatype's core-products and their associated add-on packs. These are:

1. Nexus Repository (either [Nexus Repository OSS](https://www.sonatype.com/products/repository-oss) or [Nexus Repository Pro](https://www.sonatype.com/products/repository-pro))
2. [Sonatype Lifecycle](https://www.sonatype.com/products/open-source-security-dependency-management) and its add-on packs:
    - [Advanced Legal Pack](https://www.sonatype.com/products/advanced-legal-pack)
3. [Sonatype Repository Firewall](https://www.sonatype.com/products/sonatype-repository-firewall)

For the full suite of products - check out [www.sonatype.com](https://www.sonatype.com).

# How does this code work?

We utilise [docker-compose profiles](https://docs.docker.com/compose/profiles/) to allow you to quickly stand up the required containers to realise a specific reference architecture, customized with local `.env` configuration.

Assuming you have [Docker Desktop](https://www.docker.com/products/docker-desktop) 19.03.0+ (or similar) installed, you can simply copy default `.env-example` to `.env` and run `docker-compose` passing the required profile. An example using the `proxied` profile might be:

```
cp .env-example .env
docker-compose --profile=proxied up -d
```

then open [http://nexus-platform.localhost](http://nexus-platform.localhost)

# Providing your Sonatype License

For most of the reference architectures, you'll need a Sonatype license. If you have this (it's a `.lic` file), you can use it through one of two methods:

1. Put your `.lic` file in `config/sonatype-license-all.lic`
2. Modify the path to your `.lic` file in the `.env` file:
    ```
    NEXUS_LICENSE_PATH=/your/path/to/your-sonatype.lic
    ```

# Reference Architecture Profiles

| Profile Name    | License Required | Sonatype Platform                             | Nexus Repo                               | Sonatype Lifecycle                     | Description                                                                                           |
| --------------- | ---------------- | --------------------------------------------- | ---------------------------------------- | -------------------------------------- | ----------------------------------------------------------------------------------------------------- |
| `proxied`       | Yes              | Yes - [here](http://nexus-platform.localhost) | Yes [here](http://repo.localhost/)       | Yes [here](http://iq.localhost/)       | Both Nexus Repository Pro and Sonatype Lifecycle available behind an NGINX reverse proxy.                |
| `direct`        | Yes              | No                                            | Yes - [here](http://repo.localhost:8081) | Yes - [here](http://iq.localhost:8070) | Both Nexus Repository Pro and Sonatype Lifecycle available directly via `localhost` addressed over HTTP. |
| `repoOssDemo`   | No               | No                                            | Yes - [here](http://repo.localhost:8081) | No                                     | Nexus Repo OSS will be started.                                                                       |
| `cicd-jenkins`  | Yes              | Yes - [here](http://nexus-platform.localhost) | Yes [here](http://repo.localhost/)       | Yes [here](http://iq.localhost/)       | Includes a Jenkins [here](http://nexus-platform/jenkins)                                              |
| `cicd-teamcity` | Yes              | Yes - [here](http://nexus-platform.localhost) | Yes [here](http://repo.localhost/)       | Yes [here](http://iq.localhost/)       | Includes a TeamCity Server [here](http://nexus-platform/teamcity)                                     |
| `jenkins-direct` | No | No | No | No | Just Jenkins running [here](http://localhost:8888/jenkins) |

## Additional Sub Profiles

The following profiles can be stood up in parallel to the `proxied` profile to provide further services:

| Profile Name  | Endpoints                                                                                                                  | Description                   |
| ------------- | -------------------------------------------------------------------------------------------------------------------------- | ----------------------------- |
| `swagger`     | [Swagger Editor](http://nexus-platform.localhost/swagger-editor), [Swagger UI](http://nexus-platform.localhost/swagger-ui) | Swagger Editor and Swagger UI |

You can run multiple profiles together!

# Acknowledgments
This project makes use of the following open source libraries/plugins:
1. [nexus-casc-plugin](https://github.com/asharapov/nexus-casc-plugin) which is licensed under MIT License and is Copyright 2019 Sven Tschui

# License
See `LICENSE` file for details.
 

# The Fine Print
It is worth noting that this is NOT SUPPORTED by Sonatype, and is a contribution of ours to the open source community (read: you!)

Remember:

- Use this contribution at the risk tolerance that you have
- Do NOT file Sonatype support tickets related to this project
- DO file issues here on GitHub, so that the community can pitch in
- Phew, that was easier than I thought. Last but not least of all:

Have fun creating and using this utility to quikcly get hands-on with Nexus Repository and Sonatype Lifecycle. We are glad to have you here!
