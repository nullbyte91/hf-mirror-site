FROM golang:1.22 AS builder

# Install xcaddy
RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

WORKDIR /build

# Build Caddy without extra plugins (simpler approach)
RUN xcaddy build v2.7.6 \
  --output /build/caddy

FROM alpine:3.18

RUN apk add --no-cache curl ca-certificates

# Create required directories
RUN mkdir -p /var/www/html/hf-mirror.com
RUN mkdir -p /etc/caddy

# Copy the Caddy binary from builder stage
COPY --from=builder /build/caddy /usr/bin/caddy

# Copy configuration files
COPY ./scripts/caddy/Caddyfile /etc/caddy/Caddyfile

# Copy static website files
COPY ./dist/ /var/www/html/hf-mirror.com/

# Expose port
EXPOSE 8080

# Run Caddy
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
