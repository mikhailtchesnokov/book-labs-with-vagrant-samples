FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    openssh-server \
    sudo \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && useradd --create-home --user-group --shell /bin/bash vagrant \
    && echo "vagrant ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/vagrant \
    && chmod 0440 /etc/sudoers.d/vagrant \
    && install -d -m 0700 -o vagrant -g vagrant /home/vagrant/.ssh \
    && curl -fsSL https://raw.githubusercontent.com/hashicorp/vagrant/main/keys/vagrant.pub \
    -o /home/vagrant/.ssh/authorized_keys \
    && chown vagrant:vagrant /home/vagrant/.ssh/authorized_keys \
    && chmod 0600 /home/vagrant/.ssh/authorized_keys \
    && printf '%s\n' \
    'PubkeyAuthentication yes' \
    'PasswordAuthentication no' \
    'PermitRootLogin no' \
    'UseDNS no' \
    'AllowUsers vagrant' \
    > /etc/ssh/sshd_config.d/vagrant.conf \
    && mkdir -p /run/sshd \
    && ssh-keygen -A

EXPOSE 22

CMD ["/bin/sh", "-c", "mkdir -p /run/sshd && exec /usr/sbin/sshd -D -e"]