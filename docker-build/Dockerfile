FROM golang:1.22-alpine AS builder

# Install build dependencies
RUN apk add --no-cache git ca-certificates

# Set Go environment variables
ENV GO111MODULE=on
ENV GOPROXY=https://proxy.golang.org,direct
ENV GOSUMDB=sum.golang.org
ENV CGO_ENABLED=0

# Install xcaddy
RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

# Create working directory
WORKDIR /build

# Build caddy with forwardproxy and caddy-l4 plugins
# First try building with verbose output to see any errors
RUN xcaddy build v2.8.4 \
    --with github.com/caddyserver/forwardproxy \
    --with github.com/mholt/caddy-l4 \
    --output /build/caddy

# Final stage
FROM alpine:3.18.2

LABEL description="Docker image for caddy+forwardproxy+layer4 plugin."
LABEL maintainer="SergeyFrolov@colorado.edu"

RUN apk add --no-cache ca-certificates bash curl

# Copy caddy binary from builder stage
COPY --from=builder /build/caddy /usr/bin/caddy

# Make caddy executable
RUN chmod +x /usr/bin/caddy

COPY gen_caddyfile_and_start.sh /bin/
RUN chmod +x /bin/gen_caddyfile_and_start.sh

VOLUME /root/.caddy

EXPOSE 80 443 2015

ENTRYPOINT ["/bin/gen_caddyfile_and_start.sh"]
