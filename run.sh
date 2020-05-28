#!/bin/bash
brew_packages=(
  awscli
  awsebcli
  bash
  bash-completion
  bat
  ffmpeg # --with-faac --with-fdk-aac --with-libvorbis --with-ffplay --with-theora
  fluid-synth # --with-libsndfile
  fzf
  geos
  git
  gor
  graphviz
  heroku
  imagemagick
  jpeginfo
  jq
  kubectl
  memcached
  mongodb
  moreutils
  ngrep
  node
  openssl
  postgresql
  postgis
  python3
  rabbitmq
  redis
  stern
  tree
  sqlite
  wget
  zsh
)

# Brew Cask Applications
brew_cask_apps=(
  docker
  firefox
  gimp
  google-chrome
  iterm2
  mongodb-compass
  postman
  robo-3t
  skitch
  slack
  spotify
  spectacle
  visual-studio-code
)

optional_cask_apps=(
  android-file-transfer
  android-studio
  arduino
  discord
  etcher
  ngrok
  java
  sketch
  sketchup
  skype
  virtualbox
  vlc
)

REPLACE_BASH_PROFILE=false
USE_VSCODE_SETTINGS=false

read -p "Specify any additional brew packages (separate each with a space or press ENTER to continue): " additional_packages
brew_packages=("${brew_packages[@]}" "${additional_packages[@]}")

read -p "Specify any additional brew cask apps (separate each with a space or press ENTER to continue): " additional_cask_apps
brew_cask_apps=("${brew_cask_apps[@]}" "${additional_cask_apps[@]}")

while true; do
  read -p "Install optional brew cask apps? (y/n): " yn
  case $yn in
  [Yy]*)
    brew_cask_apps=("${brew_cask_apps[@]}" "${optional_cask_apps[@]}")
    break
    ;;
  [Nn]*) break ;;
  *) echo "You must enter yes or no" ;;
  esac
done

while true; do
  read -p "Replace ~/.zshrc with new one? (y/n): " yn
  case $yn in
  [Yy]*)
    REPLACE_BASH_PROFILE=true
    break
    ;;
  [Nn]*) break ;;
  *) echo "You must enter yes or no" ;;
  esac
done

while true; do
  read -p "Replace visual studio code settings.json file with new one? (y/n): " yn
  case $yn in
  [Yy]*)
    USE_VSCODE_SETTINGS=true
    break
    ;;
  [Nn]*) break ;;
  *) echo "You must enter yes or no" ;;
  esac
done

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

echo "Updating homebrew..."
brew update && brew upgrade
echo "Installing homebrew packages..."
brew install ${brew_packages[*]}
echo "Installing homebrew cask apps..."
brew cask install ${brew_cask_apps[@]}

echo "Cleaning up after installation..."
brew cleanup

echo "Installing nvm"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash

if [ $REPLACE_BASH_PROFILE ]; then
  echo "Setting bash profile..."
  cp .bash_profile ~/.bash_profile
fi

echo "Setting up Visual Studio Code..."
./vscode/setup.sh
if [ $USE_VSCODE_SETTINGS ]; then
  echo "Overwriting visual-studio-code settings..."
  cp ./vscode/settings.json ~/Library/Application\ Support/Code/User/_settings-test.json
fi

echo "Installing ohmyzsh"
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Brew cask services available to start:"
brew services list
echo "If you'd like to start services you can do so using the command: `brew services start ...`"

echo "macOS setup complete!"
