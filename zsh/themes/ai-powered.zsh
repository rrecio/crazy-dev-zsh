# ~/.dotfiles/zsh/themes/ai-powered.zsh
# AI-POWERED THEME - Intelligent context-aware prompt with AI integration
# Features smart suggestions, AI model status, and enhanced contextual awareness

autoload -U colors && colors
setopt PROMPT_SUBST

# AI Theme configuration
typeset -g AI_PROMPT_CACHE_TIME=0
typeset -g AI_PROMPT_CACHE_CONTENT=""
typeset -g AI_PROMPT_CACHE_TTL=4

# AI Models and context detection
ai_model_status() {
  local models=()
  
  # Check Ollama status and models
  if command -v ollama &> /dev/null; then
    local ollama_status="offline"
    if pgrep -x "ollama" > /dev/null; then
      ollama_status="online"
      local model_count=$(ollama list 2>/dev/null | tail -n +2 | wc -l | tr -d ' ')
      if [[ "$model_count" -gt 0 ]]; then
        models+=("%F{green}🤖 ollama($model_count)%f")
      else
        models+=("%F{yellow}🤖 ollama(0)%f")
      fi
    else
      models+=("%F{red}🤖 ollama(off)%f")
    fi
  fi
  
  # Check for AI config files
  if [[ -f ".ai-config" || -f ".cursor-rules" ]]; then
    models+=("%F{cyan}🧠 ai-config%f")
  fi
  
  # Check Python AI environment
  if [[ -n "$CONDA_DEFAULT_ENV" ]] && [[ "$CONDA_DEFAULT_ENV" == *"ai"* || "$CONDA_DEFAULT_ENV" == *"ml"* ]]; then
    models+=("%F{blue} conda:$CONDA_DEFAULT_ENV%f")
  fi
  
  if [[ ${#models[@]} -gt 0 ]]; then
    echo " ${(j: :)models}"
  fi
}

# Intelligent directory context with AI suggestions
ai_directory() {
  local path="${PWD/#$HOME/~}"
  local icon="🌟"
  local context=""
  
  # Smart project detection with AI relevance
  if [[ -f "requirements.txt" && -f "setup.py" ]]; then
    icon="🐍✨"
    context="python-ai"
  elif [[ -f "package.json" ]] && grep -q "tensorflow\|pytorch\|@tensorflow\|openai" package.json 2>/dev/null; then
    icon="⚡🧠"
    context="js-ai"
  elif [[ -f "Cargo.toml" ]] && grep -q "candle\|tch\|ort" Cargo.toml 2>/dev/null; then
    icon="🦀🤖"
    context="rust-ai"
  elif [[ -f "pyproject.toml" ]] && grep -q "torch\|tensorflow\|transformers\|openai" pyproject.toml 2>/dev/null; then
    icon="🐍🤖"
    context="py-ml"
  elif [[ -f "go.mod" ]] && grep -q "ollama\|openai" go.mod 2>/dev/null; then
    icon="🐹🧠"
    context="go-ai"
  elif [[ -f "package.json" ]]; then
    icon="📦"
    context="node"
  elif git rev-parse --git-dir &> /dev/null; then
    icon="📂"
    context="git"
  else
    icon="📁"
    context="dir"
  fi
  
  # Shorten path intelligently
  local short_path=""
  if [[ ${#path} -gt 40 ]]; then
    if git rev-parse --show-toplevel &> /dev/null; then
      local git_root=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)")
      local relative_path=${PWD#$(git rev-parse --show-toplevel 2>/dev/null)}
      short_path="$git_root$relative_path"
    else
      short_path="…${path: -35}"
    fi
  else
    short_path="$path"
  fi
  
  echo "%F{magenta}$icon $short_path%f"
}

# Enhanced git with AI-powered insights
ai_git_status() {
  if ! git rev-parse --git-dir &> /dev/null 2>&1; then
    return 0
  fi
  
  local branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
  local staged=$(git diff --cached --name-only 2>/dev/null | wc -l | tr -d ' ')
  local modified=$(git diff --name-only 2>/dev/null | wc -l | tr -d ' ')
  local untracked=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')
  
  # Smart branch icon based on branch name patterns
  local branch_icon=""
  case "$branch" in
    main|master) branch_icon="🌟" ;;
    develop|dev) branch_icon="🚧" ;;
    feature/*|feat/*) branch_icon="✨" ;;
    fix/*|bugfix/*|hotfix/*) branch_icon="🐛" ;;
    release/*) branch_icon="🚀" ;;
    ai/*|ml/*) branch_icon="🤖" ;;
    *) branch_icon="🌿" ;;
  esac
  
  local git_info="%F{blue}$branch_icon $branch%f"
  
  # Intelligent status representation
  local status_parts=()
  [[ "$staged" -gt 0 ]] && status_parts+=("%F{green}●$staged%f")
  [[ "$modified" -gt 0 ]] && status_parts+=("%F{yellow}⚡$modified%f")
  [[ "$untracked" -gt 0 ]] && status_parts+=("%F{red}?$untracked%f")
  
  if [[ ${#status_parts[@]} -gt 0 ]]; then
    git_info="$git_info %F{8}[${(j::)status_parts}]%f"
  fi
  
  echo " $git_info"
}

# AI-enhanced language context
ai_language_context() {
  local context_parts=()
  
  # Node.js with AI framework detection
  if [[ -f "package.json" ]] && command -v node &> /dev/null; then
    local version=$(node --version 2>/dev/null | sed 's/v//')
    local ai_indicator=""
    
    if grep -q "openai\|@anthropic\|langchain\|tensorflow" package.json 2>/dev/null; then
      ai_indicator="🧠"
    elif grep -q "typescript" package.json 2>/dev/null; then
      ai_indicator="⚡"
    else
      ai_indicator="📦"
    fi
    
    context_parts+=("%F{green}$ai_indicator node:$version%f")
  fi
  
  # Python with AI/ML detection
  if [[ -f "requirements.txt" || -f "pyproject.toml" ]] && command -v python3 &> /dev/null; then
    local version=$(python3 --version 2>/dev/null | cut -d' ' -f2)
    local ai_indicator="🐍"
    
    if grep -q "torch\|tensorflow\|transformers\|openai\|anthropic" requirements.txt pyproject.toml 2>/dev/null; then
      ai_indicator="🤖"
    elif [[ -n "$VIRTUAL_ENV" ]]; then
      ai_indicator="🐍⚡"
    fi
    
    context_parts+=("%F{yellow}$ai_indicator py:$version%f")
  fi
  
  # Other languages with AI context
  if [[ -f "go.mod" ]] && command -v go &> /dev/null; then
    local version=$(go version 2>/dev/null | awk '{print $3}' | sed 's/go//')
    local ai_indicator="🐹"
    
    if grep -q "ollama\|openai" go.mod 2>/dev/null; then
      ai_indicator="🤖"
    fi
    
    context_parts+=("%F{blue}$ai_indicator go:$version%f")
  fi
  
  if [[ ${#context_parts[@]} -gt 0 ]]; then
    echo " ${(j: :)context_parts}"
  fi
}

# Smart system context with AI awareness
ai_system_context() {
  local system_parts=()
  
  # Docker with AI container detection
  if command -v docker &> /dev/null && docker info &> /dev/null 2>&1; then
    local containers=$(docker ps --format "table {{.Names}}" 2>/dev/null | grep -E "(ollama|jupyter|pytorch|tensorflow)" | wc -l | tr -d ' ')
    local total_containers=$(docker ps -q 2>/dev/null | wc -l | tr -d ' ')
    
    if [[ "$containers" -gt 0 ]]; then
      system_parts+=("%F{cyan}🐳🤖 $containers/$total_containers%f")
    elif [[ "$total_containers" -gt 0 ]]; then
      system_parts+=("%F{cyan}🐳 $total_containers%f")
    fi
  fi
  
  # GPU detection for AI workloads
  if command -v nvidia-smi &> /dev/null; then
    local gpu_usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null | head -1)
    if [[ -n "$gpu_usage" && "$gpu_usage" != "N/A" ]]; then
      if [[ "$gpu_usage" -gt 80 ]]; then
        system_parts+=("%F{red}🔥 GPU:$gpu_usage%%f")
      elif [[ "$gpu_usage" -gt 50 ]]; then
        system_parts+=("%F{yellow}⚡ GPU:$gpu_usage%%f")
      else
        system_parts+=("%F{green}💚 GPU:$gpu_usage%%f")
      fi
    fi
  fi
  
  if [[ ${#system_parts[@]} -gt 0 ]]; then
    echo " ${(j: :)system_parts}"
  fi
}

# Build AI-powered prompt
build_ai_prompt() {
  local current_time=$(date +%s)
  
  # Use cache if still valid
  if [[ $((current_time - AI_PROMPT_CACHE_TIME)) -lt $AI_PROMPT_CACHE_TTL && -n "$AI_PROMPT_CACHE_CONTENT" ]]; then
    echo "$AI_PROMPT_CACHE_CONTENT"
    return
  fi
  
  local prompt_content="$(ai_directory)$(ai_git_status)$(ai_language_context)$(ai_model_status)$(ai_system_context)"
  
  # Cache the result
  AI_PROMPT_CACHE_TIME=$current_time
  AI_PROMPT_CACHE_CONTENT="$prompt_content"
  
  echo "$prompt_content"
}

# AI-enhanced right prompt
ai_rprompt() {
  local parts=()
  
  # Execution time with AI context
  if [[ -n "$DOTFILES_CMD_EXEC_TIME" && "$DOTFILES_CMD_EXEC_TIME" != "0ms" ]]; then
    local time_icon="⏱️"
    # Long running commands might be AI training/inference
    if [[ "$DOTFILES_CMD_EXEC_TIME" == *"m"* ]]; then
      time_icon="🧠⏱️"
    fi
    parts+=("%F{magenta}$time_icon $DOTFILES_CMD_EXEC_TIME%f")
  fi
  
  # Show current time with AI session indicator
  local time_display="%D{%H:%M}"
  if [[ -n "$OLLAMA_SESSION" ]] || pgrep -x "ollama" > /dev/null; then
    time_display="🤖 $time_display"
  fi
  
  parts+=("%F{8}$time_display%f")
  
  echo "${(j: :)parts}"
}

# AI command execution hooks
ai_preexec() {
  DOTFILES_CMD_START_TIME=$(date +%s%3N)
  AI_PROMPT_CACHE_TIME=0  # Clear cache
  
  # Log AI-related commands for context
  local cmd="$1"
  if [[ "$cmd" == *"ollama"* || "$cmd" == *"python"* && -f "requirements.txt" ]]; then
    export AI_LAST_COMMAND="$cmd"
  fi
}

ai_precmd() {
  # Calculate execution time with AI context
  if [[ -n "$DOTFILES_CMD_START_TIME" ]]; then
    local end_time=$(date +%s%3N)
    local elapsed=$((end_time - DOTFILES_CMD_START_TIME))
    
    if [[ $elapsed -gt 200 ]]; then
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
  
  AI_PROMPT_CACHE_TIME=0  # Clear cache
}

# Load the AI-powered theme
load_ai_theme() {
  # AI-enhanced multi-line prompt
  PROMPT='$(build_ai_prompt)
%(?..%F{red}🚨 %f)%F{cyan}🚀%f '
  
  # AI-aware right prompt
  RPROMPT='$(ai_rprompt)'
  
  # AI-themed secondary prompts
  PS2="%F{cyan}🤖 %f"
  PS3="%F{magenta}🎯 Select:%f "
  PS4="%F{red}🔍 Debug:%f "
  
  # Hook into preexec/precmd for AI context
  preexec_functions+=(ai_preexec)
  precmd_functions+=(ai_precmd)
  
  echo "🤖 AI-Powered theme loaded - Intelligent context awareness"
} 