#!/bin/bash

# Generate nginx configuration with environment variables
cat > /etc/nginx/nginx.conf << EOF
events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    upstream backend {
        server ${BACKEND:-erpnext-backend:8000};
    }

    upstream socketio {
        server ${SOCKETIO:-erpnext-websocket:9000};
    }

    server {
        listen 80;
        server_name _;

        client_max_body_size 50m;
        proxy_read_timeout 120s;

        location / {
            proxy_pass http://backend;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto \$scheme;
        }

        location /socket.io {
            proxy_pass http://socketio;
            proxy_http_version 1.1;
            proxy_set_header Upgrade \$http_upgrade;
            proxy_set_header Connection "upgrade";
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto \$scheme;
        }
    }
}
EOF

echo "Generated nginx configuration:"
cat /etc/nginx/nginx.conf

# Start nginx
echo "Starting nginx..."
nginx -g "daemon off;" 