# ---- Build Caddy with plugins ----
FROM caddy:builder AS builder
RUN xcaddy build \
    --with github.com/caddyserver/replace-response \
    --with github.com/caddyserver/transform-encoder

# ---- Final container ----
FROM caddy:latest
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
COPY ./scripts/caddy/Caddyfile /etc/caddy/Caddyfile

# Tell Render to expose 8080
EXPOSE 8080

# Don't bind to port 80
ENV CADDY_PORT=8080
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
