#!/bin/bash

# Install Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Update and Upgrade homebrew
brew update && brew upgrade

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
  docker-toolbox
  eclipse-ide
  firefox
  gimp
  google-chrome
  java
  minecraft
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

while true; do
    read -p "Install work brew packages?" yn
    case $yn in
        [Yy]* ) brew_packages=("${brew_packages[@]}" "${work_brew_packages[@]}"); break;;
        [Nn]* ) break;;
        * ) echo "You must enter yes or no";;
    esac
done

while true; do
    read -p "Install kivy brew packages?" yn
    case $yn in
        [Yy]* ) brew_packages=("${brew_packages[@]}" "${kivy_brew_packages[@]}"); break;;
        [Nn]* ) break;;
        * ) echo "You must enter yes or no";;
    esac
done

read -p "Specify any additional brew cask apps (separate each with a space): " additional_cask_packages
brew_cask_packages=("${brew_cask_packages[@]}" "${additional_cask_packages[@]}")


# Brew and Brew cask installation
echo "Installing homebrew packages..."
brew install ${brew_packages[*]}
echo "Installing homebrew cask apps..."
brew cask install ${brew_cask_packages[@]}

echo "Cleaning up after installation..."
brew cleanup

# Python Packages
echo "Installing python packages..."
pip install --upgrade pip
pip install ipython httpie virtualenvwrapper

# Start services
echo "Starting services..."
brew services start postgresql
brew services start redis
