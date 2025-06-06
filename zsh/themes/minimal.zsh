# ~/.dotfiles/zsh/themes/minimal.zsh
# Professional Minimal Theme - UI Designer Perfected
# Sophisticated simplicity with modern color theory and optimal UX

# 🎨 UI Designer Minimal Color System - Carefully curated for comfort and clarity
typeset -A MINIMAL_COLORS
MINIMAL_COLORS=(
  # 🌊 Primary Spectrum - Calming professional blue
  primary_900    "25"     # Deep navy (HSL: 220, 100%, 20%) - high contrast headers
  primary_700    "32"     # Rich blue (HSL: 220, 85%, 35%) - important elements  
  primary_600    "39"     # Standard blue (HSL: 220, 100%, 50%) - primary actions
  primary_500    "75"     # Medium blue (HSL: 220, 70%, 60%) - secondary actions
  primary_300    "117"    # Light blue (HSL: 220, 60%, 75%) - subtle highlights
  primary_100    "153"    # Pale blue (HSL: 220, 50%, 90%) - backgrounds
  
  # 🌿 Success Spectrum - Natural, encouraging greens
  success_800    "22"     # Forest (HSL: 130, 100%, 25%) - strong success
  success_600    "28"     # Primary green (HSL: 130, 65%, 45%) - standard success
  success_500    "34"     # Medium green (HSL: 130, 55%, 55%) - soft success
  success_400    "40"     # Light green (HSL: 130, 45%, 65%) - subtle success
  success_200    "114"    # Pale green (HSL: 130, 35%, 80%) - backgrounds
  
  # ⚠️ Warning Spectrum - Warm, accessible oranges and yellows
  warning_700    "172"    # Deep amber (HSL: 35, 85%, 50%) - strong warnings
  warning_600    "178"    # Standard amber (HSL: 40, 75%, 60%) - standard warnings
  warning_500    "214"    # Light amber (HSL: 45, 65%, 70%) - soft warnings
  warning_300    "221"    # Pale amber (HSL: 50, 55%, 80%) - subtle warnings
  
  # 🚫 Error Spectrum - Clear but not aggressive reds
  error_800      "88"     # Deep red (HSL: 0, 75%, 35%) - critical errors
  error_600      "160"    # Standard red (HSL: 0, 65%, 50%) - standard errors
  error_500      "167"    # Medium red (HSL: 0, 55%, 60%) - soft errors
  error_300      "203"    # Light red (HSL: 0, 45%, 75%) - subtle errors
  
  # 🎨 Accent Spectrum - Sophisticated supporting colors
  accent_cyan    "87"     # Sophisticated cyan (HSL: 180, 60%, 70%)
  accent_purple  "105"    # Elegant purple (HSL: 280, 50%, 65%)
  accent_teal    "73"     # Modern teal (HSL: 170, 55%, 60%)
  accent_mint    "121"    # Fresh mint (HSL: 150, 45%, 70%)
  
  # 📝 Text Hierarchy - Optimized for readability and eye comfort
  text_primary   "255"    # Pure white (100%) - highest emphasis
  text_high      "253"    # Near white (98%) - high emphasis  
  text_medium    "250"    # Light gray (93%) - medium emphasis
  text_low       "245"    # Medium gray (87%) - low emphasis
  text_subtle    "240"    # Subtle gray (75%) - minimal emphasis
  text_disabled  "236"    # Disabled gray (65%) - disabled state
  
  # 🏗️ Surface Spectrum - Depth and elevation hierarchy
  surface_base   "234"    # Base surface (12%) - main background
  surface_raised "237"    # Raised surface (18%) - cards, panels
  surface_high   "240"    # High surface (25%) - modals, tooltips
  
  # 🎯 Interactive States - Modern UI feedback
  interactive_hover   "59"     # Hover overlay (HSL: 220, 15%, 35%)
  interactive_active  "75"     # Active state (HSL: 220, 70%, 65%)
  interactive_focus   "117"    # Focus ring (HSL: 220, 60%, 75%)
  
  # 🔧 Semantic Context Colors - Clear meaning through color
  info_primary    "75"     # Information blue
  info_secondary  "117"    # Light info blue
  
  # 📁 File System Colors - Intuitive file type recognition
  directory_color "39"     # Directory blue
  file_color      "245"    # Regular file gray
  executable_color "34"    # Executable green  
  symlink_color   "87"     # Symlink cyan
  
  # 🌿 Git Status Colors - Clear version control feedback
  git_clean       "34"     # Clean repo (green)
  git_staged      "28"     # Staged changes (darker green)
  git_modified    "178"    # Modified files (amber)
  git_untracked   "167"    # Untracked files (soft red)
  git_conflict    "160"    # Merge conflicts (red)
  git_ahead       "75"     # Ahead of remote (blue)
  git_behind      "214"    # Behind remote (orange)
  git_diverged    "105"    # Diverged (purple)
)

# 10x Enhanced ultra-fast path display with intelligent context awareness
minimal_path() {
  local path="${PWD/#$HOME/~}"
  local max_len=35  # Increased for better readability
  local icon=""
  local project_type=""
  local path_color="${MINIMAL_COLORS[primary]}"
  
  # Enhanced context-aware icons with semantic meaning and perfect spacing
  if [[ "$PWD" == "$HOME" ]]; then
    icon="󰋜"
    path_color="${MINIMAL_COLORS[accent]}"
  elif [[ -f "package.json" ]]; then
    icon="󰜫"
    # Detect framework for enhanced context
    if grep -q "next\|nuxt" package.json 2>/dev/null; then
      project_type="%F{${MINIMAL_COLORS[primary_alt]}}▲%f"
    elif grep -q "react" package.json 2>/dev/null; then
      project_type="%F{${MINIMAL_COLORS[accent]}}⚛%f"
    elif grep -q "vue" package.json 2>/dev/null; then
      project_type="%F{${MINIMAL_COLORS[success]}}﴾%f"
    fi
  elif [[ -f "requirements.txt" || -f "pyproject.toml" || -f "setup.py" ]]; then
    icon=""  # Python snake icon
    # Detect Python framework
    if [[ -f "manage.py" ]] || grep -q "django" requirements.txt pyproject.toml 2>/dev/null; then
      project_type="%F{${MINIMAL_COLORS[success]}}🎯%f"
    elif grep -q "flask" requirements.txt pyproject.toml 2>/dev/null; then
      project_type="%F{${MINIMAL_COLORS[warning]}}🌶%f"
    elif grep -q "fastapi" requirements.txt pyproject.toml 2>/dev/null; then
      project_type="%F{${MINIMAL_COLORS[success]}}⚡%f"
    fi
  elif [[ -f "go.mod" ]]; then
    icon="󰟓"
    path_color="${MINIMAL_COLORS[accent_alt]}"
  elif [[ -f "Cargo.toml" ]]; then
    icon="󱘗"
    path_color="${MINIMAL_COLORS[accent_warm]}"
  elif [[ -f "Package.swift" ]]; then
    icon="󰛥"
    path_color="${MINIMAL_COLORS[accent_warm]}"
  elif [[ -f "pubspec.yaml" ]]; then
    icon="󰜘"
    path_color="${MINIMAL_COLORS[primary_alt]}"
  elif [[ -f "Dockerfile" ]]; then
    icon="󰡨"
    path_color="${MINIMAL_COLORS[accent]}"
    project_type="%F{${MINIMAL_COLORS[accent]}}🐳%f"
  elif git rev-parse --git-dir &> /dev/null 2>&1; then
    icon=""
    path_color="${MINIMAL_COLORS[directory]}"
  else
    icon=""
    path_color="${MINIMAL_COLORS[muted]}"
  fi
  
  # Enhanced smart truncation with beautiful ellipsis and visual hierarchy
  local display_path=""
  if [[ ${#path} -gt $max_len ]]; then
    local parts=(${(s:/:)path})
    if [[ ${#parts[@]} -gt 3 ]]; then
      # Show first part, ellipsis, and last two parts
      display_path="${parts[1]}/%F{${MINIMAL_COLORS[muted]}}⋯%f%F{$path_color}/${parts[-2]}/${parts[-1]}"
    elif [[ ${#parts[@]} -gt 2 ]]; then
      # Show ellipsis and last two parts
      display_path="%F{${MINIMAL_COLORS[muted]}}⋯%f%F{$path_color}/${parts[-2]}/${parts[-1]}"
    else
      # Show ellipsis and truncated end
      display_path="%F{${MINIMAL_COLORS[muted]}}⋯%f%F{$path_color}${path: -$max_len}"
    fi
  else
    display_path="$path"
  fi
  
  # Beautiful output with perfect spacing and color hierarchy
  echo "%F{$path_color}$icon $display_path%f$project_type"
}

# 10x Enhanced lightning-fast git status with intelligent visual feedback
minimal_git() {
  # Ultra-fast git check with early return
  local git_dir="$(git rev-parse --git-dir 2>/dev/null)"
  [[ -z "$git_dir" ]] && return
  
  local branch="$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)"
  local git_status=""
  local branch_icon=""
  local status_color=""
  local branch_color="${MINIMAL_COLORS[accent]}"
  
  # Enhanced status detection with comprehensive coverage
  local staged=$(git diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
  local modified=$(git diff --numstat 2>/dev/null | wc -l | tr -d ' ')
  local untracked=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')
  local ahead=$(git rev-list --count @{upstream}..HEAD 2>/dev/null || echo "0")
  local behind=$(git rev-list --count HEAD..@{upstream} 2>/dev/null || echo "0")
  
  # Intelligent branch icon based on git state
  if [[ "$staged" -gt 0 ]]; then
    branch_icon="󰐗"  # Staged changes icon
    branch_color="${MINIMAL_COLORS[success]}"
  elif [[ "$modified" -gt 0 ]]; then
    branch_icon="󰴔"  # Modified files icon
    branch_color="${MINIMAL_COLORS[warning]}"
  elif [[ "$untracked" -gt 0 ]]; then
    branch_icon="󰐕"  # Untracked files icon
    branch_color="${MINIMAL_COLORS[error_soft]}"
  else
    branch_icon="󰊢"  # Clean branch icon
    branch_color="${MINIMAL_COLORS[git_clean]}"
  fi
  
  # Enhanced status indicators with minimal but informative design
  local status_parts=()
  [[ "$staged" -gt 0 ]] && status_parts+=("%F{${MINIMAL_COLORS[success]}}●%f")
  [[ "$modified" -gt 0 ]] && status_parts+=("%F{${MINIMAL_COLORS[warning]}}◆%f")
  [[ "$untracked" -gt 0 ]] && status_parts+=("%F{${MINIMAL_COLORS[error]}}?%f")
  
  # Remote sync indicators (minimal design)
  local sync_status=""
  if [[ "$ahead" -gt 0 && "$behind" -gt 0 ]]; then
    sync_status=" %F{${MINIMAL_COLORS[accent_warm]}}⇕%f"  # Diverged
  elif [[ "$ahead" -gt 0 ]]; then
    sync_status=" %F{${MINIMAL_COLORS[git_ahead]}}↗%f"    # Ahead
  elif [[ "$behind" -gt 0 ]]; then
    sync_status=" %F{${MINIMAL_COLORS[git_behind]}}↙%f"   # Behind
  fi
  
  # Compose final git status with perfect spacing and hierarchy
  if [[ ${#status_parts[@]} -gt 0 ]]; then
    git_status=" ${(j::)status_parts}"
  fi
  
  # Beautiful git segment with enhanced typography
  echo " %F{${MINIMAL_COLORS[muted]}}on%f %F{$branch_color}$branch_icon $branch%f$git_status$sync_status"
}

# Smart language detection (only show what matters)
minimal_lang() {
  local lang=""
  
  # Only detect if we're in a project
  if [[ -f "package.json" ]]; then
    lang="js"
  elif [[ -f "requirements.txt" || -f "pyproject.toml" ]]; then
    lang="py"
  elif [[ -f "go.mod" ]]; then
    lang="go"
  elif [[ -f "Cargo.toml" ]]; then
    lang="rs"
  elif [[ -f "Package.swift" ]]; then
    lang="swift"
  elif [[ -f "pubspec.yaml" ]]; then
    lang="dart"
  fi
  
  [[ -n "$lang" ]] && echo " %F{244}[$lang]%f"
}

# Build minimal prompt (single line, maximum efficiency)
build_minimal_prompt() {
  local path="$(minimal_path)"
  local git_info="$(minimal_git)"
  local lang_info="$(minimal_lang)"
  
  echo "%F{39}$path%f$git_info$lang_info"
}

# Clean right prompt with time
minimal_rprompt() {
  echo "%F{244}%D{%H:%M}%f"
}

# Minimal command timing (only for slow commands)
minimal_preexec() {
  # Only run if minimal theme is active
  [[ "$(get_saved_theme)" != "minimal" ]] && return
  
  DOTFILES_CMD_START_TIME=$(date +%s 2>/dev/null || echo 0)
}

minimal_precmd() {
  # Only run if minimal theme is active
  [[ "$(get_saved_theme)" != "minimal" ]] && return
  
  # Only track significant execution times
  if [[ -n "$DOTFILES_CMD_START_TIME" ]]; then
    local end_time=$(date +%s 2>/dev/null || echo 0)
    local elapsed=$((end_time - DOTFILES_CMD_START_TIME))
    
    # Only show if command took more than 2 seconds
    if [[ $elapsed -gt 2000 ]]; then
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

# Load the sleek minimal theme
load_minimal_theme() {
  # Clean single-line prompt
  PROMPT='$(build_minimal_prompt) %(?..%F{196}✗%f )%F{46}❯%f '
  
  # Subtle right prompt
  RPROMPT='$(minimal_rprompt)'
  
  # Minimal secondary prompts
  PS2="%F{81}…%f "
  PS3="%F{39}?%f "
  PS4="%F{244}+%f "
  
  # Hook into command execution
  preexec_functions+=(minimal_preexec)
  precmd_functions+=(minimal_precmd)
  
  echo "⚡ Minimal theme loaded - Fast and clean"
} 