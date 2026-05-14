#!/bin/bash
set -e

echo "===== Install Nginx ====="

apt-get install -y nginx || true

echo "===== Remove IPv6 listen config ====="

find /etc/nginx -type f -name "*.conf" -o -name "default" | while read file; do
  sed -i '/listen.*\[::\].*/d' "$file" || true
done

sed -i '/listen.*\[::\].*/d' /etc/nginx/sites-available/default 2>/dev/null || true
sed -i '/listen.*\[::\].*/d' /etc/nginx/sites-enabled/default 2>/dev/null || true

echo "===== Reconfigure nginx package ====="

dpkg --configure -a

systemctl enable nginx

nginx -t
systemctl restart nginx

if [ -f /etc/nginx/sites-enabled/default ]; then
  rm -f /etc/nginx/sites-enabled/default
fi

nginx -t
systemctl reload nginx

echo "===== Nginx Installed ====="