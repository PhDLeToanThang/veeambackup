clear
cd ~
############### Tham số cần thay đổi ở đây ###################
echo "FQDN: e.g: s3c.company.vn"   # Đổi địa chỉ web thứ nhất Website Master for Resource code - để tạo cùng 1 Source code duy nhất 
read -e FQDN
echo "PORT: e.g: 2022"   # Đổi port để tạo truy cập duy nhất 
read -e PORT
echo "minio: e.g: minio"   # MINIO_ACCES_KEY 
read -e minio
echo "SECRET: e.g: ABBA2@B-h01_quy3n"   # Mật khẩu MINIO_SECRET_KEY 
read -e SECRET
echo "run install? (y/n)"
read -e run
if [ "$run" == n ] ; then
  exit
else

#Step 1. Install latest version from backports cockpit:
. /etc/os-release
sudo apt install -t ${VERSION_CODENAME}-backports cockpit

#Step 2. Install MinIO:
sudo apt-get update
wget https://dl.min.io/server/minio/release/linux-amd64/minio
useradd --system $minio --shell /sbin/nologin
usermod -L $minio
chage -E0 $minio
mv minio /usr/local/bin
chmod +x /usr/local/bin/minio
chown $minio:$minio /usr/local/bin/minio

# Setup MinIO on Ubuntu 18 04 with SSL and client CLI: 
# https://www.youtube.com/watch?v=UTwb78kOUTk

mkdir /usr/local/share/minio
mkdir /etc/minio
chown $minio:$minio /etc/minio
chown $minio:$minio /usr/local/share/minio

sudo touch /etc/default/minio
echo 'MINIO_ACCESS_KEY="$minio"' >> /etc/default/minio
echo 'MINIO_VOLUMES="/usr/local/share/minio/"' >> /etc/default/minio
echo 'MINIO_OPTS="-C /etc/minio --address $FQDN:9000" --console-address $FQDN:$PORT' >> /etc/default/minio
echo 'MINIO_SECRET_KEY="$SECRET"' >> /etc/default/minio

#MINIO_VOLUMES là directory sẽ chứa dữ liệu đã tạo ở trên
#-C flag khai báo nơi sẽ chứa các file config của minIO
#–address** khai báo IP của server/VPS chạy minIO, kèm theo port

#Tiếp theo, để minIO có thể chạy như một service, ta sẽ tải về Minio Systemd Startup Script và 
#move vào /etc/systemd/system Minio service descriptor file lệnh download:
curl -O https://raw.githubusercontent.com/minio/minio-service/master/linux-systemd/minio.service

sed -i 's/User=minio-user/User=$minio/g' minio.service
sed -i 's/Group=minio-user/Group=$minio/g' minio.service

sudo touch minio.service
echo '[Unit]' >> minio.service
echo 'Description=MinIO' >> minio.service
echo 'Documentation=https://docs.min.io' >> minio.service
echo 'Wants=network-online.target' >> minio.service
echo 'After=network-online.target' >> minio.service
echo 'AssertFileIsExecutable=/usr/local/bin/minio' >> minio.service
echo '[Service]' >> minio.service
echo 'WorkingDirectory=/usr/local/' >> minio.service
echo 'User=$minio' >> minio.service
echo 'Group=$minio' >> minio.service
echo 'ProtectProc=invisible' >> minio.service
echo 'EnvironmentFile=/etc/default/minio' >> minio.service
echo 'ExecStartPre=/bin/bash -c "if [ -z \"${MINIO_VOLUMES}\" ]; then echo \"Variable MINIO_VOLUMES not set in /etc/default/minio\"; exit 1; fi"' >> minio.service
echo 'ExecStart=/usr/local/bin/minio server $MINIO_OPTS $MINIO_VOLUMES' >> minio.service
echo '# Let systemd restart this service always' >> minio.service
echo 'Restart=always' >> minio.service
echo '# Specifies the maximum file descriptor number that can be opened by this process' >> minio.service
echo 'LimitNOFILE=1048576' >> minio.service
echo '# Specifies the maximum number of threads this process can create' >> minio.service
echo 'TasksMax=infinity' >> minio.service
echo '# Disable timeout logic and wait until process is stopped' >> minio.service
echo 'TimeoutStopSec=infinity' >> minio.service
echo 'SendSIGKILL=no' >> minio.service
echo '[Install]' >> minio.service
echo 'WantedBy=multi-user.target' >> minio.service
echo '# Built for ${project.name}-${project.version} (${project.name})' >> minio.service

mv minio.service /etc/systemd/system
#Tiếp theo ta dùng lệnh sau để mở port 9000 trên server:
sudo ufw allow 9000
sudo ufw allow 9090
sudo ufw allow $PORT
sudo ufw enable

#Vậy là quá trình chuẩn bị đã hoàn tất, tiếp theo ta sẽ tiến hành start service
systemctl daemon-reload
systemctl enable minio
systemctl start minio
#Sau đó, ta có thể kiểm tra lại status của service bằng lệnh
systemctl status minio

sudo systemctl start minio
#Như hình trên là minIO đã start thành công.
sudo systemctl status minio

#In this step, you will secure access to your Minio server using a private key and public certificate that has been obtained from a certificate authority (CA), in this case Let’s Encrypt. To get a free SSL certificate, you will use Certbot.
#First, allow HTTP and HTTPS access through your firewall. To do this, open port 80, which is the port for HTTP:
sudo ufw allow 80
#Next, open up port 443 for HTTPS:
sudo ufw allow 443
#Once you’ve added these rules, check on your firewall’s status with the following command:
sudo ufw status verbose

sudo apt install software-properties-common
sudo add-apt-repository universe
sudo add-apt-repository ppa:certbot/certbot

#This is the PPA for packages prepared by Debian Let's Encrypt Team and backported for Ubuntu(s).
#More info: https://launchpad.net/~certbot/+archive/ubuntu/certbot 
#Press [ENTER] to continue or ctrl-c to cancel adding it
#Press ENTER to accept.

#Then update the package list:
sudo apt update
sudo apt upgrade
#Finally, install certbot:
sudo apt install certbot

#Next, you will use certbot to generate a new SSL certificate.
#Since Ubuntu 18.04 doesn’t yet support automatic installation, you will use the certonly command and --standalone to obtain the certificate:
sudo certbot certonly --standalone -d $FQDN

#--standalone means that this certificate is for a built-in standalone web server. For more information on this, see our How To Use Certbot Standalone Mode to Retrieve Let’s Encrypt SSL Certificates on Ubuntu 18.04 tutorial.
#You will receive the following output:
#Saving debug log to /var/log/letsencrypt/letsencrypt.log
#Plugins selected: Authenticator standalone, Installer None
#Enter email address (used for urgent renewal and security notices) (Enter 'c' to cancel):
#Add your email and press ENTER.
#Certbot will then ask you to register with Let’s Encrypt:

#Quy trình của Certbot:
#The certificate and key generated via Certbot needs to be placed inside user's home directory.
#cp /etc/letsencrypt/live/s3c.cloud.edu.vn/fullchain.pem ~/.minio/certs/CAs/public.crt
#cp /etc/letsencrypt/live/s3c.cloud.edu.vn/privkey.pem ~/.minio/certs/CAs/private.key
#Bước 8.6. Visit https://s3c.cloud.edu.vn:9000 in the browser
#Tham khảo: https://www.digitalocean.com/community/tutorials/how-to-set-up-an-object-storage-server-using-minio-on-ubuntu-18-04 

fi
