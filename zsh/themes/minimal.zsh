# ~/.dotfiles/zsh/themes/minimal.zsh
# MINIMAL THEME - Lightning fast, clean, essential-only prompt
# Perfect for low-latency environments and when you want distraction-free coding

autoload -U colors && colors
setopt PROMPT_SUBST

# Minimal git status
minimal_git_status() {
  if git rev-parse --git-dir &> /dev/null 2>&1; then
    local branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
    local status=""
    
    # Simple status check - only dirty/clean
    if ! git diff --quiet 2>/dev/null || ! git diff --cached --quiet 2>/dev/null; then
      status="%F{yellow}●%f"
    elif [[ -n $(git ls-files --others --exclude-standard 2>/dev/null) ]]; then
      status="%F{red}?%f"
    else
      status="%F{green}✓%f"
    fi
    
    echo " %F{blue}($branch$status)%f"
  fi
}

# Minimal directory path (only show last 2 directories)
minimal_path() {
  local path="${PWD/#$HOME/~}"
  local short_path=""
  
  if [[ "$path" == "~" ]]; then
    short_path="~"
  else
    # Show only last 2 directories
    short_path=$(echo "$path" | awk -F/ '{if(NF>2) print "…/"$(NF-1)"/"$NF; else print $0}')
  fi
  
  echo "%F{cyan}$short_path%f"
}

# Simple language indicator (only if in project directory)
minimal_lang() {
  local lang=""
  
  if [[ -f "package.json" ]]; then
    lang=" %F{green}⬢%f"
  elif [[ -f "Cargo.toml" ]]; then
    lang=" %F{red}🦀%f"
  elif [[ -f "go.mod" ]]; then
    lang=" %F{blue}🐹%f"
  elif [[ -f "requirements.txt" || -f "pyproject.toml" ]]; then
    lang=" %F{yellow}🐍%f"
  fi
  
  echo "$lang"
}

# Load the minimal theme
load_minimal_theme() {
  # Super clean single-line prompt
  PROMPT='$(minimal_path)$(minimal_git_status)$(minimal_lang) %F{magenta}❯%f '
  
  # Minimal right prompt with just time
  RPROMPT='%F{8}%T%f'
  
  # Clean secondary prompts
  PS2="%F{magenta}❯%f "
  PS3="? "
  PS4="+ "
  
  echo "⚡ Minimal theme loaded - Fast and clean"
} 