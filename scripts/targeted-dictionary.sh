#!/usr/bin/env bash
# Demo 3 — Diccionario dirigido con cewl + OSINT
#
# ANTES de ejecutar: edita target-web/site/index.html con el nombre de
# empresa, productos y equipo que proponga la clase. No hace falta
# reconstruir nada — nginx sirve ese fichero montado por volumen, solo
# guarda el cambio.
#
# Ejecutar desde el host, con el lab ya arrancado (docker compose up -d):
#   ./scripts/targeted-dictionary.sh

set -e
cd "$(dirname "$0")/.."
pause() { read -rp $'\n[Enter para continuar] '; }
run() { docker compose exec -T attacker bash -c "$1"; }

echo "== 1) Generando el diccionario con cewl contra la web del objetivo =="
run "cewl -w /lab/diccionario_dirigido.txt -d 2 http://target-web/"
run "wc -l /lab/diccionario_dirigido.txt && cat /lab/diccionario_dirigido.txt"
pause

echo "== 2) Construyendo hashes de contraseñas con el patrón 'Empresa2026!' =="
echo "    (sustituye EmpresaFicticia por el nombre real que use la web de la demo)"
run "rm -f /lab/hashes_osint.txt"
for p in "EmpresaFicticia2026!" "Logitrack2026" "empresaficticia123"; do
    run "printf '%s' '$p' | md5sum | awk '{print \$1}' >> /lab/hashes_osint.txt"
done
run "cat /lab/hashes_osint.txt"
pause

echo "== 3) hashcat: diccionario generado + reglas best66 =="
run "hashcat -a 0 -m 0 -r /usr/share/hashcat/rules/best66.rule /lab/hashes_osint.txt /lab/diccionario_dirigido.txt --quiet --force" || true
echo
echo "Si no cae todo: añade al diccionario el nombre + año a mano y repite,"
echo "para mostrar en vivo por qué el patrón 'Empresa+Año+!' es tan débil."
