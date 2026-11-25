FROM kalilinux/kali-rolling

RUN apt-get update && apt-get install -y --no-install-recommends \
    hashcat \
    hydra \
    cewl \
    python3-impacket \
    openssh-client \
    smbclient \
    apache2-utils \
    curl \
    netcat-traditional \
    coreutils \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /lab

CMD ["sleep", "infinity"]
