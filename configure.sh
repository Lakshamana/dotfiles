# Installs minimal setup packages for artix (w/ openrc) + i3 workstation
# author: Lakshamana

#!/bin/bash

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
      git clone --depth=1 https://github.com/Lakshamana/iosevka-docker.git ~/.iosevka-custom
      cd ~/.iosevka-custom

      # build iosevka docker image and run, extract iosevka-custom ttf files
      docker build -t iosevka_build . -f Dockerfile
      docker run -e -it -v $(pwd)/build:/build iosevka_build ttf::iosevka-custom

      # copy files to fonts folder
      cp -r build/dist/* /usr/share/fonts/
      fc-cache
      cd $HOME
}

# Main installation starts here...
log 'going to $HOME directory..'
cd $HOME

log 'installing necessary packages...'
sudo pacman -Sy \
      xorg \
      mesa \
      maim \
      python \
      xclip \
      base-devel \
      zsh \
      curl \
      kitty \
      the_silver_searcher \
      ripgrep \
      zathura \
      zathura-pdf-mupdf \
      neovim \
      vim \
      chezmoi \
      i3-gaps \
      i3blocks \
      i3exit \
      i3lock \
      i3status \
      pavucontrol \
      docker \
      docker-compose

log 'downloading oh-my-zsh + zplug...'
# setup zsh (ohmyzsh + zplug + config)
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
log 'updated zsh conf. Will restart at the end...'

log 'downloading and installing yay...'
# install yay
cd /opt
sudo git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si
cd $HOME # go back to previous dir

log 'updating mirrorlist...'
yay -Sy rankmirrors

rankmirrors -v -n 5 /etc/pacman.d/mirrorlist.pacnew | tee /etc/pacman.d/mirrorlist
reflector --score 5  --protocol https | tee /etc/pacman.d/mirrorlist-arch
pacman -Sc --noconfirm
pacman -Syu --noconfirm

log 'downloading asdf...'
yay -Sy asdf-vm

# setup asdf
asdf plugin-add nodejs

# install nodejs
asdf install nodejs lts
log 'setup nodejs asdf env'

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

# should I install iosevka-custom font?
prompt_result=`prompt_user "Install iosevka-custom font?" 'y'`
if [[ $prompt_result == 'y' ]]; then install_font; fi

# restart i3
i3-msg restart
log 'just restarted i3...'
