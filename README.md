# veeambackup:

#  Phần 1. Veeam Powered Network (VeeamPN)

**There are Two components of Veeam PN:**
1. Hub Appliance – deployable from Azure Marketplace
2. Site Gateway –  downloadable from the Veeam.com website and deployed on-premises
The architecture overview below can give you more details.

![image](https://user-images.githubusercontent.com/106635733/207789463-6a9595e3-a225-4f8b-b1cd-9d734d737a5a.png)

**Veeam PN – The Features:**
1. Provides seamless and secure networking between on-premises and Azure-based IT resources
2. Delivers easy-to-use and fully automated site-to-site network connectivity between any site
3. Designed for both SMB and enterprise customers, as well as service providers
Here is another picture from Veeam PN user guide:

![image](https://user-images.githubusercontent.com/106635733/207789750-7feb6230-01e1-43cf-961b-1484ffc4a36e.png)

**Veeam PN System Requirements:**
**1. Network Hub:**

**2.Site Gateway:**

**Tham khảo hướng dẫn cài VeeamPN:**
https://thangletoan.wordpress.com/2021/08/16/cai-va-cau-hinh-openvpn-va-wire-guard-tren-ubuntu-server-18-04-dap-ung-nhu-cau-wfh/

**Link Download VeeamPN OVA (Virtual Machine):**
https://1drv.ms/u/s!AtT2yQnThe-ykLYa3oyYiYyPk5Pp6A?e=HtPWlU

#  Phần 2. Cloud VPN Gateway:
**Xây dựng lại VPN Enterprise for BaaS, Console, Control DC**

**Features of Pritunl VPN:**
1. Simple to install and configure
2. Supports multi-cloud VPN peering
3. Offers upto five layers of authentication making it more secure.
4. Supports Wireguard, giving clients theoption to connect with openvpn or Wireguard
5. Quickly and easily scale to thousands of users, having high availability in the cloud environment without the need for expensive proprietary hardware
    supports all OpenVPN clients with official clients for most devices and platforms.
6. Create multi-cloud site-to-site links with VPC peering. VPC peering available for AWS, Google Cloud, Azure and Oracle Cloud.
7. Interconnect AWS VPC networks across AWS regions and provide reliable remote access with automatic failover that can scale horizontally
8. Pritunl is built on MongoDB, a reliable and scalable database that can be quickly deployed

**Pritunl VPN Architecture Review:**
![image](https://user-images.githubusercontent.com/106635733/208446860-c3a5bcf6-600d-4e5b-81c0-76fdec869ac2.png)
wget https://raw.githubusercontent.com/PhDLeToanThang/veeambackup/master/vpnenterprise.sh && bash ./vpnenterprise.sh

#  Phần 3. Deploy S3c Object Storage:
wget https://raw.githubusercontent.com/PhDLeToanThang/veeambackup/master/deploy_s3c_objectstore.sh && bash ./deploy_s3c_objectstore.sh

#  Phần 4. Deploy and configure VTL Server Virtual Tape Library Readonly Storage vs Multiple-LTO:

#  Phần 5. Backup / Restore Application Items (application aware image):
These files are explained in the whitepaper, script code Consistent Protection of MySQL, MariaDB, Domino Lotus, DB2, Oracle RMAN, Exchange DAG, SharePoint Server, AD-DC, ADFS SSO, BigData Apache Spark, VMware vSphere BigData Extention with Veeam Availability Suite 9 - 11.a"
1. MySQL vs MariaDB:
2. Domino Lotus R5-R9:
3. DB2/Windows hoặc DB2/Linux/AIX
4. MS-SQL Standard, DWH, Performance Tuning, Cluster Failover 
5. ORACLE RMAN/RAC:
6. Exchange DAG
7. SharePoint Farm
8. Active Directory, FSMO vs ADFS
9. Apache Spark BigData
10. SAP/HANA
11. VMware vSphere BigData Extention
