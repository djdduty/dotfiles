# Djdduty dotfiles

## Dependencies

    pacman -S git awesome stow compton rofi feh

Install nerd-fonts-complete and xst from AUR

## Clone this repo

    git clone https://github.com/djdduty/dotfiles.git

## Use stow to symlink config files to ~

    cd dotfiles
    stow -t ~ awesomewm
    stow -t ~ config
    stow -t ~ images

## Update zsh to set xst

    echo "export TERMINAL=/usr/bin/xst" >> ~/.zshrc

