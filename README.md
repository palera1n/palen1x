<p align="center">
    <img src="https://cdn.discordapp.com/attachments/1017854329887129611/1068174531048513596/Palen1x.png" alt="logo" width="250">
</p>
<br>
<p align="center">
<strong>Linux distro that lets you install <a href="https://github.com/palera1n/palera1n-c">palera1n-c</a>.</strong><br>
    It aims to be easy to use, have a nice interface and support 32 and 64 bit CPUs.
</p>
<p align="center">
    <a href="#Information">Information</a> •
    <a href="#contributing">Contributing</a> •
    <a href="#credits">Credits</a> •
    <a href="https://github.com/palera1n/palen1x/blob/main/CHANGELOG.md">Changelog</a> • 
    <a href="https://dsc.gg/palera1n">Support Discord</a> 
</p>

<p align="center">
    <img src="https://cdn.discordapp.com/attachments/1017854329887129611/1068153144305008730/IMG_0807.png" alt="screenshot" width="950">
</p>

-------
# Warnings
- We are NOT responsible for any data loss. The user of this distro accepts responsibility should something happen to their device. While nothing should happen, jailbreaking has risks in itself. If your device is stuck in recovery, please run `palera1n -n` in `Shell`.

- [palera1n-c](https://github.com/palera1n/palera1n-c) will never work in VirtualBox, VMware or any virtual machine that doesn't support a PCI passthrough. If you receive a `Segmentation Fault` that's on you.

- Use `-f -c` or `-f -B` for Rootful when creating fakeFS/bindFS, you also must use *only* `-f` to boot fakeFS/bindFS, otherwise it'll spit out an error saying that you already created the fakeFS/bindFS or it'll freeze without fakeFS/bindFS.
    - (`-f -B` won't work on 16.x). 

- This distro's purpose is to make [palera1n-c](https://github.com/palera1n/palera1n-c) easier and more intuitive(with TUI) to use within a stripped down distribution. Each option in `palera1n_options` correlates to what can be found in palera1n-c documentation. I am not including flags that the user will most likely never need, for example, `-i`. Further documention on [palera1n-c](https://github.com/palera1n/palera1n-c) can be found [here](https://cdn.nickchan.lol/palera1n/artifacts/c-rewrite/palera1n.1.html).

- Not recommended to mix `Rootful` & `Rootless` types together, but it's still a complete valid option. If you have any issues on removing them both you may go to the Support Discord.

- `A9 and below` devices may need to rerun the jailbreak if it gets stuck on PongoOS booting. If palera1n-c is stuck, press `CTRL + C` and type `exit` to go back into palen1x_menu, and rerun palera1n (make sure you don't force reboot, if you do you may need to rerun this process).

- On `A11`, **you must disable your passcode while in the jailbroken state** (on iOS 16, you need to reset your device before proceeding with palera1n-c on `A11`).

# Information
**Make an [iCloud/iTunes backup](https://support.apple.com/en-us/HT203977) before using, so that you can go back if something goes wrong**.

- ### Downloads for palen1x can be found [here](https://cdn.nickchan.lol/palera1n/artifacts/palen1x/).

- ### Guide for palen1x can be found [here](https://ios.cfw.guide/using-palen1x/).

# Building palen1x
To change the version of palen1x, either change `version` file, or manually specify it with `./build.sh`.

Execute these commands on a Debian-based system.

```sh
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
- [ElliesSurviving](https://github.com/ElliesSurviving) and [Classy Car](https://www.reddit.com/user/Hunter_Ware) for testing palen1x on `A9-` devices.
- [Everyone else who contributed to palen1x](https://github.com/palera1n/palen1x/graphs/contributors) & [palera1n-c](https://github.com/palera1n/palera1n-c/graphs/contributors)

<br>
<p align="center">
Thank you so much to our Patreons that make the future development possible! You may sub <a href="https://patreon.com/palera1n">here</a>, if you'd like to.</br>
</p>
<p align="center">
<a href="https://github.com/samh06"><img width=64 src="https://user-images.githubusercontent.com/18669106/206333607-881d7ca1-f3bf-4e18-b620-25de0c527315.png"></img></a>
<a href="https://havoc.app"><img width=64 src="https://docs.havoc.app/img/standard_icon.png"></img></a>
<a href="https://twitter.com/yyyyyy_public"><img width=64 src="https://cdn.discordapp.com/attachments/1054239098006683688/1072587455779328040/image.png?size=400"></img></a>
<a href="https://twitter.com/0xSp00kyb0t"><img width=64 src="https://pbs.twimg.com/profile_images/1603601553226620935/1t4yD1bD_400x400.jpg"></img></a>
<a href="https://chariz.com"><img width=64 src="https://chariz.com/img/favicon.png"></img></a>
<a href="https://twitter.com/stars6220"><img width=64 src="https://pbs.twimg.com/profile_images/1621062976982728706/pWVZQ-NO_400x400.jpg"></img></a>
<a href="https://github.com/beast9265"><img width=64 src="https://avatars.githubusercontent.com/u/79794946?v=4"></img></a>
<a href="https://twitter.com/0x7FF7"><img width=64 src="https://pbs.twimg.com/profile_images/1616888462665306113/AsjJvtyt_400x400.jpg"></img></a>
<a href="https://sideloadly.io/"><img width=64 src="https://sideloadly.io/icon.png"></img></a>
<a href="https://blog.stevesec.com/"><img width=64  src="https://blog.stevesec.com/img/avatar.jpg"></img></a>
</p>
