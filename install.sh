#!/bin/sh

function coloured() {
    printf "\033[00;$1m==> $2\033[0m\n"
}

function error() {
    coloured "31", "$1"
}

function success() {
    coloured "32", "$1"
}

function warning() {
    coloured "33", "$1"
}

function info() {
    coloured "34", "$1"
}

info "Starting the Mac install ..."

info "Setting up X-Code..."
xcode-select --install

# Check for Homebrew and install if not present
if ! command -v brew >/dev/null; then
    info "Installing Homebrew..."
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew tap homebrew/bundle
fi

info "Updating Homebrew formulaes..."
brew update

if ! command -v git >/dev/null; then
  info "Installing Git..."
  brew install git
  git config --global user.name "Dairon Medina Caro"
  git config --global user.email "dairon.medina@gmail.com"
fi

# Install all our dependencies with bundle (See Brewfile)
brew bundle

info "Starting Homebrew cleanup..."
brew cask cleanup
brew cleanup

info "Generating an SSH key for Git..."
ssh-keygen -t rsa
info "Please add this public key to Github \n"
info "Paste it on https://github.com/account/ssh \n"
read -p "Press [Enter] when done..."

success "Completed."

exit 0
