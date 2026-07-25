#!/usr/bin/env bash
#
# palen1x build script
# https://github.com/palera1n/palen1x
#
# Modified from https://github.com/asineth0/checkn1x
# Modified from https://github.com/raspberryenvoie/odysseyn1x

[ "$(id -u)" -ne 0 ] && {
    echo 'Please run as root'
    exit 1
}

GREEN="$(tput setaf 2)"
BLUE="$(tput setaf 6)"
NORMAL="$(tput sgr0)"

until [ "$ARCH" = 'x86_64' ] || [ "$ARCH" = 'x86' ]; do
    echo '1 x86_64'
    echo '2 x86'
    printf 'Which architecture? x86_64 (default), x86: '
    read -r input_arch
    [ "$input_arch" = 1 ] && ARCH='x86_64'
    [ "$input_arch" = 2 ] && ARCH='x86'
    [ -z "$input_arch" ] && ARCH='x86_64'
done

PATH_VERSION="v3.20"
ROOTFS_VERSION="3.20.0"
ROOTFS_PREFIX="https://dl-cdn.alpinelinux.org/alpine/${PATH_VERSION}/releases"

case "$ARCH" in
    'x86_64')
        ROOTFS="${ROOTFS_PREFIX}/x86_64/alpine-minirootfs-${ROOTFS_VERSION}-x86_64.tar.gz"
        ;;
    'x86')
        ROOTFS="${ROOTFS_PREFIX}/x86/alpine-minirootfs-${ROOTFS_VERSION}-x86.tar.gz"
        ;;
esac

echo $PALERA1N
echo $USBMUXD
echo $ROOTFS

# Clean
umount -v work/rootfs/{dev,sys,proc} >/dev/null 2>&1
rm -rf work
mkdir -pv work/{rootfs,iso/boot/grub}
cd work

# 
curl -sL "$ROOTFS" | tar -xzC rootfs
mount -vo bind /dev rootfs/dev
mount -vt sysfs sysfs rootfs/sys
mount -vt proc proc rootfs/proc
cp /etc/resolv.conf rootfs/etc
cat << ! > rootfs/etc/apk/repositories
http://dl-cdn.alpinelinux.org/alpine/v3.14/main
http://dl-cdn.alpinelinux.org/alpine/edge/community
http://dl-cdn.alpinelinux.org/alpine/edge/testing
!

sleep 2

ROOTFS_PATH="/usr/bin:/usr/local/bin:/bin:/usr/sbin:/sbin"

#
cat << ! | chroot rootfs /usr/bin/env PATH=$ROOTFS_PATH /bin/sh
apk update
apk upgrade
apk add bash alpine-base ncurses udev openssh-client sshpass usbmuxd mandoc man-pages
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
chroot rootfs /usr/bin/env PATH=$ROOTFS_PATH \
	/sbin/mkinitfs -F "palen1x" -k -t /tmp -q $(ls rootfs/lib/modules)
rm -rf rootfs/lib/modules
mv -v rootfs/tmp/lib/modules rootfs/lib

find 'rootfs/lib/modules' -type f -name "*.ko" -exec strip -v --strip-unneeded {} +
find 'rootfs/lib/modules' -type f -name "*.ko" -exec xz --x86 -ze9T0 {} +

depmod -b rootfs $(ls rootfs/lib/modules)

# create config shit
echo 'palen1x' > rootfs/etc/hostname
echo "PATH=$ROOTFS_PATH" > rootfs/root/.bashrc
echo 'welcome' >> rootfs/root/.bashrc

# Unmount fs
umount -v rootfs/{dev,sys,proc}

# install inetcat
cp ../resources/inetcat rootfs/bin/inetcat
cp ../resources/inetcat-LICENSE rootfs/usr/share/licenses/

# install palera1n
if [ -f ../resources/palera1n.tar.gz ]; then
    tar -xzf ../resources/palera1n.tar.gz -C rootfs/usr/
elif [ -f ../resources/palera1n ]; then
    cp ../resources/palera1n rootfs/bin/palera1n
else
    echo "Error: Neither ./resources/palera1n.tar.gz nor ./resources/palera1n exists." >&2
    exit 1
fi

cp -av ../scripts/inittab rootfs/etc
cp -v ../scripts/* rootfs/bin
ln -sv sbin/init rootfs/init
ln -sv ../../etc/terminfo rootfs/usr/share/terminfo # fix ncurses

cp -av rootfs/boot/vmlinuz-lts iso/boot/vmlinuz
cat << ! > iso/boot/grub/grub.cfg
insmod all_video
linux /boot/vmlinuz  quiet loglevel=3
initrd /boot/initramfs.xz
boot
!

pushd rootfs
rm -rf tmp/* boot/* var/cache/* etc/resolv.conf
find . | cpio -oH newc | xz -C crc32 --x86 -vz9eT$(nproc --all) > ../iso/boot/initramfs.xz
popd

# naming
OUTPUT="palen1x-$ARCH"

if [ -n "$VERSION" ]; then
  OUTPUT="palen1x-$VERSION-$ARCH"
fi

# create iso
grub-mkrescue -o "$OUTPUT.iso" iso --compress=xz