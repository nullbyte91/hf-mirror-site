FROM golang:1.22 AS builder

RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

WORKDIR /build

RUN xcaddy build \
  --with github.com/caddyserver/replace-response@latest \
  --with github.com/caddyserver/transform-encoder@latest \
  --output /build/caddy \
  github.com/caddyserver/caddy/v2@v2.9.1

FROM alpine:3.18

RUN apk add --no-cache curl ca-certificates

COPY --from=builder /build/caddy /usr/bin/caddy
COPY ./scripts/caddy/Caddyfile /etc/caddy/Caddyfile

EXPOSE 8080
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
