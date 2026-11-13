FROM node:22-alpine
WORKDIR /app
COPY app.b64.part.* /tmp/
RUN cat /tmp/app.b64.part.* | base64 -d > /tmp/app.tar.gz \
    && tar -xzf /tmp/app.tar.gz -C /app \
    && rm -f /tmp/app.tar.gz /tmp/app.b64.part.* \
    && apk add --no-cache su-exec \
    && chmod +x /app/docker-entrypoint.sh \
    && mkdir -p /app/runtime \
    && chown node:node /app/runtime
ENV NODE_ENV=production \
    PORT=10000 \
    HOST=0.0.0.0 \
    DATA_FILE=/app/runtime/store.json \
    SECRET_FILE=/app/runtime/link-secret.key \
    QUESTION_BANK_FILE=/app/data/banco_acompanhamento.json
VOLUME ["/app/runtime"]
EXPOSE 10000
ENTRYPOINT ["/app/docker-entrypoint.sh"]
