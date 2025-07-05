# 1. Pick a RabbitMQ version you want (this must match the plugin release)
ARG RABBITMQ_VERSION=3.11.22
FROM rabbitmq:${RABBITMQ_VERSION}-management

# 2. Set up your default user/pass (and optionally vhost)
ENV RABBITMQ_DEFAULT_USER=myuser \
    RABBITMQ_DEFAULT_PASS=mysecretpassword \
    RABBITMQ_DEFAULT_VHOST=/

# 3. Install curl so we can fetch the plugin
RUN apt-get update \
 && apt-get install -y --no-install-recommends curl \
 && rm -rf /var/lib/apt/lists/*

# 4. Download the delayed-message-exchange plugin matching the server version
#    (check https://github.com/rabbitmq/rabbitmq-delayed-message-exchange/releases for newer versions)
RUN curl -L \
    https://github.com/rabbitmq/rabbitmq-delayed-message-exchange/releases/download/v${RABBITMQ_VERSION}/rabbitmq_delayed_message_exchange-${RABBITMQ_VERSION}.ez \
    -o /plugins/rabbitmq_delayed_message_exchange.ez

# 5. Enable it offline
RUN rabbitmq-plugins enable --offline rabbitmq_delayed_message_exchange

# 6. Expose the AMQP and Management ports
EXPOSE 5672 15672
