#############################################
#  Veeam Linux Backup Proxy with 			#
#	Ubuntu linux proxy repository 			#
#		vs certgen_1.2.1 linux_amd64.deb	#
#############################################
#!/bin/bash -e
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
