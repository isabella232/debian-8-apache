PWD = $(shell pwd)
IMAGE_NAME = $(shell basename ${PWD})
BASE_IMAGE = $(shell grep Dockerfile -e FROM | cut -d ' ' -f 2)
DOCKER_SOCKET = /var/run/docker.sock
BUILD_ARGS = --rm
TPACK_IMAGE = 1and1internet/testpack-framework

all: pull build test

pull:
	##
	## Pulling image updates from registry
	##
	for IMAGE in ${BASE_IMAGE} ${TPACK_IMAGE}; \
		do docker pull $${IMAGE}; \
	done

build:
	##
	## Starting build of image ${IMAGE_NAME}
	##
	docker build ${BUILD_ARGS} --tag ${IMAGE_NAME} .

test:
	docker run --rm -i -v ${DOCKER_SOCKET}:/var/run/docker.sock -v ${PWD}/:/mnt/ -e IMAGE_NAME=${IMAGE_NAME} --network=host -e SOURCE_MOUNT=${PWD} ${TPACK_IMAGE}

clean:
	##
	## Removing docker images .. most errors during this stage are ok, ignore them
	##
	for IMAGE in ${BASE_IMAGE} ${TPACK_IMAGE}; \
		do docker rmi $${IMAGE}; \
	done

.PHONY: all pull build test clean
