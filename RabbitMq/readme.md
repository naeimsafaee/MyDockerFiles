# RabbitMQ Delayed Message Exchange Docker Image

This repository provides a Docker setup for running RabbitMQ (version 3.10) with the Management UI and the Delayed Message Exchange plugin enabled.

## Features

* **RabbitMQ 3.10** with Management Plugin
* **Delayed Message Exchange** plugin (v3.10.2)
* Default user credentials (configurable via environment variables)
* Exposes AMQP (5672) and Management UI (15672)

## Table of Contents

* [Prerequisites](#prerequisites)
* [Building the Image](#building-the-image)
* [Running the Container](#running-the-container)
* [Environment Variables](#environment-variables)
* [Accessing the Management UI](#accessing-the-management-ui)
* [Customizing the Plugin Version](#customizing-the-plugin-version)
* [Stopping and Removing](#stopping-and-removing)
* [Contributing](#contributing)
* [License](#license)

## Prerequisites

* Docker 20.10+ installed on your system
* Internet connection to download the base image and plugin

## Building the Image

Clone this repository and build the Docker image:

```bash
git clone https://github.com/yourusername/rabbitmq-delayed-exchange.git
cd rabbitmq-delayed-exchange

docker build -t rabbitmq-delayed:3.10 .
```

> You can override the plugin version by editing the URL in the `Dockerfile` before building.

## Running the Container

Start a container from the image:

```bash
docker run -d \
  --name rabbitmq \
  -e RABBITMQ_DEFAULT_USER=myuser \
  -e RABBITMQ_DEFAULT_PASS=mysecretpassword \
  -p 5672:5672 \
  -p 15672:15672 \
  rabbitmq-delayed:3.10
```

This will:

* Run RabbitMQ with the delayed-message-exchange plugin enabled
* Create a default user (`myuser`) with password (`mysecretpassword`)
* Expose port **5672** for AMQP connections
* Expose port **15672** for the Management UI

## Environment Variables

| Variable                | Description               | Default            |
| ----------------------- | ------------------------- | ------------------ |
| `RABBITMQ_DEFAULT_USER` | Default RabbitMQ username | `myuser`           |
| `RABBITMQ_DEFAULT_PASS` | Default RabbitMQ password | `mysecretpassword` |

You can set these variables at runtime (as shown above) or via an `.env` file and Docker Compose.

## Accessing the Management UI

Once the container is running, open your browser and navigate to:

```
http://localhost:15672
```

Log in with the credentials defined in the environment variables.

## Customizing the Plugin Version

If you need a different version of the delayed-message-exchange plugin:

1. Modify the `curl` URL in the `Dockerfile` to the desired release (e.g., `https://github.com/rabbitmq/rabbitmq-delayed-message-exchange/releases/download/<VERSION>/rabbitmq_delayed_message_exchange-<VERSION>.ez`).
2. Update the filename in the `mv` command and the `rabbitmq-plugins enable` line accordingly.

Rebuild the image after making these changes.

## Stopping and Removing

To stop and remove the container:

```bash
docker stop rabbitmq
docker rm rabbitmq
```

To remove the image:

```bash
docker rmi rabbitmq-delayed:3.10
```

## Contributing

Contributions are welcome! Feel free to open issues or submit pull requests.

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/my-feature`)
3. Commit your changes (`git commit -m 'Add awesome feature'`)
4. Push to the branch (`git push origin feature/my-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
