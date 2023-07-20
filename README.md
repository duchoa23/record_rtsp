# record_RTSP_camera
This is a script that supports saving RTSP cameras and uploading to Cloud (Google Drive, OneDrive, Dropbox....)

# Yêu cầu:
- Sử dụng VPS linux, trong hướng dẫn sử dụng ubuntu 22
- Mở port Camera và có link RTSP kèm tài khoản mật khẩu
- Có tài khoản Cloud
- Có thể sử dụng ddns để lấy ip động.

# Mô tả:
 - Script sẽ lưu video từ link RTSP và lưu vào VPS, mỗi 1h sẽ tạo ra 1 file khác nhau trong thư mục /opt/record/<ngày tháng năm>
 
# Thực hiện:

1. Login vps, tại đây mình sử dụng bitvise SSH để dễ theo dõi
2. Thực hiện câu lệnh và sẽ tự động cấu hình các package<br>
<code>curl -L https://raw.githubusercontent.com/duchoa23/record_rtsp/main/setup.sh | sudo bash</code>
3. Sau khi chạy xong, cấu hình Rclone theo hướng dẫn tại <a href="https://rclone.org/docs/">https://rclone.org/docs/</a>. Trong script trên mình đang để tên Rclone là <code>cam</code> và thư mục trên Cloud sẽ là <code>Camera</code>
4. Edit 2 file <code>rclone.sh</code> và <code>record.sh</code> trong thư mục <code>/opt/record</code> theo cấu hình RTSP camera và rclone để khởi chạy.
