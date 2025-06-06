# ~/.dotfiles/zsh/theme_manager.zsh
# THEME MANAGER - Handles loading and switching between prompt themes

# Available themes
typeset -A CRAZY_DEV_THEMES
CRAZY_DEV_THEMES=(
  "powerline" "🚀 Powerline - Full-featured with all segments (default)"
  "minimal" "⚡ Minimal - Lightning fast and clean"
  "developer" "👨‍💻 Developer - Enhanced coding context" 
  "ai-powered" "🤖 AI-Powered - Intelligent context awareness"
  "retro" "🕹️ Retro - Nostalgic terminal aesthetics"
  "corporate" "🏢 Corporate - Professional and enterprise-ready"
)

# Theme descriptions with previews
show_theme_preview() {
  local theme="$1"
  
  case "$theme" in
    "powerline")
      echo "%F{cyan}Preview:%f %F{blue} %f%F{white} user %f%F{cyan} ~/projects/my-app %f%F{green} main ✓ %f%F{blue}⬢ 18.2.0 %f%F{green}❯%f"
      echo "Features: OS info, user, directory icons, detailed git, language versions, containers, battery"
      ;;
    "minimal")
      echo "%F{cyan}Preview:%f %F{cyan}~/projects/my-app%f %F{blue}(main%F{green}✓%F{blue})%f %F{green}⬢%f %F{magenta}❯%f"
      echo "Features: Essential path, simple git status, basic language detection"
      ;;
    "developer")
      echo "%F{cyan}Preview:%f %F{cyan}󰜫 my-app%f %F{blue} main [+2|~1]%f %F{green}⬢ 18.2.0(npm)+TS%f"
      echo "Features: Project-focused, detailed git workflow, advanced language context, dev tools"
      ;;
    "ai-powered")
      echo "%F{cyan}Preview:%f %F{magenta}🤖 my-ai-project%f %F{blue}🌟 main [●2]%f %F{green}🧠 node:18.2%f %F{green}🤖 ollama(3)%f %F{cyan}🚀%f"
      echo "Features: AI model status, intelligent project detection, enhanced context awareness"
      ;;
    "retro")
      echo "%F{cyan}Preview:%f %F{green}[20:30:15]%f %F{yellow}[USER:dev@machine]%f %F{cyan}[GIT] %F{white}~/code%f %F{magenta}[REPO:%F{white}main%F{magenta}]%f %F{green}[CLEAN]%f %F{green}>>%f"
      echo "Features: ASCII art styling, retro indicators, vintage aesthetics with modern features"
      ;;
    "corporate")
      echo "%F{cyan}Preview:%f %F{blue}📂 my-enterprise-app%f %F{cyan}git:main%f %F{green}✓%f %F{green}node:18.2%f %F{green}❯%f"
      echo "Features: Professional styling, essential info only, enterprise-friendly"
      ;;
  esac
}

# Interactive theme selection
select_prompt_theme() {
  echo
  echo "%F{cyan}🎨 Choose Your Prompt Theme%f"
  echo "%F{8}════════════════════════════════════════════════════════════════════════%f"
  echo
  
  local theme_keys=(${(@k)CRAZY_DEV_THEMES})
  local i=1
  
  # Show all available themes with previews
  for theme in "${theme_keys[@]}"; do
    echo "%F{yellow}$i)%f ${CRAZY_DEV_THEMES[$theme]}"
    show_theme_preview "$theme"
    echo
    ((i++))
  done
  
  echo "%F{8}════════════════════════════════════════════════════════════════════════%f"
  echo
  
  # Get user selection
  local selection=""
  while true; do
    echo -n "%F{cyan}Enter your choice (1-${#theme_keys[@]}) or theme name [1]: %f"
    read selection
    
    # Default to powerline if empty
    if [[ -z "$selection" ]]; then
      selection="1"
    fi
    
    # Check if it's a number
    if [[ "$selection" =~ ^[0-9]+$ ]]; then
      if [[ "$selection" -ge 1 && "$selection" -le ${#theme_keys[@]} ]]; then
        selected_theme="${theme_keys[$selection]}"
        break
      else
        echo "%F{red}Invalid selection. Please choose 1-${#theme_keys[@]}.%f"
        continue
      fi
    # Check if it's a theme name
    elif [[ -n "${CRAZY_DEV_THEMES[$selection]}" ]]; then
      selected_theme="$selection"
      break
    else
      echo "%F{red}Invalid theme name. Available themes: ${(j:, :)theme_keys[@]}%f"
      continue
    fi
  done
  
  echo
  echo "%F{green}✓ Selected theme: ${CRAZY_DEV_THEMES[$selected_theme]}%f"
  echo "$selected_theme" > "${HOME}/.dotfiles/.selected_theme"
  
  return 0
}

# Load a specific theme
load_theme() {
  local theme="${1:-powerline}"
  local theme_file="${HOME}/.dotfiles/zsh/themes/${theme}.zsh"
  
  if [[ -f "$theme_file" ]]; then
    # Source the theme file
    source "$theme_file"
    
    # Call the theme's load function
    case "$theme" in
      "powerline") load_powerline_theme ;;
      "minimal") load_minimal_theme ;;
      "developer") load_developer_theme ;;
      "ai-powered") load_ai_theme ;;
      "retro") load_retro_theme ;;
      "corporate") load_corporate_theme ;;
      *) 
        echo "%F{red}Unknown theme: $theme%f"
        load_powerline_theme  # Fallback
        ;;
    esac
    
    # Store the current theme
    export CRAZY_DEV_CURRENT_THEME="$theme"
  else
    echo "%F{red}Theme file not found: $theme_file%f"
    echo "%F{yellow}Falling back to powerline theme%f"
    load_powerline_theme
  fi
}

# Get saved theme preference
get_saved_theme() {
  local saved_theme_file="${HOME}/.dotfiles/.selected_theme"
  if [[ -f "$saved_theme_file" ]]; then
    cat "$saved_theme_file"
  else
    echo "powerline"  # Default theme
  fi
}

# Theme switching command
switch_theme() {
  local new_theme="$1"
  
  if [[ -z "$new_theme" ]]; then
    # Interactive selection if no theme specified
    select_prompt_theme
    new_theme=$(get_saved_theme)
  fi
  
  # Validate theme exists
  if [[ -z "${CRAZY_DEV_THEMES[$new_theme]}" ]]; then
    echo "%F{red}Unknown theme: $new_theme%f"
    echo "%F{cyan}Available themes:%f ${(j:, :)${(@k)CRAZY_DEV_THEMES}}"
    return 1
  fi
  
  # Load the new theme
  load_theme "$new_theme"
  echo "$new_theme" > "${HOME}/.dotfiles/.selected_theme"
  
  echo "%F{green}✓ Switched to ${CRAZY_DEV_THEMES[$new_theme]}%f"
  echo "%F{yellow}Restart your terminal or run 'exec zsh' to see the full effect%f"
}

# List available themes
list_themes() {
  echo "%F{cyan}🎨 Available Prompt Themes:%f"
  echo
  
  local current_theme=$(get_saved_theme)
  
  for theme in "${(@k)CRAZY_DEV_THEMES}"; do
    local indicator=""
    if [[ "$theme" == "$current_theme" ]]; then
      indicator="%F{green}● (current)%f"
    else
      indicator="%F{8}○%f"
    fi
    
    echo "$indicator ${CRAZY_DEV_THEMES[$theme]}"
  done
  
  echo
  echo "%F{8}Use 'switch_theme <name>' to change themes%f"
}

# Command execution timing setup (shared across themes)
setup_command_timing() {
  # Command execution timing
  preexec() {
    DOTFILES_CMD_START_TIME=$(date +%s%3N)
  }

  precmd() {
    # Calculate execution time
    if [[ -n "$DOTFILES_CMD_START_TIME" ]]; then
      local end_time=$(date +%s%3N)
      local elapsed=$((end_time - DOTFILES_CMD_START_TIME))
      
      if [[ $elapsed -gt 100 ]]; then
        if [[ $elapsed -gt 60000 ]]; then
          local minutes=$((elapsed / 60000))
          local seconds=$(((elapsed % 60000) / 1000))
          DOTFILES_CMD_EXEC_TIME="${minutes}m${seconds}s"
        else
          DOTFILES_CMD_EXEC_TIME="${elapsed}ms"
        fi
      else
        DOTFILES_CMD_EXEC_TIME=""
      fi
      
      unset DOTFILES_CMD_START_TIME
    fi
  }
}

# Terminal title (shared across themes)
set_terminal_title() {
  local title="$(basename "$PWD")"
  
  if git rev-parse --git-dir &> /dev/null 2>&1; then
    local repo=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)")
    local branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
    title="$repo ($branch)"
  fi
  
  # Add language/framework context
  if [[ -f "package.json" ]]; then
    title="$title [Node.js]"
  elif [[ -f "Cargo.toml" ]]; then
    title="$title [Rust]"
  elif [[ -f "go.mod" ]]; then
    title="$title [Go]"
  elif [[ -f "Package.swift" ]]; then
    title="$title [Swift]"
  elif [[ -f "pubspec.yaml" ]]; then
    title="$title [Flutter]"
  fi
  
  case $TERM in
    xterm*|rxvt*|Eterm|aterm|kterm|gnome*|interix|konsole*)
      print -Pn "\e]0;$title\a"
      ;;
  esac
}

# Initialize theme system
init_theme_system() {
  # Setup shared functionality
  setup_command_timing
  
  # Add terminal title to precmd functions
  case $TERM in
    xterm*|rxvt*|Eterm|aterm|kterm|gnome*|interix|konsole*)
      precmd_functions+=(set_terminal_title)
      ;;
  esac
  
  # Load the saved theme
  local saved_theme=$(get_saved_theme)
  load_theme "$saved_theme"
} 