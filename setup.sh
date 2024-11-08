#!/usr/bin/env bash

# Setup script for Vim and Tmux environment

# Variables
NERD_FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Hack.zip"
NERD_FONT_DIR="$HOME/.local/share/fonts"
MONOKAI_REPO="https://github.com/ku1ik/vim-monokai.git"
PLUG_URL="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
TMUX_PLUGIN_REPO="https://github.com/tmux-plugins/tpm"
TMUX_CONF_SOURCE="tmux.conf"
TMUX_CONF_DEST="$HOME/.tmux.conf"
VIMRC_SOURCE="vimrc"
VIMRC_DEST="$HOME/.vimrc"
BACKUP_VIMRC="$VIMRC_DEST.bk"

# Download and install Nerd Font
echo "Downloading and installing Nerd Font..."
wget -q "$NERD_FONT_URL" -O Hack.zip
unzip -q Hack.zip -d Hack
mkdir -p "$NERD_FONT_DIR"
mv Hack/*.ttf "$NERD_FONT_DIR/"
fc-cache -fv > /dev/null 2>&1 # Update font cache
rm -rf Hack Hack.zip

# Setup Vim colors
echo "Setting up Vim color scheme..."
mkdir -p "$HOME/.vim/colors"
if [ ! -f "$HOME/.vim/colors/monokai.vim" ]; then
  git clone "$MONOKAI_REPO"
  cp vim-monokai/colors/monokai.vim "$HOME/.vim/colors/"
  rm -rf vim-monokai
fi

# Backup and replace vimrc
echo "Backing up and replacing .vimrc..."
cp "$VIMRC_DEST" "$BACKUP_VIMRC" # Backup existing vimrc
cp "$VIMRC_SOURCE" "$VIMRC_DEST"

# Install vim-plug if not already installed
echo "Checking and installing vim-plug..."
if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
  curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs "$PLUG_URL"
fi

# Install Vim plugins
echo "Installing Vim plugins..."
vim -E -s -u "$VIMRC_DEST" +PlugInstall +qall

# Tmux configuration
echo "Setting up Tmux configuration..."
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  git clone "$TMUX_PLUGIN_REPO" "$HOME/.tmux/plugins/tpm"
fi
cp "$TMUX_CONF_SOURCE" "$TMUX_CONF_DEST"

# Cleanup and prompt
echo "Tmux configuration updated. Please restart your terminal to apply changes."

