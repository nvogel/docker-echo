NAME ?= echo
NS ?= nvgl

DOCKER_USERNAME ?= nvgl+travis
DOCKER_REGISTRY ?= quay.io

RELEASE=$(shell cat VERSION)
COMMIT?=$(shell git rev-parse --short HEAD)
BUILD_TIME?=$(shell date -u '+%Y-%m-%d_%H:%M:%S')

IMAGE=$(DOCKER_REGISTRY)/$(NS)/$(NAME):$(RELEASE)

help: ## Print help [ default target ]
	@grep -E '^[a-zA-Z_-]+.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build: ## Build jenkins docker image
	docker build -t ${IMAGE} .

push: ## Push image to registry
	@echo "$(DOCKER_PASSWORD)" | docker login -u "$(DOCKER_USERNAME)" --password-stdin $(DOCKER_REGISTRY)
	docker push ${IMAGE}

update: build push ## Build and Push image to registry

.PHONY: build push update help
