# ~/.dotfiles/zsh/themes/powerline.zsh
# Professional Powerline Theme - UI Designer Enhanced
# Modern color theory with comfortable viewing and sleek aesthetics

# 🎨 UI Designer Color System - Based on HSL color theory and accessibility standards
typeset -A POWERLINE_COLORS
POWERLINE_COLORS=(
  # 🌑 Background Hierarchy - Carefully crafted depth perception
  surface_base     "234"   # Base surface (HSL: 0, 0%, 12%) - comfortable dark
  surface_raised   "237"   # Raised elements (HSL: 0, 0%, 18%) - subtle elevation  
  surface_overlay  "240"   # Overlay content (HSL: 0, 0%, 25%) - clear separation
  surface_high     "243"   # High emphasis (HSL: 0, 0%, 32%) - important content
  
  # 🎯 Primary Brand Colors - Professional blue spectrum
  primary_50       "153"   # Lightest tint (HSL: 220, 100%, 95%)
  primary_100      "117"   # Light tint (HSL: 220, 90%, 85%)  
  primary_200      "81"    # Medium light (HSL: 220, 80%, 75%)
  primary_400      "75"    # Medium (HSL: 220, 70%, 65%)
  primary_600      "39"    # Brand primary (HSL: 220, 100%, 55%)
  primary_700      "33"    # Dark (HSL: 220, 100%, 45%)
  primary_900      "27"    # Darkest (HSL: 220, 100%, 25%)
  
  # 🟢 Success Semantic Colors - Harmonious green spectrum
  success_50       "158"   # Light success background
  success_100      "121"   # Success container
  success_400      "83"    # Success emphasis  
  success_600      "47"    # Primary success (HSL: 134, 61%, 41%)
  success_700      "41"    # Dark success
  success_900      "22"    # Deep success
  
  # 🟡 Warning Semantic Colors - Warm, accessible yellows
  warning_50       "229"   # Light warning background
  warning_100      "228"   # Warning container
  warning_400      "221"   # Warning emphasis
  warning_600      "214"   # Primary warning (HSL: 45, 93%, 58%)
  warning_700      "208"   # Dark warning
  warning_900      "136"   # Deep warning
  
  # 🔴 Error Semantic Colors - Clear but not aggressive reds
  error_50         "224"   # Light error background  
  error_100        "210"   # Error container
  error_400        "204"   # Error emphasis
  error_600        "167"   # Primary error (HSL: 0, 84%, 60%)
  error_700        "161"   # Dark error
  error_900        "124"   # Deep error
  
  # 💜 Accent Colors - Sophisticated purple spectrum for variety
  accent_purple    "141"   # Soft purple (HSL: 300, 47%, 67%)
  accent_magenta   "177"   # Vibrant magenta
  accent_violet    "99"    # Deep violet
  accent_pink      "212"   # Soft pink
  
  # 🧑‍💻 Code Syntax Colors - Optimized for readability
  syntax_keyword   "68"    # Keywords (HSL: 195, 100%, 50%)
  syntax_string    "107"   # Strings (HSL: 95, 38%, 62%)
  syntax_number    "173"   # Numbers (HSL: 25, 85%, 55%)
  syntax_comment   "102"   # Comments (HSL: 60, 5%, 55%)
  
  # ⚪ Neutral Text Colors - Perfect for long reading sessions
  text_primary     "255"   # High emphasis text (100% white)
  text_secondary   "250"   # Medium emphasis (HSL: 0, 0%, 93%)
  text_tertiary    "245"   # Low emphasis (HSL: 0, 0%, 87%)
  text_disabled    "240"   # Disabled text (HSL: 0, 0%, 75%)
  text_inverse     "236"   # Dark text for light backgrounds
  
  # 🎨 Status Indicator Colors - Context-aware and accessible
  online_status    "46"    # Online/active status
  away_status      "214"   # Away/busy status  
  offline_status   "243"   # Offline/inactive status
  
  # 🛡️ Security Context Colors - Clear hierarchy for trust levels
  secure_context   "42"    # Secure/trusted (deep green)
  warning_context  "226"   # Caution required (bright yellow)
  danger_context   "196"   # High risk (bright red)
  
  # 🌈 Interactive Element Colors - Modern UI feedback
  hover_overlay    "59"    # Hover state overlay
  focus_ring       "75"    # Focus indicator ring
  selection_bg     "60"    # Text selection background
  
  # 📊 Data Visualization Colors - Distinguishable and accessible
  data_blue        "75"    # Primary data color
  data_green       "83"    # Secondary data color  
  data_orange      "214"   # Tertiary data color
  data_purple      "141"   # Quaternary data color
  data_red         "167"   # Alert data color
)

# 🎨 Modern Powerline Separators - Refined visual weight
POWERLINE_LEFT_SEP=""       # Primary separator
POWERLINE_RIGHT_SEP=""      # Reverse separator  
POWERLINE_LEFT_THIN=""      # Subtle separator
POWERLINE_RIGHT_THIN=""     # Reverse subtle
POWERLINE_LEFT_ROUND=""     # Rounded separator (modern alternative)
POWERLINE_RIGHT_ROUND=""    # Reverse rounded

# ⚡ Performance Optimization - Intelligent caching
POWERLINE_CACHE_TTL=2       # Slightly longer for stability
POWERLINE_CACHE_TIME=0
POWERLINE_CACHE_CONTENT=""

# 🖥️ Enhanced OS Detection with Modern Icons
powerline_os_icon() {
  case "$(uname)" in
    "Darwin") 
      # macOS version detection for refined icons
      local macos_version=$(sw_vers -productVersion 2>/dev/null | cut -d'.' -f1)
      if [[ "$macos_version" -ge 13 ]]; then
        echo "󰀵"  # Modern macOS (Ventura+)
      else
        echo "󰀵"  # Classic macOS
      fi
      ;;
    "Linux") 
      # Sophisticated Linux distribution detection
      if [[ -f /etc/arch-release ]]; then
        echo "󰣇"  # Arch Linux
      elif [[ -f /etc/debian_version ]]; then
        if grep -q "Ubuntu" /etc/os-release 2>/dev/null; then
          echo "󰕈"  # Ubuntu
        else
          echo "󰣚"  # Debian
        fi
      elif [[ -f /etc/fedora-release ]]; then
        echo "󰣛"  # Fedora
      elif [[ -f /etc/redhat-release ]]; then
        echo "󱄛"  # Red Hat/CentOS
      elif [[ -f /etc/SUSE-brand ]] || [[ -f /etc/SuSE-release ]]; then
        echo "󰠳"  # SUSE
      elif [[ -f /etc/gentoo-release ]]; then
        echo "󰣨"  # Gentoo
      else
        echo "󰌽"  # Generic Linux
      fi
      ;;
    "Windows"*|"CYGWIN"*|"MSYS"*|"MINGW"*) echo "󰍲" ;;    # Windows
    "FreeBSD") echo "󰣚" ;;     # FreeBSD
    "OpenBSD") echo "󰈿" ;;     # OpenBSD  
    "NetBSD") echo "󰈿" ;;      # NetBSD
    *) echo "󰟀" ;;             # Generic computer
  esac
}

# 🎭 Premium User Context - Modern status indication
powerline_user_segment() {
  local bg_color="${POWERLINE_COLORS[surface_raised]}"
  local fg_color="${POWERLINE_COLORS[text_primary]}"
  local icon="$(powerline_os_icon)"
  local username="%n"
  local status_indicator=""
  
  # 🔐 Enhanced Security Context Styling
  if [[ $EUID -eq 0 ]]; then
    bg_color="${POWERLINE_COLORS[danger_context]}"
    fg_color="${POWERLINE_COLORS[text_primary]}"
    icon="󰀇"  # Crown for root
    username="ROOT"
    status_indicator="⚠"  # Warning indicator
  elif [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" ]]; then
    bg_color="${POWERLINE_COLORS[warning_context]}"
    fg_color="${POWERLINE_COLORS[text_inverse]}"  # Dark text on bright background
    icon="󰢹"  # SSH icon
    status_indicator="🔗"  # Connection indicator
  elif [[ -n "$TMUX" ]]; then
    bg_color="${POWERLINE_COLORS[primary_600]}"
    fg_color="${POWERLINE_COLORS[text_primary]}"
    icon="󰙀"  # TMUX icon
    status_indicator="📺"  # Multiplexer indicator
  elif [[ -n "$VSCODE_INJECTION" ]]; then
    bg_color="${POWERLINE_COLORS[accent_purple]}"
    fg_color="${POWERLINE_COLORS[text_primary]}"
    icon="󰨞"  # VS Code icon
    status_indicator="💻"  # Editor indicator
  fi
  
  # 🎨 Beautiful segment composition with modern spacing
  local segment="%K{$bg_color}%F{$fg_color} $icon $username"
  [[ -n "$status_indicator" ]] && segment="$segment $status_indicator"
  segment="$segment %k%f"
  segment="${segment}%K{${POWERLINE_COLORS[surface_overlay]}}%F{$bg_color}${POWERLINE_LEFT_SEP}%k%f"
  
  echo "$segment"
}

# 📁 Intelligent Directory Display - Modern project awareness
powerline_directory_segment() {
  local bg_color="${POWERLINE_COLORS[surface_overlay]}"
  local fg_color="${POWERLINE_COLORS[text_primary]}"
  local path="${PWD/#$HOME/~}"
  local icon=""
  local project_badge=""
  local tech_indicator=""
  
  # 🏠 Enhanced Context Detection with Modern Icons
  if [[ "$PWD" == "$HOME" ]]; then
    icon="󰋜"  # Home
    bg_color="${POWERLINE_COLORS[primary_600]}"
  elif [[ -f "package.json" ]]; then
    icon="󰜫"  # Node.js
    bg_color="${POWERLINE_COLORS[syntax_keyword]}"
    
    # 🚀 Modern Framework Detection with Refined Badges
    if grep -q "\"next\":\|\"@next/\|\"next@\"" package.json 2>/dev/null; then
      tech_indicator="%F{${POWERLINE_COLORS[text_primary]}}▲%f"  # Next.js
    elif grep -q "\"react\":\|\"@types/react\"" package.json 2>/dev/null; then
      tech_indicator="%F{${POWERLINE_COLORS[primary_100]}}⚛%f"  # React  
    elif grep -q "\"vue\":\|\"@vue/\"" package.json 2>/dev/null; then
      tech_indicator="%F{${POWERLINE_COLORS[success_400]}}﴾%f"  # Vue
    elif grep -q "\"@angular/\"" package.json 2>/dev/null; then
      tech_indicator="%F{${POWERLINE_COLORS[error_600]}}🅰%f"   # Angular
    elif grep -q "\"svelte\":" package.json 2>/dev/null; then
      tech_indicator="%F{${POWERLINE_COLORS[warning_600]}}🔥%f" # Svelte
    elif grep -q "\"typescript\":" package.json 2>/dev/null; then
      tech_indicator="%F{${POWERLINE_COLORS[primary_200]}}TS%f" # TypeScript
    fi
  elif [[ -f "requirements.txt" || -f "pyproject.toml" || -f "setup.py" ]]; then
    icon=""  # Python
    bg_color="${POWERLINE_COLORS[syntax_string]}"
    
    # 🐍 Python Framework Detection  
    if [[ -f "manage.py" ]] || grep -q "django" requirements.txt pyproject.toml 2>/dev/null; then
      tech_indicator="%F{${POWERLINE_COLORS[success_600]}}🎯%f"  # Django
    elif grep -q "flask" requirements.txt pyproject.toml 2>/dev/null; then
      tech_indicator="%F{${POWERLINE_COLORS[text_secondary]}}🌶%f"  # Flask
    elif grep -q "fastapi" requirements.txt pyproject.toml 2>/dev/null; then
      tech_indicator="%F{${POWERLINE_COLORS[success_400]}}⚡%f"   # FastAPI
    elif grep -q "streamlit" requirements.txt pyproject.toml 2>/dev/null; then
      tech_indicator="%F{${POWERLINE_COLORS[error_600]}}📊%f"    # Streamlit
    else
      tech_indicator="%F{${POWERLINE_COLORS[warning_600]}}🐍%f"  # Generic Python
    fi
  elif [[ -f "Cargo.toml" ]]; then
    icon="󱘗"  # Rust
    bg_color="${POWERLINE_COLORS[syntax_number]}"
    tech_indicator="%F{${POWERLINE_COLORS[warning_700]}}🦀%f"
  elif [[ -f "go.mod" ]]; then
    icon="󰟓"  # Go
    bg_color="${POWERLINE_COLORS[primary_200]}"
    tech_indicator="%F{${POWERLINE_COLORS[primary_700]}}🐹%f"
  elif [[ -f "Package.swift" ]]; then
    icon="󰛥"  # Swift
    bg_color="${POWERLINE_COLORS[warning_600]}"
    tech_indicator="%F{${POWERLINE_COLORS[text_primary]}}🦉%f"
  elif [[ -f "pubspec.yaml" ]]; then
    icon="󰜘"  # Flutter
    bg_color="${POWERLINE_COLORS[primary_400]}"
    tech_indicator="%F{${POWERLINE_COLORS[text_primary]}}🦋%f"
  elif [[ -f "Dockerfile" ]]; then
    icon="󰡨"  # Docker
    bg_color="${POWERLINE_COLORS[primary_600]}"
    tech_indicator="%F{${POWERLINE_COLORS[text_primary]}}🐳%f"
  elif [[ -f "docker-compose.yml" || -f "docker-compose.yaml" ]]; then
    icon="󰡨"  # Docker Compose
    bg_color="${POWERLINE_COLORS[accent_purple]}"
    tech_indicator="%F{${POWERLINE_COLORS[text_primary]}}🐙%f"
  elif git rev-parse --git-dir &> /dev/null; then
    icon=""  # Git repository
    bg_color="${POWERLINE_COLORS[surface_overlay]}"
    tech_indicator="%F{${POWERLINE_COLORS[text_tertiary]}}📂%f"
  else
    icon=""  # Regular folder
    bg_color="${POWERLINE_COLORS[text_disabled]}"
  fi
  
  # 🎨 Sophisticated Path Truncation with Visual Hierarchy
  local display_path="$path"
  if [[ ${#path} -gt 40 ]]; then
    local parts=(${(s:/:)path})
    if [[ ${#parts[@]} -gt 3 ]]; then
      # Modern ellipsis with subtle color differentiation
      display_path="${parts[1]}/%F{${POWERLINE_COLORS[text_tertiary]}}⋯%f%F{$fg_color}/${parts[-2]}/${parts[-1]}"
    fi
  fi
  
  # 🏗️ Modern segment composition
  local segment="%K{$bg_color}%F{$fg_color} $icon $display_path"
  [[ -n "$tech_indicator" ]] && segment="$segment $tech_indicator"
  segment="$segment %k%f"
  segment="${segment}%K{${POWERLINE_COLORS[primary_600]}}%F{$bg_color}${POWERLINE_LEFT_SEP}%k%f"
  
  echo "$segment"
}

# 🌿 Beautiful Git Status - Modern version control visualization
powerline_git_segment() {
  if ! git rev-parse --git-dir &> /dev/null 2>&1; then
    return 0
  fi
  
  local bg_color="${POWERLINE_COLORS[primary_600]}"
  local fg_color="${POWERLINE_COLORS[text_primary]}"
  local branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
  
  # 📊 Comprehensive Git Status Analysis
  local staged=$(git diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
  local modified=$(git diff --numstat 2>/dev/null | wc -l | tr -d ' ')
  local untracked=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')
  local ahead=$(git rev-list --count @{upstream}..HEAD 2>/dev/null || echo "0")
  local behind=$(git rev-list --count HEAD..@{upstream} 2>/dev/null || echo "0")
  local stashed=$(git stash list 2>/dev/null | wc -l | tr -d ' ')
  local conflicts=$(git diff --name-only --diff-filter=U 2>/dev/null | wc -l | tr -d ' ')
  
  # 🎨 Modern Branch Status with Semantic Colors
  local branch_icon="󰊢"
  local status_color="${POWERLINE_COLORS[success_600]}"  # Clean state
  
  if [[ "$conflicts" -gt 0 ]]; then
    branch_icon="󰋪"  # Merge conflict
    bg_color="${POWERLINE_COLORS[error_600]}"
    status_color="${POWERLINE_COLORS[text_primary]}"
  elif [[ "$staged" -gt 0 ]]; then
    branch_icon="󰐗"  # Staged changes
    bg_color="${POWERLINE_COLORS[success_600]}"
    status_color="${POWERLINE_COLORS[text_primary]}"
  elif [[ "$modified" -gt 0 ]]; then
    branch_icon="󰄬"  # Modified files
    bg_color="${POWERLINE_COLORS[warning_600]}"
    status_color="${POWERLINE_COLORS[text_inverse]}"
  elif [[ "$untracked" -gt 0 ]]; then
    branch_icon="󰐕"  # Untracked files
    bg_color="${POWERLINE_COLORS[error_400]}"
    status_color="${POWERLINE_COLORS[text_primary]}"
  fi
  
  # 🏷️ Enhanced Status Indicators with Modern Icons
  local status_parts=()
  
  # 🟢 Staged changes with checkmark
  [[ "$staged" -gt 0 ]] && status_parts+=("%F{${POWERLINE_COLORS[success_600]}}✓$staged%f")
  
  # 🟡 Modified files with diamond
  [[ "$modified" -gt 0 ]] && status_parts+=("%F{${POWERLINE_COLORS[warning_600]}}◆$modified%f")
  
  # 🔴 Untracked files with plus
  [[ "$untracked" -gt 0 ]] && status_parts+=("%F{${POWERLINE_COLORS[error_600]}}+$untracked%f")
  
  # 💜 Stashed changes with bookmark
  [[ "$stashed" -gt 0 ]] && status_parts+=("%F{${POWERLINE_COLORS[accent_purple]}}📑$stashed%f")
  
  # ⚠️ Merge conflicts with warning
  [[ "$conflicts" -gt 0 ]] && status_parts+=("%F{${POWERLINE_COLORS[error_700]}}⚠$conflicts%f")
  
  # 🔄 Enhanced Remote Sync Status with Modern Arrows
  local sync_status=""
  if [[ "$ahead" -gt 0 && "$behind" -gt 0 ]]; then
    # Diverged state
    sync_status=" %F{${POWERLINE_COLORS[warning_700]}}⇅$ahead/$behind%f"
  elif [[ "$ahead" -gt 0 ]]; then
    # Ahead of remote
    sync_status=" %F{${POWERLINE_COLORS[primary_200]}}↗$ahead%f"
  elif [[ "$behind" -gt 0 ]]; then
    # Behind remote  
    sync_status=" %F{${POWERLINE_COLORS[error_400]}}↙$behind%f"
  elif git rev-parse --verify @{upstream} &>/dev/null; then
    # Up to date with remote
    sync_status=" %F{${POWERLINE_COLORS[success_400]}}✓%f"
  fi
  
  # 🏗️ Beautiful Git Segment Composition
  local git_info=" $branch_icon $branch"
  
  # Add status indicators with spacing
  if [[ ${#status_parts[@]} -gt 0 ]]; then
    git_info="$git_info %F{${POWERLINE_COLORS[text_tertiary]}}[%f${(j: :)status_parts}%F{${POWERLINE_COLORS[text_tertiary]}}]%f"
  fi
  
  # Add sync status
  git_info="$git_info$sync_status"
  
  # 🎨 Final segment with next transition
  local segment="%K{$bg_color}%F{$fg_color}$git_info %k%f"
  segment="${segment}%K{${POWERLINE_COLORS[accent_purple]}}%F{$bg_color}${POWERLINE_LEFT_SEP}%k%f"
  
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
    
    languages+=("$version$framework_info")
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
    
    languages+=("$version$framework_info")
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