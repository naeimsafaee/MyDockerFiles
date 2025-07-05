# Dockerfile
FROM rabbitmq:3.10-management-alpine

RUN apk --no-cache add curl

# 1. Enable the delayed-message-exchange plugin
RUN curl -L https://github.com/rabbitmq/rabbitmq-delayed-message-exchange/releases/download/3.10.2/rabbitmq_delayed_message_exchange-3.10.2.ez > rabbitmq_delayed_message_exchange-3.10.2.ez && \
mv rabbitmq_delayed_message_exchange-3.10.2.ez plugins/

RUN rabbitmq-plugins enable rabbitmq_delayed_message_exchange

# 2. Create a default user (you can override these at build-time or later)
ENV RABBITMQ_DEFAULT_USER=myuser \
    RABBITMQ_DEFAULT_PASS=mysecretpassword

# 3. Expose AMQP (5672) and Management UI (15672)
EXPOSE 5672 15672