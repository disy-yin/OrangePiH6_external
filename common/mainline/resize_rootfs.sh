#!/bin/sh

if [ "$(id -u)" -ne "0" ]; then
	echo "This script requires root."
	exit 1
fi

DEVICE="/dev/mmcblk0"

PART="2"

resize() {
	start=$(fdisk -l ${DEVICE}|grep ${DEVICE}p${PART}|awk '{print $2}')
	echo $start

	set +e
	fdisk ${DEVICE} <<EOF
p
d
2
n
p
2
$start

w
EOF
	partx -u ${DEVICE}
	resize2fs ${DEVICE}p${PART}
}

resize 1>/tmp/resize_rootfs.log 2>&1

echo "Done!"
