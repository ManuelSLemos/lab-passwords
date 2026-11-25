#!/usr/bin/env bash
# Demo 1 — Cracking offline con hashcat
# Ejecutar desde el host, con el lab ya arrancado (docker compose up -d):
#   ./scripts/crack-offline.sh "contraseña1" "contraseña2" "contraseña3"
#
# Sin argumentos usa 3 contraseñas de ejemplo con distinto nivel de
# "complejidad" aparente, para discutir cuál creen los alumnos que caerá antes.

set -e
cd "$(dirname "$0")/.."
pause() { read -rp $'\n[Enter para continuar] '; }
run() { docker compose exec -T attacker bash -c "$1"; }

passwords=("$@")
if [ ${#passwords[@]} -eq 0 ]; then
    passwords=("1234" "C0ntr4se~a!" "estafraseeslargaynadiemelaadivina")
fi

echo "== Contraseñas de la clase =="
printf '  - %s\n' "${passwords[@]}"
pause

echo "== 1) Generando hashes MD5 (sin salt) =="
run "rm -f /lab/hashes_md5.txt"
for p in "${passwords[@]}"; do
    run "printf '%s' '$p' | md5sum | awk '{print \$1}' >> /lab/hashes_md5.txt"
done
run "cat /lab/hashes_md5.txt"
pause

echo "== 2) Generando un hash bcrypt (KDF lenta) de la primera contraseña =="
run "htpasswd -bnBC 10 user '${passwords[0]}' | cut -d: -f2 > /lab/hash_bcrypt.txt"
run "cat /lab/hash_bcrypt.txt"
pause

echo "== 3) hashcat en modo diccionario contra los hashes MD5 (-m 0) =="
run "hashcat -a 0 -m 0 /lab/hashes_md5.txt /lab/wordlists/common-passwords.txt --quiet --force" || true
pause

echo "== 4) hashcat con reglas (best66.rule) por si alguna no cae a palo seco =="
run "hashcat -a 0 -m 0 -r /usr/share/hashcat/rules/best66.rule /lab/hashes_md5.txt /lab/wordlists/common-passwords.txt --quiet --force" || true
pause

echo "== 5) El mismo diccionario contra el hash bcrypt (-m 3200): mucho más lento =="
echo "    (déjalo correr unos segundos y para con Ctrl+C para seguir con la clase)"
run "hashcat -a 0 -m 3200 /lab/hash_bcrypt.txt /lab/wordlists/common-passwords.txt --force"
