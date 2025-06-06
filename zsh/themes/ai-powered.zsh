# ~/.dotfiles/zsh/themes/ai-powered.zsh
# Professional AI Theme - UI Designer Enhanced
# Sophisticated futuristic design with comfortable sci-fi aesthetics

# 🤖 AI Designer Color System - Futuristic yet comfortable for extended use
typeset -A AI_COLORS
AI_COLORS=(
  # 🧠 Neural Network Spectrum - Inspired by synaptic connections
  neural_deep     "25"     # Deep neural (HSL: 195, 100%, 20%) - core processing
  neural_core     "32"     # Neural blue (HSL: 195, 85%, 35%) - main pathways  
  neural_bright   "39"     # Electric neural (HSL: 195, 100%, 50%) - active synapses
  neural_glow     "75"     # Glowing neural (HSL: 195, 70%, 65%) - neural glow
  neural_soft     "117"    # Soft neural (HSL: 195, 60%, 75%) - gentle connections
  neural_whisper  "153"    # Neural whisper (HSL: 195, 50%, 85%) - subtle networks
  
  # 🔮 Quantum Computing Spectrum - Mystical yet professional
  quantum_void    "54"     # Quantum void (HSL: 285, 100%, 25%) - quantum depths
  quantum_core    "99"     # Quantum purple (HSL: 285, 75%, 45%) - quantum states
  quantum_field   "105"    # Quantum field (HSL: 285, 65%, 55%) - superposition
  quantum_glow    "141"    # Quantum glow (HSL: 285, 55%, 70%) - quantum entanglement
  quantum_aura    "177"    # Quantum aura (HSL: 285, 45%, 80%) - quantum resonance
  
  # 🧪 Machine Learning Spectrum - Data science aesthetics
  ml_data         "33"     # Data blue (HSL: 210, 85%, 40%) - raw data
  ml_processing   "75"     # Processing cyan (HSL: 195, 70%, 60%) - data processing
  ml_training     "178"    # Training amber (HSL: 40, 75%, 55%) - model training
  ml_inference    "34"     # Inference green (HSL: 130, 70%, 50%) - predictions
  ml_validation   "105"    # Validation purple (HSL: 285, 65%, 55%) - model validation
  ml_deployment   "87"     # Deployment teal (HSL: 180, 60%, 65%) - production ready
  
  # 💾 Digital Matrix Spectrum - Cyberpunk elegance
  matrix_deep     "22"     # Deep matrix (HSL: 120, 100%, 15%) - matrix depths
  matrix_core     "28"     # Matrix green (HSL: 120, 85%, 35%) - digital rain core
  matrix_flow     "34"     # Matrix flow (HSL: 120, 70%, 50%) - data streams
  matrix_bright   "40"     # Bright matrix (HSL: 120, 60%, 60%) - active code
  matrix_glow     "46"     # Matrix glow (HSL: 120, 100%, 50%) - neon highlights
  matrix_whisper  "114"    # Matrix whisper (HSL: 120, 45%, 75%) - subtle streams
  
  # 🚀 AI Status Spectrum - Intelligent feedback system
  ai_success      "34"     # AI success (HSL: 130, 70%, 50%) - positive outcomes
  ai_processing   "178"    # AI processing (HSL: 40, 75%, 55%) - active computation
  ai_learning     "105"    # AI learning (HSL: 285, 65%, 55%) - model training
  ai_error        "167"    # AI error (HSL: 0, 60%, 55%) - gentle error indication
  ai_warning      "214"    # AI warning (HSL: 45, 80%, 60%) - attention needed
  ai_complete     "87"     # AI complete (HSL: 180, 60%, 65%) - task finished
  
  # ⚡ Energy & Power Spectrum - High-tech accents
  energy_plasma   "93"     # Plasma energy (HSL: 270, 75%, 60%) - plasma effects
  energy_laser    "201"    # Laser energy (HSL: 320, 85%, 65%) - laser precision
  energy_neon     "226"    # Neon energy (HSL: 60, 100%, 75%) - neon highlights
  energy_cyber    "51"     # Cyber energy (HSL: 180, 100%, 50%) - cyber glow
  energy_aurora   "141"    # Aurora energy (HSL: 285, 55%, 70%) - aurora effects
  
  # 📊 Data Visualization Spectrum - Clear information hierarchy
  data_primary    "75"     # Primary data (HSL: 195, 70%, 65%) - main datasets
  data_secondary  "105"    # Secondary data (HSL: 285, 65%, 55%) - supporting data
  data_tertiary   "178"    # Tertiary data (HSL: 40, 75%, 55%) - additional context
  data_quaternary "87"     # Quaternary data (HSL: 180, 60%, 65%) - background data
  data_highlight  "226"    # Data highlight (HSL: 60, 100%, 75%) - key insights
  
  # 🎨 Text Hierarchy - Optimized for sci-fi readability
  text_primary    "255"    # Pure white (100%) - highest emphasis
  text_bright     "253"    # Bright white (98%) - high emphasis
  text_cyber      "87"     # Cyber cyan (HSL: 180, 60%, 70%) - themed emphasis
  text_neural     "117"    # Neural blue (HSL: 195, 60%, 75%) - neural context
  text_quantum    "177"    # Quantum purple (HSL: 285, 45%, 80%) - quantum context
  text_matrix     "114"    # Matrix green (HSL: 120, 45%, 75%) - matrix context
  text_muted      "245"    # Muted gray (87%) - low emphasis
  text_disabled   "240"    # Disabled gray (75%) - disabled state
  
  # 🌌 Surface Spectrum - Futuristic depth perception
  surface_void    "232"    # Deep void (HSL: 0, 0%, 8%) - deepest background
  surface_deep    "234"    # Deep surface (HSL: 0, 0%, 12%) - main background
  surface_neural  "236"    # Neural surface (HSL: 0, 0%, 16%) - neural panels
  surface_quantum "238"    # Quantum surface (HSL: 0, 0%, 20%) - quantum fields
  surface_matrix  "240"    # Matrix surface (HSL: 0, 0%, 25%) - matrix overlays
  surface_cyber   "243"    # Cyber surface (HSL: 0, 0%, 32%) - cyber elements
  
  # 🎯 Interactive States - Futuristic UI feedback
  hover_glow      "59"     # Hover glow (HSL: 220, 15%, 35%) - hover states
  active_pulse    "75"     # Active pulse (HSL: 195, 70%, 65%) - active states
  focus_aura      "117"    # Focus aura (HSL: 195, 60%, 75%) - focus indication
  select_energy   "87"     # Selection energy (HSL: 180, 60%, 65%) - selected items
  
  # 🤖 Legacy Compatibility - Maintaining existing functionality
  neural_blue     "39"     # Legacy neural blue
  neural_bright   "33"     # Legacy bright neural
  neural_deep     "27"     # Legacy deep neural
  quantum_cyan    "51"     # Legacy quantum cyan
  matrix_green    "46"     # Legacy matrix green
  warning_amber   "214"    # Legacy warning amber
  error_red       "167"    # Legacy error red (softened)
  success_glow    "34"     # Legacy success glow
  ghost_gray      "245"    # Legacy ghost gray
  ai_silver       "255"    # Legacy AI silver
)

# AI-themed icons and symbols
AI_BRAIN_ICON="🧠"
AI_ROCKET_ICON="🚀"
AI_ROBOT_ICON="🤖"
AI_NEURAL_ICON="⚡"
AI_QUANTUM_ICON="🌌"
AI_SPARK_ICON="✨"

# Performance caching for AI theme
AI_PROMPT_CACHE_TTL=3
AI_PROMPT_CACHE_TIME=0
AI_PROMPT_CACHE_CONTENT=""

# Intelligent directory display with AI context
ai_directory() {
  local path="${PWD/#$HOME/~}"
  local icon="📁"
  local project_type=""
  
  # AI/ML project detection
  if [[ -f "requirements.txt" ]] && grep -q "torch\|tensorflow\|transformers\|openai\|anthropic" requirements.txt 2>/dev/null; then
    icon="🤖"
    project_type=" ML"
  elif [[ -f "package.json" ]] && grep -q "openai\|@anthropic\|langchain" package.json 2>/dev/null; then
    icon="🧠"
    project_type=" AI"
  elif [[ -f "go.mod" ]] && grep -q "ollama\|openai" go.mod 2>/dev/null; then
    icon="⚡"
    project_type=" AI"
  elif [[ -f "package.json" ]]; then
    icon="⚡"
    project_type=" JS"
  elif [[ -f "Cargo.toml" ]]; then
    icon="🦀"
    project_type=" RS"
  elif [[ -f "go.mod" ]]; then
    icon="🐹"
    project_type=" GO"
  elif [[ -f "requirements.txt" ]]; then
    icon="🐍"
    project_type=" PY"
  elif git rev-parse --git-dir &> /dev/null; then
    icon="📂"
  fi
  
  # Smart path truncation with visual hierarchy
  local display_path="$path"
  if [[ ${#path} -gt 35 ]]; then
    local parts=(${(s:/:)path})
    if [[ ${#parts[@]} -gt 3 ]]; then
      display_path="${parts[1]}/⋯/${parts[-2]}/${parts[-1]}"
    fi
  fi
  
  echo "%F{${AI_COLORS[neural_blue]}}$icon %F{${AI_COLORS[ai_silver]}}$display_path%f%F{${AI_COLORS[quantum_cyan]}}$project_type%f"
}

# Advanced git status with beautiful AI-themed indicators
ai_git_status() {
  if ! git rev-parse --git-dir &> /dev/null 2>&1; then
    return 0
  fi
  
  local branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
  local staged=$(git diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
  local modified=$(git diff --numstat 2>/dev/null | wc -l | tr -d ' ')
  local untracked=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')
  local ahead=$(git rev-list --count @{upstream}..HEAD 2>/dev/null || echo "0")
  local behind=$(git rev-list --count HEAD..@{upstream} 2>/dev/null || echo "0")
  
  # Beautiful status indicators with AI-themed colors
  local status_parts=()
  [[ "$staged" -gt 0 ]] && status_parts+=("%F{${AI_COLORS[matrix_green]}}⚡$staged%f")
  [[ "$modified" -gt 0 ]] && status_parts+=("%F{${AI_COLORS[warning_amber]}}⚡$modified%f")
  [[ "$untracked" -gt 0 ]] && status_parts+=("%F{${AI_COLORS[error_red]}}?$untracked%f")
  
  # Sync status with beautiful arrows
  local sync_status=""
  if [[ "$ahead" -gt 0 || "$behind" -gt 0 ]]; then
    [[ "$ahead" -gt 0 ]] && sync_status="↗$ahead"
    [[ "$behind" -gt 0 ]] && sync_status="${sync_status}↙$behind"
    sync_status=" %F{${AI_COLORS[neon_pink]}}$sync_status%f"
  fi
  
  local git_info=" %F{${AI_COLORS[quantum_cyan]}}🌟 $branch%f"
  [[ ${#status_parts[@]} -gt 0 ]] && git_info="$git_info %F{${AI_COLORS[ghost_gray]}}[${(j::)status_parts}%F{${AI_COLORS[ghost_gray]}}]%f"
  git_info="$git_info$sync_status"
  
  echo "$git_info"
}

# AI model status with intelligent detection
ai_model_status() {
  local models=()
  
  # Ollama detection with model information
  if command -v ollama &> /dev/null; then
    if pgrep -x "ollama" > /dev/null; then
      local running_models=$(ollama ps 2>/dev/null | tail -n +2 | wc -l | tr -d ' ')
      if [[ "$running_models" -gt 0 ]]; then
        models+=("%F{${AI_COLORS[matrix_green]}}🤖 ollama($running_models)%f")
      else
        models+=("%F{${AI_COLORS[neural_blue]}}🤖 ollama(ready)%f")
      fi
    else
      models+=("%F{${AI_COLORS[ghost_gray]}}🤖 ollama(off)%f")
    fi
  fi
  
  # OpenAI API key detection
  if [[ -n "$OPENAI_API_KEY" ]]; then
    models+=("%F{${AI_COLORS[plasma_purple]}}🧠 openai%f")
  fi
  
  # Anthropic API key detection
  if [[ -n "$ANTHROPIC_API_KEY" ]]; then
    models+=("%F{${AI_COLORS[neon_pink]}}✨ anthropic%f")
  fi
  
  # Hugging Face token detection
  if [[ -n "$HUGGINGFACE_TOKEN" ]]; then
    models+=("%F{${AI_COLORS[cyber_orange]}}🤗 hf%f")
  fi
  
  # Docker AI containers
  if command -v docker &> /dev/null && docker info &> /dev/null 2>&1; then
    local ai_containers=$(docker ps --format "table {{.Names}}" 2>/dev/null | grep -E "(ollama|jupyter|pytorch|tensorflow|cuda)" | wc -l | tr -d ' ')
    if [[ "$ai_containers" -gt 0 ]]; then
      models+=("%F{${AI_COLORS[quantum_cyan]}}🐳 ai-containers($ai_containers)%f")
    fi
  fi
  
  if [[ ${#models[@]} -gt 0 ]]; then
    echo " ${(j: :)models}"
  else
    echo " %F{${AI_COLORS[ghost_gray]}}🤖 no-ai%f"
  fi
}

# Advanced language detection with AI framework awareness
ai_language_context() {
  local context_parts=()
  
  # Node.js with AI framework detection
  if [[ -f "package.json" ]] && command -v node &> /dev/null; then
    local version=$(node --version 2>/dev/null | sed 's/v//' | cut -d'.' -f1,2)
    local ai_indicator=""
    local framework=""
    
    if grep -q "openai\|@anthropic\|langchain" package.json 2>/dev/null; then
      ai_indicator="🧠"
      framework="ai"
    elif grep -q "tensorflow\|@tensorflow" package.json 2>/dev/null; then
      ai_indicator="🤖"
      framework="tf"
    elif grep -q "typescript" package.json 2>/dev/null; then
      ai_indicator="⚡"
      framework="ts"
    else
      ai_indicator="📦"
      framework="js"
    fi
    
    context_parts+=("%F{${AI_COLORS[matrix_green]}}$ai_indicator node:$version($framework)%f")
  fi
  
  # Python with AI/ML detection
  if [[ -f "requirements.txt" || -f "pyproject.toml" ]] && command -v python3 &> /dev/null; then
    local version=$(python3 --version 2>/dev/null | cut -d' ' -f2 | cut -d'.' -f1,2)
    local ai_indicator="🐍"
    local framework=""
    
    if grep -q "torch\|pytorch" requirements.txt pyproject.toml 2>/dev/null; then
      ai_indicator="🔥"
      framework="pytorch"
    elif grep -q "tensorflow" requirements.txt pyproject.toml 2>/dev/null; then
      ai_indicator="🧠"
      framework="tf"
    elif grep -q "transformers\|huggingface" requirements.txt pyproject.toml 2>/dev/null; then
      ai_indicator="🤗"
      framework="hf"
    elif grep -q "openai\|anthropic" requirements.txt pyproject.toml 2>/dev/null; then
      ai_indicator="✨"
      framework="api"
    elif [[ -n "$VIRTUAL_ENV" ]]; then
      framework="venv:$(basename $VIRTUAL_ENV)"
    elif [[ -n "$CONDA_DEFAULT_ENV" && "$CONDA_DEFAULT_ENV" != "base" ]]; then
      framework="conda:$CONDA_DEFAULT_ENV"
    else
      framework="py"
    fi
    
    context_parts+=("%F{${AI_COLORS[warning_amber]}}$ai_indicator py:$version($framework)%f")
  fi
  
  # Go with AI context
  if [[ -f "go.mod" ]] && command -v go &> /dev/null; then
    local version=$(go version 2>/dev/null | awk '{print $3}' | sed 's/go//' | cut -d'.' -f1,2)
    local ai_indicator="🐹"
    
    if grep -q "ollama\|openai" go.mod 2>/dev/null; then
      ai_indicator="🚀"
    fi
    
    context_parts+=("%F{${AI_COLORS[neural_blue]}}$ai_indicator go:$version%f")
  fi
  
  # Rust with performance focus
  if [[ -f "Cargo.toml" ]] && command -v rustc &> /dev/null; then
    local version=$(rustc --version 2>/dev/null | awk '{print $2}' | cut -d'.' -f1,2)
    context_parts+=("%F{${AI_COLORS[cyber_orange]}}🦀 rust:$version%f")
  fi
  
  if [[ ${#context_parts[@]} -gt 0 ]]; then
    echo " ${(j: :)context_parts}"
  fi
}

# System context with AI-focused monitoring
ai_system_context() {
  local system_parts=()
  
  # GPU detection for AI workloads
  if command -v nvidia-smi &> /dev/null; then
    local gpu_usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null | head -1)
    if [[ -n "$gpu_usage" && "$gpu_usage" != "N/A" ]]; then
      local gpu_icon="💚"
      local gpu_color="${AI_COLORS[matrix_green]}"
      
      if [[ "$gpu_usage" -gt 80 ]]; then
        gpu_icon="🔥"
        gpu_color="${AI_COLORS[error_red]}"
      elif [[ "$gpu_usage" -gt 50 ]]; then
        gpu_icon="⚡"
        gpu_color="${AI_COLORS[warning_amber]}"
      fi
      
      system_parts+=("%F{$gpu_color}$gpu_icon gpu:$gpu_usage%%%f")
    fi
  fi
  
  # Memory usage (if available)
  if command -v free &> /dev/null; then
    local mem_usage=$(free | awk '/^Mem:/ {printf "%.0f", $3/$2 * 100.0}')
    if [[ -n "$mem_usage" && "$mem_usage" -gt 80 ]]; then
      system_parts+=("%F{${AI_COLORS[warning_amber]}}🧠 mem:$mem_usage%%%f")
    fi
  fi
  
  # Docker containers with AI focus
  if command -v docker &> /dev/null && docker info &> /dev/null 2>&1; then
    local total_containers=$(docker ps -q 2>/dev/null | wc -l | tr -d ' ')
    if [[ "$total_containers" -gt 0 ]]; then
      system_parts+=("%F{${AI_COLORS[quantum_cyan]}}🐳 $total_containers%f")
    fi
  fi
  
  if [[ ${#system_parts[@]} -gt 0 ]]; then
    echo " ${(j: :)system_parts}"
  fi
}

# Build AI-powered prompt with caching
build_ai_prompt() {
  local current_time=$(date +%s)
  
  # Use cache if still valid
  if [[ $((current_time - AI_PROMPT_CACHE_TIME)) -lt $AI_PROMPT_CACHE_TTL && -n "$AI_PROMPT_CACHE_CONTENT" ]]; then
    echo "$AI_PROMPT_CACHE_CONTENT"
    return
  fi
  
  local prompt_content=""
  prompt_content+="$(ai_directory)"
  prompt_content+="$(ai_git_status)"
  prompt_content+="$(ai_language_context)"
  prompt_content+="$(ai_model_status)"
  prompt_content+="$(ai_system_context)"
  
  # Cache the result
  AI_PROMPT_CACHE_TIME=$current_time
  AI_PROMPT_CACHE_CONTENT="$prompt_content"
  
  echo "$prompt_content"
}

# Beautiful right prompt with AI enhancements
ai_rprompt() {
  local parts=()
  
  # Execution time with AI context
  if [[ -n "$DOTFILES_CMD_EXEC_TIME" && "$DOTFILES_CMD_EXEC_TIME" != "0ms" ]]; then
    local time_icon="⏱️"
    local time_color="${AI_COLORS[ghost_gray]}"
    
    # Long running commands might be AI training/inference
    if [[ "$DOTFILES_CMD_EXEC_TIME" == *"m"* ]]; then
      time_icon="🧠⏱️"
      time_color="${AI_COLORS[plasma_purple]}"
    elif [[ "${DOTFILES_CMD_EXEC_TIME%ms}" -gt 10000 ]]; then
      time_icon="⚡⏱️"
      time_color="${AI_COLORS[warning_amber]}"
    fi
    
    parts+=("%F{$time_color}$time_icon $DOTFILES_CMD_EXEC_TIME%f")
  fi
  
  # Beautiful timestamp with AI session indicator
  local time_display="%D{%H:%M:%S}"
  local time_color="${AI_COLORS[ghost_gray]}"
  
  if [[ -n "$OLLAMA_SESSION" ]] || pgrep -x "ollama" > /dev/null; then
    time_display="🤖 $time_display"
    time_color="${AI_COLORS[matrix_green]}"
  fi
  
  parts+=("%F{$time_color}$time_display%f")
  
  echo "${(j: | :)parts}"
}

# AI command execution hooks
ai_preexec() {
  # Only run if AI-powered theme is active
  [[ "$(get_saved_theme)" != "ai-powered" ]] && return
  
  DOTFILES_CMD_START_TIME=$(date +%s 2>/dev/null || echo 0)
  AI_PROMPT_CACHE_TIME=0  # Clear cache
  
  # Log AI-related commands for context
  local cmd="$1"
  if [[ "$cmd" == *"ollama"* || "$cmd" == *"python"* && -f "requirements.txt" ]]; then
    export AI_LAST_COMMAND="$cmd"
  fi
}

ai_precmd() {
  # Only run if AI-powered theme is active
  [[ "$(get_saved_theme)" != "ai-powered" ]] && return
  
  # Calculate execution time with AI context
  if [[ -n "$DOTFILES_CMD_START_TIME" ]]; then
    local end_time=$(date +%s 2>/dev/null || echo 0)
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

# Load the stunning AI-powered theme
load_ai_theme() {
  # Beautiful multi-line prompt with AI aesthetics
  PROMPT='$(build_ai_prompt)
%(?..%F{${AI_COLORS[error_red]}}🚨 %f)%F{${AI_COLORS[quantum_cyan]}}🚀%f '
  
  # AI-enhanced right prompt
  RPROMPT='$(ai_rprompt)'
  
  # AI-themed secondary prompts
  PS2="%F{${AI_COLORS[quantum_cyan]}}🤖 %f"
  PS3="%F{${AI_COLORS[plasma_purple]}}🎯 Select:%f "
  PS4="%F{${AI_COLORS[error_red]}}🔍 Debug:%f "
  
  # Hook into preexec/precmd for AI context
  preexec_functions+=(ai_preexec)
  precmd_functions+=(ai_precmd)
  
  echo "🤖 AI-Powered theme loaded - Intelligent context awareness"
} 