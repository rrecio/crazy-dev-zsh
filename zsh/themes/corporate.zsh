# ~/.dotfiles/zsh/themes/corporate.zsh
# CORPORATE THEME - Professional, clean, enterprise-ready
# Perfect for work environments, conservative styling, essential information only

autoload -U colors && colors
setopt PROMPT_SUBST

# Corporate color scheme - professional and readable
typeset -A CORP_COLORS
CORP_COLORS=(
  primary "blue"
  secondary "black" 
  accent "cyan"
  success "green"
  warning "yellow"
  error "red"
  muted "8"
)

# Clean directory display
corp_directory() {
  local path="${PWD/#$HOME/~}"
  local display_path="$path"
  
  # Smart path truncation for long paths
  if [[ ${#path} -gt 40 ]]; then
    # If in git repo, show project name + relative path
    if git rev-parse --show-toplevel &> /dev/null; then
      local project_root=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)")
      local relative_path=${PWD#$(git rev-parse --show-toplevel 2>/dev/null)}
      if [[ -n "$relative_path" ]]; then
        display_path="$project_root$relative_path"
      else
        display_path="$project_root"
      fi
    else
      display_path="…${path: -35}"
    fi
  fi
  
  # Simple folder icon
  local icon="📁"
  if git rev-parse --git-dir &> /dev/null; then
    icon="📂"
  fi
  
  echo "%F{${CORP_COLORS[primary]}}$icon $display_path%f"
}

# Professional git status
corp_git_status() {
  if ! git rev-parse --git-dir &> /dev/null 2>&1; then
    return 0
  fi
  
  local branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
  local ahead=$(git rev-list --count @{upstream}..HEAD 2>/dev/null || echo "0")
  local behind=$(git rev-list --count HEAD..@{upstream} 2>/dev/null || echo "0")
  
  # Simple clean/dirty check
  local status_icon=""
  local status_color="${CORP_COLORS[success]}"
  
  if ! git diff --quiet 2>/dev/null || ! git diff --cached --quiet 2>/dev/null; then
    status_icon="●"
    status_color="${CORP_COLORS[warning]}"
  elif [[ -n $(git ls-files --others --exclude-standard 2>/dev/null) ]]; then
    status_icon="+"
    status_color="${CORP_COLORS[error]}"
  else
    status_icon="✓"
    status_color="${CORP_COLORS[success]}"
  fi
  
  local git_info=" %F{${CORP_COLORS[accent]}}git:$branch%f"
  
  # Add sync status for remote tracking
  if [[ "$ahead" -gt 0 || "$behind" -gt 0 ]]; then
    local sync_info=""
    [[ "$ahead" -gt 0 ]] && sync_info="↑$ahead"
    [[ "$behind" -gt 0 ]] && sync_info="${sync_info}↓$behind"
    git_info="$git_info %F{${CORP_COLORS[muted]}}($sync_info)%f"
  fi
  
  git_info="$git_info %F{$status_color}$status_icon%f"
  
  echo "$git_info"
}

# Essential development context
corp_dev_context() {
  local context_parts=()
  
  # Node.js project
  if [[ -f "package.json" ]] && command -v node &> /dev/null; then
    local version=$(node --version 2>/dev/null | sed 's/v//')
    context_parts+=("%F{${CORP_COLORS[success]}}node:$version%f")
  fi
  
  # Python project
  if [[ -f "requirements.txt" || -f "pyproject.toml" || -f "setup.py" ]] && command -v python3 &> /dev/null; then
    local version=$(python3 --version 2>/dev/null | cut -d' ' -f2 | cut -d'.' -f1,2)
    local env_info=""
    
    if [[ -n "$VIRTUAL_ENV" ]]; then
      env_info="($(basename $VIRTUAL_ENV))"
    elif [[ -n "$CONDA_DEFAULT_ENV" && "$CONDA_DEFAULT_ENV" != "base" ]]; then
      env_info="(conda:$CONDA_DEFAULT_ENV)"
    fi
    
    context_parts+=("%F{${CORP_COLORS[warning]}}python:$version$env_info%f")
  fi
  
  # Java project  
  if [[ -f "pom.xml" || -f "build.gradle" ]] && command -v java &> /dev/null; then
    local version=$(java -version 2>&1 | head -1 | cut -d'"' -f2 | cut -d'.' -f1,2)
    context_parts+=("%F{${CORP_COLORS[error]}}java:$version%f")
  fi
  
  # Go project
  if [[ -f "go.mod" ]] && command -v go &> /dev/null; then
    local version=$(go version 2>/dev/null | awk '{print $3}' | sed 's/go//')
    context_parts+=("%F{${CORP_COLORS[accent]}}go:$version%f")
  fi
  
  # .NET project
  if [[ -f "*.csproj" || -f "*.sln" ]] && command -v dotnet &> /dev/null; then
    local version=$(dotnet --version 2>/dev/null | cut -d'.' -f1,2)
    context_parts+=("%F{${CORP_COLORS[primary]}}dotnet:$version%f")
  fi
  
  if [[ ${#context_parts[@]} -gt 0 ]]; then
    echo " ${(j: :)context_parts}"
  fi
}

# Minimal system status for corporate environment
corp_system_status() {
  local status_parts=()
  
  # Only show critical system info
  
  # Docker containers (if running)
  if command -v docker &> /dev/null && docker info &> /dev/null 2>&1; then
    local containers=$(docker ps -q 2>/dev/null | wc -l | tr -d ' ')
    if [[ "$containers" -gt 0 ]]; then
      status_parts+=("%F{${CORP_COLORS[accent]}}docker:$containers%f")
    fi
  fi
  
  # Kubernetes context (if configured)
  if command -v kubectl &> /dev/null; then
    local k8s_context=$(kubectl config current-context 2>/dev/null)
    if [[ -n "$k8s_context" ]]; then
      # Truncate long context names
      local short_context="${k8s_context##*/}"
      if [[ ${#short_context} -gt 15 ]]; then
        short_context="${short_context:0:12}…"
      fi
      status_parts+=("%F{${CORP_COLORS[primary]}}k8s:$short_context%f")
    fi
  fi
  
  if [[ ${#status_parts[@]} -gt 0 ]]; then
    echo " ${(j: :)status_parts}"
  fi
}

# Build corporate prompt
build_corp_prompt() {
  local directory="$(corp_directory)"
  local git_status="$(corp_git_status)"
  local dev_context="$(corp_dev_context)"
  local system_status="$(corp_system_status)"
  
  echo "$directory$git_status$dev_context$system_status"
}

# Professional right prompt
corp_rprompt() {
  local parts=()
  
  # Show execution time for slow commands
  if [[ -n "$DOTFILES_CMD_EXEC_TIME" && "$DOTFILES_CMD_EXEC_TIME" != "0ms" ]]; then
    # Only show if command took significant time
    if [[ "$DOTFILES_CMD_EXEC_TIME" == *"s" ]] || [[ "${DOTFILES_CMD_EXEC_TIME%ms}" -gt 2000 ]]; then
      parts+=("%F{${CORP_COLORS[muted]}}⏱ $DOTFILES_CMD_EXEC_TIME%f")
    fi
  fi
  
  # Professional timestamp
  parts+=("%F{${CORP_COLORS[muted]}}%D{%H:%M}%f")
  
  echo "${(j: :)parts}"
}

# Corporate command timing
corp_preexec() {
  # Only run if corporate theme is active
  [[ "$(get_saved_theme)" != "corporate" ]] && return
  
  DOTFILES_CMD_START_TIME=$(date +%s 2>/dev/null || echo 0)
}

corp_precmd() {
  # Only run if corporate theme is active
  [[ "$(get_saved_theme)" != "corporate" ]] && return
  
  # Calculate execution time
  if [[ -n "$DOTFILES_CMD_START_TIME" ]]; then
    local end_time=$(date +%s 2>/dev/null || echo 0)
    local elapsed=$((end_time - DOTFILES_CMD_START_TIME))
    
    if [[ $elapsed -gt 2000 ]]; then  # Only track longer commands
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

# Load the corporate theme
load_corporate_theme() {
  # Clean, professional single-line prompt
  PROMPT='$(build_corp_prompt) %(?..%F{${CORP_COLORS[error]}}✗ %f)%F{${CORP_COLORS[success]}}❯%f '
  
  # Minimal right prompt
  RPROMPT='$(corp_rprompt)'
  
  # Professional secondary prompts
  PS2="%F{${CORP_COLORS[accent]}}❯ %f"
  PS3="%F{${CORP_COLORS[primary]}}Select: %f"
  PS4="%F{${CORP_COLORS[muted]}}Debug: %f"
  
  # Hook into command execution
  preexec_functions+=(corp_preexec)
  precmd_functions+=(corp_precmd)
  
  echo "🏢 Corporate theme loaded - Professional and clean"
} 