
FROM golang:1.23-alpine AS builder

# Install build dependencies
RUN apk add --no-cache git ca-certificates

# Set Go environment variables
ENV GO111MODULE=on
ENV GOPROXY=https://proxy.golang.org,direct
ENV GOSUMDB=sum.golang.org

# Install xcaddy
RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

# Build caddy with forwardproxy plugin using stable versions
# Use Caddy v2.8.4 which is known to work well with these plugins
RUN xcaddy build v2.8.4 \
    --with github.com/caddyserver/forwardproxy@latest \
    --with github.com/mholt/caddy-l4@latest

# Final stage
FROM alpine:3.20.0

LABEL description="Docker image for caddy+forwardproxy+layer4 plugin."
LABEL maintainer="zeocax@zeocax.com"

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
