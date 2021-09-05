#!/bin/bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
echo "Current directory is: $CURRENT_DIR"

# Install Alacritty config
ALACRITTY="$HOME/.config/alacritty"
rm -rf $ALACRITTY
ln -s "$CURRENT_DIR/alacritty" $ALACRITTY

# Install NeoVim config
NEOVIM="$HOME/.config/nvim"
rm -rf $NEOVIM
ln -s "$CURRENT_DIR/nvim" $NEOVIM
