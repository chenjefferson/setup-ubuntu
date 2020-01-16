# automated tool to install and set up the following
# tested on clean install of Ubuntu 18.04. your mileage may vary
# Jefferson Chen

STUDY_TOOLS="anki"
PROGRAMMING_TOOLS="emacs vim git"
POWER_MANAGEMENT="tlp"
DESKTOP="dconf-editor gnome-tweaks gnome-shell-extensions"
DEPS="python3-distutils"

SNAPS="discord spotify"

REMOVE="gnome-shell-extensions-ubuntu-dock"

UNSNAP="gnome-calculator gnome-characters gnome-logs gnome-system-monitor" # install non-snap versions

# whether to automatically run everything
Y=true

if [ ! $Y ]; then
    echo -n "press <enter> to UPDATE APT:"
    read
fi
sudo apt update -y -q; sudo apt dist-upgrade -y -q
if [ $? -ne 0 ]; then
    echo "error: UPDATE APT process failed"
    echo -n "press <enter> to continue or ^C to exit:"
    read
fi

if [ ! $Y ]; then
    echo -n "press <enter> to install DEFAULT PACKAGES:"
    read
fi
sudo apt install -y -q $PROGRAMMING_TOOLS $STUDY_TOOLS $POWER_MANAGEMENT $DESKTOP $DEPS
if [ $? -ne 0 ]; then
    echo "error: install DEFAULT PACKAGES process failed"
    echo -n "press <enter> to continue or ^C to exit:"
    read
fi

if [ ! $Y ]; then
    echo -n "press <enter> to install SNAPS:"
    read
fi
sudo snap install $SNAPS
if [ $? -ne 0 ]; then
    echo "error: install SNAPS process failed"
    echo -n "press <enter> to continue or ^C to exit:"
    read
fi

if [ ! $Y ]; then
    echo -n "press <enter> to install POP THEME:"
    read
fi
sudo add-apt-repository -y ppa:system76/pop
sudo apt update -y -q
sudo apt install -y -q pop-theme pop-wallpapers
if [ $? -ne 0 ]; then
    echo "error: install POP THEME failed"
    echo -n "press <enter> to continue or ^C to exit:"
    read
fi

if [ ! $Y ]; then
    echo -n "press <enter> to SET GNOME THEME:"
    read
fi
gnome-shell-extension-tool -e "user-theme@gnome-shell-extensions.gcampax.github.com"
gnome-shell-extension-tool -e "alternate-tab@gnome-shell-extensions.gcampax.github.com"
gsettings set org.gnome.desktop.interface gtk-theme "Pop"
gsettings set org.gnome.shell.extensions.user-theme name "Pop"
gsettings set org.gnome.desktop.interface icon-theme "Pop"
gsettings set org.gnome.desktop.interface cursor-theme "Pop"
gsettings set org.gnome.desktop.wm.preferences titlebar-font "Fira Sans Semi-Bold 10"
gsettings set org.gnome.desktop.interface font-name "Fira Sans Semi-Light 10"
gsettings set org.gnome.desktop.interface document-font-name "Roboto Slab 11"
gsettings set org.gnome.desktop.interface monospace-font-name "Fira Mono 11"
gsettings set org.gnome.desktop.background picture-uri "file:///usr/share/backgrounds/pop/benjamin-voros-250200.jpg"
gsettings set org.gnome.desktop.screensaver picture-uri "file:///usr/share/backgrounds/pop/ahmadreza-sajadi-10140-edit.jpg"
gsettings set org.gnome.mutter dynamic-workspaces false
gsettings set org.gnome.desktop.wm.preferences num-workspaces 7
gsettings set org.gnome.Terminal.Legacy.Settings default-show-menubar false

if [ ! $Y ]; then
    echo -n "press <enter> to SET GNOME OPTIONS:"
    read
fi
gsettings set org.gnome.desktop.interface clock-show-date true
gsettings set org.gnome.desktop.calendar show-weekdate true
gsettings set org.gnome.desktop.background show-desktop-icons false
gsettings set org.gnome.desktop.input-sources xkb-options "['caps:ctrl_modifier']" # set caps lock to ctrl
gsettings set org.gnome.desktop.privacy remember-recent-files false
gsettings set org.gnome.desktop.media-handling autorun-never true
gsettings set org.gnome.shell favorite-apps "[]"
gsettings set org.gnome.shell app-picker-view 1

if [ ! $Y ]; then
    echo -n "press <enter> to REMOVE UNWANTED PACKAGES:"
    read
fi
sudo apt remove $REMOVE

if [ ! $Y ]; then
    echo -n "press <enter> to UNSNAP PACKAGES:"
    read
fi
sudo snap remove $UNSNAP
sudo apt install -y -q $UNSNAP

if [ ! $Y ]; then
    echo -n "press <enter> to SET PLYMOUTH AND GRUB THEME:"
    read
fi
sudo sed -i 's/44,0,30,0/0,0,0 /' /usr/share/plymouth/themes/default.grub
sudo sed -i 's/quiet splash/quiet/' /etc/default/grub
sudo update-grub

if [ ! $Y ]; then
    echo -n "press <enter> to DOWNLOAD AND SET CONFIG FILES:"
    read
fi
pushd $PWD
cd ~
git clone http://github.com/chenjefferson/.emacs.d.git
git clone http://github.com/chenjefferson/.dotfiles.git
cd .dotfiles
./init.sh
popd
