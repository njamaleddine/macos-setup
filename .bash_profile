# Bash autocompletion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

# virtualenvwrapper
source /usr/local/bin/virtualenvwrapper.sh

PATH=$PATH:/usr/local/sbin

export PATH="/Users/nabil/Library/Android/sdk/platform-tools":$PATH