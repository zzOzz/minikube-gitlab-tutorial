.DEFAULT_GOAL := all
DOCKER_VERSION=1.11.2
all: build push
build:
	docker build -t v20100/docker:$(DOCKER_VERSION) .
push:
	docker push v20100/docker:$(DOCKER_VERSION)
