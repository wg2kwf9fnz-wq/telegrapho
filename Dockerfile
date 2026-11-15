FROM node:20-alpine

WORKDIR /app

# Install production dependencies
COPY package*.json ./
RUN npm ci --omit=dev

COPY . .

# Run the app as the unprivileged node user (UID/GID 1000).
# Umbrel's pre-start hook prepares the persistent /data mount ownership.
USER node

EXPOSE 3712

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s \
  CMD wget -qO- http://localhost:3712/health || exit 1

CMD ["node", "server.js"]
