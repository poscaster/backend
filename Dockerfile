FROM bitwalker/alpine-elixir-phoenix:latest

ARG backend_source=./backend
ARG frontend_source=./frontend

ENV BACKEND_APP=/opt/app/backend \
  FRONTEND_APP=/opt/app/frontend \
  PORT=5000 \
  MIX_ENV=prod

EXPOSE 5000

RUN mkdir -p $BACKEND_APP $FRONTEND_APP

# Cache elixir deps
WORKDIR $BACKEND_APP
COPY ${backend_source}/mix.exs ${backend_source}/mix.lock ./
RUN mix do deps.get, deps.compile

# Cache node deps
WORKDIR $FRONTEND_APP
COPY ${frontend_source}/package.json ./
RUN apk --update add build-base nasm autoconf automake libtool libpng-dev python && \
    apk add libpng libstdc++ && \
    npm install && \
    apk del git build-base nasm autoconf automake libpng-dev python && \
    rm -rf /var/cache/apk/* && \
    echo $?

ADD $frontend_source $FRONTEND_APP

RUN npm run build

WORKDIR $BACKEND_APP
ADD $backend_source $BACKEND_APP
RUN mix compile
CMD ["mix", "phoenix.server"]
