.DEFAULT_GOAL := all
K8S_VERSION=v1.5.3
download:
	curl -s -O https://storage.googleapis.com/kubernetes-release/release/$(K8S_VERSION)/bin/linux/amd64/kubectl
	chmod +x kubectl
build:
	docker build -t v20100/kubectl:$(K8S_VERSION) .
push:
	docker push v20100/kubectl:$(K8S_VERSION)
all: download build push
