#!/usr/bin/env bash
echo "****************************************************************************************"
echo "******                                                                          ********"
echo "******                                                                          ********"
echo "******          File bash hỗ trợ cấu hình record rtsp và lưu vào drive          ********"
echo "******                             Dev By DucHoa                                ********"
echo "******    Chúng tôi không chịu bất kì trách nhiệm nào khi sử dụng Script này    ********"
echo "******                                                                          ********"
echo "****************************************************************************************"

# Cài đặt các pack: ntp, epel, unzip, wget, ffmpeg, rclone
sudo apt update
sudo apt install -y ntpdate ntp unzip wget fuse3 htop ffmpeg

# Cấu hình NTP
sudo cp /etc/ntp.conf /etc/ntp.conf.backup
echo "pool vn.pool.ntp.org iburst" | sudo tee /etc/ntp.conf
sudo systemctl restart ntp
sudo timedatectl set-timezone Asia/Ho_Chi_Minh

# Cài đặt rclone
curl https://rclone.org/install.sh | sudo bash

# Tạo thư mục và chmod
sudo mkdir -p /opt/record/camera
sudo chmod -R 777 /opt/record

# Tạo và điền nội dung vào file rclone.sh
echo '#!/bin/bash
directory="/opt/record/camera"
# Start Rclone on system startup
/usr/bin/rclone mount cam:cam/cam_backup $directory --vfs-cache-max-size=2G --vfs-cache-mode=writes --allow-non-empty' > /opt/record/rclone.sh

# Tạo và điền nội dung vào file record.sh
echo '#!/bin/bash

# Cấu hình path và source
directory="/opt/record/camera"

#điền link rtsp, ví dụ như ở dưới
#source="rtsp://user:pass@ip:port/profile0"
source=""
# Tạo thư mục theo ngày
date=$(date +\%d-\%m-\%Y)
path="$directory/$date"

# Kiểm tra thư mục có tồn tại không
if [ ! -d "$path" ]; then
    # Nếu không tồn tại thì tạo thư mục
    mkdir -p "$path"
    echo "Directory created: $path"
else
    echo "Directory already exists: $path"
fi

# Chờ 3s
sleep 3

# Bắt đầu record
ffmpeg -y -i "$source" -vcodec copy -r 60 -t 3580 -y -segment_format mkv "$path/$(date +\%d-\%m-\%Y--\%H-\%M).mkv"' > /opt/record/record.sh
# Thiết lập quyền cho các script
sudo chmod +x /opt/record/*.sh

# Tạo lịch tự động
(crontab -l ; echo "@reboot bash /opt/record/rclone.sh" ; echo "0 * * * * bash /opt/record/record.sh") | crontab -
echo "**************************************************************************"
echo "******                                                            ********"
echo "******                                                            ********"
echo "******    Setup rclone config tên cam và khởi động lại hệ thống   ********"
echo "******          File cấu hình đặt ở thư mục /opt                  ********"
echo "******                                                            ********"
echo "******                                                            ********"
echo "**************************************************************************"
