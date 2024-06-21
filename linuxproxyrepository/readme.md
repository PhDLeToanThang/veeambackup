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
1. Khôi phục nhanh / Khôi phục CBT

## Hạn chế

_Mặc dù hầu hết các tính năng hiện đều có sẵn trong Linux Backup Proxy, nhưng vẫn có một số hạn chế phải được xem xét trong quá trình thiết kế. 
Proxy sao lưu Linux có những hạn chế sau:_

1. không thể được sử dụng làm proxy tương tác với khách.
1. không thể sử dụng với VMware Cloud trên AWS.
1. Bộ khởi tạo Open-iSCSI phải được bật để truy cập Direct SAN.
1. Giao thức NFS không được hỗ trợ để tích hợp với hệ thống lưu trữ.
1. Kịch bản sao chép VM không được hỗ trợ khi sử dụng chế độ truyền tải Hot-Add.

## Supported Linux distribution
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
 
## Cài máy chủ Linux
_Trước khi tiếp tục, hãy tải xuống tệp cài đặt .ISO của bản phân phối Linux được hỗ trợ mà bạn đã chọn và lưu nó ở bất kỳ đâu trong máy tính của bạn._

