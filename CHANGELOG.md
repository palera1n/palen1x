# Changelog

## 1.0.5
- Fully switch to an Alpine-based distribution for smaller `.iso` size 

`145~ MB` -> `49~ MB` uncompressed

`88~ MB` -> `26 MB` compressed

- Include ~~`iProxy`~~ `inetcat` bin, so `libimobiledevice` doesn't need to be installed
- Fixed `*_logos` not being identified in scripts
- Fixed `Shell` not working from palen1x_menu
- Added debug information when running palera1n-c, to diagnose user issues more reliably.

## 1.0.4
- Added `Switch` option to palera1n_menu, making you able to switch from and to rootless or rootful.
- Added `Jailbreak Type:` to palera1n_menu
- Renamed bootstrap script to include rootless in it
- Added `Serial=3` to palera1n_options

## 1.0.3
- Seperate bootstrap command for rootless & rootful
- Bump version for fixed rootless loader
- Added `CHANGELOG.md`
- Removed `move.sh`, no longer using parallels for building

## 1.0.2 - Final
- Added bootstrap command, only accessible through `Shell`
- Removed bootstrap option in palen1x_menu

## 1.0.1
- Made palera1n-c bins downloaded from nickchan.lol instead of manual links
- Fixed i686 build
- Changed TUI colors

## 1.0.0
- Made GH repo
