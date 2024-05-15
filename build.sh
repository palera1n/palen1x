#!/bin/bash
#
# palen1x build script
# Made with <3 https://github.com/palera1n/palen1x
# Modified from https://github.com/asineth0/checkn1x & https://github.com/raspberryenvoie/odysseyn1x :3

# Exit if user isn't root
[ "$(id -u)" -ne 0 ] && {
    echo 'Please run as root'
    exit 1
}

GREEN="$(tput setaf 2)"
BLUE="$(tput setaf 6)"
NORMAL="$(tput sgr0)"
cat << EOF

           Welcome to                 ${GREEN}&&&%##%%(${NORMAL}
                               ${GREEN}&&&&&&&&&&&%#&&%%%${NORMAL}
                        ${GREEN}&&&&&&&&&&&&&&&&&&%%#&&&%%%${NORMAL}
                ${BLUE}&&&&&&&&${NORMAL}#############${GREEN}&&&%%&%%&&&&%%%${NORMAL}
         ${BLUE}%%%%%%%%%%%%&&&${NORMAL}#  ${BLUE}palen1x${NORMAL}  #${GREEN}%&&&&%%%%%%%%%%%%${NORMAL}
     ${BLUE}#######((((###%%%%%${NORMAL}#############${GREEN}&%%%%%%%${NORMAL}
     ${BLUE}######/     ########%%%%&&&&&&&%%${NORMAL}
      ${BLUE}((((((((((((######%%%%%%%${NORMAL}
       ${BLUE}(((((((((#####%%*${NORMAL}
        ${BLUE}/(((((##${NORMAL}                  build script

EOF
# Ask for the version and architecture if variables are empty
while [ -z "$VERSION" ]; do
    printf 'Version: '
    read -r VERSION
done
until [ "$ARCH" = 'amd64' ] || [ "$ARCH" = 'i586' ] || [ "$ARCH" = 'aarch64' ] || [ "$ARCH" = 'armv7' ]; do
    echo '1 amd64'
    echo '2 i586'
    echo '3 aarch64'
    echo '4 armv7'
    printf 'Which architecture? amd64 (default), i586, or aarch64 or armv7'
    read -r input_arch
    [ "$input_arch" = 1 ] && ARCH='amd64'
    [ "$input_arch" = 2 ] && ARCH='i586'
    [ "$input_arch" = 3 ] && ARCH='aarch64'
    [ "$input_arch" = 4 ] && ARCH='armv7'
    [ -z "$input_arch" ] && ARCH='amd64'
done

# Install dependencies to build palen1x
#apt-get update
#apt-get install -y --no-install-recommends wget gawk debootstrap mtools xorriso ca-certificates curl libusb-1.0-0-dev gcc make gzip xz-utils unzip libc6-dev
# Get proper files
if [ "$1" = "RELEASE" ]; then
    download_version=$(curl -s https://api.github.com/repos/palera1n/palera1n/releases | grep -m 1 -o '"tag_name": "[^"]*' | sed 's/"tag_name": "//')
    PALERA1N_PREFIX="https://github.com/palera1n/palera1n/releases/download/$(download_version)/palera1n-linux-"
elif [ "$1" = "NIGHTLY" ]; then
    url="https://cdn.nickchan.lol/palera1n/artifacts/c-rewrite/main/"
    latest_build=0
    html=$(curl -s "$url")
    latest_build=$(echo "$html" | awk -F'href="' '{print $2}' | awk -F'/' 'NF>1{print $1}' | sort -nr | head -1)
    PALERA1N_PREFIX="https://cdn.nickchan.lol/palera1n/artifacts/c-rewrite/main/$latest_build/binaries/palera1n-linux-"
else
    echo "ERROR: NO BUILD TYPE CHOSEN"
    exit 1
fi

echo "INFO: $1 CHOSEN"

USBMUXD_PREFIX="https://cdn.nickchan.lol/palera1n/artifacts/usbmuxd-static/usbmuxd-linux-"
ROOTFS_PREFIX="https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/x86_64/alpine-minirootfs-3.19.1-"

case "$ARCH" in
    'amd64')
        ROOTFS="${ROOTFS_PREFIX}x86_64.tar.gz"
        PALERA1N="${PALERA1N_PREFIX}x86_64"
        USBMUXD="${USBMUXD_PREFIX}x86_64"
        ;;
    'i586')
        ROOTFS="${ROOTFS_PREFIX}x86.tar.gz"
        PALERA1N="${PALERA1N_PREFIX}x86"
        USBMUXD="${USBMUXD_PREFIX}x86"
        ;;
    'aarch64')
        ROOTFS="${ROOTFS_PREFIX}aarch64.tar.gz"
        PALERA1N="${PALERA1N_PREFIX}arm64"
        USBMUXD="${USBMUXD_PREFIX}arm64"
        ;;
    'armv7')
        ROOTFS="${ROOTFS_PREFIX}armv7.tar.gz"
        PALERA1N="${PALERA1N_PREFIX}armel"
        USBMUXD="${USBMUXD_PREFIX}armel"
    ;;
esac

# Clean up previous attempts
umount -v work/rootfs/{dev,sys,proc} >/dev/null 2>&1
rm -rf work
mkdir -pv work/{rootfs,iso/boot/grub}
cd work

# Fetch ROOTFS
curl -sL "$ROOTFS" | tar -xzC rootfs
mount -vo bind /dev rootfs/dev
mount -vt sysfs sysfs rootfs/sys
mount -vt proc proc rootfs/proc
cp /etc/resolv.conf rootfs/etc
cat << ! > rootfs/etc/apk/repositories
http://dl-cdn.alpinelinux.org/alpine/v3.19/main
http://dl-cdn.alpinelinux.org/alpine/v3.19/community
!

sleep 2
# ROOTFS packages & services
cat << ! | chroot rootfs /usr/bin/env PATH=/usr/bin:/usr/local/bin:/bin:/usr/sbin:/sbin /bin/sh
apk update
apk upgrade
apk add bash alpine-base ncurses udev openssh-client sshpass newt
apk add --no-scripts linux-lts linux-firmware-none
rc-update add bootmisc
rc-update add hwdrivers
rc-update add udev
rc-update add udev-trigger
rc-update add udev-settle
!

# kernel modules
cat << ! > rootfs/etc/mkinitfs/features.d/palen1x.modules
kernel/drivers/usb/host
kernel/drivers/hid/usbhid
kernel/drivers/hid/hid-generic.ko
kernel/drivers/hid/hid-cherry.ko
kernel/drivers/hid/hid-apple.ko
kernel/net/ipv4
!
chroot rootfs /usr/bin/env PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin \
	/sbin/mkinitfs -F "palen1x" -k -t /tmp -q $(ls rootfs/lib/modules)
rm -rf rootfs/lib/modules
mv -v rootfs/tmp/lib/modules rootfs/lib
find 'rootfs/lib/modules' -type f -name "*.ko" -exec strip -v --strip-unneeded {} +
find 'rootfs/lib/modules' -type f -name "*.ko" -exec xz --x86 -ze9T0 {} +
depmod -b rootfs $(ls rootfs/lib/modules)

# Echo TUI configurations
echo 'palen1x' > rootfs/etc/hostname
echo "PATH=$PATH:$HOME/.local/bin" > rootfs/root/.bashrc # d
echo "export PALEN1X_VERSION='$VERSION'" > rootfs/root/.bashrc
echo '/usr/bin/palen1x_menu' >> rootfs/root/.bashrc
echo "Rootless" > rootfs/usr/bin/.jbtype
echo "-l --cli" > rootfs/usr/bin/.args

# Unmount fs
umount -v rootfs/{dev,sys,proc}

# Fetch palera1n-c
curl -Lo rootfs/usr/bin/palera1n "$PALERA1N"
chmod +x rootfs/usr/bin/palera1n

# Fetch usbmuxd
curl -Lo rootfs/usr/sbin/usbmuxd "$USBMUXD"
chmod +x rootfs/usr/sbin/usbmuxd

# Copy files
cp -av ../inittab rootfs/etc
cp -v ../scripts/* rootfs/usr/bin
chmod -v 755 rootfs/usr/local/bin/*
ln -sv sbin/init rootfs/init
ln -sv ../../etc/terminfo rootfs/usr/share/terminfo # fix ncurses

# Boot config
cp -av rootfs/boot/vmlinuz-lts iso/boot/vmlinuz
cat << ! > iso/boot/grub/grub.cfg
insmod all_video
echo 'palen1x $VERSION'
linux /boot/vmlinuz console=tty0 fbcon=nodefer fbcon=logo-count:1
initrd /boot/initramfs.zst
boot
!

#usr/share/{man,apk,kernel,slsh,misc,mkinitfs}
# initramfs
pushd rootfs
rm -rf tmp/* boot/* var/cache/* etc/resolv.conf etc/apk etc/motd sbin/apk lib/libapk*
find . | cpio -oH newc | zstd -c22 --ultra -T0 > ../iso/boot/initramfs.zst
popd

# ISO creation
GRUB_MODS="linux all_video configfile echo part_gpt part_msdos"
grub-mkrescue -o "palen1x-$ARCH.iso" iso \
	--compress=xz \
	--fonts= \
	--install-modules="$GRUB_MODS" \
	--modules="$GRUB_MODS" \
	--locales= \
	--themes=
