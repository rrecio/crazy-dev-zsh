# ~/.dotfiles/zsh/prompt.zsh
# Custom Prompt Theme System
# Multi-theme prompt system with performance optimization

# Enable prompt substitution for dynamic prompts
setopt PROMPT_SUBST

# Source the theme manager
source "${DOTFILES_DIR:-${HOME}/.dotfiles}/zsh/theme_manager.zsh"

# Initialize the theme system
init_theme_system 