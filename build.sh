#!/bin/bash
#
# Realiza o build das imagens docker do projeto
#

npm install

# Limpa qualquer containers existente
docker-compose kill
docker-compose rm --force

# Cria as imagens e sobe os containers
docker-compose build
docker-compose up -d
