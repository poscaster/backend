FROM bitwalker/alpine-elixir-phoenix:latest

ARG backend_source=./backend
ARG frontend_source=./frontend

ENV BACKEND_APP=/opt/app/backend \
  FRONTEND_APP=/opt/app/frontend \
  SKIP_SASS_BINARY_DOWNLOAD_FOR_CI=true \
  PORT=5000 \
  MIX_ENV=prod

EXPOSE 5000

RUN adduser -D poscaster -h /opt/app
USER poscaster

RUN mkdir -p $BACKEND_APP $FRONTEND_APP

# Cache node deps
WORKDIR $FRONTEND_APP
COPY ${frontend_source}/package.json ./
RUN apk --update add build-base nasm autoconf automake libtool libpng-dev python && \
    apk add libpng libstdc++ && \
    npm install --silent --unsafe-perm && \
    apk del build-base nasm autoconf automake libpng-dev python g++ libtool && \
    rm -rf /var/cache/apk/*

# Cache elixir deps
WORKDIR $BACKEND_APP
COPY ${backend_source}/mix.exs ${backend_source}/mix.lock ./
RUN mix do deps.get, deps.compile

ADD $frontend_source $FRONTEND_APP

WORKDIR $FRONTEND_APP
RUN npm run build

WORKDIR $BACKEND_APP
ADD $backend_source $BACKEND_APP

RUN unlink priv/static && cp -R ../frontend/dist priv/static
RUN mix compile
RUN mix phoenix.digest

CMD ["mix", "phoenix.server"]
