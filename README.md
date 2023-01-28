<p align="center">
    <img src="https://cdn.discordapp.com/attachments/1017854329887129611/1068174531048513596/Palen1x.png" alt="logo" width="250">
</p>
<br>
<p align="center">
<strong>Linux distro that lets you install <a href="https://github.com/palera1n/palera1n-c">palera1n-c</a>.</strong><br>
    It aims to be easy to use, have a nice interface and support 32 and 64 bit CPUs.
</p>
<p align="center">
    <a href="#usage">Usage</a> •
    <a href="#building-palen1x">Building palen1x</a> •
    <a href="#contributing">Contributing</a> •
    <a href="#credits">Credits</a> •
    <a href="https://github.com/palera1n/palen1x/blob/main/CHANGELOG.md">Changelog</a> 
</p>

<p align="center">
    <img src="https://cdn.discordapp.com/attachments/1017854329887129611/1068153144305008730/IMG_0807.png" alt="screenshot" width="950">
</p>

-------
# Warning
[palera1n-c](https://github.com/palera1n/palera1n-c) *may* not be ready to use, **use at your own risk**.

# Usage
**Make an [iCloud/iTunes backup](https://support.apple.com/en-us/HT203977) before using palen1x, so that you can go back if something goes wrong**.

The `amd64` iso is for 64-bit CPUs (AMD and Intel) and the `i686` one is for 32-bit CPUs. If you are unsure which one to download, the `amd64` ISO will work in most cases.

1. Download an `.iso` [here](http://mineek.online/palera1n/artifacts/palen1x).
2. Download [balenaEtcher](https://www.balena.io/etcher/). If you prefer Rufus, make sure to select GPT partition and DD image mode otherwise it won't work.
3. Open balenaEtcher and write the `.iso` you downloaded to your USB drive.
4. Reboot, enter your BIOS's boot menu and select the USB drive.

# Building palen1x

To change the version of palen1x, either change `version` file, or manually specify it with `./build.sh`.

Execute these commands on a Debian-based system.
```
git clone https://github.com/palera1n/palen1x.git
cd palen1x
sudo ./build.sh
```

# Contributing
Any contribution is always welcome :3

# Credits
- [palera1n Patreons](https://github.com/palera1n/palera1n#patreons)
- Asineth for [checkn1x](https://github.com/asineth0/checkn1x)
- The checkra1n team for [checkra1n](https://checkra.in)
- raspberryenvoie for [odysseyn1x](https://github.com/raspberryenvoie/odysseyn1x)
- [The Procursus Team](https://github.com/ProcursusTeam/) for [Procursus](https://github.com/ProcursusTeam/Procursus)
- [Everyone else who contributed to palen1x](https://github.com/palera1n/palen1x/graphs/contributors) & [palera1n-c](https://github.com/palera1n/palera1n-c/graphs/contributors)
