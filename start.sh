#!/bin/sh

echo "Aguardando Splash acordar..."
until curl -sf $SPLASH_URL > /dev/null; do
  echo "Splash dormindo, tentando novamente..."
  sleep 5
done
echo "Splash pronto!"

sed -i "s/\$PORT/$PORT/g" /app/nginx.conf
cp /app/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf

# Registra webhook
curl -s "https://api.telegram.org/bot${TELEGRAM_TOKEN}/setWebhook?url=${RENDER_EXTERNAL_URL}/webhook"

exec openresty -g 'daemon off;'