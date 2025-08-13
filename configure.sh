# Installs minimal setup packages for artix (w/ openrc) + i3 workstation
# author: Lakshamana

#!/bin/bash

# set variables
GITHUB_USERNAME='Lakshamana'

# util functions
show_usage() {
      echo 'Installs minimal setup needed packages and configs'
      echo
      echo 'usage: install [OPTIONS]'
      echo 'with OPTIONS being one of below'
      echo '--help -h: shows this help'
      echo '--verbose -v: execute verbose log commands'
      echo
}

# show help
_help_mode=`echo $@ | grep -e '-h\|--help'`
if [[ $_help_mode != '' ]]; then
      show_usage
      exit 0
fi

# allow verbose mode by running -v or --verbose
_verbose_mode=`echo $@ | grep -e '-v\|--verbose'`
log() {
      if [[  $_verbose_mode != ''  ]]; then
            echo -ne $1
            echo
      fi
}

# prompt user for yes/no question and return choice
# 1) Question: string
# 2) default value: y/n (string)
_prompt_user() {
      default_value=$2
      prompt_choice='y/n'

      if [[ $default_value == 'y' ]]
      then
            prompt_choice='Y/n'
      elif [[ $default_value == 'n' ]]
      then
            prompt_choice='y/N'
      fi

      read -p "$1 [$prompt_choice]: " choice

      valid_choices=('y', 'n')

      if [[ $choice == '' ]]
      then
            echo $default_value
      fi

      if ! [[ ${valid_choices[*]} =~ $choice ]]
      then
            _prompt_user "$1" "$2"
      fi

      echo $choice
}

# wrapper function for _prompt_user
prompt_user() {
      echo `_prompt_user "$1" "$2" | head -n1 | awk '{print $1}'`
}

# install iosevka font
install_font() {
      log 'cloning iosevka font repository...'
      git clone --depth 1 https://github.com/be5invis/Iosevka.git ~/.iosevka-custom
      cd ~/.iosevka-custom

      log 'building...'
      # build iosevka docker image and run, extract iosevka-custom ttf files
      npm i
      npm run build -- ttf::IosevkaCustom

      log 'copying font files to fonts directory...'
      sudo cp -r dist/* /usr/share/fonts/
      fc-cache
      cd $HOME
}

# install clipcat
install_clipcat() {
  log 'building clipcat and installing from source code...'

  mkdir -p ~/git/clipcat/
  git clone --branch=main https://github.com/Icelk/clipcat.git ~/git/clipcat/
  cd ~/git/clipcat

  cargo install --path . -F all-bins
  cd $HOME
}

# Main installation starts here...
log 'going to $HOME directory..'
cd $HOME

log 'installing chezmoi dotfile manager...'
sudo sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/bin

log 'setup dotfiles with chezmoi...'
chezmoi init github.com/$GITHUB_USERNAME
chezmoi update -v

log 'installing both artix and arch mirrors...'
sudo cp mirrorlist /etc/pacman.d/mirrorlist
sudo cp mirrorlist-arch /etc/pacman.d/mirrorlist-arch
sudo cp pacman.conf /etc

log 'installing archlinux support...'
sudo pacman -Syu
sudo pacman -S artix-archlinux-support

log 'installing other packages needed...'
sudo pacman -Sy \
      git \
      xorg \
      xorg-xinit \
      xorg-xrandr \
      mesa \
      maim \
      python \
      xclip \
      bitwarden \
      base \
      base-devel \
      zsh \
      curl \
      kitty \
      the_silver_searcher \
      ripgrep \
      zathura \
      zathura-pdf-mupdf \
      neovim \
      pavucontrol \
      docker \
      docker-compose \
      docker-openrc \
      pipewire \
      pipewire-alsa \
      pipewire-pulse \
      wireplumber \
      bluez \
      bluez-libs \
      bluez-openrc \
      bluez-utils \
      networkmanager \
      networkmanager-openrc \
      networkmanager-openvpn \
      network-manager-applet \
      python \
      python-pip \
      dunst \
      libnotify \
      dmenu \
      rofi \
      ttf-terminus-nerd \
      ttf-nerd-fonts-symbols-common \
      rofi-calc \
      polkit \
      ntp \
      ntp-openrc \
      accountsservice \
      rclone \
      fuse \
      fzf \
      nvm \
      lazygit \
      zk \
      protobuf \
      feh

log 'configuring NetworkManager...'
sudo rc-update add NetworkManager default
sudo rc-service NetworkManager start

log 'configuring ntpd...'
sudo rc-update add ntpd default
sudo rc-service ntpd start

log 'configuring docker for non root users...'
sudo rc-update add docker default
sudo rc-service docker start
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

log 'enable bluetooth service by default...'
sudo rc-update add bluetoothd default
sudo rc-service bluetoothd start

log 'downloading oh-my-zsh + zplug...'
# setup zsh (ohmyzsh + zplug + config)
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
log 'updated zsh conf. Will restart at the end...'

# keep .zshrc as is
cat ~/.zshrc.pre-oh-my-zsh > ~/.zshrc

log 'downloading and installing yay...'
if test -d /opt; then cd /opt; else sudo mkdir /opt && cd /opt; fi
sudo git clone https://aur.archlinux.org/yay.git
cd yay
sudo chown -R $USER .
makepkg -si
cd $HOME # go back to previous dir

log 'downloading aur packages...'
yay -Sy \
      xaskpass \
      pa-applet \
      nerd-fonts-dejavu-complete \
      ttf-nerd-fonts-symbols-2048-em \
      ttf-nerd-fonts-symbols-common \
      powerline-console-fonts \
      ttf-fira-code \
      picom-git \
      noise-suppression-for-voice

# reload pipewire
log 'reloading pipewire...'
sudo rc-service pipewire restart

log 'installing clipcat...'
install_clipcat

log 'install neovim python support...'
pip install neovim

# check npm
nvm -v
if [ $? -eq 0 ]; then
  nvm install node
  nvm use node
fi

zplug install

log 'install i3 related packages...'
sudo pacman -Sy \
    i3-gaps \
    i3blocks \
    i3lock \
    i3status

log 'install i3ipc module...'
pip install i3ipc

log 'install brave browser...'
prompt_result=`prompt_user "Install brave browser?" 'y'`
if [[ $prompt_result == 'y' ]] then
  curl -fsS https://dl.brave.com/install.sh | sh
fi

# should I install iosevka-custom font?
prompt_result=`prompt_user "Install iosevka-custom font?" 'y'`
if [[ $prompt_result == 'y' ]]; then install_font; fi

prompt_reboot=`prompt_user "Reboot machine?" 'y'`
if [[ $prompt_reboot == 'y' ]]; then loginctl reboot; fi
