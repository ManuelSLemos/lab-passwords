# Lab Docker — Ataques de Contraseñas

Laboratorio para las 4 demos de la sesión, aislado en una red Docker propia
(`lab-passwords`), sin ningún puerto publicado hacia fuera del host.

## Qué hay dentro

| Servicio | Qué es | Para qué demo |
|---|---|---|
| `attacker` | Kali con hashcat, hydra, cewl, impacket, smbclient | Las 4 |
| `target-ssh` | Debian + OpenSSH con usuarios y contraseñas débiles | Demo 2 |
| `target-web` | nginx sirviendo una web de empresa ficticia (editable en vivo) | Demo 3 |
| `target-samba` | Debian + Samba con un usuario y hash NTLM | Demo 4 |

## Antes de la clase

Prueba la descarga una vez, con calma y con buena conexión — la imagen
`kalilinux/kali-rolling` y sus paquetes pesan bastante:

```bash
docker compose build
```

## Arrancar el lab

```bash
docker compose up -d
```

## Las 4 demos

Cada una es un script que se ejecuta desde la raíz del repo, en el host
(no hace falta entrar a ningún contenedor). Van parando entre pasos con
`[Enter para continuar]`, para que marques el ritmo en clase:

```bash
./scripts/crack-offline.sh "contraseña1" "contraseña2" "contraseña3"
./scripts/bruteforce-online.sh
./scripts/targeted-dictionary.sh
./scripts/ntlm-pass-the-hash.sh
```

- **Demo 1** acepta como argumentos las contraseñas que propongan los
  alumnos; sin argumentos usa 3 de ejemplo.
- **Demo 3**: antes de lanzarla, edita `target-web/site/index.html` con el
  nombre de empresa, productos y equipo que decida la clase. Es un fichero
  montado por volumen — guardar el cambio basta, no hace falta reconstruir
  nada.
- Para ver los logs del objetivo mientras lo atacas (útil en la demo 2):
  ```bash
  docker compose logs -f target-ssh
  ```

## Apagar y limpiar

```bash
docker compose down
```

## La wordlist

`wordlists/common-passwords.txt` es una muestra generada con
`wordlists/build-sample.py` (unas 1.200 contraseñas muy comunes y sus
variantes), pensada para que las demos sean rápidas en directo. No es el
rockyou.txt real (14M líneas). Si quieres usar el real para que la demo
sea más realista, descárgalo tú mismo y colócalo en
`wordlists/rockyou.txt`, y cambia la ruta en los scripts de `scripts/`.

## Notas

- Nada se expone fuera del host: sin `ports:` en el compose, solo la red
  interna `lab-passwords`.
- Las contraseñas y usuarios de los objetivos están fijados en los
  `Dockerfile` de cada uno (`target-ssh/Dockerfile`,
  `target-samba/Dockerfile`), por si quieres cambiarlos.
# lab-passwords
