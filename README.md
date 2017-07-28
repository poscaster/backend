# Poscaster

[![Build Status](https://travis-ci.org/poscaster/backend.svg?branch=master)](https://travis-ci.org/poscaster/backend)
[![Coverage Status](https://coveralls.io/repos/github/poscaster/backend/badge.svg)](https://coveralls.io/github/poscaster/backend)


## Backend

### Clone project

    curl https://raw.githubusercontent.com/poscaster/backend/master/scripts/clone.sh | sudo bash

or

    mkdir poscaster
    cd poscaster

    git clone git@github.com:poscaster/backend.git
    git clone git@github.com:poscaster/frontend.git

### Run

    mix phoenix.server

#### First run

    cp config/dev.secret.exs{.example,}
    nano config/dev.secret.exs
    cp config/test.secret.exs{.example,}
    nano config/test.secret.exs
    mix deps.get
    mix ecto.create

### Testing and coverage

#### Run tests

    MIX_ENV=test mix test

#### Get coverage

    MIX_ENV=test mix coveralls.html

The coverage info is placed under `cover/excoveralls.html`.

#### Static code analysis

    mix credo --strict

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

## Misc

### Generating Guardian key

    {_, key} = JOSE.JWK.to_binary(JOSE.JWS.generate_key(%{"alg" => "HS512"})); key
    # => "{\"alg\":\"HS512\",\"k\":\"SECRET\",\"kty\":\"oct\",\"use\":\"sig\"}"

Use the `key` value as `GUARDIAN_SECRET_KEY`.
