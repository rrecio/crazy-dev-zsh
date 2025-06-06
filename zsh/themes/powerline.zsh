# ~/.dotfiles/zsh/themes/powerline.zsh
# POWERLINE THEME - Full-featured powerline with all segments
# The most comprehensive and feature-rich theme

# Prompt configuration
autoload -Uz vcs_info
autoload -U colors && colors
setopt PROMPT_SUBST

# Performance optimization - cache expensive operations
typeset -g PROMPT_CACHE_TIME=0
typeset -g PROMPT_CACHE_CONTENT=""
typeset -g PROMPT_CACHE_TTL=5  # Cache for 5 seconds

# Powerline-style separator characters
typeset -g LEFT_SEPARATOR=""
typeset -g RIGHT_SEPARATOR=""
typeset -g LEFT_SUBSEPARATOR=""
typeset -g RIGHT_SUBSEPARATOR=""

# Color definitions for segments
typeset -A PROMPT_COLORS
PROMPT_COLORS=(
  # Backgrounds
  os_bg "blue"
  user_bg "green"
  root_bg "red"
  ssh_bg "yellow"
  dir_bg "cyan"
  git_clean_bg "green"
  git_dirty_bg "yellow"
  git_untracked_bg "red"
  exec_time_bg "magenta"
  lang_bg "blue"
  docker_bg "cyan"
  k8s_bg "blue"
  battery_good_bg "green"
  battery_medium_bg "yellow"
  battery_low_bg "red"
  
  # Foregrounds
  primary_fg "white"
  secondary_fg "black"
  accent_fg "cyan"
)

# Segment drawing functions
segment() {
  local bg_color="$1"
  local fg_color="$2"
  local content="$3"
  local next_bg="$4"
  
  if [[ -n "$content" ]]; then
    # Start segment
    echo -n "%K{$bg_color}%F{$fg_color} $content %f"
    
    # Add separator for next segment
    if [[ -n "$next_bg" && "$next_bg" != "$bg_color" ]]; then
      echo -n "%K{$next_bg}%F{$bg_color}$LEFT_SEPARATOR%f"
    elif [[ -n "$next_bg" ]]; then
      echo -n "%K{$next_bg}%F{8}$LEFT_SUBSEPARATOR%f"
    else
      echo -n "%k%F{$bg_color}$LEFT_SEPARATOR%f"
    fi
  fi
}

# OS/Platform indicator
os_segment() {
  local icon=""
  local bg_color="${PROMPT_COLORS[os_bg]}"
  
  case "$(uname)" in
    Darwin)
      if [[ "$(uname -m)" == "arm64" ]]; then
        icon="󰀵"  # Apple Silicon
      else
        icon=""  # Intel Mac
      fi
      ;;
    Linux)
      if command -v lsb_release &> /dev/null; then
        local distro=$(lsb_release -si 2>/dev/null)
        case "$distro" in
          Ubuntu) icon="" ;;
          Debian) icon="" ;;
          *) icon="" ;;
        esac
      else
        icon=""
      fi
      ;;
    *) icon="󰚀" ;;
  esac
  
  echo "$bg_color|${PROMPT_COLORS[primary_fg]}|$icon"
}

# User and host segment
user_segment() {
  local user_icon=""
  local bg_color=""
  local content=""
  
  # Determine user type and icon
  if [[ $EUID -eq 0 ]]; then
    user_icon=""
    bg_color="${PROMPT_COLORS[root_bg]}"
  else
    user_icon=""
    bg_color="${PROMPT_COLORS[user_bg]}"
  fi
  
  # Check if SSH session
  if [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]]; then
    bg_color="${PROMPT_COLORS[ssh_bg]}"
    user_icon="󰢩"
    content="$user_icon %n@%m"
  else
    content="$user_icon %n"
  fi
  
  echo "$bg_color|${PROMPT_COLORS[primary_fg]}|$content"
}

# Smart directory path
directory_segment() {
  local bg_color="${PROMPT_COLORS[dir_bg]}"
  local max_length=35
  local path_icon=""
  local current_path="${PWD/#$HOME/~}"
  
  # Special directory icons
  case "$PWD" in
    "$HOME") path_icon=" " ;;
    "$HOME/Desktop"*) path_icon="󰇄 " ;;
    "$HOME/Documents"*) path_icon=" " ;;
    "$HOME/Downloads"*) path_icon=" " ;;
    "$HOME/Music"*) path_icon=" " ;;
    "$HOME/Pictures"*) path_icon=" " ;;
    "$HOME/Videos"*) path_icon=" " ;;
    "$HOME/.dotfiles"*) path_icon=" " ;;
    "/usr"*) path_icon=" " ;;
    "/etc"*) path_icon=" " ;;
    "/var"*) path_icon=" " ;;
    *) 
      if git rev-parse --git-dir &> /dev/null; then
        path_icon=" "
      else
        path_icon=" "
      fi
      ;;
  esac
  
  # Truncate long paths
  if [[ ${#current_path} -gt $max_length ]]; then
    current_path="…${current_path: -$max_length}"
  fi
  
  echo "$bg_color|${PROMPT_COLORS[secondary_fg]}|$path_icon$current_path"
}

# Enhanced git segment
git_segment() {
  if ! git rev-parse --git-dir &> /dev/null 2>&1; then
    return 0
  fi
  
  local branch=""
  local git_status=""
  local bg_color=""
  local git_icon=""
  
  # Get branch name
  branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
  
  # Count changes
  local staged=$(git diff --cached --name-only 2>/dev/null | wc -l | tr -d ' ')
  local modified=$(git diff --name-only 2>/dev/null | wc -l | tr -d ' ')
  local untracked=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')
  local ahead=$(git rev-list --count @{upstream}..HEAD 2>/dev/null || echo "0")
  local behind=$(git rev-list --count HEAD..@{upstream} 2>/dev/null || echo "0")
  
  # Build status string
  local status_parts=()
  [[ "$staged" -gt 0 ]] && status_parts+=("✚$staged")
  [[ "$modified" -gt 0 ]] && status_parts+=("●$modified")
  [[ "$untracked" -gt 0 ]] && status_parts+=("?$untracked")
  [[ "$ahead" -gt 0 ]] && status_parts+=("↑$ahead")
  [[ "$behind" -gt 0 ]] && status_parts+=("↓$behind")
  
  # Join status parts
  if [[ ${#status_parts[@]} -gt 0 ]]; then
    git_status=" ${(j: :)status_parts}"
  fi
  
  # Determine segment color and icon
  if [[ "$untracked" -gt 0 ]]; then
    bg_color="${PROMPT_COLORS[git_untracked_bg]}"
    git_icon=""
  elif [[ "$staged" -gt 0 || "$modified" -gt 0 ]]; then
    bg_color="${PROMPT_COLORS[git_dirty_bg]}"
    git_icon=""
  else
    bg_color="${PROMPT_COLORS[git_clean_bg]}"
    git_icon=""
  fi
  
  echo "$bg_color|${PROMPT_COLORS[secondary_fg]}|$git_icon $branch$git_status"
}

# Language version segments
node_segment() {
  if [[ -f "package.json" ]] && command -v node &> /dev/null; then
    local version=$(node --version 2>/dev/null | sed 's/v//')
    local pm_icon=""
    local bg_color="${PROMPT_COLORS[lang_bg]}"
    
    # Detect package manager
    if [[ -f "yarn.lock" ]]; then
      pm_icon="󰌠"
    elif [[ -f "pnpm-lock.yaml" ]]; then
      pm_icon="󰌠"
    elif [[ -f "bun.lockb" ]]; then
      pm_icon="󰌠"
    else
      pm_icon="󰉃"
    fi
    
    local ts_indicator=""
    if [[ -f "tsconfig.json" ]] || grep -q '"typescript"' package.json 2>/dev/null; then
      ts_indicator=" TS"
    fi
    
    echo "$bg_color|${PROMPT_COLORS[primary_fg]}|$pm_icon $version$ts_indicator"
  elif [[ -f "deno.json" || -f "deno.jsonc" ]] && command -v deno &> /dev/null; then
    local version=$(deno --version 2>/dev/null | head -1 | awk '{print $2}')
    echo "${PROMPT_COLORS[lang_bg]}|${PROMPT_COLORS[primary_fg]}|󱔤 $version"
  fi
}

python_segment() {
  if [[ -f "requirements.txt" || -f "pyproject.toml" || -f "Pipfile" || -f "setup.py" ]] && command -v python3 &> /dev/null; then
    local version=$(python3 --version 2>/dev/null | cut -d' ' -f2)
    local bg_color="${PROMPT_COLORS[lang_bg]}"
    echo "$bg_color|${PROMPT_COLORS[primary_fg]}| $version"
  fi
}

go_segment() {
  if [[ -f "go.mod" || -f "main.go" ]] && command -v go &> /dev/null; then
    local version=$(go version 2>/dev/null | awk '{print $3}' | sed 's/go//')
    local bg_color="${PROMPT_COLORS[lang_bg]}"
    echo "$bg_color|${PROMPT_COLORS[primary_fg]}| $version"
  fi
}

swift_segment() {
  if [[ -f "Package.swift" ]] || [[ -n "$(find . -maxdepth 1 -name "*.xcodeproj" -o -name "*.xcworkspace" 2>/dev/null)" ]]; then
    if command -v swift &> /dev/null; then
      local version=$(swift --version 2>/dev/null | head -1 | grep -o '[0-9]\+\.[0-9]\+' | head -1)
      local bg_color="${PROMPT_COLORS[lang_bg]}"
      echo "$bg_color|${PROMPT_COLORS[primary_fg]}| $version"
    fi
  fi
}

flutter_segment() {
  if [[ -f "pubspec.yaml" ]]; then
    if command -v flutter &> /dev/null; then
      local version=$(flutter --version 2>/dev/null | head -1 | awk '{print $2}')
      local bg_color="${PROMPT_COLORS[lang_bg]}"
      echo "$bg_color|${PROMPT_COLORS[primary_fg]}|󱘏 $version"
    elif command -v dart &> /dev/null; then
      local version=$(dart --version 2>&1 | head -1 | awk '{print $4}')
      local bg_color="${PROMPT_COLORS[lang_bg]}"
      echo "$bg_color|${PROMPT_COLORS[primary_fg]}|󰔮 $version"
    fi
  fi
}

# Container/Cloud segments
docker_segment() {
  if command -v docker &> /dev/null && docker info &> /dev/null 2>&1; then
    local containers=$(docker ps -q 2>/dev/null | wc -l | tr -d ' ')
    if [[ "$containers" -gt 0 ]]; then
      local bg_color="${PROMPT_COLORS[docker_bg]}"
      echo "$bg_color|${PROMPT_COLORS[primary_fg]}|󰡨 $containers"
    fi
  fi
}

k8s_segment() {
  if command -v kubectl &> /dev/null; then
    local context=$(kubectl config current-context 2>/dev/null)
    if [[ -n "$context" ]]; then
      local short_context="${context##*/}"  # Remove prefix
      local bg_color="${PROMPT_COLORS[k8s_bg]}"
      echo "$bg_color|${PROMPT_COLORS[primary_fg]}|󱃾 $short_context"
    fi
  fi
}

# System status segments
battery_segment() {
  if [[ "$(uname)" == "Darwin" ]] && command -v pmset &> /dev/null; then
    local battery_info=$(pmset -g batt 2>/dev/null | grep -o '[0-9]*%' | head -1)
    local battery_percent=${battery_info%\%}
    
    if [[ -n "$battery_percent" ]]; then
      local bg_color=""
      local icon=""
      
      if [[ $battery_percent -lt 20 ]]; then
        bg_color="${PROMPT_COLORS[battery_low_bg]}"
        icon="󰁺"
      elif [[ $battery_percent -lt 50 ]]; then
        bg_color="${PROMPT_COLORS[battery_medium_bg]}"
        icon="󰁾"
      else
        bg_color="${PROMPT_COLORS[battery_good_bg]}"
        icon="󰁹"
      fi
      
      echo "$bg_color|${PROMPT_COLORS[primary_fg]}|$icon $battery_info"
    fi
  fi
}

exec_time_segment() {
  if [[ -n "$DOTFILES_CMD_EXEC_TIME" && "$DOTFILES_CMD_EXEC_TIME" != "0ms" ]]; then
    local bg_color="${PROMPT_COLORS[exec_time_bg]}"
    echo "$bg_color|${PROMPT_COLORS[primary_fg]}|󰄉 $DOTFILES_CMD_EXEC_TIME"
  fi
}

# Build the complete prompt
build_powerline_prompt() {
  local current_time=$(date +%s)
  
  # Use cache if still valid
  if [[ $((current_time - PROMPT_CACHE_TIME)) -lt $PROMPT_CACHE_TTL && -n "$PROMPT_CACHE_CONTENT" ]]; then
    echo "$PROMPT_CACHE_CONTENT"
    return
  fi
  
  # Collect all segments
  local segments=()
  local segment_info=""
  
  # Add segments (order matters for appearance)
  for segment_func in os_segment user_segment directory_segment git_segment \
                     node_segment python_segment go_segment swift_segment flutter_segment \
                     docker_segment k8s_segment exec_time_segment battery_segment; do
    segment_info=$($segment_func)
    [[ -n "$segment_info" ]] && segments+=("$segment_info")
  done
  
  # Build the prompt line
  local prompt_line=""
  local next_bg=""
  
  for i in {1..${#segments[@]}}; do
    local current_segment="${segments[$i]}"
    local next_segment="${segments[$((i+1))]}"
    
    # Parse segment info: bg_color|fg_color|content
    local bg_color="${current_segment%%|*}"
    local remaining="${current_segment#*|}"
    local fg_color="${remaining%%|*}"
    local content="${remaining#*|}"
    
    # Get next segment's background color
    if [[ -n "$next_segment" ]]; then
      next_bg="${next_segment%%|*}"
    else
      next_bg=""
    fi
    
    prompt_line="${prompt_line}$(segment "$bg_color" "$fg_color" "$content" "$next_bg")"
  done
  
  # Cache the result
  PROMPT_CACHE_TIME=$current_time
  PROMPT_CACHE_CONTENT="$prompt_line"
  
  echo "$prompt_line"
}

# Right prompt with time and status
build_rprompt() {
  local time_segment="%F{8}%D{%H:%M:%S}%f"
  echo "$time_segment"
}

# Load the theme
load_powerline_theme() {
  # Main prompt with error indicator and powerline segments
  PROMPT='%(?..%F{red}✗ %f)$(build_powerline_prompt)
%F{green}❯%f '
  
  # Right prompt with time
  RPROMPT='$(build_rprompt)'
  
  # Secondary prompts
  PS2="%F{yellow}❯%f "
  PS3="%F{cyan}?%f "
  PS4="%F{red}+%f "
  
  echo "🚀 Powerline theme loaded - Full-featured with all segments"
} 