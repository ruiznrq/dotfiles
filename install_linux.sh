#!/bin/bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
echo "Current directory is: $CURRENT_DIR"


# Install fonts
HACKNF="/usr/share/fonts/truetype/Hack Nerd Font Linux/"
if [ ! -d "$HACKNF" ]; then
	echo "Installing Hack NF..."
	sudo cp -r "$CURRENT_DIR/fonts/Hack Nerd Font Linux/" "/usr/share/fonts/truetype/"
fi

# Install Alacritty config
ALACRITTY="$HOME/.config/alacritty"
rm -rf $ALACRITTY
ln -s "$CURRENT_DIR/alacritty linux" $ALACRITTY

# Install NeoVim config
NEOVIM="$HOME/.config/nvim"
rm -rf $NEOVIM
ln -s "$CURRENT_DIR/nvim" $NEOVIM


# Install neovim package manager
rm -rf "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/start/paq-nvim
git clone --depth=1 https://github.com/savq/paq-nvim.git \
    "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/start/paq-nvim

