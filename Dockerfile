FROM node:22-bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    git ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY setup.sh /app/setup.sh
RUN chmod +x /app/setup.sh && /app/setup.sh

RUN printf "\nexports.proxyip = true;\nexports.usesqlite = false;\nexports.usesqlitepm = false;\n" \
    >> /app/pokemon-showdown/config/config.js

WORKDIR /app/pokemon-showdown
CMD ["/bin/sh", "-c", "exec node pokemon-showdown ${PORT:-8000}"]
