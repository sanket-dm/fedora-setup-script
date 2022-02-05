**Fedora 33 Workstation Setup Script**

Special thanks to Tobias's for some of the tweaks.

This script will add essential and required features to a freshly installed Fedora 32 installation.

Many of the functionalities will be added, but please take a look and comment/uncomment statements according to your requirements.

<p>&nbsp;</p>

Things implemented/needed to be done:

- [x] Enabling RPMfusion repos.
- [x] Enabling flatpak repos.
- [x] Install some basic needed apps from flatpak and RPMfusion repos.
- [x] Enable tainted repos and install propriatery drivers (if any).
- [x] Remove some of the un-required apps (which slows the system down and are mostly unnecessary).
- [x] Install multimedia propriatery codecs.
- [x] Enable firefox openh264 codec support. (using cisco copr repo).
- [x] Remove `gnome-software`. Its quite laggy and unreliable.
- [x] Download and install `google-chrome-stable` from the official website directly.
- [x] Install MS Truetype fonts. 
- [x] Some kernel/usability improvements.
- [x] Change default `swappiness` value. Having 8+ GB of RAM makes the high swappiness value unnecessary.
- [x] Disable Modular Repos.
- [x] Disable Testing Repos.
- [x] Disable `fedora-cisco-openh264` COPR Repo. 
- [x] Change Pulse Audio parameters to get a better sound profile.
- [x] Set ALSA default fallback for pulse.
- [x] `powerline` prompt for bash. Looks cool!
- [x] Set better `dnf` default options.
- [x] Mask services for faster boot times.
- [x] Much better settings for GNOME apps, rather than the default ones.
- [x] Clean up some leftover messes.
- [x] Disable plymouth for faster boot.

- [ ] USB wakeup disabler. Useful especially for logitech devices. (Under work for automation. Needs to be manually enabled by commenting out `LONG_COMMENT1`.


Show the list of USB devices to identify the one you want to enable or disable:
```
grep . /sys/bus/usb/devices/*/product
```

Check wake up status of all USB devices and delect the one which shows `enabled`:
```
grep . /sys/bus/usb/devices/*/power/wakeup
```

<p>&nbsp;</p>

Some additional post-install tweaks .
These are not part of the script, but can be applied post the install.

Chrome flags for better browsing
```
enable-mark-http-as
enable-lazy-image-loading
shared-clipboard-receiver
shared-clipboard-ui
global-media-control
native-filesystem-api
ignore-gpu-blacklist
enable-reader-mode
enable-webrtc-hide-local-ips-with-mdns
smooth-scrolling
enable-quic
focus-mode
omnibox-tab-switch-suggestions
enable-parallel-downloading
mute-notifications-during-screen-share
enable-tab-search
ermission-chip
```

Firefox flags
```
gfx.webrender.all
layers.acceleration.force-enabled
```

System upgrade for fedora
```
sudo dnf upgrade --refresh
sudo dnf install dnf-plugin-system-upgrade
sudo dnf system-upgrade download --refresh --releasever=XX --allowerasing --best
sudo dnf system-upgrade reboot
```

Upgrade instructions
```
sudo dnf upgrade --refresh
sudo dnf install dnf-plugin-system-upgrade
sudo dnf upgrade --best --refresh --allowerasing
sudo dnf distro-sync --best --refresh --allowerasing
sudo dnf system-upgrade download --releasever=31 --best --refresh --allowerasing
sudo dnf system-upgrade reboot
After the reboot:
sudo dnf distro-sync --best --refresh --allowerasing
```

Managing repos
```
sudo dnf config-manager --set-disabled <repository>
sudo dnf config-manager --set-enabled <repository>
```

Enable hardware acceleration in GNOME-Web (Epiphany)
```
gsettings set org.gnome.Epiphany.web:/org/gnome/epiphany/web/ hardware-acceleration-policy 'always'
```
