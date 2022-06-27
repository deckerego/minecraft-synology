# Minecraft Server, Managed by AWS ECS

Host a Minecraft Java server with AWS' ECS using Fargate. This will
*not* to be cheaper than other hosting options such as Realms
(see [Cost Breakdown](#cost-breakdown) below) - so proceed with cost caution.
This project instead lives on as a demonstration of how
ECS + Fargate + ELBv2 + Cognito + Lambda + VPC + API Gateway + S3 + Docker
can work in relative harmony.

This project requires you have a working AWS account already configured,
and currently assumes you have some working knowledge of AWS ECS (at least
enough to start and stop tasks within a service).


## How to Create Your Own

This repo is intended to be cloned. Your best bet is to create a new private
GitHub (or just plain ole Git) repository and configure from there.

To create your own version of this repository first create the new repo,
clone this one, rename the newly cloned directory, and then change origin
to be **your new repository instead**. For example:

```sh
$ git clone https://github.com/deckerego/minecraft-ecs.git
$ mv minecraft-ecs your-system-ecs
$ cd your-system-ecs
$ git remote set-url origin git@github.com:you/your-repo
$ git push origin master
```


You should also merge from this repo as needed since the project is
rapidly changing. To do that, add this as a named remote source and merge.
For example:

```sh
$ git remote add minecraft-ecs https://github.com/deckerego/minecraft-ecs.git
$ git fetch --all
$ git merge minecraft-ecs/main
```

This *should* merge any changes in cleanly.

## How to Configure

After you have created your own repository, you can tweak the configs to meet
your needs. Within the `resources` directory there are three base files:
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
$ npm install
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

### Cognito Authentication

Cognito authentication admittedly isn't fully wired in. You can visit the
hosted login page, get the auth token from the URL, and then use that as a
`Bearer` token in the `Authentication` header, but it requires you to manually
copy-and-paste the auth token into the header before you fetch the cluster's
status over the HTTP URL.

The original goal was to create a web front-end that would do this for you,
as well as let you stop/start tasks within a container. As this project
proved cost prohibitive however, that was scrapped.


## Testing

You can test the HTTP endpoints in offline mode against your remote AWS
infrastructure using:

```sh
$ AWS_PROFILE=PROFILE AWS_REGION=us-east-1 serverless offline start
```

Where `PROFILE` is the AWS configuration profile for the remote infrstructure
you are testing against.


## Cost Breakdown

A publicly accessible, Fargate-powered ECS service with a single task,
1 vCPU, and 3gb of RAM will cost you about $3.22 a day at current rates.
Of that, $1.29 is for the actual container resource costs,
$0.54 is for the [load balancer](https://aws.amazon.com/elasticloadbalancing/pricing/),
and $1.08 is for the [NAT gateway](https://aws.amazon.com/vpc/pricing/) in the VPC.

This means your bare minimum cost per day, even if your container is
powered down, is $1.62 a day, or $49.31 a month. If you use your Minecraft
server 12.5% of the month, that's still $54.98. Running full bore would
run you about $94.66 a month.

This doesn't even deal with S3, data transfer, Elastic IP,
or container storage costs. Bottom line - you aren't going to get better than
$8 per month on hosting unless you operate **many** worlds in a single
cluster, sharing a load balancer and a NAT gateway and reducing runtime to
around 2gb of memory.

Given all that, I decided to archive this project and chalk it up to a
learning experience. Still - this was a nifty project, if for no other reason
than it spells out how to manage an ECS cluster hosting an externally-facing
container using a Lambda-based API for management with Cognito for auth.
So that's fun.
