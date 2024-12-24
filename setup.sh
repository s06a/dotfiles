#!/usr/bin/env bash

# ========================
# Setup Script for Vim and Tmux Environment
# ========================

# ========================
# Variables
# ========================
NERD_FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Hack.zip"
NERD_FONT_DIR="$HOME/.local/share/fonts"
PLUG_URL="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
TMUX_PLUGIN_REPO="https://github.com/tmux-plugins/tpm"
TMUX_CONF_SOURCE="tmux.conf"
TMUX_CONF_DEST="$HOME/.tmux.conf"
VIMRC_SOURCE="vimrc"
VIMRC_DEST="$HOME/.vimrc"
BACKUP_VIMRC="$VIMRC_DEST.bk"
BACKUP_TMUX="$TMUX_CONF_DEST.bk"

# ========================
# Dependency Checks
# ========================
echo "Checking dependencies..."
for cmd in wget curl unzip git; do
  if ! command -v $cmd >/dev/null 2>&1; then
    echo "Error: $cmd is not installed. Please install it and re-run this script."
    exit 1
  fi
done

# ========================
# Download and Install Nerd Font
# ========================
echo "Downloading and installing Nerd Font..."
if wget -q "$NERD_FONT_URL" -O Hack.zip; then
  unzip -q Hack.zip -d Hack
  mkdir -p "$NERD_FONT_DIR"
  mv Hack/*.ttf "$NERD_FONT_DIR/"
  fc-cache -fv > /dev/null 2>&1
  rm -rf Hack Hack.zip
  echo "Nerd Font installed successfully."
else
  echo "Error: Failed to download Nerd Font. Check your internet connection."
  exit 1
fi

# ========================
# Backup and Replace .vimrc
# ========================
if [ -f "$VIMRC_DEST" ]; then
  cp "$VIMRC_DEST" "$BACKUP_VIMRC"
  echo "Existing .vimrc backed up to $BACKUP_VIMRC."
fi
if ! cmp -s "$VIMRC_SOURCE" "$VIMRC_DEST"; then
  cp "$VIMRC_SOURCE" "$VIMRC_DEST"
  echo ".vimrc updated successfully."
else
  echo ".vimrc is already up to date."
fi

# ========================
# Install vim-plug
# ========================
echo "Checking and installing vim-plug..."
if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
  curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs "$PLUG_URL"
  echo "vim-plug installed successfully."
else
  echo "vim-plug is already installed."
fi

# ========================
# Install Vim Plugins
# ========================
echo "Installing Vim plugins..."
vim -E -s -u "$VIMRC_DEST" +PlugInstall +qall
echo "Vim plugins installed successfully."

# ========================
# Tmux Configuration
# ========================
if [ -f "$TMUX_CONF_DEST" ]; then
  cp "$TMUX_CONF_DEST" "$BACKUP_TMUX"
  echo "Existing .tmux.conf backed up to $BACKUP_TMUX."
fi
if ! cmp -s "$TMUX_CONF_SOURCE" "$TMUX_CONF_DEST"; then
  cp "$TMUX_CONF_SOURCE" "$TMUX_CONF_DEST"
  echo ".tmux.conf updated successfully."
else
  echo ".tmux.conf is already up to date."
fi

# ========================
# Tmux Plugin Manager
# ========================
echo "Checking and installing Tmux Plugin Manager..."
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  git clone "$TMUX_PLUGIN_REPO" "$HOME/.tmux/plugins/tpm"
  echo "Tmux Plugin Manager installed successfully."
else
  echo "Tmux Plugin Manager is already installed."
fi

# ========================
# Completion Message
# ========================
echo "Setup complete. Please restart your terminal to apply changes."
