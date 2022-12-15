cd ~
wget https://dl.min.io/server/minio/release/linux-amd64/minio
useradd --system minio --shell /sbin/nologin
usermod -L minio
chage -E0 mino
mv minio /usr/local/bin
chmod +x /usr/local/bin/minio
chown minio:minio /usr/local/bin/minio
