# Build Caddy with plugins
FROM caddy:builder AS builder
RUN xcaddy build \
    --with github.com/caddyserver/replace-response \
    --with github.com/caddyserver/transform-encoder

# Use the built Caddy
FROM caddy:latest
COPY --from=builder /usr/bin/caddy /usr/bin/caddy

# Copy config
COPY ./scripts/caddy/Caddyfile /etc/caddy/Caddyfile
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile"]
