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
NVIM_CONFIG_DIR="$HOME/.config/nvim"

# Functions
check_dependencies() {
  echo "Checking system dependencies..."

  DEPENDENCIES=(unzip curl wget git gcc make tar fzf)

  for dep in "${DEPENDENCIES[@]}"; do
    if ! command -v $dep >/dev/null 2>&1; then
      echo "$dep is not installed. Installing $dep..."
      sudo apt update && sudo apt install -y $dep
    else
      echo "$dep is already installed."
    fi
  done

  echo "All dependencies are installed."
}

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
    echo -e "\nAn existing Vim configuration (.vimrc) was found."
    echo -e "\nChoose an option:"
    echo "1) Back up and continue with the setup."
    echo "2) Remove the current configuration and do a fresh setup."
    echo "3) Keep the existing configuration and skip setup."
    read -rp "Enter your choice (1/2/3): " vim_choice

    case $vim_choice in
      1)
        BACKUP_VIMRC="$VIMRC_DEST.bk.$(date +%s)"
        echo "Backing up existing .vimrc to $BACKUP_VIMRC..."
        mv "$VIMRC_DEST" "$BACKUP_VIMRC"
        ;;
      2)
        echo "Removing existing .vimrc for a fresh setup..."
        rm -f "$VIMRC_DEST"
        ;;
      3)
        echo "Keeping existing Vim configuration and skipping setup."
        return
        ;;
      *)
        echo "Invalid choice. Exiting setup."
        return
        ;;
    esac
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
    echo -e "\nAn existing Tmux configuration (.tmux.conf) was found."
    echo -e "\nChoose an option:"
    echo "1) Back up and continue with the setup."
    echo "2) Remove the current configuration and do a fresh setup."
    echo "3) Keep the existing configuration and skip setup."
    read -rp "Enter your choice (1/2/3): " tmux_choice

    case $tmux_choice in
      1)
        BACKUP_TMUX="$TMUX_CONF_DEST.bk.$(date +%s)"
        echo "Backing up existing .tmux.conf to $BACKUP_TMUX..."
        mv "$TMUX_CONF_DEST" "$BACKUP_TMUX"
        ;;
      2)
        echo "Removing existing .tmux.conf for a fresh setup..."
        rm -f "$TMUX_CONF_DEST"
        ;;
      3)
        echo "Keeping existing Tmux configuration and skipping setup."
        return
        ;;
      *)
        echo "Invalid choice. Exiting setup."
        return
        ;;
    esac
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
  
  if [ -d "$NVIM_CONFIG_DIR" ]; then
    echo -e "\nAn existing Neovim configuration was found."
    echo -e "\nChoose an option:"
    echo "1) Back up and continue with the setup."
    echo "2) Remove everything related to the current configuration and do a fresh install."
    echo "3) Keep the existing configuration and skip setup."
    read -rp "Enter your choice (1/2/3): " nvim_choice

    case $nvim_choice in
      1)
        BACKUP_NVIM="$NVIM_CONFIG_DIR.bk.$(date +%s)"
        echo "Backing up existing Neovim configuration to $BACKUP_NVIM..."
        mv "$NVIM_CONFIG_DIR" "$BACKUP_NVIM"
        ;;
      2)
        echo "Removing existing Neovim configuration for a fresh install..."
        rm -rf "$NVIM_CONFIG_DIR"
        ;;
      3)
        echo "Keeping existing Neovim configuration and skipping setup."
        return
        ;;
      *)
        echo "Invalid choice. Exiting setup."
        return
        ;;
    esac
  fi

  git clone https://github.com/LazyVim/starter "$NVIM_CONFIG_DIR"
  rm -rf "$NVIM_CONFIG_DIR/.git"

  echo "Configuring Neovim LSP for Go and Lua..."
  mkdir -p "$NVIM_CONFIG_DIR/lua/plugins"
  cat << EOF > "$NVIM_CONFIG_DIR/lua/plugins/lsp.lua"
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
        lua_ls = {
          settings = {
            Lua = {
              runtime = {
                version = "LuaJIT",
              },
              diagnostics = {
                globals = { "vim" },
              },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
              },
              telemetry = {
                enable = false,
              },
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
  nvim --headless -c "lua require('mason').setup()" -c "MasonInstall shfmt stylua lua-language-server" -c "qa"
  echo "Mason packages installed."

  echo "Updating Neovim LazyVim packages..."
  nvim --headless -c "Lazy update" -c "qa"
  echo "Neovim LazyVim packages updated."

  echo "Neovim setup complete."
}

install_all() {
  check_dependencies
  install_nerd_font
  setup_vim
  setup_tmux
  setup_neovim
}

# Main Menu
while true; do
  echo -e "\nChoose a setup option:"
  options=("Check Dependencies" "Install Nerd Font" "Setup Vim" "Setup Tmux" "Setup Neovim" "Install All" "Exit")
  select opt in "${options[@]}"; do
    case $opt in
      "Check Dependencies")
        check_dependencies
        break
        ;;
      "Install Nerd Font")
        install_nerd_font
        break
        ;;
      "Setup Vim")
        setup_vim
        break
        ;;
      "Setup Tmux")
        setup_tmux
        break
        ;;
      "Setup Neovim")
        setup_neovim
        break
        ;;
      "Install All")
        install_all
        break
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
