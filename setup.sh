#!/usr/bin/env bash

# ========================
# Setup Script for Vim, Tmux, and Neovim Environment
# ========================

# Variables
NERD_FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Hack.zip"
NERD_FONT_DIR="$HOME/.local/share/fonts"
PLUG_URL="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
TMUX_PLUGIN_REPO="https://github.com/tmux-plugins/tpm"
TMUX_CONF_SOURCE="tmux/.tmux.conf"
TMUX_CONF_DEST="$HOME/.tmux.conf"
VIMRC_SOURCE="vim/.vimrc"
VIMRC_DEST="$HOME/.vimrc"
BACKUP_VIMRC="$VIMRC_DEST.bk"
BACKUP_TMUX="$TMUX_CONF_DEST.bk"
NVIM_LUA_DIR="$HOME/.config/nvim/lua/plugins"

# Functions
check_and_install_vim() {
  if command -v vim >/dev/null 2>&1; then
    echo "Vim is installed: $(vim --version | head -n 1)"
  else
    echo "Vim is not installed. Installing Vim..."
    sudo apt update && sudo apt install vim -y
  fi
}

check_and_install_tmux() {
  if command -v tmux >/dev/null 2>&1; then
    echo "Tmux is installed: $(tmux -V)"
  else
    echo "Tmux is not installed. Installing Tmux..."
    sudo apt update && sudo apt install tmux -y
  fi
}

check_and_install_neovim() {
  if command -v nvim >/dev/null 2>&1; then
    echo "Neovim is installed: $(nvim --version | head -n 1)"
  else
    echo "Neovim is not installed. Installing Neovim..."
    sudo apt update && sudo apt install neovim -y
  fi
}

install_nerd_font() {
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
}

install_go_tools() {
  echo "Installing Go dependencies..."
  GO_PACKAGES=(
    "golang.org/x/tools/gopls@latest"
    "golang.org/x/tools/cmd/goimports@latest"
    "github.com/golangci/golangci-lint/cmd/golangci-lint@latest"
    "github.com/go-delve/delve/cmd/dlv@latest"
  )
  for pkg in "${GO_PACKAGES[@]}"; do
    echo "Installing $pkg..."
    go install "$pkg"
  done

  echo "Verifying installed Go tools..."
  for tool in gopls goimports golangci-lint dlv; do
    if ! command -v $tool >/dev/null 2>&1; then
      echo "Error: $tool is not installed correctly. Please check."
    else
      echo "$tool installed successfully."
    fi
  done
}

setup_vim() {
  check_and_install_vim

  echo "Setting up Vim..."
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

  echo "Checking and installing vim-plug..."
  if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
    curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs "$PLUG_URL"
    echo "vim-plug installed successfully."
  else
    echo "vim-plug is already installed."
  fi
  
  echo "Installing Go tools..."
  install_go_tools

  echo "Installing Vim plugins..."
  vim -E -s -u "$VIMRC_DEST" +PlugInstall +qall
  echo "Vim setup complete."
}

setup_tmux() {
  check_and_install_tmux

  echo "Setting up Tmux..."
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

  echo "Checking and installing Tmux Plugin Manager..."
  if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone "$TMUX_PLUGIN_REPO" "$HOME/.tmux/plugins/tpm"
    echo "Tmux Plugin Manager installed successfully."
  else
    echo "Tmux Plugin Manager is already installed."
  fi

  echo "Tmux setup complete."
}

setup_neovim() {
  check_and_install_neovim

  echo "Setting up Neovim..."
  git clone https://github.com/LazyVim/starter ~/.config/nvim
  rm -rf ~/.config/nvim/.git

  echo "Configuring Neovim LSP for Go..."
  mkdir -p "$NVIM_LUA_DIR"
  cat << EOF > "$NVIM_LUA_DIR/go.lua"
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              analyses = { unusedparams = true },
              staticcheck = true,
            },
          },
        },
      },
    },
  },
}
EOF

  echo "Installing Go tools..."
  install_go_tools

  echo "Installing Neovim plugins..."
  nvim --headless "+Lazy sync" +qa
  echo "Neovim plugins synced."

  echo "Installing Mason packages..."
  nvim --headless -c "MasonInstall shfmt stylua" -c "qa"
  echo "Mason packages installed."

  echo "Neovim setup complete."
}


install_all() {
  install_nerd_font
  setup_vim
  setup_tmux
  setup_neovim
}

# Main Menu
while true; do
  echo
  echo "Choose a setup option:"
  options=("Install Nerd Font" "Setup Vim" "Setup Tmux" "Setup Neovim" "Install All" "Exit")
  select opt in "${options[@]}"; do
    case $opt in
      "Install Nerd Font")
        install_nerd_font
        break # Exit select loop to redisplay the menu
        ;;
      "Setup Vim")
        setup_vim
        break # Exit select loop to redisplay the menu
        ;;
      "Setup Tmux")
        setup_tmux
        break # Exit select loop to redisplay the menu
        ;;
      "Setup Neovim")
        setup_neovim
        break # Exit select loop to redisplay the menu
        ;;
      "Install All")
        install_all
        break # Exit select loop to redisplay the menu
        ;;
      "Exit")
        echo "Exiting setup."
        exit 0
        ;;
      *)
        echo "Invalid option. Please try again."
        ;;
    esac
  done
done
