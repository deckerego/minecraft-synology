FROM amazoncorretto:24-headless

# Minecraft Server 1.21.6
# https://www.minecraft.net/en-us/download/server
RUN curl -o /srv/server.jar https://piston-data.mojang.com/v1/objects/6e64dcabba3c01a7271b4fa6bd898483b794c59b/server.jar
RUN echo 'eula=true' > /srv/eula.txt
COPY scripts/bootstrap.sh /srv/bootstrap.sh
COPY config/server.properties /srv/server.properties

# Override these in docker-compose.yml
ENV WORLD=world
ENV MEMORY=2048m

# Use the convenience script to launch server.jar
EXPOSE 25565
ENTRYPOINT [ "bash", "/srv/bootstrap.sh", "$WORLD", "$MEMORY", "$OPERATOR" ]
