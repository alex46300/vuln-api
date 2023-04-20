docker-compose up

Swagger is at http://127.0.0.1:5000/apidocs/

# Setup the Application
apt update && apt install -y nginx

git clone https://gitlab.practical-devsecops.training/pdso/vuln-api.git

cd vuln-api

docker build -t vuln-api .

docker run -d --name flask -p 5000:5000 vuln-api

cat > /etc/nginx/sites-available/default<<EOF
server{
    listen      80;
    server_name sandbox-upphsuxc.lab.practical-devsecops.training;

    access_log  /var/log/nginx/flask_access.log;
    error_log   /var/log/nginx/flask_error.log;

    proxy_buffers 16 64k;
    proxy_buffer_size 128k;

    location / {
        proxy_pass  http://localhost:5000;
        proxy_redirect off;

        proxy_set_header    Host            \$host;
        proxy_set_header    X-Real-IP       \$remote_addr;
        proxy_set_header    X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header    X-Forwarded-Proto http;
    }
}
EOF

# Restart the nginx service.
systemctl restart nginx
