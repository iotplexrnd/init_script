#!/bin/bash
set -e

echo "===== Install Nginx ====="

apt-get install -y nginx

systemctl enable nginx
systemctl start nginx

mkdir -p /etc/nginx/sites-available
mkdir -p /etc/nginx/sites-enabled

if [ -f /etc/nginx/sites-enabled/default ]; then
  rm -f /etc/nginx/sites-enabled/default
fi

nginx -t
systemctl reload nginx