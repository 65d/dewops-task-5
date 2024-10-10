#!/bin/bash

apt-get update

sudo apt-get install -y mc

mkdir -p /home/ubuntu/folder1
mkdir -p /home/ubuntu/folder2

chown -R ubuntu:ubuntu /home/ubuntu/folder1 /home/ubuntu/folder2
chmod 755 /home/ubuntu/folder1 /home/ubuntu/folder2

cat << 'EOF' > /usr/local/bin/move_files.sh
#!/bin/bash
while true; do
    mv /home/ubuntu/folder1/* /home/ubuntu/folder2/ 2>/dev/null
    sleep 1
done
EOF

chmod +x /usr/local/bin/move_files.sh

cat << 'EOF' > /etc/systemd/system/move_files.service
[Unit]
Description=Move files from folder1 to folder2

[Service]
ExecStart=/usr/local/bin/move_files.sh
Restart=always
User=ubuntu
Group=ubuntu

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload

systemctl start move_files.service
systemctl enable move_files.service