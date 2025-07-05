# 步驟一：從官方的 Caddy builder 鏡像開始，它包含了完整的標準模組
FROM caddy:2.8.4-builder-alpine AS builder

RUN xcaddy build \
    --with github.com/caddyserver/forwardproxy@latest \
    --with github.com/mholt/caddy-l4@latest

# 步驟二：最終鏡像也使用對應版本的官方鏡像
FROM caddy:2.8.4-alpine

# 將我們剛剛編譯好的、包含額外插件的 Caddy 執行檔複製進來，
# 覆蓋掉原本的 Caddy 執行檔。
COPY --from=builder /usr/bin/caddy /usr/bin/caddy

# -------------------------------------------------------------
# 您 Dockerfile 中剩餘的部分可以保持不變
# -------------------------------------------------------------

LABEL description="Docker image for caddy+forwardproxy+layer4 plugin."
LABEL maintainer="zeocax@zeocax.com"

RUN apk add --no-cache bash curl

# Make caddy executable (通常不需要，但保留無妨)
RUN chmod +x /usr/bin/caddy

COPY gen_caddyfile_and_start.sh /bin/
RUN chmod +x /bin/gen_caddyfile_and_start.sh

VOLUME /root/.caddy

EXPOSE 80 443 2015

ENTRYPOINT ["/bin/gen_caddyfile_and_start.sh"]