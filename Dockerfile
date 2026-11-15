FROM node:20-alpine

WORKDIR /app

# Install production dependencies
COPY package*.json ./
RUN npm ci --omit=dev

COPY . .

# The official node:20-alpine image already provides node with UID/GID 1000.
# Prepare the persistent bind mount as root, then drop privileges to node.
RUN apk add --no-cache su-exec

EXPOSE 3712

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s \
  CMD wget -qO- http://localhost:3712/health || exit 1

CMD ["sh", "-c", "mkdir -p /data && chown node:node /data && exec su-exec node node server.js"]
