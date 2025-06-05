# Minecraft Server, Managed by Synology

Allows you to host a Minecraft Java server with Synology's container management utilities.
This project hosts a Docker image for the Java server & the Docker Compose configs for
ease of management by Synology.


## How to Install

Use the Container Manager within your NAS to create a new project, then either copy-and-paste
`docker-compose.yml` or upload it to create the new project. Modify the `volumes` list to
point to the file share that hosts your world files, tweak memory as needed, and specify
the operator for your world.


## How to Test an Image

```
docker build . -t ghcr.io/minecraft-synology:test
docker run ghcr.io/minecraft-synology:test
```
