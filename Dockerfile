FROM amazoncorretto:18

# Minecraft Server 1.19
RUN curl -o /srv/server.jar https://launcher.mojang.com/v1/objects/e00c4052dac1d59a1188b2aa9d5a87113aaf1122/server.jar
RUN echo 'eula=true' > /srv/eula.txt
COPY scripts/bootstrap.sh /srv/bootstrap.sh
COPY config/server.properties /srv/server.properties

# Download the world, launch the Java server
EXPOSE 25565
ENTRYPOINT [ "bash", "/srv/bootstrap.sh" ]
