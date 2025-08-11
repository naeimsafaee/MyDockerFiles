# Dockerfile
FROM eclipse-mosquitto:2

# Copy configs (no secrets baked in)
COPY mosquitto.conf /mosquitto/config/mosquitto.conf
COPY aclfile        /mosquitto/config/aclfile

# Prepare directories and an empty passwordfile so Mosquitto can start
RUN set -eux; \
    mkdir -p /mosquitto/data /mosquitto/log; \
    : > /mosquitto/config/passwordfile; \
    chown -R mosquitto:mosquitto /mosquitto; \
    chmod 640 /mosquitto/config/passwordfile

# Declare persistent volumes (no need to pass -v on docker run)
#VOLUME ["/mosquitto/config", "/mosquitto/data", "/mosquitto/log"]

EXPOSE 8883 8884
