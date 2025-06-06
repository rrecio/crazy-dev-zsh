# ~/.dotfiles/zsh/prompt.zsh
# Custom prompt with git status and performance indicators

# Prompt configuration
autoload -Uz vcs_info
autoload -U colors && colors

# VCS info configuration
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '%F{red}●%f'
zstyle ':vcs_info:*' stagedstr '%F{green}●%f'
zstyle ':vcs_info:git:*' formats '%F{blue}%b%f%c%u'
zstyle ':vcs_info:git:*' actionformats '%F{blue}%b%f|%F{red}%a%f%c%u'

# Enable parameter expansion in prompts
setopt PROMPT_SUBST

# Git status function for prompt
git_status() {
  if ! git rev-parse --git-dir &> /dev/null; then
    return 0
  fi

  local branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
  local status=""
  local color=""
  
  # Check for changes
  local staged=$(git diff --cached --name-only 2>/dev/null | wc -l | tr -d ' ')
  local modified=$(git diff --name-only 2>/dev/null | wc -l | tr -d ' ')
  local untracked=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')
  local ahead=$(git rev-list --count @{upstream}..HEAD 2>/dev/null || echo "0")
  local behind=$(git rev-list --count HEAD..@{upstream} 2>/dev/null || echo "0")
  
  # Build status indicators
  [[ "$staged" -gt 0 ]] && status="${status}+${staged}"
  [[ "$modified" -gt 0 ]] && status="${status}!${modified}"
  [[ "$untracked" -gt 0 ]] && status="${status}?${untracked}"
  [[ "$ahead" -gt 0 ]] && status="${status}↑${ahead}"
  [[ "$behind" -gt 0 ]] && status="${status}↓${behind}"
  
  # Choose color based on status
  if [[ -n "$status" ]]; then
    color="yellow"
  else
    color="green"
  fi
  
  if [[ -n "$status" ]]; then
    echo " %F{$color}$branch%f %F{red}$status%f"
  else
    echo " %F{$color}$branch%f"
  fi
}

# Directory path with truncation
smart_pwd() {
  local pwd_length=50
  local pwd_symbol="…"
  local current_pwd=${PWD/#$HOME/~}
  
  if [[ ${#current_pwd} -gt $pwd_length ]]; then
    echo "${pwd_symbol}${current_pwd: -$pwd_length}"
  else
    echo "$current_pwd"
  fi
}

# Load average (macOS only)
load_average() {
  if [[ "$(uname)" == "Darwin" ]]; then
    local load=$(uptime | awk '{print $10}' | sed 's/,//')
    echo " %F{cyan}[$load]%f"
  fi
}

# Battery status (macOS only)
battery_status() {
  if [[ "$(uname)" == "Darwin" ]] && command -v pmset &> /dev/null; then
    local battery_info=$(pmset -g batt | grep -o '[0-9]*%' | head -1)
    local battery_percent=${battery_info%\%}
    
    if [[ -n "$battery_percent" ]]; then
      local color="green"
      local icon="🔋"
      
      if [[ $battery_percent -lt 20 ]]; then
        color="red"
        icon="🪫"
      elif [[ $battery_percent -lt 50 ]]; then
        color="yellow"
        icon="🔋"
      fi
      
      echo " %F{$color}$icon$battery_info%f"
    fi
  fi
}

# Command execution time
preexec() {
  DOTFILES_CMD_START_TIME=$(date +%s%3N)
}

precmd() {
  if [[ -n "$DOTFILES_CMD_START_TIME" ]]; then
    local end_time=$(date +%s%3N)
    local elapsed=$((end_time - DOTFILES_CMD_START_TIME))
    
    if [[ $elapsed -gt 1000 ]]; then
      DOTFILES_CMD_EXEC_TIME="${elapsed}ms"
    else
      DOTFILES_CMD_EXEC_TIME=""
    fi
    
    unset DOTFILES_CMD_START_TIME
  fi
  
  # Update VCS info
  vcs_info
}

# Execution time display
exec_time() {
  [[ -n "$DOTFILES_CMD_EXEC_TIME" ]] && echo " %F{magenta}${DOTFILES_CMD_EXEC_TIME}%f"
}

# Node.js/JavaScript version and package manager (if in a JS project)
node_version() {
  if [[ -f "package.json" ]] && command -v node &> /dev/null; then
    local version=$(node --version | sed 's/v//')
    local pm_icon=""
    
    # Detect package manager
    if [[ -f "yarn.lock" ]]; then
      pm_icon="🧶"
    elif [[ -f "pnpm-lock.yaml" ]]; then
      pm_icon="📦"
    elif [[ -f "bun.lockb" ]]; then
      pm_icon="🥖"
    else
      pm_icon="⬢"
    fi
    
    # Check if TypeScript
    if [[ -f "tsconfig.json" ]] || grep -q '"typescript"' package.json 2>/dev/null; then
      echo " %F{blue}${pm_icon}${version}%f %F{blue}TS%f"
    else
      echo " %F{green}${pm_icon}${version}%f"
    fi
  elif [[ -f "deno.json" || -f "deno.jsonc" ]] && command -v deno &> /dev/null; then
    local version=$(deno --version | head -1 | awk '{print $2}')
    echo " %F{cyan}🦕${version}%f"
  fi
}

# Python version (if in a Python project)
python_version() {
  if [[ -f "requirements.txt" ]] || [[ -f "pyproject.toml" ]] || [[ -f "Pipfile" ]]; then
    if command -v python3 &> /dev/null; then
      local version=$(python3 --version | cut -d' ' -f2)
      echo " %F{blue}🐍${version}%f"
    fi
  fi
}

# Swift version (if in a Swift project)
swift_version() {
  if [[ -f "Package.swift" ]] || [[ -d "*.xcodeproj" ]] || [[ -d "*.xcworkspace" ]]; then
    if command -v swift &> /dev/null; then
      local version=$(swift --version | head -1 | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+' | head -1)
      echo " %F{orange}🍎${version}%f"
    fi
  fi
}

# Flutter/Dart version (if in a Flutter project)
flutter_version() {
  if [[ -f "pubspec.yaml" ]]; then
    if command -v flutter &> /dev/null; then
      local version=$(flutter --version 2>/dev/null | head -1 | awk '{print $2}')
      echo " %F{cyan}🦋${version}%f"
    elif command -v dart &> /dev/null; then
      local version=$(dart --version 2>/dev/null | awk '{print $4}')
      echo " %F{cyan}🎯${version}%f"
    fi
  fi
}

# Go version (if in a Go project)
go_version() {
  if [[ -f "go.mod" ]] || [[ -f "main.go" ]]; then
    if command -v go &> /dev/null; then
      local version=$(go version 2>/dev/null | awk '{print $3}' | sed 's/go//')
      echo " %F{blue}🐹${version}%f"
    fi
  fi
}

# Docker status
docker_status() {
  if command -v docker &> /dev/null && docker info &> /dev/null; then
    local containers=$(docker ps -q | wc -l | tr -d ' ')
    if [[ "$containers" -gt 0 ]]; then
      echo " %F{blue}🐳${containers}%f"
    fi
  fi
}

# Kubernetes context
k8s_context() {
  if command -v kubectl &> /dev/null && kubectl config current-context &> /dev/null; then
    local context=$(kubectl config current-context | cut -d'/' -f1)
    echo " %F{cyan}☸${context}%f"
  fi
}

# Exit code indicator
exit_code() {
  echo "%(?..%F{red}✗%f )"
}

# User and host info
user_host() {
  local user_color="green"
  local host_color="blue"
  
  # Change color if root
  if [[ $EUID -eq 0 ]]; then
    user_color="red"
  fi
  
  # Change color if SSH session
  if [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]]; then
    host_color="yellow"
  fi
  
  echo "%F{$user_color}%n%f@%F{$host_color}%m%f"
}

# Main prompt components
build_prompt() {
  local prompt_parts=(
    "$(exit_code)"
    "$(user_host)"
    "%F{cyan}$(smart_pwd)%f"
    "$(git_status)"
    "$(go_version)"
    "$(flutter_version)"
    "$(swift_version)"
    "$(node_version)"
    "$(python_version)"
    "$(docker_status)"
    "$(k8s_context)"
    "$(exec_time)"
    "$(load_average)"
    "$(battery_status)"
  )
  
  # Join non-empty parts
  local prompt_line=""
  for part in "${prompt_parts[@]}"; do
    [[ -n "$part" ]] && prompt_line="${prompt_line}${part}"
  done
  
  echo "$prompt_line"
}

# Right prompt (minimal)
build_rprompt() {
  local rprompt_parts=(
    "%F{white}%D{%H:%M:%S}%f"
  )
  
  # Join parts
  local rprompt_line=""
  for part in "${rprompt_parts[@]}"; do
    [[ -n "$part" ]] && rprompt_line="${rprompt_line}${part}"
  done
  
  echo "$rprompt_line"
}

# Set prompts
if [[ -z "$STARSHIP_SESSION_KEY" ]]; then
  # Only set custom prompt if starship is not active
  PROMPT='$(build_prompt)
%F{green}❯%f '
  RPROMPT='$(build_rprompt)'
else
  # Starship is active, don't override
  echo "Starship prompt detected, skipping custom prompt"
fi

# Continuation prompt
PS2="%F{yellow}❯%f "

# Selection prompt
PS3="%F{yellow}?%f "

# Debug prompt
PS4="%F{red}+%f "

# Terminal title
case $TERM in
  xterm*|rxvt*|Eterm|aterm|kterm|gnome*|interix|konsole*)
    precmd_functions+=(set_terminal_title)
    ;;
esac

set_terminal_title() {
  local title="$(basename "$PWD")"
  if git rev-parse --git-dir &> /dev/null; then
    local repo=$(basename "$(git rev-parse --show-toplevel)")
    local branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
    title="$repo ($branch)"
  fi
  
  case $TERM in
    xterm*|rxvt*|Eterm|aterm|kterm|gnome*|interix|konsole*)
      print -Pn "\e]0;$title\a"
      ;;
  esac
} 