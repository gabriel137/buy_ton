FROM bitwalker/alpine-elixir:1.15 AS build

RUN apk update \
    && apk add --no-cache tzdata ncurses-libs postgresql-client build-base openssh-client \
    && cp /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime \
    && echo "America/Sao_Paulo" > /etc/timezone \
    && apk del tzdata
    
WORKDIR /app

ARG MIX_ENV=prod

RUN mix local.hex --force && mix local.rebar --force

COPY mix.exs mix.lock ./
COPY config config

RUN mix do deps.get, deps.compile

COPY . ./

RUN mix do compile, release

COPY start.sh ./
CMD ["sh", "./start.sh"]