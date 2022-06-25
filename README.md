# Minecraft Server, Managed by AWS ECS

Launch a Minecraft Java server with AWS' ECS using Fargate. The hope is that
this is a bit cheaper and extensible to manage than using an EC2 instance or
virtual machine hosting.

This project requires you have a working AWS account already configured,
and currently assumes you have some working knowledge of AWS ECS (at least
enough to start and stop tasks within a service). Eventually a helper
webapp will be created to make this management easier.


## How to Configure

Within the `resources` directory there are three base files:
- `vpc.yml` - used to define the Virtual Private Cloud that Fargate will live within
- `ecs.yml` - the definition of the ECS cluster and load balancer your worlds will share
- `helloworld.yml` - an example world definition that sets up your ECS service and task

To load your own worlds, re-name the `helloworld.yml` file and
tweak the parameters at the top of the file to match the CPU, memory,
world name, and operator username that you would like. Once you are set, change
the `serverless.yml` config in the base directory to change the `helloworld.yml`
resource file name to match what you just renamed it to.


## How to Deploy

To deploy your customized resources (see [How to Configure](#how-to-configure) above),
use the included Serverless config to deploy to a named "SYSTEM" with a given
AWS profile (that I assume you already have configured).

```sh
$ serverless deploy --stage SYSTEM --aws-profile PROFILE
```

Here `SYSTEM` is a logical groupings of worlds that you have configured.
All worlds in a SYSTEM share the same ECS cluster, load balancer, and VPC.

After a deployment is complete, an S3 bucket is created in your account that can
store the world files. Upload your world files as needed, or if you would
like to start from scratch go ahead and start the ECS task.


## How to Run

By default the ECS service defined for each world launches no tasks - meaning
your worlds will not start running by default. To start them, change
the ECS service's desired task count to `1`. This should start the ECS
task to host the world, which will copy your world data from S3 into a
running container and launch the Minecraft server.

One of the big benefits of hosting in ECS Fargate is that you can easily
shut down the hosted world and greatly reduce your costs. For now, you need
to manually do this in ECS by setting the service's desired task count
back down to `0` and manually stopping the running task. Once you do so,
your world should be uploaded back to S3 and the container deprovisioned.
