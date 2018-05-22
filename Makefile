NAME ?= echo
NS ?= nvgl

DOCKER_USERNAME ?= nvgl+travis
DOCKER_REGISTRY ?= quay.io

RELEASE=$(shell cat VERSION)
COMMIT?=$(shell git rev-parse --short HEAD)

IMAGE_BUILD=$(NS)/$(NAME):$(RELEASE)-$(COMMIT)
IMAGE_RELEASE=$(DOCKER_REGISTRY)/$(NS)/$(NAME):$(RELEASE)

help: ## Print help [ default target ]
	@grep -E '^[a-zA-Z_-]+.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build: ## Build jenkins docker image
	docker build -t ${IMAGE_BUILD} .

push: ## Push image to registry
	@echo "$(DOCKER_PASSWORD)" | docker login -u "$(DOCKER_USERNAME)" --password-stdin $(DOCKER_REGISTRY)
	docker tag $(IMAGE_BUILD) $(IMAGE_RELEASE)
	docker push ${IMAGE_RELEASE}

update: build push ## Build and Push image to registry

.PHONY: build push update help
