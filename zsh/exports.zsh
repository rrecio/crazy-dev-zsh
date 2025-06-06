# ~/.dotfiles/zsh/exports.zsh
# Environment variables and PATH configuration

# Default editor (Cursor for AI development)
export EDITOR="cursor"
export VISUAL="cursor"

# Language and locale
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# History configuration
export HISTFILE="${HOME}/.zsh_history"
export HISTSIZE=50000
export SAVEHIST=50000

# Homebrew
if [[ -d "/opt/homebrew" ]]; then
  export HOMEBREW_PREFIX="/opt/homebrew"
elif [[ -d "/usr/local/Homebrew" ]]; then
  export HOMEBREW_PREFIX="/usr/local"
fi

# PATH construction
typeset -U path  # Keep unique entries
path=(
  # Homebrew
  "${HOMEBREW_PREFIX}/bin"
  "${HOMEBREW_PREFIX}/sbin"
  
  # User bins
  "${HOME}/.local/bin"
  "${HOME}/bin"
  
  # Development tools
  "${HOME}/.cargo/bin"         # Rust
  "${HOME}/.bun/bin"           # Bun
  "${HOME}/.deno/bin"          # Deno
  
  # System paths
  "/usr/local/bin"
  "/usr/local/sbin"
  "/usr/bin"
  "/bin"
  "/usr/sbin"
  "/sbin"
  
  # Keep existing paths
  $path
)
export PATH

# Node.js
export NODE_OPTIONS="--max-old-space-size=8192"

# Python
export PYTHONDONTWRITEBYTECODE=1
export PYTHONUNBUFFERED=1

# pnpm
if [[ -d "${HOME}/.local/share/pnpm" ]]; then
  export PNPM_HOME="${HOME}/.local/share/pnpm"
  path=("$PNPM_HOME" $path)
fi

# Go
if command -v go &> /dev/null; then
  export GOPATH="${HOME}/go"
  export GOBIN="${GOPATH}/bin"
  path=("$GOBIN" $path)
fi

# Rust
if [[ -d "${HOME}/.cargo" ]]; then
  export CARGO_HOME="${HOME}/.cargo"
  export RUSTUP_HOME="${HOME}/.rustup"
fi

# Java (if using jenv)
if command -v jenv &> /dev/null; then
  eval "$(jenv init -)"
fi

# Docker
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

# Security
export GPG_TTY=$(tty)

# FZF configuration
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='
  --height 40%
  --layout=reverse
  --border
  --preview "bat --style=numbers --color=always --line-range :500 {}"
  --preview-window=right:50%:wrap
  --bind="ctrl-u:preview-page-up,ctrl-d:preview-page-down"
'

# Less configuration
export LESS='-R -f -X -z-4'
export LESSOPEN='|~/.lessfilter %s'

# Disable homebrew analytics
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_INSECURE_REDIRECT=1

# Development
export DEVELOPMENT=1
export NODE_ENV=development

# iOS/macOS Development
export DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer"
export XCODE_INSTALL_PATH="/Applications/Xcode.app"

# Swift
export SWIFT_PACKAGE_MANAGER_TARGET_TRIPLE="arm64-apple-macosx"
export SOURCEKIT_LOGGING=0

# iOS Simulator
export SIMULATOR_UDID_IPHONE="$(xcrun simctl list devices | grep "iPhone.*Booted" | head -1 | grep -o '\w\{8\}-\w\{4\}-\w\{4\}-\w\{4\}-\w\{12\}' || echo '')"

# Flutter Development
export FLUTTER_ROOT="${HOME}/flutter"
export ANDROID_HOME="${HOME}/Library/Android/sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export ANDROID_NDK_HOME="$ANDROID_HOME/ndk/25.1.8937393"

# Dart
export DART_SDK="$FLUTTER_ROOT/bin/cache/dart-sdk"
export PUB_CACHE="${HOME}/.pub-cache"

# Flutter PATH additions
path=(
  "$FLUTTER_ROOT/bin"
  "$DART_SDK/bin"
  "$PUB_CACHE/bin"
  "$ANDROID_HOME/tools"
  "$ANDROID_HOME/tools/bin"
  "$ANDROID_HOME/platform-tools"
  "$ANDROID_HOME/emulator"
  $path
)

# Flutter optimization
export FLUTTER_STORAGE_BASE_URL="https://storage.flutter-io.cn"
export PUB_HOSTED_URL="https://pub.flutter-io.cn"
export FLUTTER_SUPPRESS_ANALYTICS=true
export FLUTTER_CRASH_REPORTING=false

# Go Development
export GOPATH="${HOME}/go"
export GOROOT="/opt/homebrew/opt/go/libexec"
export GOPROXY="https://proxy.golang.org,direct"
export GOSUMDB="sum.golang.org"
export GOPRIVATE=""
export GO111MODULE=on
export CGO_ENABLED=1

# Go PATH additions
path=(
  "$GOPATH/bin"
  "$GOROOT/bin"
  $path
)

# Docker
export DOCKER_CLI_EXPERIMENTAL=enabled
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

# Kubernetes
export KUBECONFIG="${HOME}/.kube/config"
export KUBE_EDITOR="cursor"

# AWS
export AWS_DEFAULT_REGION="us-east-1"
export AWS_CLI_AUTO_PROMPT=on-partial
export AWS_PAGER=""

# Heroku
export HEROKU_COLOR=1

# Node.js & JavaScript Development
export NODE_ENV="${NODE_ENV:-development}"
export NPM_CONFIG_PROGRESS=true
export NPM_CONFIG_LOGLEVEL=warn
export YARN_CACHE_FOLDER="${HOME}/.yarn/cache"
export PNPM_HOME="${HOME}/.local/share/pnpm"

# TypeScript
export TS_NODE_SKIP_IGNORE=true
export TS_NODE_COMPILER_OPTIONS='{"module":"commonjs"}'

# JavaScript package managers PATH
path=(
  "$PNPM_HOME"
  "${HOME}/.yarn/bin"
  "${HOME}/.config/yarn/global/node_modules/.bin"
  $path
)

# Bun (fast JavaScript runtime)
export BUN_INSTALL="${HOME}/.bun"
path=("$BUN_INSTALL/bin" $path)

# Deno
export DENO_INSTALL="${HOME}/.deno"
path=("$DENO_INSTALL/bin" $path)

# AI Development
export PYTHONPATH="${HOME}/ai-projects:${PYTHONPATH}"
export PYTORCH_ENABLE_MPS_FALLBACK=1
export TRANSFORMERS_CACHE="${HOME}/.cache/transformers"
export HF_HOME="${HOME}/.cache/huggingface"

# Build optimization
export XCODE_XCCONFIG_FILE=""
export BUILD_OPTIMIZATION="-j$(sysctl -n hw.ncpu)"

# ==========================================
# Ollama AI Development Environment
# ==========================================

# Ollama configuration
export OLLAMA_HOST="127.0.0.1:11434"
export OLLAMA_ORIGINS="*"
export OLLAMA_MODELS="${HOME}/.ollama/models"
export OLLAMA_LOGS="${HOME}/.ollama/logs"
export OLLAMA_TMPDIR="${HOME}/.ollama/tmp"

# AI Model defaults
export AI_MODEL_DEFAULT="codellama"
export AI_MODEL_DOCS="deepseek-coder"
export AI_MODEL_REVIEW="mistral"
export AI_MODEL_COMMIT="codellama"
export AI_MODEL_DEBUG="deepseek-coder"
export AI_MODEL_TRANSLATE="codellama"
export AI_MODEL_EXPLAIN="wizard-coder"

# Ollama server configuration
export OLLAMA_MAX_LOADED_MODELS=3
export OLLAMA_NUM_PARALLEL=2
export OLLAMA_MAX_QUEUE=512
export OLLAMA_FLASH_ATTENTION=true
export OLLAMA_LLM_LIBRARY="gpu"

# AI development preferences
export AI_RESPONSE_FORMAT="markdown"
export AI_CODE_STYLE="modern"
export AI_EXPLANATION_LEVEL="intermediate"
export AI_INCLUDE_EXAMPLES=true
export AI_CONTEXT_SIZE=4096

# Language-specific AI models
export AI_MODEL_PYTHON="codellama:python"
export AI_MODEL_JAVASCRIPT="codellama:javascript"
export AI_MODEL_TYPESCRIPT="codellama:typescript"
export AI_MODEL_GO="codellama:golang"
export AI_MODEL_RUST="codellama:rust"
export AI_MODEL_JAVA="codellama:java"
export AI_MODEL_CPP="codellama:cpp"
export AI_MODEL_SWIFT="codellama:swift"

# AI-powered development features
export AI_AUTO_EXPLAIN=false
export AI_AUTO_REVIEW=false
export AI_AUTO_DOCS=false
export AI_AUTO_TEST=false
export AI_SMART_COMMIT=true

# Integration settings
export AI_EDITOR_INTEGRATION=true
export AI_GIT_HOOKS=false
export AI_BUILD_ANALYSIS=true
export AI_ERROR_CONTEXT=true

# Performance settings
export AI_CACHE_RESPONSES=true
export AI_CACHE_DIR="${HOME}/.cache/ai-dev"
export AI_MAX_FILE_SIZE=100000  # 100KB max for AI analysis
export AI_CONCURRENT_REQUESTS=2

# Security and privacy
export AI_SEND_TELEMETRY=false
export AI_ANONYMIZE_CODE=true
export AI_LOCAL_ONLY=true
export AI_SECURE_MODE=true

# Debugging
export AI_DEBUG=false
export AI_VERBOSE=false
export AI_LOG_LEVEL="info"
export AI_LOG_FILE="${HOME}/.ollama/ai-dev.log" 