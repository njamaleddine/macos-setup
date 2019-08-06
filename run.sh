#!/bin/bash
brew_packages=(
  awscli
  awsebcli
  bash
  bash-completion
  bat
  caskroom/cask/brew-cask
  ffmpeg --with-faac --with-fdk-aac --with-libvorbis --with-ffplay --with-theora
  fluid-synth --with-libsndfile
  geos
  git
  goreplay
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
  android-file-transfer
  android-studio
  arduino
  docker-toolbox
  eclipse-ide
  etcher
  firefox
  gimp
  google-chrome
  iterm2
  java
  ngrok
  postman
  robo-3t
  sketch
  sketchup
  skitch
  skype
  slack
  spotify
  sublime-text
  spectacle
  virtualbox
  visual-studio-code
  vlc
)

USE_BASH_PROFILE=false
USE_VSCODE_SETTINGS=false

read -p "Specify any additional brew packages (separate each with a space or press ENTER to continue): " additional_packages
brew_packages=("${brew_packages[@]}" "${additional_packages[@]}")

read -p "Specify any additional brew cask apps (separate each with a space or press ENTER to continue): " additional_cask_apps
brew_cask_apps=("${brew_cask_apps[@]}" "${additional_cask_apps[@]}")

while true; do
    read -p "Replace ~/.bash_profile with new one? (y/n): " yn
    case $yn in
        [Yy]* ) USE_BASH_PROFILE=true; break;;
        [Nn]* ) break;;
        * ) echo "You must enter yes or no";;
    esac
done

while true; do
    read -p "Replace visual studio code settings.json file with new one? (y/n): " yn
    case $yn in
        [Yy]* ) USE_VSCODE_SETTINGS=true; break;;
        [Nn]* ) break;;
        * ) echo "You must enter yes or no";;
    esac
done

# Install Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo "Updating homebrew..."
brew update && brew upgrade
echo "Installing homebrew packages..."
brew install ${brew_packages[*]}
echo "Installing homebrew cask apps..."
brew cask install ${brew_cask_apps[@]}

echo "Cleaning up after installation..."
brew cleanup

echo "Installing nvm"
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash

if [ $USE_BASH_PROFILE ]; then
  echo "Setting bash profile..."
  cp .bash_profile ~/.bash_profile
fi

echo "Setting up Visual Studio Code..."
bash ./vscode/setup.sh
if [ $USE_VSCODE_SETTINGS ]; then
  echo "Overwriting visual-studio-code settings..."
  cp ./vscode/settings.json ~/Library/Application\ Support/Code/User/_settings-test.json
fi

echo "Installing python packages..."
pip install --upgrade pip
pip install ipython httpie pipenv virtualenvwrapper 

echo "Starting services..."
brew services start postgresql
brew services start redis

echo "MacOS setup complete!"
