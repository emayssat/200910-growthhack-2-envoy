DOCKER?= docker
DOCKER_COMPOSE?= docker-compose

_default_target:
	grep --only-matching --extended-regexp '^[-_a-zA-Z0-9]+:' Makefile

CURL_BIN?= curl
__CURL_OPTIONS+= -s
CURL?= $(strip $(__CURL_ENVIRONMENT) $(CURL_ENVIRONMENT) $(CURL_BIN) $(__CURL_OPTIONS) $(CURL_OPTIONS))

fingerprint= $(shell cat $(1) | openssl x509 -outform DER | openssl sha1 -r | awk '{print $$1}')

#---------------------------------------------------------------------- APPLICATION

show_backend_envoy:
	cat backend/conf/envoy.yaml

start_backend: start_backend_agent start_backend_echo start_backend_envoy fingerprint_backend

start_backend_agent:
	docker-compose exec -T spire-server bin/spire-server bundle show | docker-compose exec -T backend tee conf/agent/bootstrap.crt > /dev/null
	docker-compose exec -d backend  bin/spire-agent run

start_backend_echo:
	docker-compose exec -d backend  /usr/local/bin/echo-server -log /opt/spire/echo-server.log
	sleep 1
	make curl_backend_8081

BACKEND_AGENT_FINGERPRINT?=$(call fingerprint, backend/etc/agent.crt.pem)
fingerprint_backend:
	echo "BACKEND_AGENT_FINGERPRINT=$(BACKEND_AGENT_FINGERPRINT)"
	docker-compose exec spire-server bin/spire-server entry create -parentID spiffe://paasteurizers.iam/spire/agent/x509pop/$(BACKEND_AGENT_FINGERPRINT) -spiffeID spiffe://paasteurizers.iam/ipc2/r2/echo-server -selector unix:user:root

start_backend_envoy:
	docker-compose exec -d backend /usr/local/bin/envoy -l debug -c /etc/envoy/envoy.yaml --log-path /opt/spire/envoy.log

show_frontend_envoy:
	cat frontend/conf/envoy.yaml

start_frontend: start_frontend_agent start_frontend_web start_frontend_envoy fingerprint_frontend

start_frontend_agent:
	docker-compose exec -T spire-server bin/spire-server bundle show | docker-compose exec -T frontend tee conf/agent/bootstrap.crt > /dev/null
	docker-compose exec -d frontend  bin/spire-agent run

start_frontend_web:
	docker-compose exec -d frontend  web-server -log /opt/spire/web-server.log

start_frontend_envoy:
	docker-compose exec -d frontend /usr/local/bin/envoy -l debug -c /etc/envoy/envoy.yaml --log-path /opt/spire/envoy.log

FRONTEND_AGENT_FINGERPRINT?=$(call fingerprint, frontend/etc/agent.crt.pem)
fingerprint_frontend:
	echo "FRONTEND_AGENT_FINGERPRINT=$(FRONTEND_AGENT_FINGERPRINT)"
	docker-compose exec spire-server bin/spire-server entry create -parentID spiffe://paasteurizers.iam/spire/agent/x509pop/$(FRONTEND_AGENT_FINGERPRINT) -spiffeID spiffe://paasteurizers.iam/ipc1/web-server -selector unix:user:root

kill_frontend_web:
	docker-compose exec -d frontend  killall web-server

curl_backend_8081:
	# DIRECT CONNECTION
	curl -s --resolve backend.paasteurizers.iam:8081:127.0.0.1 -v -w "\n%{http_code}\n" http://backend.paasteurizers.iam:8081/ -H 'X-From-The-Awesome-Team: paasteurizers'

curl_frontend_8080:
	-curl -s --resolve frontend.paasteurizers.iam:8080:127.0.0.1 -v -w "\n%{http_code}\n" http://frontend.paasteurizers.iam:8080/

curl_server_:
	# curl --cacert ../etc/certs/example.com.crt --resolve nginx.example.com:9443:127.0.0.1 -s -v -w "%{http_code}\n" https://nginx.example.com:9443/    -o /dev/null

ssh_backend:
	$(DOCKER_COMPOSE) exec backend /bin/sh

ssh_frontend:
	$(DOCKER_COMPOSE) exec frontend /bin/sh

ssh_server:
	$(DOCKER_COMPOSE) exec server /bin/sh

tail_backend:
	$(DOCKER_COMPOSE) logs -f backend

tail_frontend:
	$(DOCKER_COMPOSE) logs -f frontend

#---------------------------------------------------------------------- INFRA

show:
	$(DOCKER_COMPOSE) --compatibility -f docker-compose.v3.yml config

translate_config:
	docker-compose --compatibility -f docker-compose.v3.yml config | tee docker-compose.v2.yml

create_infrastructure: translate_config
	# $(DOCKER_COMPOSE) up --compatibility --detach --force-recreate --remove-orphans
	# $(DOCKER_COMPOSE) up --remove-orphans
	$(DOCKER_COMPOSE) up --detach --remove-orphans

delete_infrastructure:
	$(DOCKER_COMPOSE) down

#---------------------------------------------------------------------- CONTAINERS

build_containers:
	$(DOCKER_COMPOSE) build

run_container:
	# Run a single service
	$(DOCKER_COMPOSE) run --service-ports envoy
	# $(DOCKER_COMPOSE) run --service-ports flask
	# $(DOCKER_COMPOSE) run --service-ports httpbin

restart_containers:
	$(DOCKER_COMPOSE) up --force-recreate

# stop_containers:
#	$(DOCKER_COMPOSE) stop

view_containers:
	$(DOCKER_COMPOSE) ps
	$(DOCKER) ps -a

#---------------------------------------------------------------------- IMAGES

view_images:
	# $(DOCKER_COMPOSE) images
	$(DOCKER) image ls

#---------------------------------------------------------------------- NETWORK

view_networks:
	$(DOCKER) network ls

#-------------------------------------------------- DEBUG LEVEL

info_wasm:
	curl -X POST http://localhost:19000/logging?level=info

debug_wasm:
	curl -X POST http://localhost:19000/logging?level=info
	curl -X POST http://localhost:19000/logging?wasm=debug

trace_wasm:
	curl -X POST http://localhost:19000/logging?level=info
	curl -X POST http://localhost:19000/logging?wasm=trace
