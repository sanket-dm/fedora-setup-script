**Fedora 32 Workstation Setup Script**

Special thanks to Tobias's script.

This script will add essential and required features to a freshly installed Fedora 32 installation.

Many of the functionalities will be added, but please take a look and modifty the parameters according to your requirements.

Things implemented/needed to be done:

[x] Enabling RPMfusion repos
[x] Enabling flatpak repos
[x] Install some basic needed apps from flatpak and RPMfusion repos
[x] Remove some of the un-required apps (which slows the system down and are mostly unnecessary)
[x] Remove `gnome-software`. Trust me, it is one of the worst ways to install anything on the system.
[x] Download and install `google-chrome-stable` from the official website directly.
[x] Install MS Truetype fonts. 
[x] Some kernel/usability improvements.
[x] Change default `swappiness` value. Having 8+ GB of RAM makes the high swappiness value unnecessary.
[x] Disable Modular Repos.
[x] Disable Testing Repos.
[x] Disable `fedora-cisco-openh264` COPR Repo. 
[x] Change Pulse Audio parameters to get a better sound profile.
[x] Set ALSA default fallback for pulse.
[x] USB wakeup disabler. Useful especially for logitech devices.
[x] `powerline` prompt for bash. Looks cool!
[x] Set better `dnf` default options.
[x] Mask services for faster boot times.
[] Disable plymouth for faster boot.
[x] Much better settings for GNOME apps, rather than the default ones.
[x] Clean up some leftover messes.


