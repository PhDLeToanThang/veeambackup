#############################################
#  minio 10.3.2024 vs certgen_1.2.1 linux_amd64.deb
############################################
#!/bin/bash
clear
cd ~
###############S3 Standard API - Tham số cần thay đổi ở đây ###################
echo "FQDN: e.g: s3s.company.vn"   # Đổi địa chỉ web thứ nhất Website Master for Resource code - để tạo cùng 1 Source code duy nhất 
read -e fqdn
echo "Web Address Port: e.g: 9000 default of Minio"   # Đổi port để tạo truy cập duy nhất 
read -e port1
echo "Console Access Port: e.g: 9001 default of Minio"   # Đổi port để tạo truy cập duy nhất 
read -e port2
echo "minio/Account access key: e.g: companyname"   # MINIO_ACCES_KEY 
read -e minio
echo "SECRET/Password key: e.g: ABBA2@B-h01_quy3n"   # Mật khẩu MINIO_SECRET_KEY 
read -e secret
echo "Email create SSL/TLS from Let's encrypt: e.g: username@company.vn"   # Mật khẩu MINIO_SECRET_KEY 
read -e email
echo "ipv4 local - LAN network hosting after NAT: e.g: 192.168.0.113"   # ipv4 local
read -e ipv4lan

echo "run install? (y/n)"
read -e run
if [ "$run" == n ] ; then
  exit
else

#Bước 1. Cập nhật, vá lỗi Ubuntu
sudo apt update -y
sudo apt list --upgradable
sudo apt autoremove -y
sudo apt upgrade -y

#Bước 2. Cấu hình Remote Desktop Access RDP 3389 tới máy chủ vật lý hoặc máy ảo Ubuntu 20.x/22.x LTS server
# https://thangletoan.wordpress.com/2023/10/31/cau-hinh-remote-desktop-access-rdp-3389-toi-may-chu-vat-ly-hoac-may-ao-ubuntu-20-x-22-x-lts-server/
#sudo apt install xrdp -y
#sudo systemctl enable xrdp
sudo apt install ufw -y
sudo apt install net-tools -y
sudo apt install gparted -y

#Bước 3: Cách cấu hình điều khiển HĐH Linux qua Web HTML 5 :https://ip-address-of-machine:9090
# After you already have Cockpit on your server, point your web browser to: https://ip-address-of-machine:9090
# note: user: root default Disallow interactive password, Never expire account, password PAM empty.
# https://thangletoan.wordpress.com/2022/05/22/cach-cau-hinh-dieu-khien-hdh-linux-qua-web-html-5/
. /etc/os-release
sudo apt install -t ${VERSION_CODENAME}-backports cockpit -y

#Bước 4. Download bản minio mới nhất amd64:
wget https://dl.min.io/server/minio/release/linux-amd64/minio

#Làm cho tệp thực thi:
chmod +x minio

#Sao chép Minio vào thư mục /usr/local/bin để nó có thể được truy cập từ bất kỳ vị trí nào:
sudo cp minio /usr/local/bin/

useradd --system $minio --shell /sbin/nologin

usermod -L $minio

chage -E0 $minio

mv minio /usr/local/bin
chmod +x /usr/local/bin/minio

chown $minio:$minio /usr/local/bin/minio

# check result: ls -l /usr/local/bin/minio
# Setup MinIO on Ubuntu 18 04 with SSL and client CLI: 
# https://www.youtube.com/watch?v=UTwb78kOUTk

#tạo thư mục chứa minio service
mkdir /etc/minio
chown $minio:$minio /etc/minio

#tạo thư mục data cho Accesss/Account key
mkdir /$minio
chown $minio:$minio /$minio

# tham khảo cấu hình default: https://github.com/minio/minio-service/tree/master/linux-systemd
# Download minio.service in /lib/systemd/system/
# ( cd /lib/systemd/system/; curl -O https://raw.githubusercontent.com/minio/minio-service/master/linux-systemd/minio.service )
#Cập nhật cấu hình minio /etc/default/minio

echo "MINIO_ACCESS_KEY=\"$minio\"" >> /etc/default/minio
echo "MINIO_VOLUMES=/$minio" >> /etc/default/minio
echo "MINIO_OPTS=\"--certs-dir /etc/minio/CAs --address :$port1 --console-address :$port2\"" >> /etc/default/minio
echo "MINIO_SECRET_KEY=\"$secret\"" >> /etc/default/minio
echo "MINIO_ROOT_USER=\"$minio\"" >> /etc/default/minio
echo "MINIO_ROOT_PASSWORD=\"$secret\"" >> /etc/default/minio
echo "MINIO_CONFIG_ENV_FILE=/etc/default/minio" >> /etc/default/minio

#echo 'MINIO_ACCESS_KEY=$minio' >> /etc/default/minio
#echo 'MINIO_VOLUMES=/$minio' >> /etc/default/minio
#echo 'MINIO_OPTS="--certs-dir /etc/minio/CAs --address :$port1 --console-address :$port2"' >> /etc/default/minio
#echo 'MINIO_SECRET_KEY=$secret' >> /etc/default/minio
#echo 'MINIO_ROOT_USER=$minio' >> /etc/default/minio
#echo 'MINIO_ROOT_PASSWORD=$secret' >> /etc/default/minio
#echo 'MINIO_CONFIG_ENV_FILE=/etc/default/minio' >> /etc/default/minio

#MINIO_ROOT_USER: $minio
#MINIO_ROOT_PASSWORD: $secret
#Access key:  tạo trên bucket của minio port web https://ip:9000
#Secret key:  tạo trên bucket của minio port web https://ip:9000

#server location: tự sửa theo cấu trúc, vị trí địa lý, ví dụ: vn-east-rack1
#MINIO_VOLUMES là directory sẽ chứa dữ liệu đã tạo ở trên
#-C flag khai báo nơi sẽ chứa các file config của minIO
#–address** khai báo IP của server/VPS chạy minIO, kèm theo port

# tham khảo file cấu hình https://blog.min.io/configuring-minio-with-systemd/
#Tiếp theo, để minIO có thể chạy như một service, ta sẽ tải về Minio Systemd Startup Script 
curl -O https://raw.githubusercontent.com/PhDLeToanThang/veeambackup/master/s3h/minio.service?token=GHSAT0AAAAAACPRQIOZWBVRS65UX7WMUXTUZPSYHYA

#sua gia tri User
#sed -i 's/User=minio-user/User=$minio/g' minio.service
sed -i "s/User=minio-user/User=$minio/g" minio.service
# sua gia tri group
#sed -i 's/Group=minio-user/Group=$minio/g' minio.service
sed -i "s/Group=minio-user/Group=$minio/g" minio.service

#move vào /etc/systemd/system Minio service descriptor file lệnh download:
mv minio.service?token=GHSAT0AAAAAACPRQIOZWBVRS65UX7WMUXTUZPSYHYA /etc/systemd/system/minio.service

#Tiếp theo ta dùng lệnh sau để mở port 9000 trên server:
sudo ufw allow $port1:$port2/tcp
sudo ufw allow 9090
sudo ufw allow 22

# Cách 1: Tự tạo chữ ký số SSL/TLS cho Minio trong mạng LAN vì Các công cụ Backup/Restore đều kết nối VPN tới LAN:
#Securing Access to MinIO Server with a Self-Signed Certificate
#In this step, you will use certgen, a Go application from the developers of MinIO, to generate a self-signed certificate.
#The latest version at the time of writing is version 1.2.1.
# https://www.digitalocean.com/community/tutorials/how-to-set-up-minio-object-storage-server-in-standalone-mode-on-ubuntu-20-04

sudo wget https://github.com/minio/certgen/releases/download/v1.2.1/certgen_1.2.1_linux_amd64.deb
sudo dpkg -i certgen_1.2.0_linux_amd64.deb
# If you want to access the MinIO server via your server’s IP address only, generate a certificate for it using the following command:
sudo certgen -host $fqdn,$ipv4lan

# Created a new certificate 'public.crt', 'private.key' valid for the following names

sudo mkdir -p /etc/minio/CAs    # The -p option creates parent directories that do not exist
sudo mv private.key public.crt /etc/minio/CAs #Move the files with this command (replacing minio as needed)
# Finally, give ownership of both files to the MinIO user and group (replacing minio as needed):
sudo chown $minio:$minio /etc/minio/CAs/private.key
sudo chown $minio:$minio /etc/minio/CAs/public.crt

# Cách 2: tạo Cert từ Let's encrypt Certbot:  https://gist.github.com/kstevenson722/e7978a75aec25feaa6ad0965ec313e2d
#sudo apt install software-properties-common -y
#sudo add-apt-repository universe -y
#sudo add-apt-repository ppa:certbot/certbot -y

#This is the PPA for packages prepared by Debian Let's Encrypt Team and backported for Ubuntu(s).
#More info: https://launchpad.net/~certbot/+archive/ubuntu/certbot 
#Press [ENTER] to continue or ctrl-c to cancel adding it
#Press ENTER to accept.

#Finally, install certbot:
#sudo apt install certbot -y 
#sudo apt-get -s autoremove -y
#Next, you will use certbot to generate a new SSL certificate.
#Since Ubuntu 18.04 doesn’t yet support automatic installation, you will use the certonly command and --standalone to obtain the certificate:
#minio đang dùng port 9000 https và port 9001 https cho web user access:
#sudo certbot certonly --standalone --agree-tos --no-eff-email --staple-ocsp --preferred-challenges http -m $email -d $fqdn
# Thay thế `your_domain.com` và `www.your_domain.com` bằng tên miền của bạn hoặc các tên miền mà bạn muốn tạo chứng chỉ SSL/TLS cho.
# Lựa chọn `--preferred-challenges http` sẽ yêu cầu Certbot sử dụng thử thách HTTP để xác minh tên miền của bạn.
# Lựa chọn `--http-01-port 9000` sẽ chỉ định cổng 9000 cho Certbot sử dụng khi xác minh tên miền bằng thử thách HTTP. 
# Điều này cho phép Certbot tương tác với MinIO để xác minh tên miền.

#--standalone means that this certificate is for a built-in standalone web server. For more information on this, see our How To Use Certbot Standalone Mode to Retrieve Let’s Encrypt SSL Certificates on Ubuntu 18.04 tutorial.
#You will receive the following output:
#Saving debug log to /var/log/letsencrypt/letsencrypt.log
#Plugins selected: Authenticator standalone, Installer None
#Enter email address (used for urgent renewal and security notices) (Enter 'c' to cancel):
#Add your email and press ENTER.
#Certbot will then ask you to register with Let’s Encrypt:

#Quy trình của Certbot:
#The certificate and key generated via Certbot needs to be placed inside user's home directory.
#cp /etc/letsencrypt/live/s3c.company.vn/fullchain.pem ~/.minio/certs/CAs/public.crt
#cp /etc/letsencrypt/live/s3c.company.vn/privkey.pem ~/.minio/certs/CAs/private.key
#Bước 8.6. Visit https://s3c.company.vn:9000 in the browser
#Tham khảo: https://www.digitalocean.com/community/tutorials/how-to-set-up-an-object-storage-server-using-minio-on-ubuntu-18-04 

#Vậy là quá trình chuẩn bị đã hoàn tất, tiếp theo ta sẽ tiến hành start service
systemctl daemon-reload
systemctl enable minio
systemctl restart minio

#Check the status:
sudo systemctl status minio
sudo ufw enable

#Output:
#minio.service - MinIO
#     Loaded: loaded (/etc/systemd/system/minio.service; enabled; vendor preset: enabled)
#     Active: active (running) since Wed 2024-01-10 08:07:48 UTC; 5s ago
#       Docs: https://docs.min.io
#    Process: 133116 ExecStartPre=/bin/bash -c if [ -z "${MINIO_VOLUMES}" ]; then echo "Variable MINIO_VOLUMES not set in /etc/default/minio";>
#   Main PID: 133126 (minio)
#      Tasks: 14
#     Memory: 93.9M
#     CGroup: /system.slice/minio.service
#             └─133126 /usr/local/bin/minio server --certs-dir /etc/minio/CAs --address :9000 --console-address :9001 /$minio
#
#Jan 10 08:07:48 miniopod1 systemd[1]: Started MinIO.
#Jan 10 08:07:48 miniopod1 minio[133126]: MinIO Object Storage Server
#Jan 10 08:07:48 miniopod1 minio[133126]: Copyright: 2015-2024 MinIO, Inc.
#Jan 10 08:07:48 miniopod1 minio[133126]: License: GNU AGPLv3 <https://www.gnu.org/licenses/agpl-3.0.html>
#Jan 10 08:07:48 miniopod1 minio[133126]: Version: RELEASE.2024-01-05T22-17-24Z (go1.21.5 linux/amd64)
#Jan 10 08:07:48 miniopod1 minio[133126]: Status:         1 Online, 0 Offline.
#Jan 10 08:07:48 miniopod1 minio[133126]: S3-API: https://ipv4lan:9000  https://127.0.0.1:9000
#Jan 10 08:07:48 miniopod1 minio[133126]: Console: https://ipv4lan:9001 https://127.0.0.1:9001
#Jan 10 08:07:48 miniopod1 minio[133126]: Documentation: https://min.io/docs/minio/linux/index.html
#Jan 10 08:07:48 miniopod1 minio[133126]: Warning: The standard parity is set to 0. This can lead to data loss.
fi
