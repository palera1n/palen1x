#!/cores/binpack/bin/sh

# Check if you can use it
if stat /.procursus_strapped >/dev/null 2>&1; then
echo 'WTF.. (Dont install on root)'
exit
fi

if stat /var/jb/.procursus_strapped >/dev/null 2>&1; then
echo 'Already installed.'
exit
fi

if stat /private/preboot/$(cat /private/preboot/active)/procursus >/dev/null 2>&1; then
echo 'Already installed?'
exit
fi

if stat /var/jb >/dev/null 2>&1; then
echo 'Already installed?'
exit
fi

version=$(sysctl -n kern.osrelease)

if [[ $version == 21.* ]]; then
  value=1800
elif [[ $version == 22.* ]]; then
  value=1900
else
  exit
fi

# Download bootstrap, along with other packages
cd /var/root
curl -sLOOOOO https://apt.procurs.us/bootstraps/$(value)/bootstrap-ssh-iphoneos-arm64.tar.zst
curl -sLOOOOO https://raw.githubusercontent.com/elihwyma/Pogo/1724d2864ca55bc598fa96bee62acad875fe5990/Pogo/Required/org.coolstar.sileonightly_2.4_iphoneos-arm64.deb
zstd -d bootstrap-ssh-iphoneos-arm64.tar.zst
sleep 2

# Move bootstrap, mount necessary directories
mount -uw /private/preboot
mkdir /private/preboot/tempdir
tar --preserve-permissions -xkf bootstrap-ssh-iphoneos-arm64.tar -C /private/preboot/tempdir
mv -v /private/preboot/tempdir/var/jb /private/preboot/$(cat /private/preboot/active)/procursus

# Make symlink to var/jb, and prep_bootstrap
ln -s /private/preboot/$(cat /private/preboot/active)/procursus /var/jb
rm -rf /private/preboot/tempdir
source /var/jb/etc/profile
sleep 1
/var/jb/prep_bootstrap.sh
/var/jb/usr/libexec/firmware

# Install packages
echo "Installing Sileo-Nightly and upgrading Procursus packages..."
dpkg -i org.coolstar.sileonightly_2.4_iphoneos-arm64.deb > /dev/null
uicache -p /var/jb/Applications/Sileo-Nightly.app

# Echo palera1n repo to procursus sources, update sources, & remove leftovers
{
    echo "Types: deb"
    echo "URIs: https://repo.palera.in/"
    echo "Suites: ./"
    echo "Components:"
    echo ""   
} >> /var/jb/etc/apt/sources.list.d/procursus.sources
sleep 1
apt-get update -o Acquire::AllowInsecureRepositories=true
apt-get dist-upgrade -y --allow-downgrades --allow-unauthenticated

rm org.coolstar.sileonightly_2.4_iphoneos-arm64.deb
rm bootstrap-ssh-iphoneos-arm64.tar
rm bootstrap-ssh-iphoneos-arm64.tar.zst

echo Rebooting...
sleep 2
launchctl reboot userspace
