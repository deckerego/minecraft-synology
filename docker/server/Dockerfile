FROM amazoncorretto:18

# Install the AWS CLI for S3 synchronization
RUN set -eux \
    && yum install -y awscli
RUN aws configure set default.s3.payload_signing_enabled true

# Minecraft Server 1.19
RUN curl -o /srv/server.jar https://launcher.mojang.com/v1/objects/e00c4052dac1d59a1188b2aa9d5a87113aaf1122/server.jar
RUN echo 'eula=true' > /srv/eula.txt
COPY scripts/server/bootstrap.sh /srv/bootstrap.sh
COPY config/server/server.properties /srv/server.properties

# Download the world, launch the Java server
EXPOSE 25565
ENTRYPOINT [ "bash", "/srv/bootstrap.sh" ]
