FROM amazoncorretto:24-headless

# Minecraft Server 1.21.5
RUN curl -o /srv/server.jar https://piston-data.mojang.com/v1/objects/e6ec2f64e6080b9b5d9b471b291c33cc7f509733/server.jar
RUN echo 'eula=true' > /srv/eula.txt
COPY scripts/bootstrap.sh /srv/bootstrap.sh
COPY config/server.properties /srv/server.properties

ENV WORLD=world
ENV MEMORY=2048m

# Download the world, launch the Java server
EXPOSE 25565
ENTRYPOINT [ "bash", "/srv/bootstrap.sh", "$WORLD", "$MEMORY", "$OPERATOR" ]
