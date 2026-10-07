#!/usr/bin/env bash
set -euo pipefail

echo "==> Checking for required tools"
if ! command -v curl >/dev/null 2>&1; then
    echo "    curl not found — installing"
    apt-get update
    apt-get install -y --no-install-recommends curl ca-certificates
fi

if ! command -v sudo >/dev/null 2>&1; then
    echo "    sudo not found — installing"
    apt-get update
    apt-get install -y --no-install-recommends sudo
fi

echo "==> Creating vagrant user (if not already present)"
if ! id -u vagrant >/dev/null 2>&1; then
    useradd --create-home --user-group --shell /bin/bash vagrant
else
    echo "    vagrant user already exists, skipping"
fi

echo "==> Granting passwordless sudo to vagrant"
echo "vagrant ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/vagrant
chmod 0440 /etc/sudoers.d/vagrant

echo "==> Setting up .ssh directory and authorized_keys"
install -d -m 0700 -o vagrant -g vagrant /home/vagrant/.ssh
curl -fsSL https://raw.githubusercontent.com/hashicorp/vagrant/main/keys/vagrant.pub \
    -o /home/vagrant/.ssh/authorized_keys
chown vagrant:vagrant /home/vagrant/.ssh/authorized_keys
chmod 0600 /home/vagrant/.ssh/authorized_keys

echo "==> Writing sshd config drop-in"
printf '%s\n' \
    'PubkeyAuthentication yes' \
    'PasswordAuthentication no' \
    'PermitRootLogin no' \
    'UseDNS no' \
    'AllowUsers vagrant' \
    > /etc/ssh/sshd_config.d/vagrant.conf

echo "==> Validating sshd config"
sshd -t

echo "==> Restarting sshd to apply changes"
if command -v systemctl >/dev/null 2>&1; then
    systemctl restart ssh || systemctl restart sshd
else
    service ssh restart || service sshd
fi

echo "==> Done. vagrant user is ready for SSH key-based login."