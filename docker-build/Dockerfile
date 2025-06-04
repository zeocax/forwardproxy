FROM golang:1.21-alpine AS builder

# Install build dependencies
RUN apk add --no-cache git ca-certificates

# Install xcaddy
RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

# Build caddy with forwardproxy plugin
RUN xcaddy build --with github.com/caddyserver/forwardproxy

# Final stage
FROM alpine:3.18.2

LABEL description="Docker image for caddy+forwardproxy plugin."
LABEL maintainer="SergeyFrolov@colorado.edu"

RUN apk add --no-cache ca-certificates bash curl

# Copy caddy binary from builder stage
COPY --from=builder /go/caddy /usr/bin/caddy

# Make caddy executable
RUN chmod +x /usr/bin/caddy

COPY gen_caddyfile_and_start.sh /bin/
RUN chmod +x /bin/gen_caddyfile_and_start.sh

VOLUME /root/.caddy

EXPOSE 80 443 2015

ENTRYPOINT ["/bin/gen_caddyfile_and_start.sh"]
