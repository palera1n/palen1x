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
until [ "$ARCH" = 'amd64' ] || [ "$ARCH" = 'i686' ] || [ "$ARCH" = 'aarch64' ] || [ "$ARCH" = 'armv7' ]; do
    echo '1 amd64'
    echo '2 i686'
    echo '3 aarch64'
    echo '4 armv7'
    printf 'Which architecture? amd64 (default), i686, or aarch64 or armv7'
    read -r input_arch
    [ "$input_arch" = 1 ] && ARCH='amd64'
    [ "$input_arch" = 2 ] && ARCH='i686'
    [ "$input_arch" = 3 ] && ARCH='aarch64'
    [ "$input_arch" = 4 ] && ARCH='armv7'
    [ -z "$input_arch" ] && ARCH='amd64'
done

# Install dependencies to build palen1x
apt-get update
apt-get install -y --no-install-recommends wget gawk debootstrap mtools xorriso ca-certificates curl libusb-1.0-0-dev gcc make gzip xz-utils unzip libc6-dev

# Get proper files
if [ "$1" = "RELEASE" ]; then
    case "$ARCH" in
        'amd64')
            ROOTFS='https://dl-cdn.alpinelinux.org/alpine/v3.17/releases/x86_64/alpine-minirootfs-3.17.3-x86_64.tar.gz'
            PALERA1N="https://github.com/palera1n/palera1n/releases/download/v2.0.0-beta.8/palera1n-linux-x86_64"
            ;;
        'i686')
            ROOTFS='https://dl-cdn.alpinelinux.org/alpine/v3.17/releases/x86/alpine-minirootfs-3.17.3-x86.tar.gz'
            PALERA1N="https://github.com/palera1n/palera1n/releases/download/v2.0.0-beta.8/palera1n-linux-x86"
            ;;
        'aarch64')
            ROOTFS='https://dl-cdn.alpinelinux.org/alpine/v3.17/releases/aarch64/alpine-minirootfs-3.17.3-aarch64.tar.gz'
            PALERA1N="https://github.com/palera1n/palera1n/releases/download/v2.0.0-beta.8/palera1n-linux-arm64"
            ;;
        'armv7')
            ROOTFS='https://dl-cdn.alpinelinux.org/alpine/v3.17/releases/armv7/alpine-minirootfs-3.17.3-armv7.tar.gz'
            PALERA1N="https://github.com/palera1n/palera1n/releases/download/v2.0.0-beta.8/palera1n-linux-armel"
            ;;
    esac
    echo "INFO: RELEASE CHOSEN"
elif [ "$1" = "NIGHTLY" ]; then


    url="https://cdn.nickchan.lol/palera1n/artifacts/c-rewrite/main/"
    latest_build=0
    html=$(curl -s "$url")
    latest_build=$(echo "$html" | awk -F'href="' '{print $2}' | awk -F'/' 'NF>1{print $1}' | sort -nr | head -1)

     case "$ARCH" in
        'amd64')
            ROOTFS='https://dl-cdn.alpinelinux.org/alpine/v3.17/releases/x86_64/alpine-minirootfs-3.17.3-x86_64.tar.gz'
            PALERA1N="https://cdn.nickchan.lol/palera1n/artifacts/c-rewrite/main/$latest_build/palera1n-linux-x86_64"
            ;;
        'i686')
            ROOTFS='https://dl-cdn.alpinelinux.org/alpine/v3.17/releases/x86/alpine-minirootfs-3.17.3-x86.tar.gz'
            PALERA1N="https://cdn.nickchan.lol/palera1n/artifacts/c-rewrite/main/$latest_build/palera1n-linux-x86"
            ;;
        'aarch64')
            ROOTFS='https://dl-cdn.alpinelinux.org/alpine/v3.17/releases/aarch64/alpine-minirootfs-3.17.3-aarch64.tar.gz'
            PALERA1N="https://cdn.nickchan.lol/palera1n/artifacts/c-rewrite/main/$latest_build/palera1n-linux-arm64"
            ;;
        'armv7')
            ROOTFS='https://dl-cdn.alpinelinux.org/alpine/v3.17/releases/armv7/alpine-minirootfs-3.17.3-armv7.tar.gz'
            PALERA1N="https://cdn.nickchan.lol/palera1n/artifacts/c-rewrite/main/$latest_build/palera1n-linux-armel"
            ;;
    esac
    echo "INFO: NIGHTLY CHOSEN"
elif [[ -z "$BUILD_TYPE" ]]; then
    echo "ERROR: NO BUILD TYPE CHOSEN"
    exit 1
fi

# Delete old build
{
    umount work/chroot/proc
    umount work/chroot/sys
    umount work/chroot/dev
} > /dev/null 2>&1
rm -rf work/

set -e -u -v
start_time="$(date -u +%s)"

# Install dependencies to build palen1x
apt-get update
apt-get install -y --no-install-recommends wget debootstrap grub-pc-bin \
    grub-efi-amd64-bin mtools squashfs-tools xorriso ca-certificates curl \
    libusb-1.0-0-dev gcc make gzip xz-utils unzip libc6-dev

if [ "$ARCH" = 'amd64' ]; then
    REPO_ARCH='amd64' # Debian's 64-bit repos are "amd64"
    KERNEL_ARCH='amd64' # Debian's 32-bit kernels are suffixed "amd64"
else
    # Install depencies to build palen1x for i686
    dpkg --add-architecture i386
    apt-get update
    apt install -y --no-install-recommends libusb-1.0-0-dev:i386 gcc-multilib
    REPO_ARCH='i386' # Debian's 32-bit repos are "i386"
    KERNEL_ARCH='686' # Debian's 32-bit kernels are suffixed "-686"
fi

# Configure the base system
mkdir -p work/chroot work/iso/live work/iso/boot/grub
debootstrap --variant=minbase --arch="$REPO_ARCH" stable work/chroot 'http://mirror.xtom.com.hk/debian/'
mount --bind /proc work/chroot/proc
mount --bind /sys work/chroot/sys
mount --bind /dev work/chroot/dev
cp /etc/resolv.conf work/chroot/etc
cat << EOF | chroot work/chroot /bin/bash
# Set debian frontend to noninteractive
export DEBIAN_FRONTEND=noninteractive

# Install requiered packages
echo "deb http://archive.ubuntu.com/ubuntu bionic main universe" >> work/chroot/etc/apt/sources.list
apt update
sleep 1
apt-get install -y --no-install-recommends linux-image-$KERNEL_ARCH live-boot \
  systemd systemd-sysv usbmuxd openssh-client sshpass whiptail xz-utils

# Remove apt as it won't be usable anymore
sleep 1
apt purge perl -y --allow-remove-essential
apt purge apt -y --allow-remove-essential
EOF
# Change initramfs compression to xz
sed -i 's/COMPRESS=gzip/COMPRESS=xz/' work/chroot/etc/initramfs-tools/initramfs.conf
chroot work/chroot update-initramfs -u
(
    cd work/chroot
    # Empty some directories to make the system smaller
    rm -f etc/mtab \
        etc/fstab \
        etc/ssh/ssh_host* \
        root/.wget-hsts \
        root/.bash_history
    rm -rf var/log/* \
        var/cache/* \
        var/backups/* \
        var/lib/apt/* \
        var/lib/dpkg/* \
        usr/share/doc/* \
        usr/share/man/* \
        usr/share/info/* \
        usr/share/icons/* \
        usr/share/locale/* \
        usr/share/zoneinfo/* \
        usr/lib/modules/*
)

sleep 1
# Copy scripts
cp scripts/* work/chroot/usr/bin/

(
    cd work/chroot/usr/local/bin
    curl -L -o palera1n "$PALERA1N"
    chmod +x palera1n
)

# Configure autologin
mkdir -p work/chroot/etc/systemd/system/getty@tty1.service.d
cat << EOF > work/chroot/etc/systemd/system/getty@tty1.service.d/override.conf
[Service]
ExecStart=
ExecStart=-/sbin/agetty --noissue --autologin root %I
Type=idle
EOF

# Configure grub
cat << "EOF" > work/iso/boot/grub/grub.cfg
insmod all_video
echo ''
echo ' _ __   __ _| | ___ _ __ | |_  __'
echo '| `_ \ / _` | |/ _ \ `_ \| \ \/ /'
echo '| |_) | (_| | |  __/ | | | |>  < '
echo '| .__/ \__,_|_|\___|_| |_|_/_/\_\'
echo '| |                              '
echo ''
echo '    Made with <3 by flower, forked from raspberryenvoie/odysseyn1x'
linux /boot/vmlinuz boot=live quiet
initrd /boot/initrd.img
boot
EOF

# Echo TUI configurations
echo 'palen1x' > rootfs/etc/hostname
echo "PATH=$PATH:$HOME/.local/bin" > rootfs/root/.bashrc # d
echo "export PALEN1X_VERSION='$VERSION'" > rootfs/root/.bashrc
echo '/usr/bin/palen1x_menu' >> rootfs/root/.bashrc
echo "Rootless" > rootfs/usr/bin/.jbtype
echo "" > rootfs/usr/bin/.args

rm -f work/chroot/etc/resolv.conf

# Build the ISO
umount work/chroot/proc
umount work/chroot/sys
umount work/chroot/dev
cp work/chroot/vmlinuz work/iso/boot
cp work/chroot/initrd.img work/iso/boot
mksquashfs work/chroot work/iso/live/filesystem.squashfs -noappend -e boot -comp xz -Xbcj x86
grub-mkrescue -o "c-palen1x-$VERSION-$ARCH.iso" work/iso \
    --compress=xz \
    --fonts='' \
    --locales='' \
    --themes=''

end_time="$(date -u +%s)"
elapsed_time="$((end_time - start_time))"

echo "Built c-palen1x-$VERSION-$ARCH in $((elapsed_time / 60)) minutes and $((elapsed_time % 60)) seconds."
