# ~/.dotfiles/zsh/themes/developer.zsh
# DEVELOPER THEME - Code-focused with enhanced development context
# Emphasizes git workflow, language versions, and development tools

autoload -U colors && colors
setopt PROMPT_SUBST

# Performance caching
typeset -g DEV_PROMPT_CACHE_TIME=0
typeset -g DEV_PROMPT_CACHE_CONTENT=""
typeset -g DEV_PROMPT_CACHE_TTL=3

# Enhanced git information for developers
dev_git_status() {
  if ! git rev-parse --git-dir &> /dev/null 2>&1; then
    return 0
  fi
  
  local branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
  local staged=$(git diff --cached --name-only 2>/dev/null | wc -l | tr -d ' ')
  local modified=$(git diff --name-only 2>/dev/null | wc -l | tr -d ' ')
  local untracked=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')
  
  # Branch with icon
  local git_info="%F{blue} $branch%f"
  
  # Add file status indicators
  local status_parts=()
  [[ "$staged" -gt 0 ]] && status_parts+=("%F{green}+$staged%f")
  [[ "$modified" -gt 0 ]] && status_parts+=("%F{yellow}~$modified%f")
  [[ "$untracked" -gt 0 ]] && status_parts+=("%F{red}?$untracked%f")
  
  if [[ ${#status_parts[@]} -gt 0 ]]; then
    git_info="$git_info %F{8}[${(j:|:)status_parts}]%f"
  fi
  
  echo "$git_info"
}

# Smart directory with project context
dev_directory() {
  local path="${PWD/#$HOME/~}"
  local project_root=""
  local relative_path=""
  
  # Try to find project root
  if git rev-parse --show-toplevel &> /dev/null; then
    project_root=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)")
    local git_root=$(git rev-parse --show-toplevel 2>/dev/null)
    relative_path=${PWD#$git_root}
    if [[ -n "$relative_path" ]]; then
      path="$project_root$relative_path"
    else
      path="$project_root"
    fi
  fi
  
  # Premium project type icons with enhanced styling
  local icon=""
  local path_color="81"  # Cyan
  
  if [[ -f "package.json" ]]; then
    icon="󰜫 "
    path_color="46"  # Green for Node.js
  elif [[ -f "Cargo.toml" ]]; then
    icon="󱘗 "
    path_color="208"  # Orange for Rust
  elif [[ -f "go.mod" ]]; then
    icon="󰟓 "
    path_color="39"   # Blue for Go
  elif [[ -f "requirements.txt" || -f "pyproject.toml" ]]; then
    icon=" "
    path_color="220"  # Yellow for Python
  elif [[ -f "Package.swift" ]]; then
    icon="󰛥 "
    path_color="196"  # Red for Swift
  elif [[ -f "pubspec.yaml" ]]; then
    icon="󰜘 "
    path_color="81"   # Cyan for Flutter
  elif git rev-parse --git-dir &> /dev/null; then
    icon=" "
    path_color="135"  # Purple for Git repos
  else
    icon=" "
    path_color="246"  # Gray for regular folders
  fi
  
  echo "%F{$path_color}$icon$path%f"
}

# Development language and tools context
dev_context() {
  local context_parts=()
  
  # Node.js with package manager detection
  if [[ -f "package.json" ]] && command -v node &> /dev/null; then
    local node_version=$(node --version 2>/dev/null | sed 's/v//')
    local pm=""
    if [[ -f "yarn.lock" ]]; then
      pm="yarn"
    elif [[ -f "pnpm-lock.yaml" ]]; then
      pm="pnpm"
    elif [[ -f "bun.lockb" ]]; then
      pm="bun"
    else
      pm="npm"
    fi
    
    # TypeScript detection
    local ts=""
    if [[ -f "tsconfig.json" ]] || grep -q '"typescript"' package.json 2>/dev/null; then
      ts="+TS"
    fi
    
    context_parts+=("%F{green}⬢ $node_version($pm)$ts%f")
  fi
  
  # Python with virtual environment
  if [[ -f "requirements.txt" || -f "pyproject.toml" || -f "Pipfile" ]] && command -v python3 &> /dev/null; then
    local py_version=$(python3 --version 2>/dev/null | cut -d' ' -f2)
    local venv=""
    if [[ -n "$VIRTUAL_ENV" ]]; then
      venv="($(basename $VIRTUAL_ENV))"
    elif [[ -n "$CONDA_DEFAULT_ENV" ]]; then
      venv="(conda:$CONDA_DEFAULT_ENV)"
    fi
    context_parts+=("%F{yellow} $py_version$venv%f")
  fi
  
  # Go
  if [[ -f "go.mod" ]] && command -v go &> /dev/null; then
    local go_version=$(go version 2>/dev/null | awk '{print $3}' | sed 's/go//')
    context_parts+=("%F{blue} $go_version%f")
  fi
  
  # Rust
  if [[ -f "Cargo.toml" ]] && command -v rustc &> /dev/null; then
    local rust_version=$(rustc --version 2>/dev/null | awk '{print $2}')
    context_parts+=("%F{red}🦀 $rust_version%f")
  fi
  
  # Docker context
  if command -v docker &> /dev/null && docker info &> /dev/null 2>&1; then
    local containers=$(docker ps -q 2>/dev/null | wc -l | tr -d ' ')
    if [[ "$containers" -gt 0 ]]; then
      context_parts+=("%F{cyan}󰡨 $containers%f")
    fi
  fi
  
  # Kubernetes context
  if command -v kubectl &> /dev/null; then
    local k8s_context=$(kubectl config current-context 2>/dev/null)
    if [[ -n "$k8s_context" ]]; then
      local short_context="${k8s_context##*/}"
      context_parts+=("%F{blue}󱃾 $short_context%f")
    fi
  fi
  
  if [[ ${#context_parts[@]} -gt 0 ]]; then
    echo " ${(j: :)context_parts}"
  fi
}

# Build developer prompt
build_dev_prompt() {
  local current_time=$(date +%s)
  
  # Use cache if still valid
  if [[ $((current_time - DEV_PROMPT_CACHE_TIME)) -lt $DEV_PROMPT_CACHE_TTL && -n "$DEV_PROMPT_CACHE_CONTENT" ]]; then
    echo "$DEV_PROMPT_CACHE_CONTENT"
    return
  fi
  
  local prompt_content="$(dev_directory)$(dev_git_status)$(dev_context)"
  
  # Cache the result
  DEV_PROMPT_CACHE_TIME=$current_time
  DEV_PROMPT_CACHE_CONTENT="$prompt_content"
  
  echo "$prompt_content"
}

# Right prompt with useful dev info
dev_rprompt() {
  local parts=()
  
  # Execution time
  if [[ -n "$DOTFILES_CMD_EXEC_TIME" && "$DOTFILES_CMD_EXEC_TIME" != "0ms" ]]; then
    parts+=("%F{magenta}󰄉 $DOTFILES_CMD_EXEC_TIME%f")
  fi
  
  # Current time
  parts+=("%F{8}%D{%H:%M}%f")
  
  echo "${(j: :)parts}"
}

# Command execution timing
dev_preexec() {
  # Only run if developer theme is active
  [[ "$(get_saved_theme)" != "developer" ]] && return
  
  DOTFILES_CMD_START_TIME=$(date +%s 2>/dev/null || echo 0)
  DEV_PROMPT_CACHE_TIME=0  # Clear cache
}

dev_precmd() {
  # Only run if developer theme is active
  [[ "$(get_saved_theme)" != "developer" ]] && return
  
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
  
  DEV_PROMPT_CACHE_TIME=0  # Clear cache
}

# Load the developer theme
load_developer_theme() {
  # Multi-line prompt with development context
  PROMPT='$(build_dev_prompt)
%(?..%F{red}✗ %f)%F{green}▶%f '
  
  # Right prompt with timing and status
  RPROMPT='$(dev_rprompt)'
  
  # Development-focused secondary prompts
  PS2="%F{green}▶%f "
  PS3="%F{cyan}Select:%f "
  PS4="%F{red}Debug:%f "
  
  # Hook into preexec/precmd for timing
  preexec_functions+=(dev_preexec)
  precmd_functions+=(dev_precmd)
  
  echo "👨‍💻 Developer theme loaded - Enhanced coding context"
} 