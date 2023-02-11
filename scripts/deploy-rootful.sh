#!/cores/binpack/bin/sh

# Check if you can use it
if stat /.procursus_strapped >/dev/null 2>&1; then
echo 'Already installed.'
exit
fi

if stat /var/jb/.procursus_strapped >/dev/null 2>&1; then
echo 'Dont install on rootless.'
exit
fi

if stat /private/preboot/$(cat /private/preboot/active)/procursus >/dev/null 2>&1; then
echo 'Dont install on rootless?'
exit
fi

if stat /var/jb >/dev/null 2>&1; then
echo 'Dont install on rootless.'
exit
fi

cd /private/var/tmp
echo "Downloading Contents.."
curl -sLOOOOO https://static.palera.in/bootstrap.tar
curl -sLOOOOO https://static.palera.in/sileo.deb
curl -sLOOOOO https://static.palera.in/straprepo.deb
sleep 1

echo "Preparing Bootstrap.."
/sbin/mount -uw /
tar --preserve-permissions -xkf bootstrap.tar /
sleep 1
/usr/bin/chmod 4755 /usr/bin/sudo
/usr/bin/chown root:wheel /usr/bin/sudo
/usr/bin/sh /prep_bootstrap.sh

# Install packages
echo "Installing Sileo-Nightly.."
/usr/bin/dpkg -i straprepo.deb
/usr/bin/dpkg -i sileo.deb
sleep 1

/usr/bin/apt-get update -o Acquire::AllowInsecureRepositories=true
/usr/bin/apt-get dist-upgrade -y --allow-downgrades --allow-unauthenticated
/usr/bin/uicache -a
