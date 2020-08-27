#!/usr/bin/env bash
set -euo pipefail

function coloured() {
    printf "\033[00;$1m==> $2\033[0m\n"
}

function error() {
    coloured "31", "$1"
}

function success() {
    coloured "32", "$1"
}

function warn() {
    coloured "33", "$1"
}

function info() {
    coloured "34", "$1"
}

DOTFILES=~/.dotfiles
if [ -d $DOTFILES ]; then
  error "$DOTFILES already exists! Aborting."
  exit 1
fi

info "Starting the Mac install ..."

#info "Setting up X-Code..."
# xcode-select --install

# Check for Homebrew and install if not present
if ! command -v brew >/dev/null; then
    info "Installing Homebrew..."
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew tap homebrew/bundle
    info "Updating Homebrew formulaes..."
    brew update
fi

if ! command -v git >/dev/null; then
  info "Installing Git..."
  brew install git
  git config --global user.name "Dairon Medina Caro"
  git config --global user.email "dairon.medina@gmail.com"
fi

# Clone the dotfiles
git clone https://github.com/codeadict/dotfiles.git $DOTFILES
cd $DOTFILES

# Install all our dependencies with bundle (See Brewfile)
brew bundle

#echo "Setuping up MacOS..."
#sh osx_config.sh

# Symlink dotfiles
rcup -v rcrc
rcup -v

# Install ASDF version manager
cd "$HOME"
git clone https://github.com/asdf-vm/asdf.git ~/.asdf

info "Installing asdf plugins"
. ~/.asdf/asdf.sh
asdf plugin-add erlang
asdf plugin-add elixir
asdf plugin-add nodejs
asdf plugin-add golang

info "Installing languages via asdf..."
info "Installing latest NodeJS..."
bash -c $HOME/.asdf/plugins/nodejs/bin/import-release-team-keyring
asdf install nodejs latest && asdf global nodejs $(asdf latest nodejs)
info "Installing Golang 1.14..."
asdf install golang latest && asdf global golang 1.14

# Install


# Install and use ZSH
ZSH=/bin/zsh
if grep -vFxq $ZSH /etc/shells
then
  info "Adding $ZSH to /etc/shells"
  echo $ZSH | sudo tee -a /etc/shells
fi

info "Starting Homebrew cleanup..."
brew cleanup

# chsh -s $ZSH
env zsh
# shellcheck source=./zshrc
. ~/.zshrc

success "Completed."

exit 0
