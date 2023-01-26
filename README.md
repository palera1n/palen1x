<p align="center">
    <img src="https://gist.github.com/raspberryenvoie/586dbef790b752cabda3c50a0a169f6d/raw/838909cd160ba8e010c7b72618a71f84aa45d0aa/odysseyn1x-logo.png" alt="logo">
</p>
<br>
<p align="center">
<strong>Linux distro that lets you install <a href="https://checkra.in/">checkra1n</a>, <a href="https://github.com/coolstar/Odyssey-bootstrap">odysseyra1n</a>, <a href="https://projectsandcastle.org/">Project Sandcastle</a> as well as starting <a href="https://github.com/SoMainline/linux-apple-resources">Linux on Apple</a>.</strong><br>
    It aims to be easy to use, have a nice interface and support 32 and 64 bit CPUs.
</p>
<p align="center">
    <a href="#usage">Usage</a> •
    <a href="#odysseyra1n">Odysseyra1n</a> •
    <a href="#project-sandcastle">Project Sandcastle</a> •
    <a href="#building-odysseyn1x">Linux on Apple</a> •
    <a href="#building-odysseyn1x">Building odysseyn1x</a> •
    <a href="#contributing">Contributing</a> •
    <a href="#credits">Credits</a>
</p>

<p align="center">
    <img src="https://gist.github.com/raspberryenvoie/c2e1423c7fe02cff68c392427a47de04/raw/fe481f35bec02e91f0392f5ff3f086ff8b4298aa/odysseyn1x_screenshot.png" alt="screenshot" width="650">
</p>

-------

# Usage
**Make an [iCloud/iTunes backup](https://support.apple.com/en-us/HT203977) before using odysseyn1x, so that you can go back if something goes wrong.**

The `amd64` iso is for 64-bit CPUs (AMD and Intel) and the `i686` one is for 32-bit CPUs. If you are unsure which one to download, the `amd64` ISO will work in most cases.

1. Download an `.iso` [here](https://github.com/raspberryenvoie/odysseyn1x/releases).
2. Download [balenaEtcher](https://www.balena.io/etcher/). If you prefer Rufus, make sure to select GPT partition and DD image mode otherwise it won't work.
3. Open balenaEtcher and write the `.iso` you downloaded to your USB drive.
4. Reboot, enter your BIOS's boot menu and select the USB drive.

# Checkra1n (A8X/A9X)

Due to a checkra1n bug, the checkra1n option will give `Found corrupting kerninfo` after booting into the checkra1n apple logo screen on A8X/A9X devices. Use this option to workaround this bug.

# Odysseyra1n
## What's odysseyra1n
Odysseyra1n lets you install on a checkra1ned device
- libhooker, a substrate/substitute alternative built from the ground up by Coolstar with speed and stability in mind,
- Procursus, an open source and modern bootstrap that aims to provide a large set of consistently up-to-date tools and
- Sileo instead of aging Cydia.

## Installing odysseyra1n
1. If you're already jailbroken, restore system using the ckeckra1n app.
2. Jailbreak using checkra1n, but don’t open the ckeckra1n app.
3. Install odysseyra1n.

Note: You don’t have to reinstall odysseyra1n after each reboot, just re-jailbreak using checkra1n.

# Project Sandcastle
## What's Project Sandcastle
It's Android and Linux for the iPhone. Project Sandcastle is in beta so not everything is fully supported. [More information](https://projectsandcastle.org)

## Installing Android
Select `Project Sandcastle` > `Setup Project Sandcastle`. After that choose `Start Android`.

Note: Once Project Sandcastle is installed, simply choose `Start Android` to boot back into Android.

## Removing Android to reclaim space
1. Login via SSH to your checkra1ned device (odysseyn1x has a feature for that) or use a terminal app (e.g. Newterm)
2. Run `ls /dev/disk0s1s*` and find the last volume. You can verify it's the right volume by running `/System/Library/Filesystems/apfs.fs/apfs.util -p VOLUME_HERE` and if it says Android, that's the correct one.
3. Once you have the volume path, you can then run these commands as root (type `su`):
```
mkdir -p /tmp/mnt
mount -t apfs VOLUME_HERE /tmp/mnt
rm -rf /tmp/mnt/nand
umount /tmp/mnt
sync
```

## Booting Linux
Select `Project Sandcastle` > `Start Linux`.

# Linux on Apple
## What's Linux on Apple
Linux on Apple is another project to port Linux to 64-bit checkm8 apple devices. Linux on Apple is currently in alpha.
Please note that all T2 and HomePod devices, as well as the Apple TV 4K are not supported.

- [More inforamtion](https://github.com/SoMainline/linux-apple-resources)
- [Kernel source](https://github.com/konradybcio/linux-apple)
- [ADT Collection](https://github.com/SoMainline/adt_collection)
- [pongoOS fork](https://github.com/konradybcio/pongoOS)

## Booting Linux
Select `Linux on Apple`, then, depending on your device, select `Start Linux (A7-A8)` or `Start Linux (A9-A11)`.

# Building odysseyn1x

To change the version of checkra1n, edit `CRSOURCE_amd64` and `CRSOURCE_i686`.\
Execute these commands on a Debian-based system.
```
git clone https://github.com/raspberryenvoie/odysseyn1x.git
cd odysseyn1x
sudo ./build.sh
```

# Contributing
Any contribution is always welcome :)

# Credits
- Asineth for checkn1x
- The checkra1n team for [checkra1n](https://checkra.in)
- CoolStar for [odysseyra1n](https://github.com/coolstar/Odyssey-bootstrap)
- [The Procursus Team](https://github.com/ProcursusTeam/) for [Procursus](https://github.com/ProcursusTeam/Procursus)
- [Corellium](https://github.com/corellium) for [Project Sandcastle](https://projectsandcastle.org)
- [u/GOGO307](https://www.reddit.com/user/GOGO307/) for the concept of an ISO with odysseyra1n
- [MyCatCondo](https://github.com/MyCatCondo) for suggesting to integrate Project Sandcastle (Android and Linux for the iPhone)
- [Konard Dybcio](https://twitter.com/konradybcio) and [Ivaylo Ivanov](https://twitter.com/ivoszbg) for [Linux on Apple](https://github.com/SoMainline/linux-apple-resources)
- [Everyone else who contributed to the project](https://github.com/raspberryenvoie/odysseyn1x/graphs/contributors)
