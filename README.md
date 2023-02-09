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
<h2
<p align="center">
    <a href="https://cdn.nickchan.lol/palera1n/artifacts/palen1x">Download palen1x</a> •
    <a href="https://dsc.gg/palera1n">Support Discord</a> 
</p>
</h2

-------
# Warning
[palera1n-c](https://github.com/palera1n/palera1n-c) / palen1x will never work in VirtualBox, VMware or any virtual machine that doesn't support a PCI passthrough. If you recieve a `Segmentation Fault` that's on you.

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

- Asineth for [checkn1x](https://github.com/asineth0/checkn1x)
- The checkra1n team for [checkra1n](https://checkra.in)
- raspberryenvoie for [odysseyn1x](https://github.com/raspberryenvoie/odysseyn1x)
- [The Procursus Team](https://github.com/ProcursusTeam/) for [Procursus](https://github.com/ProcursusTeam/Procursus)
- [Everyone else who contributed to palen1x](https://github.com/palera1n/palen1x/graphs/contributors) & [palera1n-c](https://github.com/palera1n/palera1n-c/graphs/contributors)

<br>
<p align="center">
Thank you so much to our Patreons that make the future development possible! You may sub <a href="https://patreon.com/palera1n">here</a>, if you'd like to.</br>
</p>
<p align="center">
<a href="https://github.com/samh06"><img width=64 src="https://user-images.githubusercontent.com/18669106/206333607-881d7ca1-f3bf-4e18-b620-25de0c527315.png"></img></a>
<a href="https://havoc.app"><img width=64 src="https://docs.havoc.app/img/standard_icon.png"></img></a>
<a href="https://twitter.com/yyyyyy_public"><img width=64  src="https://cdn.discordapp.com/attachments/1054239098006683688/1072587455779328040/image.png?size=400"></img></a>
<a href="https://twitter.com/0xSp00kyb0t"><img width=64  src="https://pbs.twimg.com/profile_images/1603601553226620935/1t4yD1bD_400x400.jpg"></img></a>
<a href="https://chariz.com"><img width=64 src="https://chariz.com/img/favicon.png"></img></a>
<a href="https://twitter.com/stars6220"><img width=64  src="https://pbs.twimg.com/profile_images/1621062976982728706/pWVZQ-NO_400x400.jpg"></img></a>
<a href="https://github.com/beast9265"><img width=64 src="https://avatars.githubusercontent.com/u/79794946?v=4"></img></a>
<a href="https://twitter.com/0x7FF7"><img width=64 src="https://pbs.twimg.com/profile_images/1616888462665306113/AsjJvtyt_400x400.jpg"></img></a>
<a href="https://sideloadly.io/"><img width=64 src="https://sideloadly.io/icon.png"></img></a>
<a href="https://blog.stevesec.com/"><img width=64 src="https://blog.stevesec.com/img/avatar.jpg"></img></a>
</p>
