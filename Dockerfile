FROM elixir:1.7.3-alpine as base

EXPOSE 4000
ENV MIX_ENV=dev

RUN apk add --update \
    git \
    make \
    alpine-sdk \
    && mix local.hex --force \
    && mix local.rebar --force

WORKDIR /usr/src/app

COPY . /usr/src/app
# RUN mix do deps.get --only $MIX_ENV, deps.compile

#####

FROM base as builder

ENV MIX_ENV=prod

RUN mix do deps.get --only $MIX_ENV, deps.compile

RUN mix release --env=$MIX_ENV --verbose

#####

FROM alpine:3.6

EXPOSE 4000
ENV PORT=4000 \
    MIX_ENV=prod \
    REPLACE_OS_VARS=true \
    SHELL=/bin/bash

RUN apk add --update \
    bash \
    ncurses-libs \
    openssl \
    curl

WORKDIR /usr/src/app

COPY --from=builder /usr/src/app/_build/prod/rel/server .

ENTRYPOINT ["/usr/src/app/bin/server"]
CMD ["foreground"]
