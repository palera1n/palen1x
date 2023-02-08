#!/bin/sh
# Made with <3 by flower
# palen1x build script (a fork of raspberryenvoie/odysseyn1x)

# Exit if user isn't root
[ "$(id -u)" -ne 0 ] && {
    echo 'Please run as root'
    exit 1
}

# Change these variables to modify the version of palera1n-c, with updated PongoOS
PALERA1N_AMD64='https://cdn.nickchan.lol/palera1n/artifacts/c-rewrite/palera1n-linux-x86_64'
PALERA1N_I686='https://cdn.nickchan.lol/palera1n/artifacts/c-rewrite/palera1n-linux-x86'

GREEN="$(tput setaf 2)"
BLUE="$(tput setaf 6)"
NORMAL="$(tput sgr0)"
cat << EOF
${GREEN}############################################${NORMAL}
${GREEN}#                                          #${NORMAL}
${GREEN}#  ${BLUE}Welcome to the palen1x build script     ${GREEN}#${NORMAL}
${GREEN}#                                          #${NORMAL}
${GREEN}############################################${NORMAL}

EOF
# Ask for the version and architecture if variables are empty
while [ -z "$VERSION" ]; do
    printf 'Version: '
    read -r VERSION
done
until [ "$ARCH" = 'amd64' ] || [ "$ARCH" = 'i686' ]; do
    echo '1 amd64'
    echo '2 i686'
    printf 'Which architecture? amd64 (default) or i686 '
    read -r input_arch
    [ "$input_arch" = 1 ] && ARCH='amd64'
    [ "$input_arch" = 2 ] && ARCH='i686'
    [ -z "$input_arch" ] && ARCH='amd64'
done

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
  systemd systemd-sysv usbmuxd openssh-client sshpass whiptail

# Remove apt as it won't be usable anymore
sleep 1
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
        if [ "$ARCH" = 'amd64' ]; then
        curl -L -o palera1n "$PALERA1N_AMD64"
    else
        curl -L -o palera1n "$PALERA1N_I686"
    fi
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

# Change hostname and configure .bashrc & set default jailbreak type (rootful)
echo 'palen1x' > work/chroot/etc/hostname
echo "PATH=$PATH:$HOME/.local/bin" >> work/chroot/root/.bashrc
echo "export PALEN1X_VERSION='$VERSION'" > work/chroot/root/.bashrc
echo '/usr/bin/palen1x_menu' >> work/chroot/root/.bashrc
echo "Rootful" > work/chroot/usr/bin/.jbtype

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
