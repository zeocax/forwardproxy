#!/usr/bin/env bash

CADDYFILE="${CADDYFILE:-/etc/caddy/Caddyfile}"
ROOTDIR="${ROOTDIR:-/srv/index}"
SITE_ADDRESS="${SITE_ADDRESS:-localhost}"

generate_caddyfile() {
    mkdir -p "$(dirname "${CADDYFILE}")"
    mkdir -p "${ROOTDIR}"

    echo "${SITE_ADDRESS} {" > ${CADDYFILE}
    echo "  root * ${ROOTDIR}" >> ${CADDYFILE}
    echo "  file_server" >> ${CADDYFILE}

    echo "  forward_proxy {" >> ${CADDYFILE}
    if [[ ! -z ${PROXY_USERNAME} ]]; then
        echo "    basic_auth ${PROXY_USERNAME} ${PROXY_PASSWORD}" >> ${CADDYFILE}
    fi
    if [[ "${PROBE_RESISTANT}" = true ]]; then
        echo "    probe_resistance ${SECRET_LINK}" >> ${CADDYFILE}
    fi
    echo "  }" >> ${CADDYFILE}

    echo "}" >> ${CADDYFILE}
}

if [ -f "${CADDYFILE}" ]; then
    echo "Using provided Caddyfile"
else
    echo "Caddyfile is not provided: generating new one"
    generate_caddyfile
fi

echo "Generated Caddyfile content:"
cat ${CADDYFILE}

# Use Caddy v2 command format
exec caddy run --config ${CADDYFILE} ${CADDY_OPTS}
