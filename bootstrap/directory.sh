#!/bin/bash
set -e

echo "===== Create user/directories ====="

if ! id "$APP_USER" >/dev/null 2>&1; then
  useradd -m -s /bin/bash "$APP_USER"
fi

mkdir -p "$APP_HOME"
mkdir -p "$APP_HOME/projects"
mkdir -p "$APP_HOME/env"
mkdir -p "$APP_HOME/scripts"
mkdir -p "$APP_HOME/logs"

mkdir -p "$DATA_HOME"
mkdir -p "$DATA_HOME/postgres"
mkdir -p "$DATA_HOME/redis"
mkdir -p "$DATA_HOME/prometheus"
mkdir -p "$DATA_HOME/logs"

chown -R "$APP_USER:$APP_USER" "$APP_HOME"
chown -R "$APP_USER:$APP_USER" "$DATA_HOME"

cat > "$APP_HOME/scripts/check-server.sh" <<'EOF'
#!/bin/bash

echo "===== Docker ====="
docker --version || true
docker compose version || true

echo ""
echo "===== Node ====="
node -v || true
npm -v || true
pm2 -v || true

echo ""
echo "===== Nginx ====="
nginx -v || true

echo ""
echo "===== Disk ====="
df -h

echo ""
echo "===== Memory ====="
free -h
EOF

chmod +x "$APP_HOME/scripts/check-server.sh"
chown -R "$APP_USER:$APP_USER" "$APP_HOME/scripts"