#!/bin/bash

# Install Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew_packages=(
  awscli
  bash
  bash-completion
  caskroom/cask/brew-cask
  ffmpeg --with-faac --with-fdk-aac --with-libvorbis --with-ffplay --with-theora
  fluid-synth --with-libsndfile
  geos
  git
  graphviz
  heroku
  imagemagick
  jpeginfo
  jq
  memcached
  mongodb
  node
  openssl
  postgresql
  postgis
  python
  python3
  rabbitmq
  redis
  sassc
  tree
  sqlite
  wget
)

# Optional packages
kivy_brew_packages=(
  sdl2
  sdl2_image
  sdl2_ttf
  sdl2_mixer
  gstreamer
)

work_brew_packages=(
  syncthing
)

# Brew Cask (Install apps)
brew_cask_packages=(
  android-file-transfer
  android-studio
  arduino
  atom
  code
  docker-toolbox
  eclipse-ide
  firefox
  gimp
  google-chrome
  java
  ngrok
  postman
  sketch
  sketchup
  skype
  slack
  spotify
  sublime-text
  spectacle
  virtualbox
  vlc
)

USE_BASH_PROFILE=false

while true; do
    read -p "Install work brew packages? (y/n): " yn
    case $yn in
        [Yy]* ) brew_packages=("${brew_packages[@]}" "${work_brew_packages[@]}"); break;;
        [Nn]* ) break;;
        * ) echo "You must enter yes or no";;
    esac
done

while true; do
    read -p "Install kivy brew packages? (y/n): " yn
    case $yn in
        [Yy]* ) brew_packages=("${brew_packages[@]}" "${kivy_brew_packages[@]}"); break;;
        [Nn]* ) break;;
        * ) echo "You must enter yes or no";;
    esac
done

read -p "Specify any additional brew cask apps (separate each with a space or press ENTER to continue): " additional_cask_packages
brew_cask_packages=("${brew_cask_packages[@]}" "${additional_cask_packages[@]}")

while true; do
    read -p "Replace ~/.bash_profile with new one? (y/n): " yn
    case $yn in
        [Yy]* ) USE_BASH_PROFILE=true; break;;
        [Nn]* ) break;;
        * ) echo "You must enter yes or no";;
    esac
done

# Brew and Brew cask installation
echo "Updating homebrew..."
brew update && brew upgrade
echo "Installing homebrew packages..."
brew install ${brew_packages[*]}
echo "Installing homebrew cask apps..."
brew cask install ${brew_cask_packages[@]}

echo "Cleaning up after installation..."
brew cleanup

# Setup text editors
vscode_setup.sh

# Python Packages
echo "Installing python packages..."
pip install --upgrade pip
pip install ipython httpie virtualenvwrapper

# Start services
echo "Starting services..."
brew services start postgresql
brew services start redis

# Copying custom .bash_profile to ~/.bash_profile
if [ $USE_BASH_PROFILE ]; then
  echo "Setting bash profile..."
  cp .bash_profile ~/.bash_profile
fi

echo "MacOS setup complete!"
