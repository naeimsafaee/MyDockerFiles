# 1) Choose your RabbitMQ and plugin versions—must match!
ARG RABBITMQ_VERSION=3.11.22
ARG DELAYED_PLUGIN_VERSION=3.11.22

FROM rabbitmq:${RABBITMQ_VERSION}-management

# 2) Set up credentials (override at build time if you like)
ENV RABBITMQ_DEFAULT_USER=myuser \
    RABBITMQ_DEFAULT_PASS=mysecretpassword \
    RABBITMQ_DEFAULT_VHOST=/

# 3) Install curl
RUN apt-get update \
 && apt-get install -y --no-install-recommends curl \
 && rm -rf /var/lib/apt/lists/*

# 4) Ensure the real plugins directory exists, download the matching plugin there,
#    and fix ownership so the rabbitmq user can read it.
RUN mkdir -p /opt/rabbitmq/plugins \
 && curl -fSL \
      https://github.com/rabbitmq/rabbitmq-delayed-message-exchange/releases/download/v${DELAYED_PLUGIN_VERSION}/rabbitmq_delayed_message_exchange-${DELAYED_PLUGIN_VERSION}.ez \
      -o /opt/rabbitmq/plugins/rabbitmq_delayed_message_exchange.ez \
 && chown rabbitmq:rabbitmq /opt/rabbitmq/plugins/rabbitmq_delayed_message_exchange.ez

# 5) Enable the plugin offline
RUN rabbitmq-plugins enable --offline rabbitmq_delayed_message_exchange

# 6) Expose AMQP & Management UI ports
EXPOSE 5672 15672
