# Poscaster

[![Build Status](https://travis-ci.org/poscaster/backend.svg?branch=master)](https://travis-ci.org/poscaster/backend)
[![Coverage Status](https://coveralls.io/repos/github/poscaster/backend/badge.svg)](https://coveralls.io/github/poscaster/backend)


## Backend

### Clone project

    curl https://raw.githubusercontent.com/poscaster/backend/master/scripts/clone.sh | bash

### Run

    mix phoenix.server

#### First run

    cp config/dev.secret.exs{.example,}
    nano config/dev.secret.exs
    cp config/test.secret.exs{.example,}
    nano config/test.secret.exs
    mix deps.get
    mix ecto.create

## Docker

This repo includes Dockerfile to prepare an image for poscaster
deployment. Image also includes compiled
[poscaster/frontend](https://github.com/poscaster/frontend), so
you need that cloned as well.

Assuming you are starting in this repository:

    cp .dockerignore ../
    cd ../
    git clone https://github.com/poscaster/frontend
    docker build -t poscaster -f backend/Dockerfile .
    docker run -p 5000:5000 --net=host -e DATABASE_URL=postgres://postgres@localhost:5432/poscaster poscaster
