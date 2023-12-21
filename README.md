# Modified 

PoC on migrating from `Pulp2` to `Pulp3`:
- legacy `rpm` repositories for each architecture at `yum/nordvpn`
- legacy `deb` repository for all architectures ar `deb/nordvpn`
- after migraton need to be exactly the same URLs!

Need to modify `nginx.conf` - see `images/s6_assets/nginx.conf`

Then need to create `deb` and `rpm` repositories and corresponding 
distributions with `base_path`, e.g.:

```
pulp deb repository create --name=deb22
pulp deb content upload --repository=deb22 --file=nordvpn_3.16.8_amd64.deb
pulp deb publication create --repository=deb22 --structured
pulp deb distribution create --name=distro22 --base-path='deb/nordvpn/mydeb22' --repository=deb22


pulp rpm repository create --name=rpm22
pulp rpm content upload --repository=rpm22 --file=nordvpn-3.16.9-1.aarch64.rpm
pulp rpm publication create --repository=rpm22
pulp rpm distribution create --name=distro23 --base-path='yum/nordvpn/myrpm22' --repository=rpm22
```

Then URLs will be as follows:
- http://localhost:8080/deb/nordvpn/mydeb22
- http://localhost:8080/yum/nordvpn/myrpm22  
  
#
Use script `build-pulp-oci-image.sh` to locally rebuild pulp OCI image.

#

# Pulp 3 Containers

The [pulp-oci-images](https://github.com/pulp/pulp-oci-images) repository is used to provide container images for running Pulp.
These images represent one of several officially supported [Pulp installation methods](https://docs.pulpproject.org/pulpcore/installation/instructions.html).
The available images can be divided into two types:

- [Multi-Process Images](multi-process-images) - Images for running a [Pulp](https://github.com/pulp/pulpcore) or [Ansible Galaxy](https://github.com/ansible/galaxy_ng), as well as its [third-party services](#third-party-services),
in a single Docker/Podman container.
- [Single-Process Images](single-process-images) - Images containing a single Pulp service each, which collectively make up a Pulp instance. They can be used via docker-compose or podman-compose, example [here](https://github.com/pulp/pulp-oci-images/tree/latest/images/compose). These images are also used by [pulp operator](https://docs.pulpproject.org/pulp_operator/).

Note that OCI stands for "Open Container Initiative", see [here](https://opencontainers.org/).

## Quickstart

See the [quickstart guide for deploying](quickstart).


## Available Images

| Name | Description |
| ---- | ----------- |
| pulp | Multi-Process Pulp with several plugins |
| pulp-minimal | Single-Process Pulp with several plugins
| pulp-web | Webserver for pulp-minimal |
| galaxy | Multi-Process Ansible Galaxy |
| galaxy-minimal | Single-Process Ansible Galaxy |
| galaxy-web | Webserver for galaxy-minimal |

## First-Party Services

The first-party services are services written by the Pulp project itself.

They are pulp-api, pulp-content, and pulp-worker.

## Third-Party Services

The third-party services are services written by other open source projects, but
Pulp depends on them as the middle tier in 3-tier application architecture to
run.

The 2 backends are the PostgreSQL database server and the redis caching server.

The 1 frontend is the Nginx webserver, with special config to combine
both pulp-api and pulp-content into one service.

## Get Help

Documentation: [https://docs.pulpproject.org/pulp_oci_images/](https://docs.pulpproject.org/pulp_oci_images/)

Issue Tracker: [https://github.com/pulp/pulp-oci-images/issues](https://github.com/pulp/pulp-oci-images/issues)

Forum: [https://discourse.pulpproject.org/](https://discourse.pulpproject.org/)

Join [**#pulp** on Matrix](https://matrix.to/#/#pulp:matrix.org)

Join [**#pulp-dev** on Matrix](https://matrix.to/#/#pulp-dev:matrix.org) for Developer discussion.
