NAME ?= echo
NS ?= nvgl

DOCKER_USERNAME ?= nvgl+travis
DOCKER_REGISTRY ?= quay.io

RELEASE=$(shell git symbolic-ref -q --short HEAD 2> /dev/null || git describe --tags --exact-match 2> /dev/null || echo $(TRAVIS_BRANCH))
COMMIT?=$(shell git rev-parse --short HEAD)

IMAGE_BUILD=$(NAME):$(RELEASE)-$(COMMIT)
IMAGE_RELEASE=$(DOCKER_REGISTRY)/$(NS)/$(NAME):$(RELEASE)

.PHONY: help
help: ### Print help [ default target ]
	@echo '-------------------------------------------------------------------'
	@grep -E '### .*$$' $(MAKEFILE_LIST) | grep -v '@grep' | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo '-------------------------------------------------------------------'

.PHONY: build
build: ### Build jenkins docker image
	docker build -t ${IMAGE_BUILD} .

.PHONY: push
push: ### Push image to registry
	@echo "$(DOCKER_PASSWORD)" | docker login -u "$(DOCKER_USERNAME)" --password-stdin $(DOCKER_REGISTRY)
	docker tag $(IMAGE_BUILD) $(IMAGE_RELEASE)
	docker push ${IMAGE_RELEASE}

.PHONY: update
update: build push ### Build and Push image to registry
