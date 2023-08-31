# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/dantae/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

source /home/dantae/repos/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# PATH
export PATH=$PATH:/home/dantae/scripts

# Aliases
alias ls='ls --color'
source /home/dantae/repos/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
