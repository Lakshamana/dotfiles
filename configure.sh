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
      git clone --depth=1 -b feat/iosevka-custom https://github.com/Lakshamana/iosevka-docker.git ~/.iosevka-custom
      cd ~/.iosevka-custom

      log 'building container...'
      # build iosevka docker image and run, extract iosevka-custom ttf files
      docker build -t iosevka_build . -f Dockerfile
      docker run -e -it -v $(pwd):/build iosevka_build ttf::iosevka-custom

      log 'copying font files to fonts folder...'
      # copy files to fonts folder
      sudo cp -r dist/* /usr/share/fonts/
      fc-cache
      cd $HOME
}

# Main installation starts here...
log 'going to $HOME directory..'
cd $HOME

log 'installing chezmoi dotfile manager...'
sudo sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/bin

log 'setup dotfiles with chezmoi...'
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
      i3-gaps \
      i3blocks \
      i3lock \
      i3status \
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
      accountsservice

log 'configuring NetworkManager...'
sudo rc-update add NetworkManager default
sudo rc-service NetworkManager start

log 'configuring ntpd...'
sudo rc-update add ntpd default
sudo rc-service ntpd start

log 'configuring docker for non root users...'
sudo rc-update add docker default
sudo rc-service docker start

log 'enable bluetooth service by default...'
sudo rc-update add bluetoothd default
sudo rc-service bluetoothd start

log 'downloading oh-my-zsh + zplug...'
# setup zsh (ohmyzsh + zplug + config)
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
log 'updated zsh conf. Will restart at the end...'

log 'downloading and installing yay...'
# install yay
if test -d /opt; then cd /opt; else sudo mkdir /opt && cd /opt; fi
sudo git clone https://aur.archlinux.org/yay.git
cd yay
sudo chown -R arjuna:arjuna .
makepkg -si
cd $HOME # go back to previous dir

log 'downloading aur packages...'
yay -Sy \
      asdf-vm \
      xaskpass \
      clipcatd \
      pa-applet \
      nerd-fonts-dejavu-complete \
      ttf-nerd-fonts-symbols-2048-em \
      ttf-nerd-fonts-symbols-common \
      powerline-console-fonts \
      picom-git

log 'adding temporarily asdf to $PATH'
export PATH=$PATH:/opt/asdf-vm/bin

# setup asdf
asdf plugin-add nodejs

# install nodejs
log 'setup nodejs asdf env...'
asdf install nodejs lts
asdf global nodejs lts
asdf reshim nodejs

log 'install neovim python support...'
pip install neovim

log 'install i3ipc module...'
pip install i3ipc

log 'downloading vim-plug now...'
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
nvim -c ':source ~/.config/nvim/init.vim'
nvim -c ':PlugInstall'
log 'nvim plugins successfully installed...'

# check npm
npm -v
if [ $? -eq 0 ]; then
      sudo npm i -g pnpm
fi

zplug install

# should I install iosevka-custom font?
prompt_result=`prompt_user "Install iosevka-custom font?" 'y'`
if [[ $prompt_result == 'y' ]]; then install_font; fi
