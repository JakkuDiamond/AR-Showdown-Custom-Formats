FROM node:22-bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    git ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY setup.sh /app/setup.sh
RUN chmod +x /app/setup.sh && /app/setup.sh

RUN printf "\nexports.proxyip = true;\nexports.usesqlite = false;\nexports.usesqlitepm = false;\n" \
    >> /app/pokemon-showdown/config/config.js

RUN printf "const cp = require('child_process'); const orig = cp.execSync; cp.execSync = (cmd, ...args) => String(cmd).includes('node build') ? Buffer.alloc(0) : orig.call(cp, cmd, ...args);\n" \
    > /app/skip-build.js

WORKDIR /app/pokemon-showdown
CMD ["/bin/sh", "-c", "cd /app/pokemon-showdown && exec node -r /app/skip-build.js pokemon-showdown start ${PORT:-8000}"]
