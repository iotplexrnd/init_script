#!/bin/bash
set -e

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"

APP_USER="${APP_USER:-iotstd}"
APP_HOME="${APP_HOME:-/home/iotstd}"
DATA_HOME="${DATA_HOME:-/data}"
NODE_MAJOR="${NODE_MAJOR:-22}"

export APP_USER
export APP_HOME
export DATA_HOME
export NODE_MAJOR
export DEBIAN_FRONTEND=noninteractive

echo "======================================="
echo "IOTSTD Bootstrap Start"
echo "======================================="
echo "USER: ${APP_USER}"
echo "HOME: ${APP_HOME}"
echo "DATA: ${DATA_HOME}"
echo "===== 1. System update ====="

apt-get update -y

apt-get install -y \
  curl \
  ca-certificates \
  gnupg \
  lsb-release \
  git \
  vim \
  unzip \
  htop \
  net-tools \
  ufw \
  logrotate

echo "===== 2. Timezone ====="

timedatectl set-timezone Asia/Seoul

echo "===== 3. Run install scripts ====="

bash "$BASE_DIR/scripts/directory.sh"
bash "$BASE_DIR/scripts/install_docker.sh"
bash "$BASE_DIR/scripts/install_node.sh"
bash "$BASE_DIR/scripts/install_nginx.sh"

echo "===== 4. Firewall ====="

ufw allow OpenSSH
ufw allow 80/tcp
ufw allow 443/tcp
ufw --force enable

echo "===== 5. Kernel tuning ====="

cat > /etc/sysctl.d/99-iotstd.conf <<EOF
fs.file-max = 1000000
net.core.somaxconn = 65535
net.ipv4.tcp_max_syn_backlog = 65535
net.ipv4.ip_local_port_range = 10000 65000
net.ipv4.tcp_tw_reuse = 1
EOF

sysctl --system

echo "===== 6. Limits ====="

cat > /etc/security/limits.d/99-iotstd.conf <<EOF
${APP_USER} soft nofile 65535
${APP_USER} hard nofile 65535
root soft nofile 65535
root hard nofile 65535
EOF

echo "===== 7. Ownership ====="

chown -R ${APP_USER}:${APP_USER} ${APP_HOME}

echo "===== 8. Cleanup ====="

apt-get autoremove -y
apt-get clean

echo "======================================="
echo "Bootstrap Complete"
echo "======================================="

echo ""
echo "Next:"
echo "su - ${APP_USER}"
echo "cd ~"
echo "./scripts/check-server.sh"
echo ""