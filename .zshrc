# ~/.zshrc - Modern ZSH Configuration
# Author: rrecio
# Optimized for macOS development

# Performance monitoring - start timer
DOTFILES_START_TIME=$(($(date +%s%3N)))

# Define dotfiles directory
export DOTFILES_DIR="${HOME}/.dotfiles"
export ZSH_CONFIG_DIR="${DOTFILES_DIR}/zsh"

# Create custom config if it doesn't exist
[[ ! -f "${ZSH_CONFIG_DIR}/custom.zsh" ]] && touch "${ZSH_CONFIG_DIR}/custom.zsh"

# Load all zsh modules in order
typeset -a config_files=(
  "exports"
  "macos"
  "completion"
  "aliases"
  "functions"
  "git"
  "prompt"
  "performance"
  "custom"
)

# Load each configuration module
for config_file in $config_files; do
  config_path="${ZSH_CONFIG_DIR}/${config_file}.zsh"
  if [[ -r "$config_path" ]]; then
    source "$config_path"
  else
    echo "Warning: Could not load $config_path"
  fi
done

# Load fzf if available
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Load homebrew completions if available
if command -v brew &> /dev/null; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

# Initialize completion system
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# Load syntax highlighting if available (should be last)
if [[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Load autosuggestions if available
if [[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [[ -f /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Load custom prompt themes (replaces starship)
source "${HOME}/.zsh/prompt.zsh"

# Load plugins
source "${HOME}/.zsh/plugins.zsh"

# Helpful dotfiles management aliases
alias dotfiles='cd ~/.dotfiles'
alias dotfiles-update='cd ~/.dotfiles && git pull && source ~/.zshrc'
alias dotfiles-edit='code ~/.dotfiles'

# Calculate and display load time if verbose mode is enabled
if [[ -n "$DOTFILES_VERBOSE" ]]; then
  DOTFILES_END_TIME=$(($(date +%s%3N)))
  DOTFILES_LOAD_TIME=$((DOTFILES_END_TIME - DOTFILES_START_TIME))
  echo "Dotfiles loaded in ${DOTFILES_LOAD_TIME}ms"
fi 