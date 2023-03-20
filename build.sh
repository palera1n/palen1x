#!/usr/bin/env bash
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
# Ask for the architecture if variable is empty
until [ "$ARCH" = 'amd64' ] || [ "$ARCH" = 'i686' ]; do
    echo '1 amd64'
    echo '2 i686'
    printf 'Which architecture? amd64 (default) or i686'
    read -r input_arch
    [ "$input_arch" = 1 ] && ARCH='amd64'
    [ "$input_arch" = 2 ] && ARCH='i686'
    [ -z "$input_arch" ] && ARCH='amd64'
done

# Install dependencies to build palen1x
apt-get update
apt-get install -y --no-install-recommends ca-certificates cpio curl grub2-common grub-efi-amd64-bin grub-pc-bin gzip mtools tar xorriso xz-utils

VERSION="$(cat version)"

# Get proper files for amd64 or i686
if [ "$ARCH" = 'amd64' ]; then
    ROOTFS='https://dl-cdn.alpinelinux.org/alpine/v3.17/releases/x86_64/alpine-minirootfs-3.17.1-x86_64.tar.gz'
    PALERA1N='https://github.com/palera1n/palera1n/releases/download/v2.0.0-beta.4/palera1n-linux-x86_64'
else
    ROOTFS='https://dl-cdn.alpinelinux.org/alpine/v3.17/releases/x86/alpine-minirootfs-3.17.1-x86.tar.gz'
    PALERA1N='https://github.com/palera1n/palera1n/releases/download/v2.0.0-beta.4/palera1n-linux-x86'
fi

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
http://dl-cdn.alpinelinux.org/alpine/v3.13/main
http://dl-cdn.alpinelinux.org/alpine/v3.13/community
http://dl-cdn.alpinelinux.org/alpine/edge/testing
!

sleep 2
# ROOTFS packages & services
cat << ! | chroot rootfs /usr/bin/env PATH=/usr/bin:/usr/local/bin:/bin:/usr/sbin:/sbin /bin/sh
apk update
apk upgrade
apk add bash alpine-base usbmuxd ncurses udev openssh-client sshpass newt
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
rm -rfv rootfs/lib/modules
mv -v rootfs/tmp/lib/modules rootfs/lib
find rootfs/lib/modules/* -type f -name "*.ko" -exec strip -v --strip-unneeded {} \; -exec xz --x86 -v9eT0 \;
depmod -b rootfs $(ls rootfs/lib/modules)

# Echo TUI configurations
echo 'palen1x' > rootfs/etc/hostname
echo "PATH=$PATH:$HOME/.local/bin" >> rootfs/root/.bashrc
echo "export PALEN1X_VERSION='$VERSION'" > rootfs/root/.bashrc
echo '/usr/bin/palen1x_menu' >> rootfs/root/.bashrc
echo "Rootful" > rootfs/usr/bin/.jbtype
echo "" > rootfs/usr/bin/.args

# Unmount fs
umount -v rootfs/{dev,sys,proc}

# Fetch palera1n-c
curl -Lo rootfs/usr/bin/palera1n "$PALERA1N"
chmod +x rootfs/usr/bin/palera1n

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
linux /boot/vmlinuz quiet loglevel=3
initrd /boot/initramfs.xz
boot
!

# initramfs
pushd rootfs
rm -rfv tmp/* boot/* var/cache/* etc/resolv.conf
find . | cpio -oH newc | xz -C crc32 --x86 -vz9eT$(nproc --all) > ../iso/boot/initramfs.xz
popd

# ISO creation
grub-mkrescue -o "c-palen1x-$VERSION-$ARCH.iso" iso --compress=xz
