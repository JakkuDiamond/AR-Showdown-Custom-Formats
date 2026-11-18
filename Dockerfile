FROM node:22-bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    git ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY setup.sh /app/setup.sh
RUN chmod +x /app/setup.sh && /app/setup.sh

RUN printf "// already built during docker build\n" > /app/pokemon-showdown/build

RUN printf "\nexports.proxyip = true;\nexports.usesqlite = false;\nexports.usesqlitepm = false;\n" \
    >> /app/pokemon-showdown/config/config.js

RUN echo "JakkuDiamond,~" >> /app/pokemon-showdown/config/usergroups.csv

WORKDIR /app/pokemon-showdown
CMD ["/bin/sh", "-c", "cd /app/pokemon-showdown && exec node pokemon-showdown start --skip-build ${PORT:-8000}"]
