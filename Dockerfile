FROM amazoncorretto:24-headless

# https://www.minecraft.net/en-us/download/server
# https://piston-meta.mojang.com/mc/game/version_manifest.json
ARG HASH

# Set config files
RUN echo 'eula=true' > /srv/eula.txt
COPY scripts/bootstrap.sh /srv/bootstrap.sh
COPY config/server.properties /srv/server.properties

# Override these in docker-compose.yml
ENV WORLD=world
ENV MEMORY=2048m

RUN curl -o /srv/server.jar https://piston-data.mojang.com/v1/objects/${HASH}/server.jar
RUN echo "${HASH}  /srv/server.jar" | sha1sum -c -

# Use the convenience script to launch server.jar
EXPOSE 25565
ENTRYPOINT [ "bash", "/srv/bootstrap.sh", "$WORLD", "$MEMORY", "$OPERATOR" ]
