#!/bin/bash

set -o pipefail 

####
##	Fedora Workstation setup script.
##	Made by Sanket D (sanket.dm@outlook.com), for ASUS X556UR.
##	Special thanks to Tobias and Chris Marts for some of the tweaks included.
##	To run, type "sh /path/to/fed.sh" in terminal.
####

#### Enable RPMfusion repos
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y -y
sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y -y

#### Install flatpak
sudo dnf in flatpak -y
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

#### Update the system
sudo dnf update -y --refresh

#### Tainted Repos
## Update the system first. This repo contains non free contains non FOSS software and hardware drivers.
sudo dnf upgrade --refresh
sudo dnf groupupdate core
sudo dnf install -y rpmfusion-free-release-tainted
sudo dnf install -y rpmfusion-nonfree-release-tainted 
sudo dnf install -y dnf-plugins-core
sudo dnf install -y *-firmware

#### Install from flatpak
flatpak install flathub com.spotify.Client -y -y
flatpak install flathub com.sublimetext.three -y -y

#### Install basic apps
sudo dnf install -y\
	qbittorrent\
	neofetch\
	ffmpeg\
	lm_sensors\
	evolution\
	drawing\
	wine\
	winetricks\
	brasero\
	gparted\
	gimp\
	obs-studio\
	vlc\
	x265\
	intel-media-driver\
	libva-intel-driver\
	dnf-plugin-system-upgrade\
	dnf-plugins-core\
	android-tools\
	unzip\
	unrar\
	p7zip\
	p7zip-plugins\
	gnome-tweak-tool\
	
#### If you use dropbox
sudo dnf -y install dropbox nautilus-dropbox

#### Remove unnecessary apps
sudo dnf remove -y\
	yelp\
	gnome-software\
	gnome-boxes\
	gnome-weather\
	gnome-shell-extension-background-logo\
	gnome-user-docs\
	gnome-maps\
	totem\
	gnome-photos\
	abrt\
	gnome-logs\
	
#### Install multimedia propriatery codecs
sudo dnf install -y libdvdcss
sudo dnf install -y gstreamer1-plugins-{bad-\*,good-\*,ugly-\*,base} gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel ffmpeg gstreamer-ffmpeg
sudo dnf install -y lame\* --exclude=lame-devel
sudo dnf -y groupupdate sound-and-video

#### Firefox openh264 support
#sudo dnf config-manager --set-enabled fedora-cisco-openh264
#sudo dnf install -y gstreamer1-plugin-openh264 mozilla-openh264
#sudo dnf group upgrade --with-optional Multimedia

#### Install google-chrome (direct method)
sudo dnf in liberation-fonts -y
wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
sudo rpm -i google-chrome-stable_current_x86_64.rpm
rm google-chrome-stable_current_x86_64.rpm

#### Install google chrome (using repos)
#sudo dnf install fedora-workstation-repositories -y
#sudo dnf config-manager --set-enabled google-chrome
#sudo dnf install google-chrome-stable -y

#### Install shotwell for better photo management
#sudo dnf insall shotwell -y
#sudo dnf remove eog -y
#gsettings set org.gnome.shotwell.preferences.ui:/org/gnome/shotwell/profiles/preferences/ui/ display-map-widget false

#### Configure zsh
#sudo dnf in zsh zsh-syntax-highlighting zsh-autosuggestions -y
#sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
#sudo chsh -s $(which zsh) prometheus ##prometheus is username in my case
#sudo chsh -s $(which zsh) ##for the root 
#source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh	

#### Install Microsoft Fonts
sudo dnf install curl cabextract xorg-x11-font-utils fontconfig -y
sudo rpm -i https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm

#### Improve battery life using tuned
sudo dnf in tuned -y
sudo tuned-adm profile powersave

#### Some Kernel/Usability Improvements
sudo tee -a /etc/sysctl.d/40-max-user-watches.conf > /dev/null  <<EOF
fs.inotify.max_user_watches=524288
EOF
sudo tee -a /etc/sysctl.d/99-network.conf > /dev/null  <<EOF
net.ipv4.ip_forward=0
net.ipv4.tcp_ecn=1
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
EOF

#### Change swappiness
sudo tee -a /etc/sysctl.d/99-swappiness.conf > /dev/null  <<EOF
vm.swappiness=10
EOF

#### Disable Modular repos
sudo sed -i 's/enabled=1/enabled=0/g' /etc/yum.repos.d/fedora-updates-modular.repo
sudo sed -i 's/enabled=1/enabled=0/g' /etc/yum.repos.d/fedora-modular.repo

#### Disable Testing repos
sudo sed -i 's/enabled=1/enabled=0/g' /etc/yum.repos.d/fedora-updates-testing-modular.repo
sudo sed -i 's/enabled=1/enabled=0/g' /etc/yum.repos.d/rpmfusion-free-updates-testing.repo

#### Installing Rpmfusion makes this obsolete
sudo sed -i 's/enabled=1/enabled=0/g' /etc/yum.repos.d/fedora-cisco-openh264.repo

#### Disable Machine Counting for all repos
sudo sed -i 's/countme=1/countme=0/g' /etc/yum.repos.d/*

#### Improve audio quality by modifying pulse values
tee -a ~/.config/pulse/daemon.conf > /dev/null <<EOF
default-sample-format = float32le
default-sample-rate = 48000
alternate-sample-rate = 44100
resample-method = copy
high-priority = yes
nice-level = -16
realtime-scheduling = no
realtime-priority = 9
rlimit-rtprio = 9
avoid-resampling = yes
EOF

#### Default fallback for pulse
sudo tee -a /etc/asound.conf > /dev/null <<EOF
# Use PulseAudio plugin hw
pcm.!default {
   type plug
   slave.pcm hw
}
EOF

#### Show the list of USB devices to identify the one you want to enable / disable:
## grep . /sys/bus/usb/devices/*/product

#### Check wake up status of all USB devices:
## grep . /sys/bus/usb/devices/*/power/wakeup

<<LONG_COMMENT1

#### Usb wakeup disabler (for usb 1-2)
sudo tee -a /usr/bin/usb-wkp.sh > /dev/null <<EOF
#!/bin/bash
sudo echo disabled > /sys/bus/usb/devices/1-2/power/wakeup
EOF
sudo chmod +x /usr/bin/usb-wkp.sh

sudo tee -a /etc/systemd/system/usb-wkp.service > /dev/null <<EOF
[Unit]																							
Description=Usb Wakeup Disabler For Port 1-2.

[Service]
Type=simple 
ExecStart=/bin/bash /usr/bin/usb-wkp.sh 

[Install]
WantedBy=multi-user.target 
EOF
sudo chmod 644 /etc/systemd/system/usb-wkp.service
sudo systemctl enable --now usb-wkp.service
sudo systemctl start usb-wkp.service

LONG_COMMENT1

#### Powerline prompt for bash 
sudo dnf in powerline -y
tee -a ~/.bashrc > /dev/null <<EOF
# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

if [ -f `which powerline-daemon` ]; then
  powerline-daemon -q
  POWERLINE_BASH_CONTINUATION=1
  POWERLINE_BASH_SELECT=1
  . /usr/share/powerline/bash/powerline.sh
fi
EOF

#### DNF better defaults
sudo tee -a /etc/dnf/dnf.conf > /dev/null <<EOF
[main]
gpgcheck=1
installonly_limit=3
clean_requirements_on_remove=True
best=False
skip_if_unavailable=True
fastestmirror=1
deltarpm=true
defaultyes=true
max_parallel_downloads=10
EOF

#### Disable services for faster boot
sudo systemctl mask NetworkManager-wait-online.service
sudo systemctl mask dnf-makecache.timer

#### Disable plymouth for faster boot
sudo sed -i 's/quiet/quiet rd.plymouth=0 plymouth.enable=0/g' /etc/default/grub
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg

#### Settings can be found out using "gsettings list-recursively | grep xxxxxx"

## Nautilus Usability
gsettings set org.gnome.nautilus.icon-view default-zoom-level 'standard'
gsettings set org.gnome.nautilus.preferences executable-text-activation 'ask'
gsettings set org.gtk.Settings.FileChooser sort-directories-first true

## Gnome Night Light 
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-automatic true
gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-to 6.0
gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-from 20.0
gsettings set org.gnome.settings-daemon.plugins.color night-light-temperature uint32 4700

## General Usability Improvements 
gsettings set org.gnome.desktop.calendar show-weekdate true
gsettings set org.gnome.desktop.interface clock-show-date true
gsettings set org.gnome.desktop.interface clock-show-weekday true
gsettings set org.gnome.mutter center-new-windows true
gsettings set org.gnome.desktop.interface show-battery-percentage true
gsettings set org.gnome.desktop.peripherals.touchpad middle-click-emulation true
gsettings set org.gnome.gnome-system-monitor cpu-smooth-graph false

## Settings "Better Settings"
gsettings set org.gnome.desktop.privacy recent-files-max-age -1
gsettings set org.gnome.desktop.privacy remove-old-temp-files true
gsettings set org.gnome.desktop.privacy send-software-usage-stats false
gsettings set org.gnome.desktop.privacy old-files-age uint32 7
gsettings set org.gnome.desktop.privacy remember-recent-files false
gsettings set org.gnome.desktop.privacy report-technical-problems false
gsettings set org.gnome.desktop.privacy remove-old-trash-files true
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-automatic true
gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-to 6.0
gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-from 20.0
gsettings set org.gnome.desktop.peripherals.touchpad speed 0.055
gsettings set org.gnome.settings-daemon.plugins.power power-button-action 'interactive'
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'suspend'
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'suspend'
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout 1800
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 3600

## Favourite Apps
gsettings set org.gnome.shell favorite-apps ['google-chrome.desktop', 'org.gnome.Nautilus.desktop', 'rhythmbox.desktop', 'com.spotify.Client.desktop', 'gnome-control-center.desktop', 'org.gnome.Evolution.desktop']

## Gnome power-manager "Better Settings"
gsettings set org.gnome.power-manager info-stats-graph-points false
gsettings set org.gnome.power-manager info-stats-graph-smooth false
gsettings set org.gnome.power-manager info-history-graph-points false
gsettings set org.gnome.power-manager info-history-graph-smooth false

## Gedit gsettings backup
gsettings set org.gnome.gedit.preferences.editor use-default-font false
gsettings set org.gnome.gedit.preferences.editor editor-font 'Monospace 12'

## Make rhythmbox somewhat better
sudo dnf in rhythmbox-alternative-toolbar -y
gsettings set org.gnome.rhythmbox.plugins active-plugins ['iradio', 'notification', 'mmkeys', 'mpris', 'mtpdevice', 'power-manager', 'daap', 'rb', 'alternative-toolbar', 'dbus-media-server', 'audioscrobbler', 'audiocd', 'cd-recorder', 'artsearch', 'android', 'generic-player']
gsettings set org.gnome.rhythmbox.plugins.alternative_toolbar enhanced-sidebar false
gsettings set org.gnome.rhythmbox.plugins.alternative_toolbar volume-control true

#### Clean some leftover messes
#sudo dnf up clean all -y
sudo dnf distro-sync --refresh --best --allowerasing -y
sudo dnf autoremove -y --refresh
flatpak update -y
flatpak uninstall --unused

#### Reboot and apply all changes.
echo "Script Completed. Please Reboot. Enjoy your Fedora install :)" && exit 0


#### Some additional post-install tweaks 
#### These are not part of the script, but can be applied post the install

#### Chrome flags for better browsing
#enable-mark-http-as
#enable-lazy-image-loading
#shared-clipboard-receiver
#shared-clipboard-ui
#global-media-control
#native-filesystem-api
#ignore-gpu-blacklist
#enable-reader-mode
#enable-webrtc-hide-local-ips-with-mdns
#smooth-scrolling
#enable-quic
#focus-mode
#omnibox-tab-switch-suggestions
#enable-parallel-downloading

#### Firefox flags
#gfx.webrender.all
#layers.acceleration.force-enabled

#### System upgrade for fedora
#sudo dnf upgrade --refresh
#sudo dnf install dnf-plugin-system-upgrade
#sudo dnf system-upgrade download --refresh --releasever=XX --allowerasing --best
#sudo dnf system-upgrade reboot

#### upgrade instructions
#sudo dnf upgrade --refresh
#sudo dnf install dnf-plugin-system-upgrade
#sudo dnf upgrade --best --refresh --allowerasing
#sudo dnf distro-sync --best --refresh --allowerasing
#sudo dnf system-upgrade download --releasever=31 --best --refresh --allowerasing
#sudo dnf system-upgrade reboot
#After the reboot:
#sudo dnf distro-sync --best --refresh --allowerasing

#### manage repos
#sudo dnf config-manager --set-disabled <repository>
#sudo dnf config-manager --set-enabled <repository>
