#!/bin/bash

# Install packages
dnf update -y
dnf install -y amazon-ssm-agent

sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent

dnf install -y nodejs git nginx
dnf install -y mariadb105

# Enable nginx
systemctl enable nginx
systemctl start nginx

# Clone app
cd /home/ec2-user

if [ ! -d "devops-project" ]; then
  git clone https://github.com/siddharth-chourey-sp/web_app.git
fi

cd /home/ec2-user/web_app

# Install dependencies
npm install @aws-sdk/client-secrets-manager

# Start Node app
nohup node server.js > app.log 2>&1 &

# Configure nginx
cat > /etc/nginx/nginx.conf <<'EOF'
events {}

http {
    server {
        listen 80;

        location / {
            proxy_pass http://localhost:3000;

            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection 'upgrade';
            proxy_set_header Host $host;
        }
    }
}
EOF

# Restart nginx
systemctl restart nginx