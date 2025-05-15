# --- Build custom Caddy with plugins ---
FROM caddy:builder AS builder

RUN xcaddy build \
    --with github.com/caddyserver/replace-response \
    --with github.com/caddyserver/transform-encoder

# --- Final stage: strip out the setcap step ---
FROM caddy:latest

# Set a non-root user to prevent permission issues
USER caddy

# Copy the custom Caddy binary
COPY --from=builder /usr/bin/caddy /usr/bin/caddy

# Copy your config
COPY ./scripts/caddy/Caddyfile /etc/caddy/Caddyfile

# Use port 8080 for Render compatibility
EXPOSE 8080

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
