# ~/.dotfiles/zsh/custom.zsh
# Personal customizations - add your own configurations here
# This file is loaded last and won't be overwritten during updates

# Add your custom aliases here
# alias myalias='command'

# Add your custom functions here
# myfunction() {
#   echo "This is my custom function"
# }

# Add your custom environment variables here
# export MY_CUSTOM_VAR="value"

# Add any tool-specific configurations here
# Example: nvm, rbenv, pyenv, etc.

# Custom prompt modifications using our theme system
# Themes are managed by theme_manager.zsh

# Load any additional local configurations
[[ -f "${HOME}/.zshrc.local" ]] && source "${HOME}/.zshrc.local"

# History settings
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history

# ZSH options
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY 