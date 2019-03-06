# Bash autocompletion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

PATH=$PATH:/usr/local/sbin

# python
export PATH="/usr/local/opt/python/libexec/bin:$PATH"
VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3

# pyenv
eval "$(pyenv init -)"

# virtualenvwrapper
source /usr/local/bin/virtualenvwrapper.sh

# Android SDK
export PATH="/Users/nabil/Library/Android/sdk/platform-tools":$PATH

# postgresql
export PATH="/usr/local/opt/postgresql@9.6/bin:$PATH"
export PATH="/usr/local/opt/postgresql@9.6/bin:$PATH"

# nvm
export NVM_DIR="$HOME/.nvm"
. "/usr/local/opt/nvm/nvm.sh"