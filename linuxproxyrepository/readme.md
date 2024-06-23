# Veeam v10x/11x/12x: Linux Backup Proxy configuration

![image](https://github.com/PhDLeToanThang/veeambackup/assets/106635733/ba0ea905-ddff-4fe8-8547-d0df3c5ffc50)

Trong Veeam Backup & Replication v10x/11x/12x, 
_Linux Backup Proxy đã được cải tiến và hiện hoạt động giống như phiên bản Windows cung cấp hầu hết tất cả các tính năng có sẵn.
Linux Backup Proxy đã được giới thiệu trong phiên bản trước chỉ cung cấp khả năng Hot-Add, 
nhưng với Veeam Backup & Replication v10x/11x/12x, tất cả các chế độ truyền tải hiện đều được hỗ trợ đầy đủ._

## Trong VBR phiên bản 10x/11x/12x, Proxy sao lưu Linux có các khả năng sau:

1. Vật lý hoặc ảo
1. Chế độ vận chuyển: NDB, Direct SAN, Hot-Add
1. Sao lưu từ Ảnh chụp nhanh lưu trữ (iSCSI, FC)
1. Khôi phục nhanh / Khôi phục CBT.
1. Một bản phân phối Linux Distro được hỗ trợ để cung cấp dung lượng lưu trữ.
_(Hiện tại, đó là Ubuntu 20.4 LTS, sử dụng kernel v5.4.
Theo Veeam, đó là phiên bản cung cấp chức năng “Reflink” (Fast Clone in Veeam speak) tốt nhất với hệ thống tệp XFS.)_

## Hạn chế:

_Mặc dù hầu hết các tính năng hiện đều có sẵn trong Linux Backup Proxy, nhưng vẫn có một số hạn chế phải được xem xét trong quá trình thiết kế. 
Proxy sao lưu Linux có những hạn chế sau:_

1. không thể được sử dụng làm proxy tương tác với khách.
1. không thể sử dụng với VMware Cloud trên AWS.
1. Bộ khởi tạo Open-iSCSI phải được bật để truy cập Direct SAN.
1. Giao thức NFS không được hỗ trợ để tích hợp với hệ thống lưu trữ.
1. Kịch bản sao chép VM không được hỗ trợ khi sử dụng chế độ truyền tải Hot-Add.

## Supported Linux distribution:
_Veeam không cung cấp thiết bị Linux sẵn sàng hoạt động để sử dụng làm Máy chủ proxy, nhưng bạn cần tạo một máy ảo cài đặt bản phân phối Linux được hỗ trợ như:_

- CentOS 7–8.3, CentOS Stream
- Debian 9.0–10.8
- Fedora 30–33
- openSUSE Leap 15.2, Tumbleweed
- Oracle Linux 6 (UEK3) to 8.3 (UEK R6)
- Oracle Linux 6 to 8.3 (RHCK)
- RHEL 6.0–8.3
- SLES 11 SP4, 12 SP1–SP5, 15 SP0–SP2
- Ubuntu: 14.04 LTS, 16.04 LTS, 18.04 LTS, 19.10, 20.04 LTS
 
## Cài máy chủ Linux:
_Trước khi tiếp tục, hãy tải xuống tệp cài đặt .ISO của bản phân phối Linux được hỗ trợ mà bạn đã chọn và lưu nó ở bất kỳ đâu trong máy tính của bạn._

---
## Lưu ý:
UFW Ref: https://helpcenter.veeam.com/archive/backup/110/vsphere/used_ports.html
_Linux Server:_

1. Bảng sau mô tả các cổng mạng phải được mở để đảm bảo giao tiếp thích hợp với máy chủ Linux.

Mỗi máy chủ Linux là thành phần cơ sở hạ tầng dự phòng phải mở các cổng này. Nếu muốn sử dụng máy chủ làm thành phần cơ sở hạ tầng dự phòng, bạn cũng phải mở các cổng mà vai trò thành phần yêu cầu.

Ví dụ: nếu bạn chỉ định vai trò kho lưu trữ sao lưu cho máy chủ Linux của mình, bạn phải mở các cổng được liệt kê bên dưới và cả các cổng được liệt kê trong phần Kho lưu trữ sao lưu dựa trên Microsoft Windows/Linux.

Máy chủ Linux hoạt động như một nơi chia sẻ tệp NFS yêu cầu các cổng mạng được liệt kê bên dưới và cả các cổng được liệt kê trong Kho lưu trữ sao lưu NFS. Máy chủ Linux hoạt động như một máy chủ chia sẻ tệp SMB yêu cầu các cổng mạng được liệt kê bên dưới cũng như các cổng được liệt kê trong Kho lưu trữ sao lưu SMB.

```Tables
From---To---Protocol---Port---Notes
Backup---Linux---TCP---22---Port used as a control channel from the console to the target Linux host.
server---server
				 TCP---6162---Default port used by the Veeam Data Mover.
					You can specify a different port while adding the Linux server to the Veeam Backup & Replication infrastructure.
					Note that you can specify a different port only if there is no previously installed Veeam Data Mover on this Linux server.
					For more information, see Specify Credentials and SSH Settings.
				TCP---2500 to 33001---Default range of ports used as data transmission channels. 
					For every TCP connection that a job uses,one port from this range is assigned.
Linux---Backup---TCP---2500 to 33001---Default range of ports used as data transmission channels. 
server---server				 For every TCP connection that a job uses,one port from this range is assigned.
--------------
(1) This range of ports applies to newly installed Veeam Backup & Replication starting from version 10.0, without upgrade from previous versions.
If you have upgraded from an earlier version of the product, the range of ports from 2500 to 5000 applies to the already added components.
--------------
```
_Nếu không cấu hình UFW của máy chủ Linux Ubuntu Proxy mở cổng 6162 TCP sẽ bị báo lỗi_

![image](https://github.com/PhDLeToanThang/veeambackup/assets/106635733/1cb8aa88-2f9e-4e46-b910-5209ce4dc5f9)


2. Để nguyên gốc (Ubuntu does not set up a root password):
Theo mặc định, Ubuntu không thiết lập mật khẩu root.
Điều đó có nghĩa là nó không thể được sử dụng để đăng nhập vào hệ thống vì mật khẩu trống bị vô hiệu hóa.
Hãy để nó như vậy. Sử dụng người dùng tiêu chuẩn có khả năng sudo để quản trị và sử dụng một tài khoản chuyên dụng khác cho thông tin xác thực sử dụng một lần Veeam cho kho lưu trữ cứng.
Sống theo nguyên tắc yêu cầu đặc quyền tối thiểu cho tài khoản người dùng.

