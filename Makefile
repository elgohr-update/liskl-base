VERSION=0.0.2

APP_NAME = "alpine-base"

NAMESPACE = "liskl"

ALPINE_VERSION = 3.14.1

# location of Dockerfiles
DOCKER_FILE_DIR = "dockerfiles"
DOCKERFILE = "${DOCKER_FILE_DIR}/Dockerfile"

IMAGE_NAME = "${APP_NAME}"
CUR_DIR = $(shell echo "${PWD}")

#################################
# Docker targets
#################################
.PHONY: clean-image
clean-image: version-check
	@echo "+ $@"
	@docker rmi ${NAMESPACE}/${IMAGE_NAME}:latest  || true
	@docker rmi ${NAMESPACE}/${IMAGE_NAME}:${VERSION}  || true

.PHONY: image
image: version-check
	@echo "+ $@"
	@docker build -t ${NAMESPACE}/${IMAGE_NAME}:${VERSION}-x86_64 --build-arg ARCH=x86_64 --build-arg ALPINE_VERSION -f ./${DOCKERFILE} .
	@docker build -t ${NAMESPACE}/${IMAGE_NAME}:${VERSION}-armhf --build-arg ARCH=armhf -f ./${DOCKERFILE} .
	@docker build -t ${NAMESPACE}/${IMAGE_NAME}:${VERSION}-aarch64 --build-arg ARCH=aarch64 -f ./${DOCKERFILE} .

	@docker manifest create ${NAMESPACE}/${IMAGE_NAME}:${VERSION}-latest \
		--amend ${NAMESPACE}/${IMAGE_NAME}:${VERSION}-x86_64 \
		--amend ${NAMESPACE}/${IMAGE_NAME}:${VERSION}-armhf \
		--amend ${NAMESPACE}/${IMAGE_NAME}:${VERSION}-aarch64

	@docker manifest create ${NAMESPACE}/${IMAGE_NAME}:${VERSION} \
		--amend ${NAMESPACE}/${IMAGE_NAME}:${VERSION}-x86_64 \
		--amend ${NAMESPACE}/${IMAGE_NAME}:${VERSION}-armhf \
		--amend ${NAMESPACE}/${IMAGE_NAME}:${VERSION}-aarch64

	#@docker build -t ${NAMESPACE}/${IMAGE_NAME}:${VERSION} -f ./${DOCKERFILE} .
	#@docker tag ${NAMESPACE}/${IMAGE_NAME}:${VERSION} ${NAMESPACE}/${IMAGE_NAME}:latest
	@echo 'Done.'
	@docker images --format '{{.Repository}}:{{.Tag}}\t\t Built: {{.CreatedSince}}\t\tSize: {{.Size}}' | \
		grep ${IMAGE_NAME}:${VERSION}

.PHONY: push
push: clean-image image
	@echo "+ $@"
	@docker push ${NAMESPACE}/${IMAGE_NAME}:${VERSION}-x86_64
	@docker push ${NAMESPACE}/${IMAGE_NAME}:${VERSION}-armhf
	@docker push ${NAMESPACE}/${IMAGE_NAME}:${VERSION}-aarch64

	@docker push ${NAMESPACE}/${IMAGE_NAME}:${VERSION}
	@docker push ${NAMESPACE}/${IMAGE_NAME}:latest


#################################
# Utilities
#################################

.PHONY: version-check
version-check:
	@echo "+ $@"
	if [ -z "${VERSION}" ]; then \
		echo "VERSION is not set" ; \
		false ; \
	else \
		echo "VERSION is ${VERSION}"; \
	fi