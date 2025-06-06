# ~/.dotfiles/zsh/prompt.zsh
# Crazy Dev ZSH - Multi-theme Prompt System
# Beautiful, customizable prompt themes with interactive selection

# Load the theme manager
source "${HOME}/.dotfiles/zsh/theme_manager.zsh"

# Initialize the theme system (only if starship is not active)
if [[ -z "$STARSHIP_SESSION_KEY" ]]; then
  init_theme_system
else
  echo "⭐ Starship prompt detected, skipping custom prompt themes"
fi 