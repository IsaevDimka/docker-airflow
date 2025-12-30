# suppress output, run `make XXX V=` to be verbose
V := @

COMPOSE_FILE := -f docker-compose.yml

THIS_FILE := $(lastword $(MAKEFILE_LIST))

include .env

.DEFAULT_GOAL : help
help:
	@make -pRrq  -f $(THIS_FILE) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | grep -E -v -e '^[^[:alnum:]]' -e '^$@$$'

.PHONY: init
init: \
	docker-clear \
	docker-up

.PHONY: docker-down
docker-down:
	$(V)COMPOSE_PROFILES=${COMPOSE_PROFILES} docker compose down --volumes --rmi all

.PHONY: docker-clear
docker-clear: docker-down
docker-clear:
	$(V)echo "Remove ./volumes ./config ./logs"
	$(V)rm -rf ./volumes ./config ./logs

.PHONY: docker-up
docker-up:
	$(V)docker compose pull
	$(V)docker compose build --build-arg local_ip=$(LOCAL_IP)
	$(V)docker compose up -d

.PHONY: docker-start
docker-start:
	$(V)docker compose ${COMPOSE_FILES} up -d

.PHONY: docker-stop
docker-stop:
	$(V)docker compose ${COMPOSE_FILES} down
