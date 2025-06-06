# ~/.dotfiles/zsh/themes/retro.zsh
# RETRO THEME - Nostalgic terminal aesthetics with modern functionality
# Classic ASCII art, vintage colors, but smart features underneath

autoload -U colors && colors
setopt PROMPT_SUBST

# Retro ASCII art and styling
retro_banner() {
  local banners=(
    "░▒▓█ CYBER TERMINAL █▓▒░"
    "◆◇◆ RETRO COMPUTING ◆◇◆" 
    "▲▼▲ HACKER STATION ▲▼▲"
    "■□■ CODE MATRIX ■□■"
  )
  
  # Show banner occasionally (1 in 10 chance)
  if [[ $(($RANDOM % 10)) -eq 0 ]]; then
    local banner=${banners[$(($RANDOM % ${#banners[@]} + 1))]}
    echo "%F{green}$banner%f"
  fi
}

# Retro directory with ASCII styling
retro_directory() {
  local path="${PWD/#$HOME/~}"
  local ascii_icon=""
  
  # Retro ASCII icons
  case "$PWD" in
    "$HOME") ascii_icon="[~]" ;;
    "$HOME/Desktop"*) ascii_icon="[DESK]" ;;
    "$HOME/Documents"*) ascii_icon="[DOCS]" ;;
    "$HOME/Downloads"*) ascii_icon="[DOWN]" ;;
    "$HOME/.dotfiles"*) ascii_icon="[CFG]" ;;
    "/usr"*) ascii_icon="[SYS]" ;;
    "/etc"*) ascii_icon="[ETC]" ;;
    *) 
      if git rev-parse --git-dir &> /dev/null; then
        ascii_icon="[GIT]"
      else
        ascii_icon="[DIR]"
      fi
      ;;
  esac
  
  # Truncate path with retro styling
  local display_path="$path"
  if [[ ${#path} -gt 30 ]]; then
    display_path="...${path: -25}"
  fi
  
  echo "%F{cyan}$ascii_icon %F{white}$display_path%f"
}

# Retro git status with ASCII indicators
retro_git() {
  if ! git rev-parse --git-dir &> /dev/null 2>&1; then
    return 0
  fi
  
  local branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
  local status=""
  
  # Retro ASCII status indicators
  if ! git diff --quiet 2>/dev/null; then
    status="%F{yellow}[MODIFIED]%f"
  elif ! git diff --cached --quiet 2>/dev/null; then
    status="%F{green}[STAGED]%f"
  elif [[ -n $(git ls-files --others --exclude-standard 2>/dev/null) ]]; then
    status="%F{red}[UNTRACKED]%f"
  else
    status="%F{green}[CLEAN]%f"
  fi
  
  echo " %F{magenta}[REPO:%F{white}$branch%F{magenta}]%f $status"
}

# Retro language detection with classic styling
retro_tech() {
  local tech_parts=()
  
  # Classic language indicators
  if [[ -f "package.json" ]]; then
    tech_parts+=("%F{green}[NODE.JS]%f")
    if grep -q "typescript" package.json 2>/dev/null; then
      tech_parts+=("%F{blue}[TypeScript]%f")
    fi
  fi
  
  if [[ -f "requirements.txt" || -f "setup.py" ]]; then
    tech_parts+=("%F{yellow}[PYTHON]%f")
    if [[ -n "$VIRTUAL_ENV" ]]; then
      tech_parts+=("%F{yellow}[VENV:$(basename $VIRTUAL_ENV)]%f")
    fi
  fi
  
  if [[ -f "Cargo.toml" ]]; then
    tech_parts+=("%F{red}[RUST]%f")
  fi
  
  if [[ -f "go.mod" ]]; then
    tech_parts+=("%F{blue}[GOLANG]%f")
  fi
  
  if [[ -f "Package.swift" ]]; then
    tech_parts+=("%F{orange}[SWIFT]%f")
  fi
  
  # Docker detection
  if command -v docker &> /dev/null && docker info &> /dev/null 2>&1; then
    local containers=$(docker ps -q 2>/dev/null | wc -l | tr -d ' ')
    if [[ "$containers" -gt 0 ]]; then
      tech_parts+=("%F{cyan}[DOCKER:$containers]%f")
    fi
  fi
  
  if [[ ${#tech_parts[@]} -gt 0 ]]; then
    echo " ${(j: :)tech_parts}"
  fi
}

# Retro system status with ASCII meters
retro_system() {
  local system_parts=()
  
  # Battery meter (macOS)
  if [[ "$(uname)" == "Darwin" ]] && command -v pmset &> /dev/null; then
    local battery_info=$(pmset -g batt 2>/dev/null | grep -o '[0-9]*%' | head -1)
    local battery_percent=${battery_info%\%}
    
    if [[ -n "$battery_percent" ]]; then
      local meter=""
      local blocks=$((battery_percent / 10))
      local i=0
      
      # ASCII battery meter
      while [[ $i -lt 10 ]]; do
        if [[ $i -lt $blocks ]]; then
          meter="${meter}█"
        else
          meter="${meter}░"
        fi
        ((i++))
      done
      
      local color=""
      if [[ $battery_percent -lt 20 ]]; then
        color="%F{red}"
      elif [[ $battery_percent -lt 50 ]]; then
        color="%F{yellow}"
      else
        color="%F{green}"
      fi
      
      system_parts+=("${color}[BAT:$meter]%f")
    fi
  fi
  
  # Load average (if available)
  if command -v uptime &> /dev/null; then
    local load=$(uptime | grep -o 'load average[s]*: [0-9.]*' | awk '{print $3}' | cut -d',' -f1)
    if [[ -n "$load" ]] && [[ "$load" != "0.00" ]]; then
      system_parts+=("%F{cyan}[LOAD:$load]%f")
    fi
  fi
  
  if [[ ${#system_parts[@]} -gt 0 ]]; then
    echo " ${(j: :)system_parts}"
  fi
}

# Retro prompt builder
build_retro_prompt() {
  local timestamp="%F{green}[%D{%H:%M:%S}]%f"
  local user_host="%F{yellow}[USER:%n@%m]%f"
  local directory="$(retro_directory)"
  local git_info="$(retro_git)"
  local tech_info="$(retro_tech)"
  local system_info="$(retro_system)"
  
  echo "$timestamp $user_host $directory$git_info$tech_info$system_info"
}

# Retro right prompt with classic styling
retro_rprompt() {
  local parts=()
  
  # Execution time in retro format
  if [[ -n "$DOTFILES_CMD_EXEC_TIME" && "$DOTFILES_CMD_EXEC_TIME" != "0ms" ]]; then
    parts+=("%F{magenta}[EXEC:$DOTFILES_CMD_EXEC_TIME]%f")
  fi
  
  # Show random retro element occasionally
  if [[ $(($RANDOM % 5)) -eq 0 ]]; then
    local elements=("▓▒░" "♦♣♠♥" "◊◇◈" "▲▼◀▶" "■□▪▫")
    local element=${elements[$(($RANDOM % ${#elements[@]} + 1))]}
    parts+=("%F{8}$element%f")
  fi
  
  echo "${(j: :)parts}"
}

# Retro command hooks
retro_preexec() {
  DOTFILES_CMD_START_TIME=$(date +%s%3N)
  
  # Show occasional retro message
  if [[ $(($RANDOM % 20)) -eq 0 ]]; then
    local messages=(
      ">>> EXECUTING COMMAND..."
      ">>> PROCESSING REQUEST..."
      ">>> ACCESSING MAINFRAME..."
      ">>> COMPILING MATRIX..."
    )
    local msg=${messages[$(($RANDOM % ${#messages[@]} + 1))]}
    echo "%F{green}$msg%f" >&2
  fi
}

retro_precmd() {
  # Calculate execution time
  if [[ -n "$DOTFILES_CMD_START_TIME" ]]; then
    local end_time=$(date +%s%3N)
    local elapsed=$((end_time - DOTFILES_CMD_START_TIME))
    
    if [[ $elapsed -gt 1000 ]]; then
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
  
  # Show banner occasionally
  retro_banner
}

# Load the retro theme
load_retro_theme() {
  # Retro multi-line prompt
  PROMPT='$(build_retro_prompt)
%(?..%F{red}[ERROR] %f)%F{green}>>%f '
  
  # Retro right prompt
  RPROMPT='$(retro_rprompt)'
  
  # Retro secondary prompts
  PS2="%F{green}>>> %f"
  PS3="%F{cyan}[SELECT] %f"
  PS4="%F{red}[DEBUG] %f"
  
  # Hook into command execution
  preexec_functions+=(retro_preexec)
  precmd_functions+=(retro_precmd)
  
  # Show initial retro banner
  echo "%F{green}░▒▓█ RETRO TERMINAL ACTIVATED █▓▒░%f"
  echo "%F{yellow}>>> WELCOME TO THE MATRIX, USER $(whoami) <<<% f"
} 