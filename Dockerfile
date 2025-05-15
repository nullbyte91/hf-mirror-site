FROM golang:1.21 AS builder

# Install xcaddy and build Caddy with plugins
RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

WORKDIR /build

RUN xcaddy build \
  --with github.com/caddyserver/replace-response \
  --with github.com/caddyserver/transform-encoder

# Final minimal image
FROM alpine:3.18

RUN apk add --no-cache curl ca-certificates

COPY --from=builder /build/caddy /usr/bin/caddy
COPY ./scripts/caddy/Caddyfile /etc/caddy/Caddyfile

EXPOSE 8080
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
