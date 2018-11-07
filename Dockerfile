FROM elixir:1.7-alpine as builder

ENV MIX_ENV prod

WORKDIR /opt/app

RUN apk update && \
  apk upgrade --no-cache && \
  apk add --no-cache \
  build-base \
  nodejs \
  yarn && \
  mix local.rebar --force && \
  mix local.hex --force

ADD . .

RUN mix do deps.get, deps.compile, compile

RUN rel/assets.sh && mix phx.digest

RUN mkdir -p /opt/release && \
  mix release --verbose && \
  RELEASE=$(ls -d _build/prod/rel/revista/releases/*/revista.tar.gz) && \
  cp $RELEASE /opt/release && \
  cd /opt/release && \
  tar -xzf revista.tar.gz && \
  rm revista.tar.gz

FROM alpine:3.8

RUN apk update && \
  apk add --no-cache \
  bash \
  openssl-dev

WORKDIR /opt/app

COPY --from=builder /opt/release .

CMD ["/opt/app/bin/revista", "foreground"]
