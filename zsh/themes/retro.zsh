# ~/.dotfiles/zsh/themes/retro.zsh
# RETRO THEME - Nostalgic terminal aesthetics with modern functionality
# Classic ASCII art, vintage colors, but smart features underneath

autoload -U colors && colors
setopt PROMPT_SUBST

# Authentic retro color palette
typeset -A RETRO_COLORS
RETRO_COLORS=(
  terminal_green "46"     # Classic terminal green
  amber_glow     "220"    # Amber CRT glow
  neon_cyan      "51"     # Neon cyan
  hot_magenta    "201"    # Hot magenta
  electric_blue  "39"     # Electric blue
  plasma_red     "196"    # Plasma red
  gold_text      "226"    # Gold text
  silver_chrome  "255"    # Silver chrome
  shadow_gray    "244"    # Shadow gray
  void_black     "0"      # Void black
  matrix_dim     "28"     # Dim matrix green
)

# Retro ASCII art banners (shown occasionally)
retro_banner() {
  local banners=(
    "░▒▓█ CYBER TERMINAL █▓▒░"
    "◆◇◆ RETRO COMPUTING ◆◇◆" 
    "▲▼▲ HACKER STATION ▲▼▲"
    "■□■ CODE MATRIX ■□■"
    "▓▒░ QUANTUM SHELL ░▒▓"
    "◊◇◊ NEON DREAMS ◊◇◊"
  )
  
  # Show banner occasionally (1 in 15 chance)
  if [[ $(($RANDOM % 15)) -eq 0 ]]; then
    local banner=${banners[$(($RANDOM % ${#banners[@]} + 1))]}
    echo "%F{${RETRO_COLORS[terminal_green]}}$banner%f"
  fi
}

# Beautiful retro directory with ASCII styling
retro_directory() {
  local path="${PWD/#$HOME/~}"
  local ascii_icon=""
  local icon_color="${RETRO_COLORS[neon_cyan]}"
  
  # Retro ASCII icons with perfect styling
  case "$PWD" in
    "$HOME") 
      ascii_icon="[◊HOME◊]"
      icon_color="${RETRO_COLORS[gold_text]}"
      ;;
    "$HOME/Desktop"*) 
      ascii_icon="[▲DESK▲]"
      icon_color="${RETRO_COLORS[electric_blue]}"
      ;;
    "$HOME/Documents"*) 
      ascii_icon="[■DOCS■]"
      icon_color="${RETRO_COLORS[amber_glow]}"
      ;;
    "$HOME/Downloads"*) 
      ascii_icon="[▼DOWN▼]"
      icon_color="${RETRO_COLORS[hot_magenta]}"
      ;;
    "$HOME/.dotfiles"*) 
      ascii_icon="[◆CFG◆]"
      icon_color="${RETRO_COLORS[terminal_green]}"
      ;;
    "/usr"*) 
      ascii_icon="[▓SYS▓]"
      icon_color="${RETRO_COLORS[plasma_red]}"
      ;;
    "/etc"*) 
      ascii_icon="[░ETC░]"
      icon_color="${RETRO_COLORS[plasma_red]}"
      ;;
    *) 
      if git rev-parse --git-dir &> /dev/null; then
        ascii_icon="[▒GIT▒]"
        icon_color="${RETRO_COLORS[terminal_green]}"
      else
        ascii_icon="[□DIR□]"
        icon_color="${RETRO_COLORS[neon_cyan]}"
      fi
      ;;
  esac
  
  # Beautiful path truncation with retro styling
  local display_path="$path"
  if [[ ${#path} -gt 35 ]]; then
    local parts=(${(s:/:)path})
    if [[ ${#parts[@]} -gt 3 ]]; then
      display_path="${parts[1]}/⋯/${parts[-2]}/${parts[-1]}"
    else
      display_path="⋯${path: -30}"
    fi
  fi
  
  echo "%F{$icon_color}$ascii_icon%f %F{${RETRO_COLORS[silver_chrome]}}$display_path%f"
}

# Retro git status with beautiful ASCII indicators
retro_git() {
  if ! git rev-parse --git-dir &> /dev/null 2>&1; then
    return 0
  fi
  
  local branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
  local git_status=""
  local status_color=""
  local status_icon=""
  
  # Beautiful retro ASCII status indicators
  if ! git diff --quiet 2>/dev/null; then
    git_status="MODIFIED"
    status_color="${RETRO_COLORS[amber_glow]}"
    status_icon="◊"
  elif ! git diff --cached --quiet 2>/dev/null; then
    git_status="STAGED"
    status_color="${RETRO_COLORS[terminal_green]}"
    status_icon="▲"
  elif [[ -n $(git ls-files --others --exclude-standard 2>/dev/null) ]]; then
    git_status="UNTRACKED"
    status_color="${RETRO_COLORS[plasma_red]}"
    status_icon="?"
  else
    git_status="CLEAN"
    status_color="${RETRO_COLORS[terminal_green]}"
    status_icon="✓"
  fi
  
  # Check for remote sync
  local ahead=$(git rev-list --count @{upstream}..HEAD 2>/dev/null || echo "0")
  local behind=$(git rev-list --count HEAD..@{upstream} 2>/dev/null || echo "0")
  local sync_info=""
  
  if [[ "$ahead" -gt 0 || "$behind" -gt 0 ]]; then
    local sync_icons=""
    [[ "$ahead" -gt 0 ]] && sync_icons="↑$ahead"
    [[ "$behind" -gt 0 ]] && sync_icons="${sync_icons}↓$behind"
    sync_info=" %F{${RETRO_COLORS[hot_magenta]}}[$sync_icons]%f"
  fi
  
  echo " %F{${RETRO_COLORS[hot_magenta]}}[REPO:%F{${RETRO_COLORS[silver_chrome]}}$branch%F{${RETRO_COLORS[hot_magenta]}}]%f %F{$status_color}[$status_icon$git_status]%f$sync_info"
}

# Retro language detection with classic styling
retro_tech() {
  local tech_parts=()
  
  # Classic language indicators with beautiful colors
  if [[ -f "package.json" ]]; then
    local js_color="${RETRO_COLORS[terminal_green]}"
    tech_parts+=("%F{$js_color}[◆NODE.JS◆]%f")
    if grep -q "typescript" package.json 2>/dev/null; then
      tech_parts+=("%F{${RETRO_COLORS[electric_blue]}}[▲TypeScript▲]%f")
    fi
  fi
  
  if [[ -f "requirements.txt" || -f "setup.py" ]]; then
    tech_parts+=("%F{${RETRO_COLORS[amber_glow]}}[◊PYTHON◊]%f")
    if [[ -n "$VIRTUAL_ENV" ]]; then
      local env_name=$(basename $VIRTUAL_ENV)
      tech_parts+=("%F{${RETRO_COLORS[amber_glow]}}[VENV:$env_name]%f")
    fi
  fi
  
  if [[ -f "Cargo.toml" ]]; then
    tech_parts+=("%F{${RETRO_COLORS[plasma_red]}}[▓RUST▓]%f")
  fi
  
  if [[ -f "go.mod" ]]; then
    tech_parts+=("%F{${RETRO_COLORS[neon_cyan]}}[░GOLANG░]%f")
  fi
  
  if [[ -f "Package.swift" ]]; then
    tech_parts+=("%F{${RETRO_COLORS[electric_blue]}}[■SWIFT■]%f")
  fi
  
  if [[ -f "pubspec.yaml" ]]; then
    tech_parts+=("%F{${RETRO_COLORS[hot_magenta]}}[◇FLUTTER◇]%f")
  fi
  
  # Docker detection with retro style
  if command -v docker &> /dev/null && docker info &> /dev/null 2>&1; then
    local containers=$(docker ps -q 2>/dev/null | wc -l | tr -d ' ')
    if [[ "$containers" -gt 0 ]]; then
      tech_parts+=("%F{${RETRO_COLORS[neon_cyan]}}[▒DOCKER:$containers▒]%f")
    fi
  fi
  
  if [[ ${#tech_parts[@]} -gt 0 ]]; then
    echo " ${(j: :)tech_parts}"
  fi
}

# Retro system status with ASCII meters
retro_system() {
  local system_parts=()
  
  # Beautiful ASCII battery meter (macOS)
  if [[ "$(uname)" == "Darwin" ]] && command -v pmset &> /dev/null; then
    local battery_info=$(pmset -g batt 2>/dev/null | grep -o '[0-9]*%' | head -1)
    local battery_percent=${battery_info%\%}
    
    if [[ -n "$battery_percent" ]]; then
      local meter=""
      local blocks=$((battery_percent / 10))
      local i=0
      
      # Beautiful ASCII battery meter with retro style
      while [[ $i -lt 10 ]]; do
        if [[ $i -lt $blocks ]]; then
          meter="${meter}█"
        else
          meter="${meter}░"
        fi
        ((i++))
      done
      
      local battery_color=""
      if [[ $battery_percent -lt 20 ]]; then
        battery_color="${RETRO_COLORS[plasma_red]}"
      elif [[ $battery_percent -lt 50 ]]; then
        battery_color="${RETRO_COLORS[amber_glow]}"
      else
        battery_color="${RETRO_COLORS[terminal_green]}"
      fi
      
      system_parts+=("%F{$battery_color}[BAT:$meter]%f")
    fi
  fi
  
  # Load average with retro styling
  if command -v uptime &> /dev/null; then
    local load=$(uptime | grep -o 'load average[s]*: [0-9.]*' | awk '{print $3}' | cut -d',' -f1)
    if [[ -n "$load" ]] && [[ "$load" != "0.00" ]]; then
      local load_color="${RETRO_COLORS[neon_cyan]}"
      if (( $(echo "$load > 2.0" | bc -l 2>/dev/null || echo 0) )); then
        load_color="${RETRO_COLORS[plasma_red]}"
      elif (( $(echo "$load > 1.0" | bc -l 2>/dev/null || echo 0) )); then
        load_color="${RETRO_COLORS[amber_glow]}"
      fi
      system_parts+=("%F{$load_color}[LOAD:$load]%f")
    fi
  fi
  
  if [[ ${#system_parts[@]} -gt 0 ]]; then
    echo " ${(j: :)system_parts}"
  fi
}

# Retro prompt builder with perfect ASCII aesthetics
build_retro_prompt() {
  local timestamp="%F{${RETRO_COLORS[terminal_green]}}[%D{%H:%M:%S}]%f"
  local user_host="%F{${RETRO_COLORS[amber_glow]}}[USER:%n@%m]%f"
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
    local time_color="${RETRO_COLORS[hot_magenta]}"
    local time_icon="⏱"
    
    # Color based on execution time
    if [[ "$DOTFILES_CMD_EXEC_TIME" == *"m"* ]]; then
      time_color="${RETRO_COLORS[plasma_red]}"
      time_icon="⌛"
    elif [[ "${DOTFILES_CMD_EXEC_TIME%ms}" -gt 5000 ]]; then
      time_color="${RETRO_COLORS[amber_glow]}"
    fi
    
    parts+=("%F{$time_color}[EXEC:$time_icon$DOTFILES_CMD_EXEC_TIME]%f")
  fi
  
  # Show random retro element occasionally
  if [[ $(($RANDOM % 8)) -eq 0 ]]; then
    local elements=("▓▒░" "♦♣♠♥" "◊◇◈" "▲▼◀▶" "■□▪▫" "●○◐◑" "★☆✦✧")
    local element=${elements[$(($RANDOM % ${#elements[@]} + 1))]}
    parts+=("%F{${RETRO_COLORS[shadow_gray]}}$element%f")
  fi
  
  echo "${(j: :)parts}"
}

# Retro command hooks with beautiful feedback
retro_preexec() {
  # Only run if retro theme is active
  [[ "$(get_saved_theme)" != "retro" ]] && return
  
  DOTFILES_CMD_START_TIME=$(date +%s 2>/dev/null || echo 0)
  
  # Show occasional retro message with perfect styling
  if [[ $(($RANDOM % 25)) -eq 0 ]]; then
    local messages=(
      ">>> EXECUTING COMMAND..."
      ">>> PROCESSING REQUEST..."
      ">>> ACCESSING MAINFRAME..."
      ">>> COMPILING MATRIX..."
      ">>> LOADING PROGRAM..."
      ">>> QUANTUM PROCESSING..."
    )
    local msg=${messages[$(($RANDOM % ${#messages[@]} + 1))]}
    echo "%F{${RETRO_COLORS[terminal_green]}}$msg%f" >&2
  fi
}

retro_precmd() {
  # Only run if retro theme is active
  [[ "$(get_saved_theme)" != "retro" ]] && return
  
  # Calculate execution time
  if [[ -n "$DOTFILES_CMD_START_TIME" ]]; then
    local end_time=$(date +%s 2>/dev/null || echo 0)
    local elapsed=$((end_time - DOTFILES_CMD_START_TIME))
    
    if [[ $elapsed -gt 500 ]]; then
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

# Load the stunning retro theme
load_retro_theme() {
  # Beautiful multi-line retro prompt
  PROMPT='$(build_retro_prompt)
%(?..%F{${RETRO_COLORS[plasma_red]}}[ERROR] %f)%F{${RETRO_COLORS[terminal_green]}}>>%f '
  
  # Retro right prompt with ASCII elements
  RPROMPT='$(retro_rprompt)'
  
  # Retro secondary prompts with perfect styling
  PS2="%F{${RETRO_COLORS[terminal_green]}}>>> %f"
  PS3="%F{${RETRO_COLORS[neon_cyan]}}[SELECT] %f"
  PS4="%F{${RETRO_COLORS[plasma_red]}}[DEBUG] %f"
  
  # Hook into command execution
  preexec_functions+=(retro_preexec)
  precmd_functions+=(retro_precmd)
  
  # Show initial retro banner with perfect colors
  echo "%F{${RETRO_COLORS[terminal_green]}}░▒▓█ RETRO TERMINAL ACTIVATED █▓▒░%f"
  echo "%F{${RETRO_COLORS[amber_glow]}}>>> WELCOME TO THE MATRIX, USER $(whoami) <<<% f"
} 