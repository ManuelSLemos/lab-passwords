FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    openssh-server \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /run/sshd

# Usuario para la demo de fuerza bruta clásica: contraseña débil y predecible
RUN useradd -m -s /bin/bash admin \
    && echo "admin:admin123" | chpasswd

# Usuarios para la demo de password spraying: contraseñas fuertes,
# salvo "carol", que comparte una contraseña débil muy común
RUN useradd -m -s /bin/bash alice  && echo "alice:Xk9#mQ2vLp\$7wR"  | chpasswd
RUN useradd -m -s /bin/bash bob    && echo "bob:Tz4@nF8jUe\$2qD"    | chpasswd
RUN useradd -m -s /bin/bash carol  && echo "carol:Summer2026!"      | chpasswd
RUN useradd -m -s /bin/bash diego  && echo "diego:Hj6%rW1sYk\$9pL"  | chpasswd

RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config \
    && ssh-keygen -A

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D", "-e"]
