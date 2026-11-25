FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    samba \
    smbclient \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /srv/samba/shared && chmod 0777 /srv/samba/shared

COPY smb.conf /etc/samba/smb.conf

# Usuario de demo con una contraseña débil, para que el hash NTLM
# resultante sea fácil de crackear con hashcat en la propia demo 1.
RUN useradd -M -s /usr/sbin/nologin administrator \
    && (echo "Password1"; echo "Password1") | smbpasswd -a -s administrator

EXPOSE 139 445
CMD ["/usr/sbin/smbd", "--foreground", "--no-process-group"]
