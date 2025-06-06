# ~/.dotfiles/zsh/themes/powerline.zsh
# Modern Powerline Theme - 10x Enhanced Visual Excellence
# Premium color palette with perfect contrast ratios and visual hierarchy
typeset -A POWERLINE_COLORS
POWERLINE_COLORS=(
  # Core background colors with enhanced contrast
  bg_deepest   "232"   # Ultra-deep black for maximum contrast
  bg_dark      "235"   # Deep charcoal background
  bg_medium    "240"   # Medium gray
  bg_light     "250"   # Light gray (enhanced from 245)
  
  # Premium accent colors - 10x more vibrant
  accent       "39"    # Electric blue
  accent_alt   "45"    # Brighter cyan alternative
  success      "46"    # Bright green
  success_alt  "82"    # Forest green alternative
  warning      "220"   # Golden yellow
  warning_alt  "214"   # Orange yellow
  error        "196"   # Bright red
  error_alt    "160"   # Deep red alternative
  info         "81"    # Cyan
  info_alt     "117"   # Light blue
  
  # Enhanced neutral colors
  muted        "244"   # Subtle gray
  muted_dark   "238"   # Darker muted
  white        "255"   # Pure white
  silver       "252"   # Silver alternative
  
  # Premium accent colors
  purple       "135"   # Royal purple
  purple_alt   "171"   # Magenta purple
  orange       "208"   # Vibrant orange
  orange_alt   "202"   # Red orange
  pink         "205"   # Hot pink
  lime         "154"   # Lime green
  
  # Special status colors
  ssh_warning  "226"   # Bright yellow for SSH
  root_danger  "196"   # Bright red for root
  battery_critical "124" # Dark red for critical battery
)

# Enhanced powerline separators with better visual weight
POWERLINE_LEFT_SEP=""
POWERLINE_RIGHT_SEP=""
POWERLINE_LEFT_THIN=""
POWERLINE_RIGHT_THIN=""

# Advanced performance caching with shorter TTL for responsiveness
POWERLINE_CACHE_TTL=1
POWERLINE_CACHE_TIME=0
POWERLINE_CACHE_CONTENT=""

# Enhanced OS detection with more comprehensive icons
powerline_os_icon() {
  case "$(uname)" in
    "Darwin") echo "󰀵" ;;      # Apple logo - premium
    "Linux") 
      if [[ -f /etc/arch-release ]]; then
        echo "󰣇"  # Arch Linux
      elif [[ -f /etc/ubuntu-release ]] || grep -q "Ubuntu" /etc/os-release 2>/dev/null; then
        echo "󰕈"  # Ubuntu
      elif [[ -f /etc/fedora-release ]]; then
        echo "󰣛"  # Fedora
      else
        echo "󰌽"  # Generic Linux
      fi
      ;;
    "Windows"*|"CYGWIN"*|"MSYS"*|"MINGW"*) echo "󰍲" ;;    # Windows logo
    "FreeBSD") echo "󰣚" ;;     # FreeBSD daemon
    *) echo "󰟀" ;;             # Generic computer
  esac
}

# Premium user context with enhanced visual hierarchy
powerline_user_segment() {
  local bg_color="${POWERLINE_COLORS[bg_dark]}"
  local fg_color="${POWERLINE_COLORS[white]}"
  local icon="$(powerline_os_icon)"
  local username="%n"
  
  # Enhanced context-aware styling
  if [[ $EUID -eq 0 ]]; then
    bg_color="${POWERLINE_COLORS[root_danger]}"
    fg_color="${POWERLINE_COLORS[white]}"
    icon="󰀇"  # Crown for root - danger indicator
    username="ROOT"
  elif [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" ]]; then
    bg_color="${POWERLINE_COLORS[ssh_warning]}"
    fg_color="${POWERLINE_COLORS[bg_deepest]}"  # Dark text on bright background
    icon="󰢹"  # SSH icon
  elif [[ -n "$TMUX" ]]; then
    bg_color="${POWERLINE_COLORS[info]}"
    fg_color="${POWERLINE_COLORS[white]}"
    icon="󰙀"  # TMUX multiplexer icon
  fi
  
  local segment="%K{$bg_color}%F{$fg_color} $icon $username %k%f"
  segment="${segment}%K{${POWERLINE_COLORS[bg_medium]}}%F{$bg_color}${POWERLINE_LEFT_SEP}%k%f"
  
  echo "$segment"
}

# Intelligent directory display with enhanced project context
powerline_directory_segment() {
  local bg_color="${POWERLINE_COLORS[bg_medium]}"
  local fg_color="${POWERLINE_COLORS[white]}"
  local path="${PWD/#$HOME/~}"
  local icon=""
  local project_indicator=""
  
  # Enhanced smart icons with project type detection
  if [[ "$PWD" == "$HOME" ]]; then
    icon="󰋜"  # Home
    project_indicator=""
  elif [[ -f "package.json" ]]; then
    icon="󰜫"  # Node.js project
    # Detect framework
    if grep -q "next\|nuxt" package.json 2>/dev/null; then
      project_indicator=" %F{${POWERLINE_COLORS[info_alt]}}▲%f"  # Next.js triangle
    elif grep -q "react" package.json 2>/dev/null; then
      project_indicator=" %F{${POWERLINE_COLORS[info]}}⚛%f"    # React atom
    elif grep -q "vue" package.json 2>/dev/null; then
      project_indicator=" %F{${POWERLINE_COLORS[success]}}﴾%f"  # Vue logo
    elif grep -q "angular" package.json 2>/dev/null; then
      project_indicator=" %F{${POWERLINE_COLORS[error]}}🅰%f"   # Angular A
    fi
  elif [[ -f "Cargo.toml" ]]; then
    icon="󱘗"  # Rust project
    project_indicator=" %F{${POWERLINE_COLORS[orange]}}🦀%f"
  elif [[ -f "go.mod" ]]; then
    icon="󰟓"  # Go project
    project_indicator=" %F{${POWERLINE_COLORS[info]}}🐹%f"
  elif [[ -f "requirements.txt" || -f "pyproject.toml" || -f "setup.py" ]]; then
    icon=""  # Python project - FIXED: was missing
    # Detect Python framework
    if [[ -f "manage.py" ]] || grep -q "django" requirements.txt pyproject.toml 2>/dev/null; then
      project_indicator=" %F{${POWERLINE_COLORS[success]}}🎯%f"  # Django
    elif grep -q "flask" requirements.txt pyproject.toml 2>/dev/null; then
      project_indicator=" %F{${POWERLINE_COLORS[muted]}}🌶%f"   # Flask
    elif grep -q "fastapi" requirements.txt pyproject.toml 2>/dev/null; then
      project_indicator=" %F{${POWERLINE_COLORS[success]}}⚡%f"  # FastAPI
    else
      project_indicator=" %F{${POWERLINE_COLORS[lime]}}🐍%f"    # Generic Python
    fi
  elif [[ -f "Package.swift" ]]; then
    icon="󰛥"  # Swift project
    project_indicator=" %F{${POWERLINE_COLORS[orange]}}🦉%f"
  elif [[ -f "pubspec.yaml" ]]; then
    icon="󰜘"  # Flutter project
    project_indicator=" %F{${POWERLINE_COLORS[info]}}🦋%f"
  elif [[ -f "Dockerfile" ]]; then
    icon="󰡨"  # Docker project
    project_indicator=" %F{${POWERLINE_COLORS[info]}}🐳%f"
  elif [[ -f "docker-compose.yml" || -f "docker-compose.yaml" ]]; then
    icon="󰡨"  # Docker compose
    project_indicator=" %F{${POWERLINE_COLORS[purple]}}🐙%f"
  elif git rev-parse --git-dir &> /dev/null; then
    icon=""  # Git repository
    project_indicator=" %F{${POWERLINE_COLORS[muted]}}📂%f"
  else
    icon=""  # Regular folder
  fi
  
  # Enhanced smart path truncation with visual hierarchy
  local display_path="$path"
  if [[ ${#path} -gt 35 ]]; then
    # Show first and last parts with beautiful ellipsis
    local parts=(${(s:/:)path})
    if [[ ${#parts[@]} -gt 3 ]]; then
      display_path="${parts[1]}/%F{${POWERLINE_COLORS[muted]}}⋯%f%F{$fg_color}/${parts[-2]}/${parts[-1]}"
    fi
  fi
  
  local segment="%K{$bg_color}%F{$fg_color} $icon $display_path$project_indicator %k%f"
  segment="${segment}%K{${POWERLINE_COLORS[accent]}}%F{$bg_color}${POWERLINE_LEFT_SEP}%k%f"
  
  echo "$segment"
}

# Beautiful git status with comprehensive information and enhanced visuals
powerline_git_segment() {
  if ! git rev-parse --git-dir &> /dev/null 2>&1; then
    return 0
  fi
  
  local bg_color="${POWERLINE_COLORS[accent]}"
  local fg_color="${POWERLINE_COLORS[white]}"
  local branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
  
  # Enhanced git status with beautiful icons and colors
  local staged=$(git diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
  local modified=$(git diff --numstat 2>/dev/null | wc -l | tr -d ' ')
  local untracked=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')
  local ahead=$(git rev-list --count @{upstream}..HEAD 2>/dev/null || echo "0")
  local behind=$(git rev-list --count HEAD..@{upstream} 2>/dev/null || echo "0")
  local stashed=$(git stash list 2>/dev/null | wc -l | tr -d ' ')
  
  # Enhanced status indicators with premium colors and icons
  local status_parts=()
  [[ "$staged" -gt 0 ]] && status_parts+=("%F{${POWERLINE_COLORS[success]}}●$staged%f")     # Bright green staged
  [[ "$modified" -gt 0 ]] && status_parts+=("%F{${POWERLINE_COLORS[warning]}}◆$modified%f") # Golden modified
  [[ "$untracked" -gt 0 ]] && status_parts+=("%F{${POWERLINE_COLORS[error]}}◇$untracked%f") # Red untracked
  [[ "$stashed" -gt 0 ]] && status_parts+=("%F{${POWERLINE_COLORS[purple]}}⚑$stashed%f")    # Purple stashed
  
  # Enhanced remote sync status with beautiful arrows
  local sync_status=""
  if [[ "$ahead" -gt 0 || "$behind" -gt 0 ]]; then
    local sync_color="${POWERLINE_COLORS[orange]}"
    [[ "$ahead" -gt 0 ]] && sync_status="↗$ahead"
    [[ "$behind" -gt 0 ]] && sync_status="${sync_status}↙$behind"
    sync_status=" %F{$sync_color}$sync_status%f"
  fi
  
  # Branch status with enhanced styling
  local branch_icon=""
  if git status --porcelain 2>/dev/null | grep -q .; then
    branch_icon="󰊢"  # Dirty branch
    bg_color="${POWERLINE_COLORS[warning_alt]}"  # Orange background for dirty
  else
    branch_icon="󰊢"  # Clean branch
  fi
  
  local git_info=" $branch_icon $branch"
  [[ ${#status_parts[@]} -gt 0 ]] && git_info="$git_info ${(j: :)status_parts}"
  git_info="$git_info$sync_status"
  
  local segment="%K{$bg_color}%F{$fg_color}$git_info %k%f"
  segment="${segment}%K{${POWERLINE_COLORS[purple]}}%F{$bg_color}${POWERLINE_LEFT_SEP}%k%f"
  
  echo "$segment"
}

# Enhanced language detection with comprehensive framework support
powerline_language_segment() {
  local bg_color="${POWERLINE_COLORS[purple]}"
  local fg_color="${POWERLINE_COLORS[white]}"
  local languages=()
  
  # Node.js with enhanced package manager and framework detection
  if [[ -f "package.json" ]] && command -v node &> /dev/null; then
    local version=$(node --version 2>/dev/null | sed 's/v//' | cut -d'.' -f1,2)
    local pm_icon="󰎙"  # Default npm
    local framework_info=""
    
    # Package manager detection with premium icons
    [[ -f "yarn.lock" ]] && pm_icon="󰒋"     # Yarn
    [[ -f "pnpm-lock.yaml" ]] && pm_icon="󰜚" # PNPM  
    [[ -f "bun.lockb" ]] && pm_icon="󰇴"     # Bun
    
    # Framework detection
    if grep -q "next\|nuxt" package.json 2>/dev/null; then
      framework_info="%F{${POWERLINE_COLORS[accent_alt]}}▲%f"
    elif grep -q "react" package.json 2>/dev/null; then
      framework_info="%F{${POWERLINE_COLORS[info]}}⚛%f"
    elif grep -q "vue" package.json 2>/dev/null; then
      framework_info="%F{${POWERLINE_COLORS[success]}}﴾%f"
    fi
    
    languages+=("$pm_icon $version$framework_info")
  fi
  
  # Python with enhanced virtual environment and framework detection
  if [[ -f "requirements.txt" || -f "pyproject.toml" || -f "setup.py" ]] && command -v python3 &> /dev/null; then
    local version=$(python3 --version 2>/dev/null | cut -d' ' -f2 | cut -d'.' -f1,2)
    local env_icon=""
    local framework_info=""
    
    # Virtual environment detection with visual indicators
    if [[ -n "$VIRTUAL_ENV" ]]; then
      env_icon="%F{${POWERLINE_COLORS[lime]}}($(basename $VIRTUAL_ENV))%f"
    elif [[ -n "$CONDA_DEFAULT_ENV" && "$CONDA_DEFAULT_ENV" != "base" ]]; then
      env_icon="%F{${POWERLINE_COLORS[success_alt]}}($CONDA_DEFAULT_ENV)%f"
    fi
    
    # Framework detection
    if [[ -f "manage.py" ]] || grep -q "django" requirements.txt pyproject.toml 2>/dev/null; then
      framework_info="%F{${POWERLINE_COLORS[success]}}🎯%f"
    elif grep -q "flask" requirements.txt pyproject.toml 2>/dev/null; then
      framework_info="%F{${POWERLINE_COLORS[muted]}}🌶%f"
    elif grep -q "fastapi" requirements.txt pyproject.toml 2>/dev/null; then
      framework_info="%F{${POWERLINE_COLORS[success]}}⚡%f"
    fi
    
    languages+=(
      " $version$env_icon$framework_info"
    )
  fi
  
  # Go with enhanced module detection
  if [[ -f "go.mod" ]] && command -v go &> /dev/null; then
    local version=$(go version 2>/dev/null | awk '{print $3}' | sed 's/go//')
    local framework_info=""
    
    # Go framework detection
    if grep -q "gin-gonic/gin\|gorilla/mux\|echo" go.mod 2>/dev/null; then
      framework_info="%F{${POWERLINE_COLORS[info]}}🌐%f"
    elif grep -q "cobra" go.mod 2>/dev/null; then
      framework_info="%F{${POWERLINE_COLORS[muted]}}🐍%f"
    fi
    
    languages+=("�� $version$framework_info")
  fi
  
  # Rust with enhanced crate detection
  if [[ -f "Cargo.toml" ]] && command -v rustc &> /dev/null; then
    local version=$(rustc --version 2>/dev/null | awk '{print $2}')
    local framework_info=""
    
    # Rust framework detection
    if grep -q "actix-web\|rocket\|warp" Cargo.toml 2>/dev/null; then
      framework_info="%F{${POWERLINE_COLORS[orange]}}🌐%f"
    elif grep -q "tokio" Cargo.toml 2>/dev/null; then
      framework_info="%F{${POWERLINE_COLORS[info]}}⚡%f"
    fi
    
    languages+=("󱘗 $version$framework_info")
  fi
  
  if [[ ${#languages[@]} -gt 0 ]]; then
    local segment="%K{$bg_color}%F{$fg_color} ${(j: | :)languages} %k%f"
    segment="${segment}%K{${POWERLINE_COLORS[info]}}%F{$bg_color}${POWERLINE_LEFT_SEP}%k%f"
    echo "$segment"
  fi
}

# Enhanced system status with comprehensive monitoring and beautiful indicators
powerline_system_segment() {
  local bg_color="${POWERLINE_COLORS[info]}"
  local fg_color="${POWERLINE_COLORS[white]}"
  local system_info=()
  
  # Enhanced battery status with gradient colors (macOS)
  if [[ "$(uname)" == "Darwin" ]] && command -v pmset &> /dev/null; then
    local battery_info=$(pmset -g batt 2>/dev/null | grep -o '[0-9]*%' | head -1)
    local battery_percent=${battery_info%\%}
    local charging_status=$(pmset -g batt 2>/dev/null | grep -o "discharging\|charging\|charged")
    
    if [[ -n "$battery_percent" ]]; then
      local battery_icon="󰁹"  # Full battery
      local battery_color="${POWERLINE_COLORS[success]}"
      
      # Enhanced battery level indicators with precise ranges
      if [[ $battery_percent -le 10 ]]; then
        battery_icon="󰂎"  # Critical
        battery_color="${POWERLINE_COLORS[battery_critical]}"
      elif [[ $battery_percent -le 20 ]]; then
        battery_icon="󰁺"  # Very low
        battery_color="${POWERLINE_COLORS[error]}"
      elif [[ $battery_percent -le 30 ]]; then
        battery_icon="󰁻"  # Low
        battery_color="${POWERLINE_COLORS[error_alt]}"
      elif [[ $battery_percent -le 50 ]]; then
        battery_icon="󰁼"  # Medium low
        battery_color="${POWERLINE_COLORS[warning]}"
      elif [[ $battery_percent -le 70 ]]; then
        battery_icon="󰁽"  # Medium
        battery_color="${POWERLINE_COLORS[warning_alt]}"
      elif [[ $battery_percent -le 90 ]]; then
        battery_icon="󰁾"  # High
        battery_color="${POWERLINE_COLORS[success_alt]}"
      else
        battery_icon="󰁹"  # Full
        battery_color="${POWERLINE_COLORS[success]}"
      fi
      
      # Charging indicator
      local charge_indicator=""
      if [[ "$charging_status" == "charging" ]]; then
        charge_indicator="󰂄"  # Charging bolt
        battery_color="${POWERLINE_COLORS[accent]}"
      elif [[ "$charging_status" == "charged" ]]; then
        charge_indicator="󰚥"  # Plugged
        battery_color="${POWERLINE_COLORS[success]}"
      fi
      
      system_info+=("%F{$battery_color}$battery_icon$charge_indicator%f $battery_percent")
    fi
  fi
  
  # Enhanced Docker containers with service detection
  if command -v docker &> /dev/null && docker info &> /dev/null 2>&1; then
    local containers=$(docker ps -q 2>/dev/null | wc -l | tr -d ' ')
    local total_containers=$(docker ps -a -q 2>/dev/null | wc -l | tr -d ' ')
    
    if [[ "$containers" -gt 0 ]]; then
      local docker_color="${POWERLINE_COLORS[info]}"
      [[ "$containers" != "$total_containers" ]] && docker_color="${POWERLINE_COLORS[warning]}"
      system_info+=("%F{$docker_color}󰡨%f $containers")
    fi
  fi
  
  # Kubernetes context detection
  if command -v kubectl &> /dev/null && kubectl config current-context &> /dev/null 2>&1; then
    local k8s_context=$(kubectl config current-context 2>/dev/null | cut -d'/' -f1)
    if [[ -n "$k8s_context" && "$k8s_context" != "docker-desktop" ]]; then
      system_info+=("%F{${POWERLINE_COLORS[purple]}}☸%f ${k8s_context:0:8}")
    fi
  fi
  
  # Load average (Linux/macOS)
  if [[ "$(uname)" == "Linux" ]] && [[ -f /proc/loadavg ]]; then
    local load=$(cut -d' ' -f1 /proc/loadavg)
    local load_int=${load%.*}
    local load_color="${POWERLINE_COLORS[success]}"
    
    [[ $load_int -gt 2 ]] && load_color="${POWERLINE_COLORS[warning]}"
    [[ $load_int -gt 4 ]] && load_color="${POWERLINE_COLORS[error]}"
    
    system_info+=("%F{$load_color}󰑮%f $load")
  elif [[ "$(uname)" == "Darwin" ]]; then
    local load=$(uptime 2>/dev/null | awk -F'load averages: ' '{print $2}' | cut -d' ' -f1)
    if [[ -n "$load" ]]; then
      local load_int=${load%.*}
      local load_color="${POWERLINE_COLORS[success]}"
      
      [[ $load_int -gt 2 ]] && load_color="${POWERLINE_COLORS[warning]}"
      [[ $load_int -gt 4 ]] && load_color="${POWERLINE_COLORS[error]}"
      
      system_info+=("%F{$load_color}󰑮%f $load")
    fi
  fi
  
  # Memory usage (if available)
  if command -v free &> /dev/null; then
    local mem_percent=$(free | awk 'NR==2{printf "%.0f", $3*100/($3+$7)}')
    if [[ -n "$mem_percent" ]]; then
      local mem_color="${POWERLINE_COLORS[success]}"
      [[ $mem_percent -gt 70 ]] && mem_color="${POWERLINE_COLORS[warning]}"
      [[ $mem_percent -gt 85 ]] && mem_color="${POWERLINE_COLORS[error]}"
      
      system_info+=("%F{$mem_color}󰍛%f ${mem_percent}%")
    fi
  fi
  
  if [[ ${#system_info[@]} -gt 0 ]]; then
    local segment="%K{$bg_color}%F{$fg_color} ${(j: | :)system_info} %k%f"
    segment="${segment}%F{$bg_color}${POWERLINE_LEFT_SEP}%f"
    echo "$segment"
  fi
}

# Build the complete powerline prompt
build_powerline_prompt() {
  local current_time=$(date +%s)
  
  # Use cache if still valid
  if [[ $((current_time - POWERLINE_CACHE_TIME)) -lt $POWERLINE_CACHE_TTL && -n "$POWERLINE_CACHE_CONTENT" ]]; then
    echo "$POWERLINE_CACHE_CONTENT"
    return
  fi
  
  local prompt_content=""
  prompt_content+="$(powerline_user_segment)"
  prompt_content+="$(powerline_directory_segment)"
  prompt_content+="$(powerline_git_segment)"
  prompt_content+="$(powerline_language_segment)"
  prompt_content+="$(powerline_system_segment)"
  
  # Cache the result
  POWERLINE_CACHE_TIME=$current_time
  POWERLINE_CACHE_CONTENT="$prompt_content"
  
  echo "$prompt_content"
}

# Beautiful right prompt with timing
powerline_rprompt() {
  local parts=()
  
  # Execution time with beautiful formatting
  if [[ -n "$DOTFILES_CMD_EXEC_TIME" && "$DOTFILES_CMD_EXEC_TIME" != "0ms" ]]; then
    local time_color="246"  # Light gray
    local time_icon="󰄉"
    
    # Color code based on execution time
    if [[ "$DOTFILES_CMD_EXEC_TIME" == *"m"* ]]; then
      time_color="196"  # Bright red
      time_icon="󰅐"
    elif [[ "${DOTFILES_CMD_EXEC_TIME%ms}" -gt 5000 ]]; then
      time_color="220"  # Golden yellow
      time_icon="󰄉"
    fi
    
    parts+=("%F{$time_color}$time_icon $DOTFILES_CMD_EXEC_TIME%f")
  fi
  
  # Beautiful timestamp
  parts+=("%F{246}󰥔 %D{%H:%M:%S}%f")
  
  echo "${(j: | :)parts}"
}

# Command execution hooks
powerline_preexec() {
  # Only run if powerline theme is active
  [[ "$(get_saved_theme)" != "powerline" ]] && return
  
  DOTFILES_CMD_START_TIME=$(date +%s 2>/dev/null || echo 0)
  POWERLINE_CACHE_TIME=0  # Clear cache
}

powerline_precmd() {
  # Only run if powerline theme is active
  [[ "$(get_saved_theme)" != "powerline" ]] && return
  
  # Calculate execution time
  if [[ -n "$DOTFILES_CMD_START_TIME" ]]; then
    local end_time=$(date +%s 2>/dev/null || echo 0)
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
  
  POWERLINE_CACHE_TIME=0  # Clear cache
}

# Load the stunning powerline theme
load_powerline_theme() {
  # Beautiful multi-line prompt
  PROMPT='$(build_powerline_prompt)
%(?..%F{196}✗%f )%F{46}❯%f '
  
  # Right prompt with timing
  RPROMPT='$(powerline_rprompt)'
  
  # Beautiful secondary prompts
  PS2="%F{39}${POWERLINE_RIGHT_THIN}%f "
  PS3="%F{135}Select:%f "
  PS4="%F{246}Debug:%f "
  
  # Hook into command execution
  preexec_functions+=(powerline_preexec)
  precmd_functions+=(powerline_precmd)
  
  echo "🚀 Powerline theme loaded - Full-featured with all segments"
} 