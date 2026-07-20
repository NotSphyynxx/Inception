NAME = inception
COMPOSE_FILE = ./srcs/docker-compose.yml
DATA_DIR = /home/ilarhrib/data

all: up

up: 
	mkdir -p $(DATA_DIR)/wordpress
	mkdir -p $(DATA_DIR)/mariadb
	docker-compose -f $(COMPOSE_FILE) up -d --build

down:
	docker-compose -f $(COMPOSE_FILE) down

clean: down
	docker system prune -a --force

fclean: clean
	sudo rm -rf $(DATA_DIR)
	docker volume rm $$(docker volume ls -q) || true
	docker network rm inception || true

re: fclean all

.PHONY: all up down clean fclean re