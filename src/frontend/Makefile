DKR_CONTAINER_NAME?= paasteurizers-frontend

DKR_IMAGE_FAMILY_NAME?= paasteurizers/frontend
DKR_IMAGE_TAG?= v1
DKR_IMAGE_NAME?= $(DKR_IMAGE_FAMILY_NAME):$(DKR_IMAGE_TAG)

DOCKER?= docker

#---------------------------------------------------------------------- IMAGE

build_image:
	$(DOCKER) build -t $(DKR_IMAGE_NAME) .

dive_image:
	dive $(DKR_IMAGE_NAME)

dive_from:
	dive grafana/grafana:7.0.3

inspect_image:
	$(DOCKER) inspect $(DKR_IMAGE_NAME)

inspect_from:
	$(DOCKER) inspect grafana/grafana:7.0.3

push_image:
	$(DOCKER) push $(DKR_IMAGE_NAME)

view_images:
	$(DOCKER) images | grep $(DKR_IMAGE_FAMILY_NAME)

#---------------------------------------------------------------------- CONTAINERS

delete_container:
	$(DOCKER) container rm $(DKR_CONTAINER_NAME)

restart_container: stop_container start_container

ssh_container:
	$(DOCKER) exec -it $(DKR_CONTAINER_NAME)  /bin/sh

sleep:
	# use embedded configuration
	$(DOCKER) run --detach \
			--name $(DKR_CONTAINER_NAME) \
			-v $(abspath .):/app \
			$(DKR_IMAGE_NAME) infinity
			# --entrypoint /bin/sleep \
			# --rm \

start_container:
	# use embedded configuration
	$(DOCKER) run --detach \
			--name $(DKR_CONTAINER_NAME) \
			--publish 8090:8089 \
			-v $(abspath .):/app \
			$(DKR_IMAGE_NAME) \
			# --rm \
			# --host http://127.0.0.1:80

stop_container:
	$(DOCKER) stop $(DKR_CONTAINER_NAME)

tail_container:
	$(DOCKER) logs -f $(DKR_CONTAINER_NAME)

view_containers:
	$(DOCKER) ps -a
