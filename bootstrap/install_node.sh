#!/bin/bash
set -e

echo "===== Install Node.js ${NODE_MAJOR} ====="

curl -fsSL "https://deb.nodesource.com/setup_${NODE_MAJOR}.x" | bash -

apt-get install -y nodejs

echo "===== Install PM2 ====="
npm install -g pm2

pm2 install pm2-logrotate

pm2 startup systemd -u "$APP_USER" --hp "/home/$APP_USER" || true