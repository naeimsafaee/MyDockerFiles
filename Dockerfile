# Dockerfile
FROM rabbitmq:3.11-management

# 1. Enable the delayed-message-exchange plugin
RUN rabbitmq-plugins enable --offline rabbitmq_delayed_message_exchange

# 2. Create a default user (you can override these at build-time or later)
ENV RABBITMQ_DEFAULT_USER=myuser \
    RABBITMQ_DEFAULT_PASS=mysecretpassword

# 3. Expose AMQP (5672) and Management UI (15672)
EXPOSE 5672 15672
