#!/bin/bash
set -euo pipefail

# GCP startup scripts run as root.
exec > >(tee -a /var/log/app1-startup.log) 2>&1
set -x
export DEBIAN_FRONTEND=noninteractive

# Refresh package indexes.
apt-get -o Acquire::Retries=3 \
  -o APT::Update::Error-Mode=any update

# Install packages; wait for an existing package-manager lock.
apt-get -o Acquire::Retries=3 \
  -o DPkg::Lock::Timeout=300 install -y nginx telnet curl

# Create the application page.
install -d -m 755 /var/www/html/app1

cat > /var/www/html/app1/index.html <<EOF
<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><title>WebVM App1</title></head>
<body style="background-color:rgb(250, 210, 210);">
<h1>Welcome to StackSimplify - WebVM App1</h1>
<p><strong>VM Hostname:</strong> $(hostname)</p>
<p><strong>VM IP Address:</strong> $(hostname -I)</p>
<p><strong>Application Version:</strong> V1</p>
<p>Google Cloud Platform - Demos</p>
</body>
</html>
EOF

# Serve the same page at / and /app1/.
cp /var/www/html/app1/index.html /var/www/html/index.html
chmod 644 /var/www/html/index.html /var/www/html/app1/index.html

# Validate configuration and start Nginx.
nginx -t
systemctl enable --now nginx

# Verify both pages.
curl --fail --silent --show-error --retry 5 \
  --retry-connrefused --max-time 10 \
  http://127.0.0.1/ > /dev/null

curl --fail --silent --show-error --retry 5 \
  --retry-connrefused --max-time 10 \
  http://127.0.0.1/app1/ > /dev/null

echo "App1 startup completed successfully."