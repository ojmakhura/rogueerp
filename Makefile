include ./Makefile.dev

gen_self_certs:
	chmod 755 .env && . ./.env && sudo rm ${ROGUE_ERP_DATA}/traefik/${DOMAIN}.crt && chmod 755 .env && . ./.env && sudo rm ${ROGUE_ERP_DATA}/traefik/${DOMAIN}.key && chmod 755 .env && . ./.env && sudo openssl req -x509 -sha256 -days 356 -nodes -newkey rsa:2048 -out ${ROGUE_ERP_DATA}/traefik/${DOMAIN}.crt -keyout ${ROGUE_ERP_DATA}/traefik/${DOMAIN}.key


##
## Start the docker containers
##
up_full_app: up_proxy up_db

up_db:
	chmod 755 .env && . ./.env && docker stack deploy -c docker-compose-db.yml ${STACK_NAME}-db

down_db:
	docker stack rm ${STACK_NAME}-db

up_keycloak: build_keycloak_image
	chmod 755 .env && . ./.env && docker stack deploy -c docker-compose-keycloak.yml ${STACK_NAME}-keycloak

down_keycloak:
	docker stack rm ${STACK_NAME}-keycloak

up_proxy: 
	chmod 755 .env && . ./.env && docker stack deploy -c docker-compose-traefik.yml ${STACK_NAME}-proxy

down_proxy:
	docker stack rm ${STACK_NAME}-proxy


##
## System initialisation
##
swarm_init:
	docker swarm init

rpgueerp_network:
	docker network create --driver overlay rogueerp-public

local_prep: gen_env
	. ./.env && mkdir ${ROGUE_ERP_DATA}
	. ./.env && mkdir ${ROGUE_ERP_DATA}/db
	. ./.env && mkdir ${ROGUE_ERP_DATA}/auth
	. ./.env && cp traefik_passwd ${ROGUE_ERP_DATA}/auth/system_passwd
	. ./.env && mkdir ${ROGUE_ERP_DATA}/keycloak
	. ./.env && mkdir ${ROGUE_ERP_DATA}/certs
	. ./.env && cp deployment/certs/* ${ROGUE_ERP_DATA}/certs
	. ./.env && mkdir ${ROGUE_ERP_DATA}/registry
	. ./.env && mkdir ${ROGUE_ERP_DATA}/traefik
	. ./.env && cp deployment/traefik/config.yml ${ROGUE_ERP_DATA}/traefik
	. ./.env && mkdir ${ROGUE_ERP_DATA}/web

##
## Environment management
##
rm_env:
	rm -f .env

gen_env:
ifdef env
	if [ -f .env ]; then \
		rm -f .env; \
	fi
	@$(${env}_ENV)
	chmod 755 .env
else
	@echo 'no env defined. Please run again with `make env=<LOCAL_ENV, DEV_ENV, TEST_ENV, LIVE_ENV> target`'
	exit 1
endif