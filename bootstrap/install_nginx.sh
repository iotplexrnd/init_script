#!/bin/bash
set -e

echo "===== Install Nginx ====="

apt-get install -y nginx || true

echo "===== Disable IPv6 listen in default nginx config ====="

if [ -f /etc/nginx/sites-available/default ]; then
  sed -i '/listen \[::\]:80/d' /etc/nginx/sites-available/default
fi

if [ -f /etc/nginx/sites-enabled/default ]; then
  sed -i '/listen \[::\]:80/d' /etc/nginx/sites-enabled/default
fi

dpkg --configure -a

systemctl enable nginx

nginx -t
systemctl restart nginx

mkdir -p /etc/nginx/sites-available
mkdir -p /etc/nginx/sites-enabled

if [ -f /etc/nginx/sites-enabled/default ]; then
  rm -f /etc/nginx/sites-enabled/default
fi

nginx -t
systemctl reload nginx