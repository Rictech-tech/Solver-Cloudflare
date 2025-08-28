#!/bin/bash
set -e

declare -r REPO_URL="https://github.com/odell0111/turnstile_solver.git"

# Config timezone
[[ -n "${TZ}" ]] && {
    ln -sf "/usr/share/zoneinfo/${TZ}" /etc/localtime
    echo "${TZ}" >/etc/timezone
}

# Instalar repo
pip3 install "git+${REPO_URL}@main" --no-cache-dir

# Instalar patchright + chrome
pip3 install --no-cache-dir patchright
patchright install chrome

# Arrancar el solver server
echo "🚀 Iniciando solver en puerto ${SOLVER_SERVER_PORT:-8088}"
exec solver \
  --browser "${SOLVER_BROWSER:-chrome}" \
  --port "${SOLVER_SERVER_PORT:-8088}" \
  --secret "${SOLVER_SECRET:-jWRN7DH6}" \
  --max-attempts 3 \
  --captcha-timeout 30 \
  --page-load-timeout 30
