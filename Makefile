# Set the default image and version
DOCKER_COMPOSE=docker-compose
DOCKER_COMPOSE_FILE=docker-compose.yml
PYTHON_VERSION=3.9
DOCKER_VERSION=docker

# Set the path to where your .env file is located
ENV_FILE=.env

# Targets to check for installations
check_python:
	@echo "Checking if Python ${PYTHON_VERSION} is installed..."
	@python3 --version || { echo "Python ${PYTHON_VERSION} is not installed."; exit 1; }

check_docker:
	@echo "Checking if Docker is installed..."
	@docker --version || { echo "Docker is not installed."; exit 1; }

# Pre-install python3.9 and docker, if not installed
install_dependencies: check_python check_docker
	@echo "All dependencies (Python and Docker) are installed."

# Build the docker images
build:
	@echo "Building the Docker images..."
	@${DOCKER_COMPOSE} -f ${DOCKER_COMPOSE_FILE} build

# Start the services using docker-compose
up: install_dependencies build
	@echo "Starting the services..."
	@${DOCKER_COMPOSE} -f ${DOCKER_COMPOSE_FILE} up -d

# Restart the services (useful for restarting after changes)
restart:
	@echo "Restarting the services..."
	@${DOCKER_COMPOSE} -f ${DOCKER_COMPOSE_FILE} down
	@${DOCKER_COMPOSE} -f ${DOCKER_COMPOSE_FILE} up -d

# Stop the services
stop:
	@echo "Stopping the services..."
	@${DOCKER_COMPOSE} -f ${DOCKER_COMPOSE_FILE} down

# Clean up all docker containers, networks, and volumes
clean: stop
	@echo "Cleaning up unused containers, networks, and volumes..."
	@docker system prune -f

# Rebuild and restart the services
rebuild: clean build up

# View logs of a specific container
logs:
	@echo "Tail logs for services..."
	@${DOCKER_COMPOSE} -f ${DOCKER_COMPOSE_FILE} logs -f

# Run DBT tasks (you can add specific dbt commands here)
dbt:
	@echo "Running DBT tasks..."
	@${DOCKER_COMPOSE} -f ${DOCKER_COMPOSE_FILE} run dbt bash -c "dbt run"

# Help target to show available commands
help:
	@echo "Makefile for Docker Compose deployment with Python and Docker support"
	@echo "Available targets:"
	@echo "  check_python       - Check if Python 3.9 is installed."
	@echo "  check_docker       - Check if Docker is installed."
	@echo "  install_dependencies - Ensure Python 3.9 and Docker are installed."
	@echo "  build              - Build the Docker images."
	@echo "  up                 - Build and start the Docker containers in detached mode."
	@echo "  restart            - Restart the services (stop and up)."
	@echo "  stop               - Stop the Docker containers."
	@echo "  clean              - Clean up unused Docker containers, networks, and volumes."
	@echo "  rebuild            - Clean, build, and start the containers."
	@echo "  logs               - View logs for services."
	@echo "  dbt                - Run DBT tasks."
