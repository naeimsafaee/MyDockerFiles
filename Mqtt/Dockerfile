# syntax=docker/dockerfile:1
#
# Dev-only Mosquitto broker:
# - MQTT over TLS (8883)
# - WebSockets over TLS (8884)
# - Hard-coded user/password
# - Self-signed TLS cert (CN=localhost)
#
FROM eclipse-mosquitto:2.0

# Hard-coded dev credentials & cert CN
ENV MQTT_USERNAME="Poldark69" \
    MQTT_PASSWORD="nMi-ey@SG!p7zgc" \
    CERT_CN="localhost"

# Need openssl to generate a self-signed cert
RUN apk add --no-cache openssl

# Create required dirs
RUN mkdir -p /mosquitto/config/certs /mosquitto/config/www /mosquitto/data

# Generate self-signed certificate (dev only)
RUN openssl req -x509 -nodes -newkey rsa:2048 \
      -keyout /mosquitto/config/certs/server.key \
      -out /mosquitto/config/certs/server.crt \
      -days 365 \
      -subj "/CN=${CERT_CN}" \
    && cp /mosquitto/config/certs/server.crt /mosquitto/config/certs/ca.crt \
    && chmod 600 /mosquitto/config/certs/server.key

# Copy Mosquitto configuration
COPY mosquitto.conf /mosquitto/config/mosquitto.conf

# Create password file (hashed) using hard-coded creds
RUN mosquitto_passwd -b -c /mosquitto/config/passwd "${MQTT_USERNAME}" "${MQTT_PASSWORD}" \
    && chmod 600 /mosquitto/config/passwd

# (Optional) echo for build log clarity
RUN echo "Built dev broker with user: ${MQTT_USERNAME}"

# Expose TLS MQTT & WSS ports
EXPOSE 8883 8884
