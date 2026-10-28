#!/bin/sh
set -e
apt-get update
apt-get install -y nginx curl
systemctl enable --now nginx
tee /var/www/html/index.html >/dev/null <<'HTML'
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Lab 08</title>
</head>
<body>
  <h1>Welcome to lab-08</h1>
  <p>This page was created by the Vagrant shell provisioner.</p>
</body>
</html>
HTML