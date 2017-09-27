FROM ruby:2.4.1
MAINTAINER antonio.s.m.gatto@gmail.com

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get install apt-transport-https -y --no-install-recommends apt-utils

RUN apt-get update \
    && apt-get install -y build-essential \
    locales \
    nodejs \
    git \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

### Set locale ###
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen en_US.UTF-8 && \
    dpkg-reconfigure locales && \
    /usr/sbin/update-locale LANG=en_US.UTF-8
ENV LC_ALL en_US.UTF-8

## Usuário para desenvolvimento ###
RUN useradd -p "" -ms /bin/bash developer
ENV HOME /home/developer
USER developer

### Install basic gems ###
RUN gem install foreman

### Instalando dependencias do projeto ###
ADD Gemfile /tmp/Gemfile
ADD Gemfile.lock /tmp/Gemfile.lock
WORKDIR /tmp
RUN bundle install

### Criando path para armazenar o cÃ³digo ###
ENV APP_DIR $HOME/app
RUN mkdir -p $APP_DIR

### Setando path para o cÃ³digo como diretÃ³rio de trabalho ###
WORKDIR $APP_DIR

EXPOSE 3000