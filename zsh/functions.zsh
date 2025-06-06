# ~/.dotfiles/zsh/functions.zsh
# Utility functions for enhanced shell experience

# Create directory and cd into it
mcd() {
  mkdir -p "$1" && cd "$1"
}

# Extract archives intelligently
extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"     ;;
      *.tar.gz)    tar xzf "$1"     ;;
      *.bz2)       bunzip2 "$1"     ;;
      *.rar)       unrar x "$1"     ;;
      *.gz)        gunzip "$1"      ;;
      *.tar)       tar xf "$1"      ;;
      *.tbz2)      tar xjf "$1"     ;;
      *.tgz)       tar xzf "$1"     ;;
      *.zip)       unzip "$1"       ;;
      *.Z)         uncompress "$1"  ;;
      *.7z)        7z x "$1"        ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Find and kill process by name
killport() {
  if [ -z "$1" ]; then
    echo "Usage: killport <port>"
    return 1
  fi
  
  local pid=$(lsof -ti tcp:"$1")
  if [ -n "$pid" ]; then
    kill -9 "$pid"
    echo "Killed process on port $1 (PID: $pid)"
  else
    echo "No process found on port $1"
  fi
}

# Smart project finder and navigator
proj() {
  local projects_dir="${HOME}/Projects"
  local selected_dir
  
  if [ -z "$1" ]; then
    # Use fzf to select project if available
    if command -v fzf &> /dev/null; then
      selected_dir=$(find "$projects_dir" -mindepth 1 -maxdepth 2 -type d | fzf --preview 'ls -la {}')
      [ -n "$selected_dir" ] && cd "$selected_dir"
    else
      echo "Available projects:"
      ls -1 "$projects_dir"
    fi
  else
    # Direct navigation
    if [ -d "$projects_dir/$1" ]; then
      cd "$projects_dir/$1"
    else
      echo "Project '$1' not found in $projects_dir"
    fi
  fi
}

# Quick git repository clone and navigate
clone() {
  if [ -z "$1" ]; then
    echo "Usage: clone <git-url> [directory]"
    return 1
  fi
  
  local repo_url="$1"
  local target_dir="$2"
  
  # Extract repository name if no directory specified
  if [ -z "$target_dir" ]; then
    target_dir=$(basename "$repo_url" .git)
  fi
  
  git clone "$repo_url" "$target_dir" && cd "$target_dir"
}

# Smart backup function
backup() {
  if [ -z "$1" ]; then
    echo "Usage: backup <file_or_directory>"
    return 1
  fi
  
  local target="$1"
  local backup_name="${target}.backup.$(date +%Y%m%d_%H%M%S)"
  
  cp -r "$target" "$backup_name"
  echo "Backup created: $backup_name"
}

# Quick HTTP server with custom port (renamed to avoid alias conflict)
http_serve() {
  local port="${1:-8000}"
  local directory="${2:-.}"
  
  echo "Starting HTTP server on port $port serving $directory"
  python3 -m http.server "$port" --directory "$directory"
}

# Generate random password
genpass() {
  local length="${1:-20}"
  openssl rand -base64 "$length" | tr -d "=+/" | cut -c1-"$length"
}

# Weather information
weather() {
  local city="${1:-}"
  if [ -n "$city" ]; then
    curl -s "wttr.in/$city?format=3"
  else
    curl -s "wttr.in/?format=3"
  fi
}

# System information summary (renamed to avoid alias conflict)
system_info() {
  echo "System Information:"
  echo "==================="
  echo "OS: $(uname -s) $(uname -r)"
  echo "CPU: $(sysctl -n machdep.cpu.brand_string)"
  echo "Memory: $(vm_stat | grep 'Pages active' | awk '{print $3}' | sed 's/\.//')"
  echo "Disk Usage:"
  df -h | head -n 2
  echo ""
  echo "Network:"
  echo "External IP: $(curl -s -4 icanhazip.com)"
  echo "Local IP: $(ipconfig getifaddr en0)"
}

# Docker container management
drun() {
  if [ -z "$1" ]; then
    echo "Usage: drun <image> [command]"
    return 1
  fi
  
  local image="$1"
  local command="${2:-bash}"
  
  docker run -it --rm "$image" "$command"
}

# Git worktree management
gwt() {
  local action="$1"
  local branch="$2"
  
  case "$action" in
    "add")
      if [ -z "$branch" ]; then
        echo "Usage: gwt add <branch-name>"
        return 1
      fi
      git worktree add "../$(basename $(pwd))-$branch" "$branch"
      ;;
    "list")
      git worktree list
      ;;
    "remove")
      if [ -z "$branch" ]; then
        echo "Usage: gwt remove <branch-name>"
        return 1
      fi
      git worktree remove "../$(basename $(pwd))-$branch"
      ;;
    *)
      echo "Usage: gwt {add|list|remove} [branch-name]"
      ;;
  esac
}

# NPM/Node.js project initialization
npminit() {
  local project_name="$1"
  local template="${2:-typescript}"
  
  if [ -z "$project_name" ]; then
    echo "Usage: npminit <project-name> [template]"
    echo "Templates: typescript, react, vue, express, next"
    return 1
  fi
  
  case "$template" in
    "typescript")
      npm create typescript-app "$project_name"
      ;;
    "react")
      npx create-react-app "$project_name" --template typescript
      ;;
    "vue")
      npm create vue@latest "$project_name"
      ;;
    "express")
      npx express-generator "$project_name"
      ;;
    "next")
      npx create-next-app@latest "$project_name" --typescript
      ;;
    *)
      mkdir "$project_name" && cd "$project_name"
      npm init -y
      ;;
  esac
  
  [ -d "$project_name" ] && cd "$project_name"
}

# Quick note taking
note() {
  local notes_dir="${HOME}/Notes"
  local note_file="${notes_dir}/$(date +%Y-%m-%d).md"
  
  mkdir -p "$notes_dir"
  
  if [ -z "$1" ]; then
    # Open today's note
    $EDITOR "$note_file"
  else
    # Add quick note
    echo "## $(date +%H:%M) - $*" >> "$note_file"
    echo "Added note to $note_file"
  fi
}

# Git commit with conventional commits
gcommit() {
  local type="$1"
  local scope="$2"
  local message="$3"
  
  if [ -z "$type" ] || [ -z "$message" ]; then
    echo "Usage: gcommit <type> [scope] <message>"
    echo "Types: feat, fix, docs, style, refactor, test, chore"
    return 1
  fi
  
  local commit_msg
  if [ -n "$scope" ] && [ "$scope" != "$message" ]; then
    commit_msg="${type}(${scope}): ${message}"
  else
    commit_msg="${type}: ${message}"
  fi
  
  git commit -m "$commit_msg"
}

# Environment management
setenv() {
  local env_name="$1"
  local env_file=".env"
  
  if [ -n "$env_name" ]; then
    env_file=".env.$env_name"
  fi
  
  if [ -f "$env_file" ]; then
    export $(cat "$env_file" | grep -v '^#' | xargs)
    echo "Environment loaded from $env_file"
  else
    echo "Environment file $env_file not found"
  fi
}

# Quick directory bookmarks
bookmark() {
  local name="$1"
  local bookmarks_file="${HOME}/.bookmarks"
  
  if [ -z "$name" ]; then
    # List bookmarks
    if [ -f "$bookmarks_file" ]; then
      cat "$bookmarks_file"
    else
      echo "No bookmarks found"
    fi
  else
    # Add bookmark
    echo "$name:$(pwd)" >> "$bookmarks_file"
    echo "Bookmarked $(pwd) as '$name'"
  fi
}

# Navigate to bookmark
goto() {
  local name="$1"
  local bookmarks_file="${HOME}/.bookmarks"
  
  if [ -z "$name" ]; then
    echo "Usage: goto <bookmark-name>"
    return 1
  fi
  
  if [ -f "$bookmarks_file" ]; then
    local path=$(grep "^$name:" "$bookmarks_file" | cut -d: -f2-)
    if [ -n "$path" ]; then
      cd "$path"
    else
      echo "Bookmark '$name' not found"
    fi
  else
    echo "No bookmarks file found"
  fi
}

# Performance monitoring
perf() {
  local duration="${1:-10}"
  echo "Monitoring system performance for ${duration} seconds..."
  
  # CPU usage
  echo "CPU Usage:"
  top -l 1 -s 0 | grep "CPU usage" | awk '{print $3, $5}' | sed 's/%//g'
  
  # Memory usage
  echo "Memory Usage:"
  vm_stat | grep -E "(Pages active|Pages free)" | awk '{print $3, $4}' | sed 's/\.//'
  
  # Disk I/O
  echo "Disk I/O:"
  iostat -c 1 -w "$duration" | tail -n 1
}

# iOS/Swift Development Functions

# Smart xcodebuild - Better than xcbeautify
smart_xcodebuild() {
  local scheme=""
  local workspace=""
  local project=""
  local destination="platform=iOS Simulator,name=iPhone 15"
  local action="build"
  local configuration="Debug"
  local verbose=false
  local clean=false
  local analyze=false
  
  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case $1 in
      -scheme)
        scheme="$2"
        shift 2
        ;;
      -workspace)
        workspace="$2"
        shift 2
        ;;
      -project)
        project="$2"
        shift 2
        ;;
      -destination)
        destination="$2"
        shift 2
        ;;
      -configuration)
        configuration="$2"
        shift 2
        ;;
      -action)
        action="$2"
        shift 2
        ;;
      -clean)
        clean=true
        shift
        ;;
      -analyze)
        analyze=true
        shift
        ;;
      -verbose)
        verbose=true
        shift
        ;;
      -help|--help)
        echo "Smart Xcodebuild - Intelligent iOS build tool"
        echo ""
        echo "Usage: smart_xcodebuild [options]"
        echo ""
        echo "Options:"
        echo "  -scheme <name>        Build scheme (auto-detected if not provided)"
        echo "  -workspace <file>     Workspace file (auto-detected if not provided)"
        echo "  -project <file>       Project file (auto-detected if not provided)"
        echo "  -destination <dest>   Build destination (default: iPhone 15 simulator)"
        echo "  -configuration <cfg>  Build configuration (Debug/Release, default: Debug)"
        echo "  -action <action>      Build action (build/test/archive, default: build)"
        echo "  -clean               Clean before building"
        echo "  -analyze             Run static analyzer"
        echo "  -verbose             Verbose output"
        echo ""
        echo "Examples:"
        echo "  smart_xcodebuild                           # Auto-detect and build"
        echo "  smart_xcodebuild -scheme MyApp -clean     # Clean and build specific scheme"
        echo "  smart_xcodebuild -action test              # Run tests"
        echo "  smart_xcodebuild -configuration Release   # Release build"
        return 0
        ;;
      *)
        echo "Unknown option: $1"
        echo "Use -help for usage information"
        return 1
        ;;
    esac
  done
  
  # Auto-detect project/workspace if not specified
  if [[ -z "$workspace" ]] && [[ -z "$project" ]]; then
    if ls *.xcworkspace &> /dev/null; then
      workspace=$(ls *.xcworkspace | head -1)
      echo "🔍 Auto-detected workspace: $workspace"
    elif ls *.xcodeproj &> /dev/null; then
      project=$(ls *.xcodeproj | head -1)
      echo "🔍 Auto-detected project: $project"
    else
      echo "❌ No Xcode project or workspace found"
      return 1
    fi
  fi
  
  # Auto-detect scheme if not specified
  if [[ -z "$scheme" ]]; then
    local schemes_output
    if [[ -n "$workspace" ]]; then
      schemes_output=$(xcodebuild -workspace "$workspace" -list 2>/dev/null)
    elif [[ -n "$project" ]]; then
      schemes_output=$(xcodebuild -project "$project" -list 2>/dev/null)
    fi
    
    scheme=$(echo "$schemes_output" | grep -A 100 "Schemes:" | grep -v "Schemes:" | head -1 | xargs)
    if [[ -n "$scheme" ]]; then
      echo "🔍 Auto-detected scheme: $scheme"
    else
      echo "❌ Could not auto-detect scheme"
      return 1
    fi
  fi
  
  # Build command array
  local cmd=("xcodebuild")
  
  if [[ -n "$workspace" ]]; then
    cmd+=("-workspace" "$workspace")
  elif [[ -n "$project" ]]; then
    cmd+=("-project" "$project")
  fi
  
  cmd+=("-scheme" "$scheme")
  cmd+=("-destination" "$destination")
  cmd+=("-configuration" "$configuration")
  
  if [[ "$clean" == true ]]; then
    cmd+=("clean")
  fi
  
  if [[ "$analyze" == true ]]; then
    cmd+=("analyze")
  fi
  
  cmd+=("$action")
  
  # Additional build settings for optimization
  cmd+=("COMPILER_INDEX_STORE_ENABLE=NO")
  cmd+=("SWIFT_COMPILATION_MODE=wholemodule")
  cmd+=("SWIFT_OPTIMIZATION_LEVEL=-O")
  
  echo "🚀 Building with smart optimizations..."
  echo "📋 Scheme: $scheme"
  echo "🎯 Destination: $destination"
  echo "⚙️  Configuration: $configuration"
  echo "🔨 Action: $action"
  echo ""
  
  # Execute with smart formatting
  local start_time=$(date +%s)
  
  if [[ "$verbose" == true ]]; then
    "${cmd[@]}" 2>&1 | smart_xcode_formatter
  else
    "${cmd[@]}" 2>&1 | smart_xcode_formatter | grep -E "(▸|❌|⚠️|✅|📊|🎉)"
  fi
  
  local exit_code=${PIPESTATUS[0]}
  local end_time=$(date +%s)
  local duration=$((end_time - start_time))
  
  echo ""
  if [[ $exit_code -eq 0 ]]; then
    echo "🎉 Build succeeded in ${duration}s"
  else
    echo "❌ Build failed in ${duration}s (exit code: $exit_code)"
  fi
  
  return $exit_code
}

# Smart Xcode output formatter (better than xcbeautify)
smart_xcode_formatter() {
  local line_count=0
  local warning_count=0
  local error_count=0
  local test_count=0
  local current_target=""
  
  while IFS= read -r line; do
    ((line_count++))
    
    # Clean ANSI escape sequences for processing
    local clean_line=$(echo "$line" | sed 's/\x1B\[[0-9;]*[JKmsu]//g')
    
    # Detect build phases and targets
    if [[ "$clean_line" =~ "Building target" ]]; then
      current_target=$(echo "$clean_line" | sed -n 's/.*Building target \([^[:space:]]*\).*/\1/p')
      echo "🎯 Building target: $current_target"
      continue
    elif [[ "$clean_line" =~ "=== BUILD TARGET" ]]; then
      current_target=$(echo "$clean_line" | sed -n 's/.*BUILD TARGET \([^[:space:]]*\).*/\1/p')
      echo "🎯 Building target: $current_target"
      continue
    fi
    
    # Format different types of output
    case "$clean_line" in
      *"Compile Swift"*|*"CompileSwift"*)
        local file=$(echo "$clean_line" | grep -o '[^/]*\.swift' | tail -1)
        echo "▸ 🔨 Compiling Swift: $file"
        ;;
      *"Compile"*" Objective-C"*|*"CompileC"*)
        local file=$(echo "$clean_line" | grep -o '[^/]*\.[cm]' | tail -1)
        echo "▸ 🔨 Compiling Objective-C: $file"
        ;;
      *"Linking"*|*"Ld "*|*" linking "*)
        echo "▸ 🔗 Linking..."
        ;;
      *"Copy"*|*"CpResource"*)
        local resource=$(echo "$clean_line" | grep -o '[^/]*\.[a-zA-Z0-9]*' | tail -1)
        echo "▸ 📁 Copying resource: $resource"
        ;;
      *"Archive"*)
        echo "▸ 📦 Archiving..."
        ;;
      *"Code signing"*|*"CodeSign"*)
        echo "▸ ✍️  Code signing..."
        ;;
      *"Running script"*|*"PhaseScriptExecution"*)
        local script=$(echo "$clean_line" | sed -n 's/.*Running script \(.*\)/\1/p')
        echo "▸ 📜 Running script: $script"
        ;;
      *"Test Suite"*" started"*)
        local suite=$(echo "$clean_line" | sed -n "s/.*Test Suite '\([^']*\)'.*/\1/p")
        echo "▸ 🧪 Testing suite: $suite"
        ;;
      *"Test Case"*" started"*)
        local test=$(echo "$clean_line" | sed -n "s/.*Test Case '\([^']*\)'.*/\1/p")
        echo "  ▸ Running test: $test"
        ((test_count++))
        ;;
      *"Test Case"*" passed"*)
        local test=$(echo "$clean_line" | sed -n "s/.*Test Case '\([^']*\)'.*/\1/p")
        local time=$(echo "$clean_line" | grep -o '([0-9.]*' | sed 's/(//')
        echo "  ✅ Passed: $test (${time}s)"
        ;;
      *"Test Case"*" failed"*)
        local test=$(echo "$clean_line" | sed -n "s/.*Test Case '\([^']*\)'.*/\1/p")
        echo "  ❌ Failed: $test"
        ;;
      *"warning:"*|*"Warning:"*)
        ((warning_count++))
        local warning=$(echo "$clean_line" | sed 's/.*warning: *//')
        echo "⚠️  Warning #$warning_count: $warning"
        ;;
      *"error:"*|*"Error:"*)
        ((error_count++))
        local error=$(echo "$clean_line" | sed 's/.*error: *//')
        echo "❌ Error #$error_count: $error"
        ;;
      *"BUILD SUCCEEDED"*)
        echo "🎉 BUILD SUCCEEDED"
        ;;
      *"BUILD FAILED"*)
        echo "💥 BUILD FAILED"
        ;;
      *"Testing failed"*)
        echo "💥 TESTING FAILED"
        ;;
      *"Testing succeeded"*)
        echo "🎉 TESTING SUCCEEDED"
        ;;
      "")
        # Skip empty lines
        continue
        ;;
      *)
        # For verbose mode, show other lines with less emphasis
        if [[ -n "$VERBOSE_XCODE" ]]; then
          echo "   $line"
        fi
        ;;
    esac
  done
  
  # Summary
  if [[ $line_count -gt 0 ]]; then
    echo ""
    echo "📊 Build Summary:"
    [[ $warning_count -gt 0 ]] && echo "   ⚠️  $warning_count warnings"
    [[ $error_count -gt 0 ]] && echo "   ❌ $error_count errors"
    [[ $test_count -gt 0 ]] && echo "   🧪 $test_count tests run"
  fi
}

# iOS Simulator management
ios_sim() {
  local action="$1"
  local device="${2:-iPhone 15}"
  
  case "$action" in
    "list"|"l")
      echo "📱 Available iOS Simulators:"
      xcrun simctl list devices iOS | grep -E "(iPhone|iPad)" | grep -v "unavailable"
      ;;
    "boot"|"b")
      echo "🚀 Booting $device..."
      xcrun simctl boot "$device" 2>/dev/null || xcrun simctl boot "$(xcrun simctl list devices | grep "$device" | head -1 | grep -o '[A-F0-9-]\{36\}')"
      open -a Simulator
      ;;
    "shutdown"|"s")
      echo "🛑 Shutting down all simulators..."
      xcrun simctl shutdown all
      ;;
    "reset"|"r")
      echo "🔄 Resetting $device..."
      local udid=$(xcrun simctl list devices | grep "$device" | head -1 | grep -o '[A-F0-9-]\{36\}')
      if [[ -n "$udid" ]]; then
        xcrun simctl erase "$udid"
        echo "✅ Reset complete"
      else
        echo "❌ Device not found"
      fi
      ;;
    "install"|"i")
      local app_path="$3"
      if [[ -z "$app_path" ]]; then
        echo "Usage: ios_sim install <device> <app_path>"
        return 1
      fi
      echo "📲 Installing app to $device..."
      local udid=$(xcrun simctl list devices | grep "$device" | head -1 | grep -o '[A-F0-9-]\{36\}')
      xcrun simctl install "$udid" "$app_path"
      ;;
    *)
      echo "iOS Simulator Manager"
      echo "Usage: ios_sim {list|boot|shutdown|reset|install} [device] [app_path]"
      echo ""
      echo "Commands:"
      echo "  list (l)      - List available simulators"
      echo "  boot (b)      - Boot simulator"
      echo "  shutdown (s)  - Shutdown all simulators"
      echo "  reset (r)     - Reset simulator"
      echo "  install (i)   - Install app to simulator"
      ;;
  esac
}

# Swift Package creation
swift_new() {
  local name="$1"
  local type="${2:-executable}"
  
  if [[ -z "$name" ]]; then
    echo "Usage: swift_new <name> [executable|library]"
    return 1
  fi
  
  echo "🆕 Creating Swift package: $name"
  mkdir "$name" && cd "$name"
  
  case "$type" in
    "executable"|"exec"|"app")
      swift package init --type executable --name "$name"
      echo "✅ Created executable Swift package"
      ;;
    "library"|"lib")
      swift package init --type library --name "$name"
      echo "✅ Created library Swift package"
      ;;
    *)
      echo "❌ Unknown package type: $type"
      echo "Available types: executable, library"
      return 1
      ;;
  esac
  
  # Add useful development dependencies
  echo "📦 Adding development dependencies..."
  
  # Open in Cursor
  cursor .
}

# AI Python environment setup
ai_env() {
  local env_name="${1:-ai-dev}"
  local python_version="${2:-3.11}"
  
  echo "🤖 Setting up AI development environment: $env_name"
  
  # Create conda environment
  if command -v conda &> /dev/null; then
    conda create -n "$env_name" python="$python_version" -y
    conda activate "$env_name"
    
    # Install common AI packages
    echo "📦 Installing AI packages..."
    conda install -c conda-forge -y \
      numpy pandas matplotlib seaborn \
      scikit-learn jupyter jupyterlab \
      pytorch torchvision torchaudio -c pytorch
    
    pip install \
      transformers datasets tokenizers \
      huggingface-hub accelerate \
      openai anthropic \
      streamlit gradio \
      langchain chromadb \
      ollama
    
    echo "✅ AI environment '$env_name' ready!"
    echo "💡 Activate with: conda activate $env_name"
  else
    echo "❌ Conda not found. Please install Anaconda or Miniconda first."
    return 1
  fi
}

# Xcode project analyzer
xc_analyze() {
  local project_path="${1:-.}"
  
  echo "🔍 Analyzing Xcode project..."
  cd "$project_path"
  
  # Find project files
  local xcworkspace=$(find . -name "*.xcworkspace" -maxdepth 1 | head -1)
  local xcodeproj=$(find . -name "*.xcodeproj" -maxdepth 1 | head -1)
  
  if [[ -n "$xcworkspace" ]]; then
    echo "📁 Workspace: $xcworkspace"
  elif [[ -n "$xcodeproj" ]]; then
    echo "📁 Project: $xcodeproj"
  else
    echo "❌ No Xcode project found"
    return 1
  fi
  
  # Analyze Swift files
  local swift_files=$(find . -name "*.swift" -not -path "./build/*" -not -path "./.build/*" | wc -l)
  local objc_files=$(find . -name "*.m" -o -name "*.mm" | wc -l)
  local header_files=$(find . -name "*.h" | wc -l)
  
  echo "📊 Code Statistics:"
  echo "   Swift files: $swift_files"
  echo "   Objective-C files: $objc_files"
  echo "   Header files: $header_files"
  
  # Check for common issues
  echo ""
  echo "🔍 Checking for common issues..."
  
  # Check for force unwrapping
  local force_unwraps=$(grep -r "!" --include="*.swift" . 2>/dev/null | grep -v "// " | wc -l)
  if [[ $force_unwraps -gt 10 ]]; then
    echo "⚠️  Found $force_unwraps potential force unwraps"
  fi
  
  # Check for retain cycles
  local weak_refs=$(grep -r "weak " --include="*.swift" . 2>/dev/null | wc -l)
  echo "✅ Found $weak_refs weak references (good for avoiding retain cycles)"
  
  # Check SwiftLint if available
  if command -v swiftlint &> /dev/null; then
    echo ""
    echo "🧹 Running SwiftLint analysis..."
    swiftlint lint --quiet | head -10
  fi
}

# Flutter Development Functions

# Smart Flutter project creation
flutter_new() {
  local name="$1"
  local template="${2:-app}"
  local platform="${3:-ios,android}"
  
  if [[ -z "$name" ]]; then
    echo "Usage: flutter_new <name> [template] [platforms]"
    echo "Templates: app, module, package, plugin"
    echo "Platforms: ios,android,web,macos,linux,windows"
    return 1
  fi
  
  echo "🆕 Creating Flutter project: $name"
  
  case "$template" in
    "app"|"application")
      flutter create --template=app --platforms="$platform" "$name"
      ;;
    "module")
      flutter create --template=module --platforms="$platform" "$name"
      ;;
    "package"|"pkg")
      flutter create --template=package "$name"
      ;;
    "plugin")
      flutter create --template=plugin --platforms="$platform" "$name"
      ;;
    *)
      echo "❌ Unknown template: $template"
      echo "Available templates: app, module, package, plugin"
      return 1
      ;;
  esac
  
  if [[ -d "$name" ]]; then
    cd "$name"
    
    # Add useful development dependencies
    echo "📦 Adding development dependencies..."
    flutter pub add dev:flutter_lints
    flutter pub add dev:build_runner
    
    # AI/ML packages if it's an app
    if [[ "$template" == "app" ]]; then
      read -p "Add AI/ML packages? (y/N): " -n 1 -r
      echo
      if [[ $REPLY =~ ^[Yy]$ ]]; then
        flutter pub add tflite_flutter
        flutter pub add camera
        flutter pub add image_picker
        flutter pub add http
        echo "✅ Added AI/ML packages"
      fi
    fi
    
    # Open in Cursor
    cursor .
    
    echo "✅ Flutter project '$name' created successfully!"
    echo "💡 Run 'flutter run' to start development"
  fi
}

# Flutter project analyzer
flutter_analyze() {
  local project_path="${1:-.}"
  
  echo "🔍 Analyzing Flutter project..."
  cd "$project_path"
  
  # Check if it's a Flutter project
  if [[ ! -f "pubspec.yaml" ]]; then
    echo "❌ Not a Flutter project (no pubspec.yaml found)"
    return 1
  fi
  
  echo "📁 Project: $(basename $(pwd))"
  
  # Get Flutter info
  local flutter_version=$(flutter --version | head -1 | awk '{print $2}')
  local dart_version=$(dart --version | awk '{print $4}')
  
  echo "🔧 Flutter: $flutter_version"
  echo "🎯 Dart: $dart_version"
  
  # Analyze Dart files
  local dart_files=$(find lib -name "*.dart" 2>/dev/null | wc -l)
  local test_files=$(find test -name "*.dart" 2>/dev/null | wc -l)
  
  echo ""
  echo "📊 Code Statistics:"
  echo "   Dart files: $dart_files"
  echo "   Test files: $test_files"
  
  # Check dependencies
  echo ""
  echo "📦 Dependencies:"
  grep -A 20 "dependencies:" pubspec.yaml | grep -E "^  [a-zA-Z]" | head -5
  
  # Run Flutter doctor
  echo ""
  echo "🩺 Flutter Doctor:"
  flutter doctor --android-licenses > /dev/null 2>&1
  flutter doctor
  
  # Run analysis
  echo ""
  echo "🔍 Running Dart analysis..."
  flutter analyze --no-congratulate
  
  # Check for common issues
  echo ""
  echo "🔍 Checking for common issues..."
  
  # Check for print statements
  local print_statements=$(grep -r "print(" lib/ 2>/dev/null | wc -l)
  if [[ $print_statements -gt 0 ]]; then
    echo "⚠️  Found $print_statements print statements (consider using debugPrint)"
  fi
  
  # Check for TODOs
  local todos=$(grep -r "TODO\|FIXME\|HACK" lib/ 2>/dev/null | wc -l)
  if [[ $todos -gt 0 ]]; then
    echo "📝 Found $todos TODOs/FIXMEs"
  fi
  
  echo "✅ Analysis complete"
}

# Device management (iOS Simulators + Android Emulators)
device_manager() {
  local action="$1"
  local device="$2"
  
  case "$action" in
    "list"|"l")
      echo "📱 Available Devices:"
      echo ""
      echo "iOS Simulators:"
      xcrun simctl list devices iOS | grep -E "(iPhone|iPad)" | grep -v "unavailable"
      echo ""
      echo "Android Emulators:"
      emulator -list-avds 2>/dev/null || echo "No Android emulators found"
      echo ""
      echo "Connected Devices:"
      flutter devices
      ;;
    "ios")
      ios_sim "${@:2}"
      ;;
    "android"|"droid")
      android_emulator "${@:2}"
      ;;
    "flutter"|"fl")
      echo "🔄 Refreshing Flutter devices..."
      flutter devices
      ;;
    *)
      echo "Device Manager"
      echo "Usage: device {list|ios|android|flutter} [device_name]"
      echo ""
      echo "Commands:"
      echo "  list (l)      - List all available devices"
      echo "  ios           - Manage iOS simulators"
      echo "  android       - Manage Android emulators"
      echo "  flutter       - Show Flutter-detected devices"
      echo ""
      echo "Examples:"
      echo "  device list"
      echo "  device ios boot 'iPhone 15'"
      echo "  device android boot Pixel_7"
      ;;
  esac
}

# Android emulator management
android_emulator() {
  local action="$1"
  local emulator_name="$2"
  
  case "$action" in
    "list"|"l")
      echo "🤖 Available Android Emulators:"
      emulator -list-avds 2>/dev/null || echo "No emulators found"
      ;;
    "boot"|"b"|"start")
      if [[ -z "$emulator_name" ]]; then
        echo "Usage: android_emulator boot <emulator_name>"
        echo "Available emulators:"
        emulator -list-avds 2>/dev/null
        return 1
      fi
      echo "🚀 Starting Android emulator: $emulator_name"
      emulator -avd "$emulator_name" -no-snapshot &
      ;;
    "create"|"c")
      if [[ -z "$emulator_name" ]]; then
        echo "Usage: android_emulator create <emulator_name>"
        return 1
      fi
      echo "🆕 Creating Android emulator: $emulator_name"
      avdmanager create avd -n "$emulator_name" -k "system-images;android-33;google_apis;arm64-v8a"
      ;;
    "delete"|"d")
      if [[ -z "$emulator_name" ]]; then
        echo "Usage: android_emulator delete <emulator_name>"
        return 1
      fi
      echo "🗑️  Deleting Android emulator: $emulator_name"
      avdmanager delete avd -n "$emulator_name"
      ;;
    "cold")
      if [[ -z "$emulator_name" ]]; then
        echo "Usage: android_emulator cold <emulator_name>"
        return 1
      fi
      echo "❄️  Cold booting Android emulator: $emulator_name"
      emulator -avd "$emulator_name" -no-snapshot -cold-boot &
      ;;
    *)
      echo "Android Emulator Manager"
      echo "Usage: android_emulator {list|boot|create|delete|cold} [emulator_name]"
      echo ""
      echo "Commands:"
      echo "  list (l)      - List available emulators"
      echo "  boot (b)      - Start emulator"
      echo "  create (c)    - Create new emulator"
      echo "  delete (d)    - Delete emulator"
      echo "  cold          - Cold boot emulator"
      ;;
  esac
}

# Flutter hot reload helper
flutter_hot() {
  local action="${1:-run}"
  
  case "$action" in
    "run"|"r")
      echo "🔥 Starting Flutter with hot reload..."
      flutter run --hot
      ;;
    "debug"|"d")
      echo "🐛 Starting Flutter in debug mode..."
      flutter run --debug --hot
      ;;
    "profile"|"p")
      echo "📊 Starting Flutter in profile mode..."
      flutter run --profile
      ;;
    "release"|"rel")
      echo "🚀 Starting Flutter in release mode..."
      flutter run --release
      ;;
    "web"|"w")
      echo "🌐 Starting Flutter web..."
      flutter run -d chrome --hot
      ;;
    *)
      echo "Flutter Hot Reload Helper"
      echo "Usage: flutter_hot {run|debug|profile|release|web}"
      echo ""
      echo "Commands:"
      echo "  run (r)       - Start with hot reload (default)"
      echo "  debug (d)     - Start in debug mode"
      echo "  profile (p)   - Start in profile mode"
      echo "  release (rel) - Start in release mode"
      echo "  web (w)       - Start web version"
      ;;
  esac
}

# Flutter build helper
flutter_build_smart() {
  local platform="${1:-apk}"
  local build_mode="${2:-debug}"
  
  echo "🔨 Building Flutter app for $platform in $build_mode mode..."
  
  case "$platform" in
    "apk"|"android")
      flutter build apk --$build_mode
      echo "✅ APK built: build/app/outputs/flutter-apk/app-$build_mode.apk"
      ;;
    "aab"|"bundle")
      flutter build appbundle --$build_mode
      echo "✅ AAB built: build/app/outputs/bundle/${build_mode}App/app-$build_mode.aab"
      ;;
    "ios")
      flutter build ios --$build_mode
      echo "✅ iOS app built"
      ;;
    "ipa")
      flutter build ipa --$build_mode
      echo "✅ IPA built: build/ios/ipa/"
      ;;
    "web")
      flutter build web --$build_mode
      echo "✅ Web app built: build/web/"
      ;;
    "macos")
      flutter build macos --$build_mode
      echo "✅ macOS app built: build/macos/Build/Products/"
      ;;
    *)
      echo "Usage: flutter_build_smart {apk|aab|ios|ipa|web|macos} [debug|profile|release]"
      echo ""
      echo "Platforms:"
      echo "  apk      - Android APK"
      echo "  aab      - Android App Bundle"
      echo "  ios      - iOS app"
      echo "  ipa      - iOS archive"
      echo "  web      - Web app"
      echo "  macos    - macOS app"
      ;;
  esac
}

# Flutter dependency manager
flutter_deps() {
  local action="$1"
  local package="$2"
  
  case "$action" in
    "add"|"a")
      if [[ -z "$package" ]]; then
        echo "Usage: flutter_deps add <package_name>"
        return 1
      fi
      echo "📦 Adding dependency: $package"
      flutter pub add "$package"
      ;;
    "remove"|"r")
      if [[ -z "$package" ]]; then
        echo "Usage: flutter_deps remove <package_name>"
        return 1
      fi
      echo "🗑️  Removing dependency: $package"
      flutter pub remove "$package"
      ;;
    "dev"|"d")
      if [[ -z "$package" ]]; then
        echo "Usage: flutter_deps dev <package_name>"
        return 1
      fi
      echo "📦 Adding dev dependency: $package"
      flutter pub add dev:"$package"
      ;;
    "get"|"g")
      echo "📥 Getting dependencies..."
      flutter pub get
      ;;
    "upgrade"|"u")
      echo "⬆️  Upgrading dependencies..."
      flutter pub upgrade
      ;;
    "outdated"|"o")
      echo "📊 Checking for outdated dependencies..."
      flutter pub outdated
      ;;
    "ai")
      echo "🤖 Adding AI/ML dependencies..."
      flutter pub add tflite_flutter camera image_picker http
      flutter pub add dev:build_runner
      echo "✅ AI/ML packages added"
      ;;
    *)
      echo "Flutter Dependency Manager"
      echo "Usage: flutter_deps {add|remove|dev|get|upgrade|outdated|ai} [package_name]"
      echo ""
      echo "Commands:"
      echo "  add (a)       - Add dependency"
      echo "  remove (r)    - Remove dependency"
      echo "  dev (d)       - Add dev dependency"
      echo "  get (g)       - Get all dependencies"
      echo "  upgrade (u)   - Upgrade dependencies"
      echo "  outdated (o)  - Check outdated packages"
      echo "  ai            - Add AI/ML packages"
      ;;
  esac
}

# Go Development Functions

# Smart Go project creation
go_new() {
  local name="$1"
  local type="${2:-app}"
  
  if [[ -z "$name" ]]; then
    echo "Usage: go_new <name> [type]"
    echo "Types: app, lib, api, cli, web"
    return 1
  fi
  
  echo "🆕 Creating Go project: $name"
  
  mkdir -p "$name"
  cd "$name"
  
  # Initialize Go module
  go mod init "$name"
  
  case "$type" in
    "app"|"application")
      cat > main.go <<EOF
package main

import "fmt"

func main() {
    fmt.Println("Hello, $name!")
}
EOF
      ;;
    "lib"|"library")
      cat > ${name}.go <<EOF
// Package $name provides...
package $name

// Version returns the version of $name
func Version() string {
    return "0.1.0"
}
EOF
      cat > ${name}_test.go <<EOF
package $name

import "testing"

func TestVersion(t *testing.T) {
    v := Version()
    if v == "" {
        t.Error("Version should not be empty")
    }
}
EOF
      ;;
    "api"|"rest")
      go get github.com/gin-gonic/gin
      cat > main.go <<EOF
package main

import (
    "github.com/gin-gonic/gin"
    "net/http"
)

func main() {
    r := gin.Default()
    
    r.GET("/health", func(c *gin.Context) {
        c.JSON(http.StatusOK, gin.H{
            "status": "ok",
            "service": "$name",
        })
    })
    
    r.Run(":8080")
}
EOF
      ;;
    "cli")
      go get github.com/spf13/cobra
      cat > main.go <<EOF
package main

import (
    "fmt"
    "github.com/spf13/cobra"
    "os"
)

var rootCmd = &cobra.Command{
    Use:   "$name",
    Short: "$name CLI application",
    Run: func(cmd *cobra.Command, args []string) {
        fmt.Println("Hello from $name CLI!")
    },
}

func main() {
    if err := rootCmd.Execute(); err != nil {
        fmt.Println(err)
        os.Exit(1)
    }
}
EOF
      ;;
    "web")
      cat > main.go <<EOF
package main

import (
    "html/template"
    "net/http"
    "log"
)

func homeHandler(w http.ResponseWriter, r *http.Request) {
    tmpl := \`<!DOCTYPE html>
<html>
<head><title>{{.Title}}</title></head>
<body><h1>Welcome to {{.Title}}!</h1></body>
</html>\`
    
    t, _ := template.New("home").Parse(tmpl)
    t.Execute(w, map[string]string{"Title": "$name"})
}

func main() {
    http.HandleFunc("/", homeHandler)
    log.Println("Server starting on :8080")
    log.Fatal(http.ListenAndServe(":8080", nil))
}
EOF
      ;;
    *)
      echo "❌ Unknown type: $type"
      echo "Available types: app, lib, api, cli, web"
      cd ..
      rm -rf "$name"
      return 1
      ;;
  esac
  
  # Create basic project structure
  mkdir -p {cmd,internal,pkg,api,web,scripts,configs,docs}
  
  # Create .gitignore
  cat > .gitignore <<EOF
# Binaries
*.exe
*.exe~
*.dll
*.so
*.dylib
$name

# Test binary, built with \`go test -c\`
*.test

# Output of the go coverage tool
*.out

# Go workspace file
go.work

# IDE
.vscode/
.idea/

# OS
.DS_Store
Thumbs.db

# Logs
*.log
EOF
  
  # Create Dockerfile
  cat > Dockerfile <<EOF
FROM golang:1.21-alpine AS builder

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o $name .

FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /app/$name .
CMD ["./$name"]
EOF
  
  # Create Makefile
  cat > Makefile <<EOF
.PHONY: build run test clean docker

APP_NAME=$name
VERSION ?= \$(shell git describe --tags --always --dirty)

build:
	go build -o \$(APP_NAME) .

run:
	go run .

test:
	go test -v ./...

test-cover:
	go test -v -cover ./...

clean:
	go clean
	rm -f \$(APP_NAME)

docker:
	docker build -t \$(APP_NAME):latest .

fmt:
	go fmt ./...

lint:
	golangci-lint run

deps:
	go mod tidy
	go mod download

dev:
	air # requires air for hot reload
EOF
  
  # Create README
  cat > README.md <<EOF
# $name

## Getting Started

\`\`\`bash
# Build
make build

# Run
make run

# Test
make test

# Docker
make docker
\`\`\`

## Development

\`\`\`bash
# Install air for hot reload
go install github.com/cosmtrek/air@latest

# Start development server
make dev
\`\`\`
EOF
  
  # Open in Cursor
  cursor .
  
  echo "✅ Go project '$name' created successfully!"
  echo "💡 Run 'make run' to start development"
}

# Smart Go runner with auto-detection
go_run_smart() {
  local target="${1:-.}"
  
  if [[ -f "Makefile" ]] && grep -q "run:" Makefile; then
    echo "🚀 Running with Make..."
    make run
  elif [[ -f "main.go" ]]; then
    echo "🚀 Running main.go..."
    go run main.go "${@:2}"
  elif [[ -f "cmd/main.go" ]]; then
    echo "🚀 Running cmd/main.go..."
    go run cmd/main.go "${@:2}"
  elif [[ -d "cmd" ]]; then
    local cmd_dirs=(cmd/*)
    if [[ ${#cmd_dirs[@]} -eq 1 && -d "${cmd_dirs[0]}" ]]; then
      echo "🚀 Running ${cmd_dirs[0]}..."
      go run "${cmd_dirs[0]}"/*.go "${@:2}"
    else
      echo "Multiple commands found in cmd/:"
      for dir in "${cmd_dirs[@]}"; do
        [[ -d "$dir" ]] && echo "  - $(basename "$dir")"
      done
      echo "Usage: go_run_smart <command_name>"
      return 1
    fi
  else
    echo "🚀 Running current package..."
    go run "$target" "${@:2}"
  fi
}

# Docker Management Functions

# Docker manager
docker_manager() {
  local action="$1"
  
  case "$action" in
    "ps"|"list"|"l")
      echo "🐳 Running Containers:"
      docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"
      ;;
    "images"|"i")
      echo "📦 Docker Images:"
      docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedSince}}"
      ;;
    "clean"|"c")
      echo "🧹 Cleaning Docker system..."
      docker system prune -f
      docker image prune -f
      ;;
    "deep-clean"|"dc")
      echo "🧹 Deep cleaning Docker system..."
      docker system prune -af --volumes
      ;;
    "stats"|"s")
      echo "📊 Docker Statistics:"
      docker stats --no-stream
      ;;
    "logs"|"log")
      local container="$2"
      if [[ -z "$container" ]]; then
        echo "Usage: docker_manager logs <container_name>"
        return 1
      fi
      docker logs -f "$container"
      ;;
    "exec"|"e")
      local container="$2"
      if [[ -z "$container" ]]; then
        echo "Usage: docker_manager exec <container_name>"
        return 1
      fi
      docker exec -it "$container" /bin/sh
      ;;
    "compose"|"up")
      if [[ -f "docker-compose.yml" ]] || [[ -f "docker-compose.yaml" ]]; then
        echo "🚀 Starting Docker Compose..."
        docker-compose up -d
      else
        echo "❌ No docker-compose.yml found"
        return 1
      fi
      ;;
    "down"|"stop")
      if [[ -f "docker-compose.yml" ]] || [[ -f "docker-compose.yaml" ]]; then
        echo "⏹️ Stopping Docker Compose..."
        docker-compose down
      else
        echo "❌ No docker-compose.yml found"
        return 1
      fi
      ;;
    *)
      echo "Docker Manager"
      echo "Usage: docker_manager {ps|images|clean|stats|logs|exec|compose|down}"
      echo ""
      echo "Commands:"
      echo "  ps (l)        - List running containers"
      echo "  images (i)    - List images"
      echo "  clean (c)     - Clean system"
      echo "  deep-clean    - Deep clean with volumes"
      echo "  stats (s)     - Show resource usage"
      echo "  logs          - Follow container logs"
      echo "  exec (e)      - Execute shell in container"
      echo "  compose (up)  - Start docker-compose"
      echo "  down (stop)   - Stop docker-compose"
      ;;
  esac
}

# Kubernetes Management Functions

# Kubernetes manager
k8s_manager() {
  local action="$1"
  
  case "$action" in
    "ctx"|"context")
      if command -v kubectx &> /dev/null; then
        kubectx "$2"
      else
        if [[ -n "$2" ]]; then
          kubectl config use-context "$2"
        else
          kubectl config get-contexts
        fi
      fi
      ;;
    "ns"|"namespace")
      if command -v kubens &> /dev/null; then
        kubens "$2"
      else
        if [[ -n "$2" ]]; then
          kubectl config set-context --current --namespace="$2"
        else
          kubectl get namespaces
        fi
      fi
      ;;
    "pods"|"p")
      echo "🏃 Pods:"
      kubectl get pods -o wide
      ;;
    "services"|"svc"|"s")
      echo "🔗 Services:"
      kubectl get services -o wide
      ;;
    "deployments"|"deploy"|"d")
      echo "🚀 Deployments:"
      kubectl get deployments -o wide
      ;;
    "all"|"a")
      echo "📋 All Resources:"
      kubectl get all
      ;;
    "logs"|"l")
      local pod="$2"
      if [[ -z "$pod" ]]; then
        echo "Usage: k8s_manager logs <pod_name>"
        echo "Available pods:"
        kubectl get pods --no-headers | awk '{print $1}'
        return 1
      fi
      kubectl logs -f "$pod"
      ;;
    "exec"|"e")
      local pod="$2"
      if [[ -z "$pod" ]]; then
        echo "Usage: k8s_manager exec <pod_name>"
        echo "Available pods:"
        kubectl get pods --no-headers | awk '{print $1}'
        return 1
      fi
      kubectl exec -it "$pod" -- /bin/sh
      ;;
    "port"|"pf")
      local pod="$2"
      local ports="$3"
      if [[ -z "$pod" ]] || [[ -z "$ports" ]]; then
        echo "Usage: k8s_manager port <pod_name> <local_port:remote_port>"
        return 1
      fi
      kubectl port-forward "$pod" "$ports"
      ;;
    "describe"|"desc")
      local resource="$2"
      local name="$3"
      if [[ -z "$resource" ]] || [[ -z "$name" ]]; then
        echo "Usage: k8s_manager describe <resource_type> <name>"
        return 1
      fi
      kubectl describe "$resource" "$name"
      ;;
    "apply"|"create")
      local file="$2"
      if [[ -z "$file" ]]; then
        if [[ -f "k8s.yaml" ]]; then
          file="k8s.yaml"
        elif [[ -d "k8s" ]]; then
          file="k8s/"
        else
          echo "Usage: k8s_manager apply <yaml_file>"
          return 1
        fi
      fi
      echo "📝 Applying $file..."
      kubectl apply -f "$file"
      ;;
    "delete"|"del")
      local file="$2"
      if [[ -z "$file" ]]; then
        echo "Usage: k8s_manager delete <yaml_file>"
        return 1
      fi
      kubectl delete -f "$file"
      ;;
    *)
      echo "Kubernetes Manager"
      echo "Usage: k8s_manager {ctx|ns|pods|services|deployments|all|logs|exec|port|describe|apply|delete}"
      echo ""
      echo "Commands:"
      echo "  ctx           - Switch context"
      echo "  ns            - Switch namespace"
      echo "  pods (p)      - List pods"
      echo "  services (s)  - List services"
      echo "  deployments   - List deployments"
      echo "  all (a)       - List all resources"
      echo "  logs (l)      - Follow pod logs"
      echo "  exec (e)      - Execute shell in pod"
      echo "  port (pf)     - Port forward"
      echo "  describe      - Describe resource"
      echo "  apply         - Apply YAML file"
      echo "  delete        - Delete resources"
      ;;
  esac
}

# Smart Deployment Functions

# Smart deployment manager
smart_deploy() {
  local platform="${1:-detect}"
  local environment="${2:-staging}"
  
  echo "🚀 Smart Deploy - Platform: $platform, Environment: $environment"
  
  # Auto-detect deployment platform if not specified
  if [[ "$platform" == "detect" ]]; then
    if [[ -f "Procfile" ]] && command -v heroku &> /dev/null; then
      platform="heroku"
    elif [[ -f "Dockerfile" ]] && [[ -d "k8s" || -f "k8s.yaml" ]]; then
      platform="k8s"
    elif [[ -f "Dockerfile" ]]; then
      platform="docker"
    elif [[ -f "serverless.yml" ]]; then
      platform="serverless"
    elif [[ -d ".aws" ]] || [[ -f "aws.yaml" ]]; then
      platform="aws"
    else
      echo "❌ Could not detect deployment platform"
      echo "Available platforms: heroku, k8s, docker, aws, serverless"
      return 1
    fi
    echo "🔍 Detected platform: $platform"
  fi
  
  case "$platform" in
    "heroku"|"h")
      deploy_heroku "$environment"
      ;;
    "k8s"|"kubernetes")
      deploy_k8s "$environment"
      ;;
    "docker"|"d")
      deploy_docker "$environment"
      ;;
    "aws"|"a")
      deploy_aws "$environment"
      ;;
    "serverless"|"sls")
      deploy_serverless "$environment"
      ;;
    *)
      echo "❌ Unknown platform: $platform"
      echo "Available platforms: heroku, k8s, docker, aws, serverless"
      return 1
      ;;
  esac
}

# Heroku deployment
deploy_heroku() {
  local environment="${1:-staging}"
  
  if ! command -v heroku &> /dev/null; then
    echo "❌ Heroku CLI not installed"
    return 1
  fi
  
  echo "🟣 Deploying to Heroku ($environment)..."
  
  # Check if git repo is clean
  if [[ -n "$(git status --porcelain)" ]]; then
    echo "⚠️  Git working directory is not clean"
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    [[ ! $REPLY =~ ^[Yy]$ ]] && return 1
  fi
  
  # Deploy based on environment
  if [[ "$environment" == "production" ]]; then
    git push heroku main
  else
    git push heroku-staging main
  fi
  
  # Open app if requested
  read -p "Open app in browser? (y/N): " -n 1 -r
  echo
  [[ $REPLY =~ ^[Yy]$ ]] && heroku open
}

# Kubernetes deployment
deploy_k8s() {
  local environment="${1:-staging}"
  
  if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl not installed"
    return 1
  fi
  
  echo "☸️ Deploying to Kubernetes ($environment)..."
  
  # Build Docker image if Dockerfile exists
  if [[ -f "Dockerfile" ]]; then
    local image_name=$(basename $(pwd))
    local tag="${environment}-$(git rev-parse --short HEAD)"
    
    echo "🐳 Building Docker image: $image_name:$tag"
    docker build -t "$image_name:$tag" .
    
    # Push to registry if configured
    if [[ -n "$DOCKER_REGISTRY" ]]; then
      docker tag "$image_name:$tag" "$DOCKER_REGISTRY/$image_name:$tag"
      docker push "$DOCKER_REGISTRY/$image_name:$tag"
    fi
  fi
  
  # Apply Kubernetes manifests
  if [[ -d "k8s/$environment" ]]; then
    kubectl apply -f "k8s/$environment/"
  elif [[ -f "k8s.yaml" ]]; then
    kubectl apply -f k8s.yaml
  elif [[ -d "k8s" ]]; then
    kubectl apply -f k8s/
  else
    echo "❌ No Kubernetes manifests found"
    return 1
  fi
  
  echo "✅ Deployed to Kubernetes"
}

# Docker deployment
deploy_docker() {
  local environment="${1:-staging}"
  
  if ! command -v docker &> /dev/null; then
    echo "❌ Docker not installed"
    return 1
  fi
  
  echo "🐳 Docker deployment ($environment)..."
  
  local image_name=$(basename $(pwd))
  local tag="${environment}-$(git rev-parse --short HEAD)"
  
  # Build image
  echo "🔨 Building image: $image_name:$tag"
  docker build -t "$image_name:$tag" .
  
  # Tag as latest for this environment
  docker tag "$image_name:$tag" "$image_name:$environment"
  
  # Push to registry if configured
  if [[ -n "$DOCKER_REGISTRY" ]]; then
    echo "📤 Pushing to registry..."
    docker tag "$image_name:$tag" "$DOCKER_REGISTRY/$image_name:$tag"
    docker tag "$image_name:$tag" "$DOCKER_REGISTRY/$image_name:$environment"
    docker push "$DOCKER_REGISTRY/$image_name:$tag"
    docker push "$DOCKER_REGISTRY/$image_name:$environment"
  fi
  
  echo "✅ Docker image built and tagged"
}

# AWS deployment
deploy_aws() {
  local environment="${1:-staging}"
  
  if ! command -v aws &> /dev/null; then
    echo "❌ AWS CLI not installed"
    return 1
  fi
  
  echo "☁️ AWS deployment ($environment)..."
  
  # Check AWS credentials
  if ! aws sts get-caller-identity &> /dev/null; then
    echo "❌ AWS credentials not configured"
    echo "Run: aws configure"
    return 1
  fi
  
  # Deploy based on available AWS configs
  if [[ -f "sam-template.yaml" ]] || [[ -f "template.yaml" ]]; then
    # SAM deployment
    sam build
    sam deploy --parameter-overrides Environment="$environment"
  elif [[ -f "cloudformation.yaml" ]]; then
    # CloudFormation deployment
    aws cloudformation deploy \
      --template-file cloudformation.yaml \
      --stack-name "$(basename $(pwd))-$environment" \
      --parameter-overrides Environment="$environment"
  elif [[ -f "cdk.json" ]]; then
    # CDK deployment
    cdk deploy --profile "$environment"
  else
    echo "❌ No AWS deployment configuration found"
    echo "Supported: SAM, CloudFormation, CDK"
    return 1
  fi
}

# Serverless deployment
deploy_serverless() {
  local environment="${1:-staging}"
  
  if ! command -v serverless &> /dev/null && ! command -v sls &> /dev/null; then
    echo "❌ Serverless framework not installed"
    return 1
  fi
  
  echo "⚡ Serverless deployment ($environment)..."
  
  if [[ -f "serverless.yml" ]]; then
    serverless deploy --stage "$environment"
  else
    echo "❌ serverless.yml not found"
    return 1
  fi
}

# JavaScript & TypeScript Development Functions

# Smart JavaScript/TypeScript project creation
js_new() {
  local name="$1"
  local framework="${2:-vanilla}"
  local package_manager="${3:-npm}"
  
  if [[ -z "$name" ]]; then
    echo "Usage: js_new <name> [framework] [package_manager]"
    echo "Frameworks: vanilla, react, next, vue, nuxt, svelte, angular, express, fastify, nest"
    echo "Package Managers: npm, yarn, pnpm, bun"
    return 1
  fi
  
  echo "🆕 Creating JavaScript project: $name ($framework)"
  
  case "$framework" in
    "vanilla"|"js"|"typescript"|"ts")
      mkdir -p "$name"
      cd "$name"
      
      # Initialize package.json
      if [[ "$package_manager" == "yarn" ]]; then
        yarn init -y
      elif [[ "$package_manager" == "pnpm" ]]; then
        pnpm init
      elif [[ "$package_manager" == "bun" ]]; then
        bun init
      else
        npm init -y
      fi
      
      # Create basic structure
      mkdir -p {src,dist,tests,docs}
      
      # Create main files
      if [[ "$framework" == "typescript" || "$framework" == "ts" ]]; then
        cat > src/index.ts <<EOF
console.log('Hello from TypeScript!');

export function greet(name: string): string {
  return \`Hello, \${name}!\`;
}
EOF
        
        cat > tsconfig.json <<EOF
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
EOF
        
        # Add TypeScript dependencies
        if [[ "$package_manager" == "yarn" ]]; then
          yarn add -D typescript @types/node ts-node nodemon
        elif [[ "$package_manager" == "pnpm" ]]; then
          pnpm add -D typescript @types/node ts-node nodemon
        elif [[ "$package_manager" == "bun" ]]; then
          bun add -d typescript @types/node
        else
          npm install --save-dev typescript @types/node ts-node nodemon
        fi
      else
        cat > src/index.js <<EOF
console.log('Hello from JavaScript!');

export function greet(name) {
  return \`Hello, \${name}!\`;
}
EOF
      fi
      
      # Create package.json scripts
      local scripts='"scripts": {
    "start": "node src/index.js",
    "dev": "nodemon src/index.js",
    "build": "echo \"Build step here\"",
    "test": "echo \"Tests here\"",
    "lint": "eslint src",
    "format": "prettier --write src"
  },'
      
      if [[ "$framework" == "typescript" || "$framework" == "ts" ]]; then
        scripts='"scripts": {
    "start": "node dist/index.js",
    "dev": "ts-node src/index.ts",
    "build": "tsc",
    "test": "echo \"Tests here\"",
    "lint": "eslint src --ext .ts",
    "format": "prettier --write src"
  },'
      fi
      
      # Update package.json with scripts
      node -e "
        const pkg = require('./package.json');
        pkg.scripts = {
          start: pkg.scripts?.start || 'node src/index.js',
          dev: 'nodemon src/index.js',
          build: 'echo \"Build step here\"',
          test: 'echo \"Tests here\"',
          lint: 'eslint src',
          format: 'prettier --write src'
        };
        if ('$framework' === 'typescript' || '$framework' === 'ts') {
          pkg.scripts.start = 'node dist/index.js';
          pkg.scripts.dev = 'ts-node src/index.ts';
          pkg.scripts.build = 'tsc';
          pkg.scripts.lint = 'eslint src --ext .ts';
        }
        require('fs').writeFileSync('package.json', JSON.stringify(pkg, null, 2));
      "
      ;;
    "react")
      if [[ "$package_manager" == "yarn" ]]; then
        yarn create react-app "$name" --template typescript
      elif [[ "$package_manager" == "pnpm" ]]; then
        pnpm create react-app "$name" --template typescript
      elif [[ "$package_manager" == "bun" ]]; then
        bun create react "$name"
      else
        npx create-react-app "$name" --template typescript
      fi
      cd "$name"
      ;;
    "next"|"nextjs")
      if [[ "$package_manager" == "yarn" ]]; then
        yarn create next-app "$name" --typescript --tailwind --eslint --app
      elif [[ "$package_manager" == "pnpm" ]]; then
        pnpm create next-app "$name" --typescript --tailwind --eslint --app
      elif [[ "$package_manager" == "bun" ]]; then
        bun create next "$name"
      else
        npx create-next-app "$name" --typescript --tailwind --eslint --app
      fi
      cd "$name"
      ;;
    "vue")
      if [[ "$package_manager" == "yarn" ]]; then
        yarn create vue "$name"
      elif [[ "$package_manager" == "pnpm" ]]; then
        pnpm create vue "$name"
      elif [[ "$package_manager" == "bun" ]]; then
        bun create vue "$name"
      else
        npx create-vue "$name"
      fi
      cd "$name"
      ;;
    "nuxt"|"nuxtjs")
      if [[ "$package_manager" == "yarn" ]]; then
        yarn create nuxt-app "$name"
      elif [[ "$package_manager" == "pnpm" ]]; then
        pnpm create nuxt-app "$name"
      elif [[ "$package_manager" == "bun" ]]; then
        bun create nuxt "$name"
      else
        npx create-nuxt-app "$name"
      fi
      cd "$name"
      ;;
    "svelte")
      if [[ "$package_manager" == "yarn" ]]; then
        yarn create svelte "$name"
      elif [[ "$package_manager" == "pnpm" ]]; then
        pnpm create svelte "$name"
      elif [[ "$package_manager" == "bun" ]]; then
        bun create svelte "$name"
      else
        npx create-svelte "$name"
      fi
      cd "$name"
      ;;
    "vite")
      if [[ "$package_manager" == "yarn" ]]; then
        yarn create vite "$name" --template vanilla-ts
      elif [[ "$package_manager" == "pnpm" ]]; then
        pnpm create vite "$name" --template vanilla-ts
      elif [[ "$package_manager" == "bun" ]]; then
        bun create vite "$name"
      else
        npx create-vite "$name" --template vanilla-ts
      fi
      cd "$name"
      ;;
    "angular")
      npx @angular/cli new "$name" --routing --style=scss --strict
      cd "$name"
      ;;
    "express")
      mkdir -p "$name"
      cd "$name"
      
      if [[ "$package_manager" == "yarn" ]]; then
        yarn init -y
        yarn add express
        yarn add -D nodemon @types/express typescript ts-node
      elif [[ "$package_manager" == "pnpm" ]]; then
        pnpm init
        pnpm add express
        pnpm add -D nodemon @types/express typescript ts-node
      elif [[ "$package_manager" == "bun" ]]; then
        bun init
        bun add express
        bun add -d @types/express typescript
      else
        npm init -y
        npm install express
        npm install --save-dev nodemon @types/express typescript ts-node
      fi
      
      mkdir -p {src,dist}
      cat > src/index.ts <<EOF
import express from 'express';

const app = express();
const port = process.env.PORT || 3000;

app.use(express.json());

app.get('/', (req, res) => {
  res.json({ message: 'Hello from $name API!' });
});

app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

app.listen(port, () => {
  console.log(\`Server running on port \${port}\`);
});
EOF
      ;;
    "fastify")
      mkdir -p "$name"
      cd "$name"
      
      if [[ "$package_manager" == "yarn" ]]; then
        yarn init -y
        yarn add fastify
        yarn add -D nodemon @types/node typescript ts-node
      elif [[ "$package_manager" == "pnpm" ]]; then
        pnpm init
        pnpm add fastify
        pnpm add -D nodemon @types/node typescript ts-node
      elif [[ "$package_manager" == "bun" ]]; then
        bun init
        bun add fastify
        bun add -d @types/node typescript
      else
        npm init -y
        npm install fastify
        npm install --save-dev nodemon @types/node typescript ts-node
      fi
      
      mkdir -p {src,dist}
      cat > src/index.ts <<EOF
import Fastify from 'fastify';

const fastify = Fastify({ logger: true });

fastify.get('/', async (request, reply) => {
  return { message: 'Hello from $name API!' };
});

fastify.get('/health', async (request, reply) => {
  return { status: 'ok', timestamp: new Date().toISOString() };
});

const start = async () => {
  try {
    await fastify.listen({ port: 3000 });
    console.log('Server running on port 3000');
  } catch (err) {
    fastify.log.error(err);
    process.exit(1);
  }
};

start();
EOF
      ;;
    "nest"|"nestjs")
      npx @nestjs/cli new "$name" --package-manager="$package_manager"
      cd "$name"
      ;;
    *)
      echo "❌ Unknown framework: $framework"
      echo "Available frameworks: vanilla, react, next, vue, nuxt, svelte, angular, express, fastify, nest"
      return 1
      ;;
  esac
  
  # Create common files for all projects
  if [[ ! -f ".gitignore" ]]; then
    cat > .gitignore <<EOF
# Dependencies
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*
pnpm-debug.log*
.pnpm-debug.log*

# Runtime data
pids
*.pid
*.seed
*.pid.lock

# Coverage directory used by tools like istanbul
coverage/
*.lcov

# nyc test coverage
.nyc_output

# Dependency directories
.npm
.eslintcache

# Optional npm cache directory
.npm

# Build outputs
dist/
build/
out/

# Environment variables
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# TypeScript
*.tsbuildinfo

# Logs
*.log
logs/
EOF
  fi
  
  # Create Dockerfile for backend projects
  if [[ "$framework" == "express" || "$framework" == "fastify" || "$framework" == "nest" ]]; then
    cat > Dockerfile <<EOF
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

COPY . .

EXPOSE 3000

CMD ["npm", "start"]
EOF
  fi
  
  # Open in Cursor
  cursor .
  
  echo "✅ JavaScript project '$name' created successfully!"
  echo "💡 Run '${package_manager} run dev' to start development"
}

# Smart JavaScript runner
js_run_smart() {
  local action="${1:-dev}"
  
  # Detect package manager
  local pm="npm"
  if [[ -f "yarn.lock" ]]; then
    pm="yarn"
  elif [[ -f "pnpm-lock.yaml" ]]; then
    pm="pnpm"
  elif [[ -f "bun.lockb" ]]; then
    pm="bun"
  fi
  
  case "$action" in
    "dev"|"d")
      echo "🚀 Starting development server with $pm..."
      $pm run dev 2>/dev/null || $pm run start
      ;;
    "build"|"b")
      echo "🔨 Building project with $pm..."
      $pm run build
      ;;
    "start"|"s")
      echo "▶️ Starting production server with $pm..."
      $pm start
      ;;
    "test"|"t")
      echo "🧪 Running tests with $pm..."
      $pm test
      ;;
    "lint"|"l")
      echo "🔍 Linting code with $pm..."
      $pm run lint
      ;;
    "format"|"f")
      echo "💅 Formatting code with $pm..."
      $pm run format 2>/dev/null || $pm run prettier
      ;;
    *)
      echo "JavaScript Runner"
      echo "Usage: js_run_smart {dev|build|start|test|lint|format}"
      echo ""
      echo "Commands:"
      echo "  dev (d)       - Start development server"
      echo "  build (b)     - Build for production"
      echo "  start (s)     - Start production server"
      echo "  test (t)      - Run tests"
      echo "  lint (l)      - Lint code"
      echo "  format (f)    - Format code"
      ;;
  esac
}

# Smart JavaScript test runner
js_test_smart() {
  local type="${1:-unit}"
  
  # Detect package manager and test framework
  local pm="npm"
  if [[ -f "yarn.lock" ]]; then
    pm="yarn"
  elif [[ -f "pnpm-lock.yaml" ]]; then
    pm="pnpm"
  elif [[ -f "bun.lockb" ]]; then
    pm="bun"
  fi
  
  case "$type" in
    "unit"|"u")
      echo "🧪 Running unit tests..."
      if [[ -f "vitest.config.js" || -f "vitest.config.ts" ]]; then
        $pm run test
      elif [[ -f "jest.config.js" || -f "jest.config.ts" ]]; then
        $pm run test
      else
        $pm test
      fi
      ;;
    "watch"|"w")
      echo "👀 Running tests in watch mode..."
      $pm run test:watch 2>/dev/null || $pm run test -- --watch
      ;;
    "coverage"|"c")
      echo "📊 Running tests with coverage..."
      $pm run test:coverage 2>/dev/null || $pm run test -- --coverage
      ;;
    "e2e")
      echo "🎭 Running end-to-end tests..."
      if command -v cypress &> /dev/null; then
        npx cypress run
      elif command -v playwright &> /dev/null; then
        npx playwright test
      else
        $pm run test:e2e 2>/dev/null || echo "No e2e test runner found"
      fi
      ;;
    *)
      echo "JavaScript Test Runner"
      echo "Usage: js_test_smart {unit|watch|coverage|e2e}"
      echo ""
      echo "Commands:"
      echo "  unit (u)      - Run unit tests"
      echo "  watch (w)     - Run tests in watch mode"
      echo "  coverage (c)  - Run tests with coverage"
      echo "  e2e           - Run end-to-end tests"
      ;;
  esac
}

# Smart JavaScript build system
js_build_smart() {
  local target="${1:-production}"
  local optimize="${2:-true}"
  
  # Detect package manager and build tool
  local pm="npm"
  if [[ -f "yarn.lock" ]]; then
    pm="yarn"
  elif [[ -f "pnpm-lock.yaml" ]]; then
    pm="pnpm"
  elif [[ -f "bun.lockb" ]]; then
    pm="bun"
  fi
  
  echo "🔨 Building JavaScript project for $target..."
  
  case "$target" in
    "production"|"prod"|"p")
      # Set production environment
      export NODE_ENV=production
      
      # Run build
      if [[ -f "vite.config.js" || -f "vite.config.ts" ]]; then
        $pm run build
      elif [[ -f "webpack.config.js" ]]; then
        $pm run build
      elif [[ -f "next.config.js" ]]; then
        $pm run build
      elif [[ -f "angular.json" ]]; then
        $pm run build --prod
      else
        $pm run build
      fi
      
      echo "✅ Production build complete"
      ;;
    "development"|"dev"|"d")
      export NODE_ENV=development
      $pm run build:dev 2>/dev/null || $pm run build
      echo "✅ Development build complete"
      ;;
    "preview"|"pre")
      echo "👀 Building and starting preview server..."
      $pm run build
      if [[ -f "vite.config.js" || -f "vite.config.ts" ]]; then
        $pm run preview
      elif [[ -f "next.config.js" ]]; then
        $pm start
      else
        echo "Preview server not available for this project type"
      fi
      ;;
    "analyze"|"a")
      echo "📊 Building with bundle analyzer..."
      if [[ -f "next.config.js" ]]; then
        ANALYZE=true $pm run build
      elif [[ -f "vite.config.js" || -f "vite.config.ts" ]]; then
        $pm run build --mode analyze
      else
        $pm run build:analyze 2>/dev/null || $pm run build
      fi
      ;;
    *)
      echo "JavaScript Build System"
      echo "Usage: js_build_smart {production|development|preview|analyze}"
      echo ""
      echo "Commands:"
      echo "  production (p) - Build for production"
      echo "  development    - Build for development"
      echo "  preview        - Build and preview"
      echo "  analyze (a)    - Build with bundle analysis"
      ;;
  esac
}

# JavaScript dependency manager
js_deps_manager() {
  local action="$1"
  local package="$2"
  
  # Detect package manager
  local pm="npm"
  if [[ -f "yarn.lock" ]]; then
    pm="yarn"
  elif [[ -f "pnpm-lock.yaml" ]]; then
    pm="pnpm"
  elif [[ -f "bun.lockb" ]]; then
    pm="bun"
  fi
  
  case "$action" in
    "add"|"a")
      if [[ -z "$package" ]]; then
        echo "Usage: js_deps_manager add <package_name>"
        return 1
      fi
      echo "📦 Adding dependency: $package"
      case "$pm" in
        "yarn") yarn add "$package" ;;
        "pnpm") pnpm add "$package" ;;
        "bun") bun add "$package" ;;
        *) npm install "$package" ;;
      esac
      ;;
    "remove"|"r")
      if [[ -z "$package" ]]; then
        echo "Usage: js_deps_manager remove <package_name>"
        return 1
      fi
      echo "🗑️ Removing dependency: $package"
      case "$pm" in
        "yarn") yarn remove "$package" ;;
        "pnpm") pnpm remove "$package" ;;
        "bun") bun remove "$package" ;;
        *) npm uninstall "$package" ;;
      esac
      ;;
    "dev"|"d")
      if [[ -z "$package" ]]; then
        echo "Usage: js_deps_manager dev <package_name>"
        return 1
      fi
      echo "📦 Adding dev dependency: $package"
      case "$pm" in
        "yarn") yarn add -D "$package" ;;
        "pnpm") pnpm add -D "$package" ;;
        "bun") bun add -d "$package" ;;
        *) npm install --save-dev "$package" ;;
      esac
      ;;
    "install"|"i")
      echo "📥 Installing dependencies with $pm..."
      case "$pm" in
        "yarn") yarn install ;;
        "pnpm") pnpm install ;;
        "bun") bun install ;;
        *) npm install ;;
      esac
      ;;
    "update"|"u")
      echo "⬆️ Updating dependencies with $pm..."
      case "$pm" in
        "yarn") yarn upgrade ;;
        "pnpm") pnpm update ;;
        "bun") bun update ;;
        *) npm update ;;
      esac
      ;;
    "outdated"|"o")
      echo "📊 Checking outdated dependencies..."
      case "$pm" in
        "yarn") yarn outdated ;;
        "pnpm") pnpm outdated ;;
        "bun") bun outdated ;;
        *) npm outdated ;;
      esac
      ;;
    "audit"|"security")
      echo "🔒 Running security audit..."
      case "$pm" in
        "yarn") yarn audit ;;
        "pnpm") pnpm audit ;;
        "bun") bun audit ;;
        *) npm audit ;;
      esac
      ;;
    "clean"|"c")
      echo "🧹 Cleaning dependencies..."
      rm -rf node_modules
      case "$pm" in
        "yarn") rm -f yarn.lock ;;
        "pnpm") rm -f pnpm-lock.yaml ;;
        "bun") rm -f bun.lockb ;;
        *) rm -f package-lock.json ;;
      esac
      echo "Run 'js_deps_manager install' to reinstall"
      ;;
    "ui")
      echo "🎨 Adding common UI framework dependencies..."
      read -p "Choose UI framework (tailwind/bootstrap/mui/chakra): " ui_choice
      case "$ui_choice" in
        "tailwind")
          case "$pm" in
            "yarn") yarn add -D tailwindcss postcss autoprefixer ;;
            "pnpm") pnpm add -D tailwindcss postcss autoprefixer ;;
            "bun") bun add -d tailwindcss postcss autoprefixer ;;
            *) npm install --save-dev tailwindcss postcss autoprefixer ;;
          esac
          npx tailwindcss init -p
          ;;
        "bootstrap")
          case "$pm" in
            "yarn") yarn add bootstrap ;;
            "pnpm") pnpm add bootstrap ;;
            "bun") bun add bootstrap ;;
            *) npm install bootstrap ;;
          esac
          ;;
        "mui")
          case "$pm" in
            "yarn") yarn add @mui/material @emotion/react @emotion/styled ;;
            "pnpm") pnpm add @mui/material @emotion/react @emotion/styled ;;
            "bun") bun add @mui/material @emotion/react @emotion/styled ;;
            *) npm install @mui/material @emotion/react @emotion/styled ;;
          esac
          ;;
        "chakra")
          case "$pm" in
            "yarn") yarn add @chakra-ui/react @emotion/react @emotion/styled framer-motion ;;
            "pnpm") pnpm add @chakra-ui/react @emotion/react @emotion/styled framer-motion ;;
            "bun") bun add @chakra-ui/react @emotion/react @emotion/styled framer-motion ;;
            *) npm install @chakra-ui/react @emotion/react @emotion/styled framer-motion ;;
          esac
          ;;
      esac
      ;;
    *)
      echo "JavaScript Dependency Manager (using $pm)"
      echo "Usage: js_deps_manager {add|remove|dev|install|update|outdated|audit|clean|ui}"
      echo ""
      echo "Commands:"
      echo "  add (a)       - Add dependency"
      echo "  remove (r)    - Remove dependency"
      echo "  dev (d)       - Add dev dependency"
      echo "  install (i)   - Install all dependencies"
      echo "  update (u)    - Update dependencies"
      echo "  outdated (o)  - Check outdated packages"
      echo "  audit         - Security audit"
      echo "  clean (c)     - Clean node_modules"
      echo "  ui            - Add UI framework"
      ;;
  esac
}

# ==========================================
# AI-Powered Development with Ollama
# ==========================================

# Ollama model management
ollama_manager() {
  local action="$1"
  local model="$2"
  
  case "$action" in
    "list"|"l")
      echo "🤖 Available Local Models:"
      ollama list
      echo ""
      echo "📋 Popular Models for Development:"
      echo "  🔥 codellama        - Code generation and completion"
      echo "  🧠 llama2           - General purpose chat"
      echo "  ⚡ mistral          - Fast and efficient"
      echo "  🎯 deepseek-coder   - Specialized code assistant"
      echo "  📝 wizard-coder     - Code explanation and docs"
      echo "  🐍 codellama:python - Python-specific model"
      echo "  ☕ codellama:java   - Java-specific model"
      echo "  🦀 codellama:rust   - Rust-specific model"
      ;;
    "download"|"d"|"pull")
      if [[ -z "$model" ]]; then
        echo "Usage: ollama_manager download <model_name>"
        echo "Popular models: codellama, llama2, mistral, deepseek-coder"
        return 1
      fi
      echo "📥 Downloading model: $model"
      ollama pull "$model"
      ;;
    "remove"|"r"|"rm")
      if [[ -z "$model" ]]; then
        echo "Usage: ollama_manager remove <model_name>"
        ollama list
        return 1
      fi
      echo "🗑️ Removing model: $model"
      ollama rm "$model"
      ;;
    "run"|"chat")
      if [[ -z "$model" ]]; then
        echo "Usage: ollama_manager run <model_name>"
        ollama list
        return 1
      fi
      echo "💬 Starting chat with $model"
      ollama run "$model"
      ;;
    "info"|"i")
      if [[ -z "$model" ]]; then
        echo "Usage: ollama_manager info <model_name>"
        ollama list
        return 1
      fi
      echo "ℹ️ Model information: $model"
      ollama show "$model"
      ;;
    "serve"|"start")
      echo "🚀 Starting Ollama server..."
      ollama serve &
      ;;
    "stop")
      echo "🛑 Stopping Ollama server..."
      pkill -f ollama || echo "Ollama server not running"
      ;;
    "status"|"ps")
      echo "📊 Ollama Status:"
      if pgrep -f ollama > /dev/null; then
        echo "✅ Ollama server is running"
        echo "🤖 Available models:"
        ollama list
      else
        echo "❌ Ollama server is not running"
        echo "Run 'ollama_manager serve' to start"
      fi
      ;;
    "models"|"popular")
      echo "🔥 Popular Models for Development:"
      echo ""
      echo "📝 Code Generation & Completion:"
      echo "  codellama (7B/13B/34B)  - Meta's code-focused model"
      echo "  deepseek-coder (1.3B/7B) - Specialized coding assistant"
      echo "  wizard-coder (15B)      - Enhanced code understanding"
      echo "  starcoder (15B)         - GitHub-trained coding model"
      echo ""
      echo "🧠 General Purpose:"
      echo "  llama2 (7B/13B/70B)    - Meta's general chat model"
      echo "  mistral (7B)            - Fast and efficient"
      echo "  mixtral (8x7B)          - Mixture of experts model"
      echo ""
      echo "🎯 Language-Specific:"
      echo "  codellama:python        - Python development"
      echo "  codellama:java          - Java development"
      echo "  codellama:rust          - Rust development"
      echo ""
      echo "📚 Documentation & Explanation:"
      echo "  llama2-uncensored       - Detailed technical explanations"
      echo "  dolphin-mistral         - Helpful coding assistant"
      ;;
    *)
      echo "🤖 Ollama Manager"
      echo "Usage: ollama_manager {list|download|remove|run|info|serve|stop|status|models}"
      echo ""
      echo "Commands:"
      echo "  list (l)        - List installed models"
      echo "  download (d)    - Download/pull a model"
      echo "  remove (r)      - Remove a model"
      echo "  run            - Start interactive chat"
      echo "  info (i)       - Show model information"
      echo "  serve          - Start Ollama server"
      echo "  stop           - Stop Ollama server"
      echo "  status         - Check server status"
      echo "  models         - Show popular models"
      echo ""
      echo "Examples:"
      echo "  ollama_manager download codellama"
      echo "  ollama_manager run deepseek-coder"
      echo "  ollama_manager list"
      ;;
  esac
}

# AI-powered code explanation
ai_explain() {
  local file="$1"
  local model="${2:-codellama}"
  
  if [[ -z "$file" ]]; then
    echo "Usage: ai_explain <file> [model]"
    echo "Example: ai_explain src/main.py deepseek-coder"
    return 1
  fi
  
  if [[ ! -f "$file" ]]; then
    echo "❌ File not found: $file"
    return 1
  fi
  
  echo "🧠 Analyzing code in $file with $model..."
  echo ""
  
  local prompt="Please analyze and explain this code. Focus on:
1. What the code does (high-level purpose)
2. Key functions and their roles
3. Important patterns or techniques used
4. Potential improvements or issues
5. Dependencies and architecture

Here's the code:

\`\`\`
$(cat "$file")
\`\`\`"
  
  echo "$prompt" | ollama run "$model"
}

# AI-powered commit message generation
ai_commit() {
  local model="${1:-codellama}"
  
  # Check if there are staged changes
  if ! git diff --cached --quiet; then
    echo "🤖 Generating commit message with $model..."
    echo ""
    
    local changes=$(git diff --cached --stat)
    local diff=$(git diff --cached)
    
    local prompt="Based on the following git diff, generate a concise, clear commit message following conventional commit format.

Git diff stats:
$changes

Git diff:
$diff

Please provide:
1. A conventional commit message (type: description)
2. A brief explanation of what changed

Use types like: feat, fix, docs, style, refactor, test, chore"
    
    echo "📊 Staged changes:"
    echo "$changes"
    echo ""
    echo "💡 AI suggested commit message:"
    echo ""
    echo "$prompt" | ollama run "$model" --format json | jq -r '.message' 2>/dev/null || echo "$prompt" | ollama run "$model"
  else
    echo "❌ No staged changes found. Stage your changes first with 'git add'"
  fi
}

# AI-powered code review
ai_review() {
  local file="${1:-.}"
  local model="${2:-deepseek-coder}"
  
  if [[ "$file" == "." ]]; then
    # Review uncommitted changes
    if git diff --quiet; then
      echo "❌ No uncommitted changes to review"
      return 1
    fi
    
    echo "🔍 Reviewing uncommitted changes with $model..."
    local changes=$(git diff)
    
    local prompt="Please review this code diff and provide feedback on:
1. Code quality and best practices
2. Potential bugs or issues
3. Performance considerations
4. Security concerns
5. Suggestions for improvement

Here's the diff:
$changes"
    
    echo "$prompt" | ollama run "$model"
  else
    # Review specific file
    if [[ ! -f "$file" ]]; then
      echo "❌ File not found: $file"
      return 1
    fi
    
    echo "🔍 Reviewing $file with $model..."
    
    local prompt="Please review this code file and provide feedback on:
1. Code quality and best practices
2. Potential bugs or issues
3. Performance considerations
4. Security concerns
5. Suggestions for improvement

Here's the code:
\`\`\`
$(cat "$file")
\`\`\`"
    
    echo "$prompt" | ollama run "$model"
  fi
}

# AI-powered documentation generation
ai_docs() {
  local file="$1"
  local model="${2:-codellama}"
  local output_file="${3:-README.md}"
  
  if [[ -z "$file" ]]; then
    echo "Usage: ai_docs <file|directory> [model] [output_file]"
    echo "Example: ai_docs src/ deepseek-coder DOCS.md"
    return 1
  fi
  
  echo "📝 Generating documentation for $file with $model..."
  
  local content=""
  if [[ -d "$file" ]]; then
    # Directory - analyze structure and key files
    content="Project structure:\n$(tree "$file" 2>/dev/null || find "$file" -type f -name "*.py" -o -name "*.js" -o -name "*.go" -o -name "*.rs" -o -name "*.java" | head -20)\n\n"
    
    # Add main files content
    for main_file in "$file"/{main,index,app}.{py,js,ts,go,rs,java}; do
      if [[ -f "$main_file" ]]; then
        content+="\nMain file: $main_file\n\`\`\`\n$(head -50 "$main_file")\n\`\`\`\n"
      fi
    done
  else
    # Single file
    content="File: $file\n\`\`\`\n$(cat "$file")\n\`\`\`"
  fi
  
  local prompt="Generate comprehensive documentation for this project/code. Include:

1. Project Overview and Purpose
2. Installation/Setup Instructions
3. Usage Examples
4. API Documentation (if applicable)
5. Configuration Options
6. Contributing Guidelines
7. License Information

Here's the code/project information:
$content"
  
  echo "$prompt" | ollama run "$model" > "$output_file"
  echo "✅ Documentation generated: $output_file"
}

# AI-powered test generation
ai_test() {
  local file="$1"
  local model="${2:-codellama}"
  local framework="$3"
  
  if [[ -z "$file" ]]; then
    echo "Usage: ai_test <file> [model] [framework]"
    echo "Example: ai_test src/utils.py deepseek-coder pytest"
    return 1
  fi
  
  if [[ ! -f "$file" ]]; then
    echo "❌ File not found: $file"
    return 1
  fi
  
  # Auto-detect test framework if not provided
  if [[ -z "$framework" ]]; then
    case "${file##*.}" in
      py) framework="pytest" ;;
      js|ts) framework="jest" ;;
      go) framework="testing" ;;
      java) framework="junit" ;;
      rs) framework="cargo test" ;;
      *) framework="unittest" ;;
    esac
  fi
  
  echo "🧪 Generating tests for $file using $framework with $model..."
  
  local file_content=$(cat "$file")
  local prompt="Generate comprehensive unit tests for this code using $framework. Include:

1. Test cases for all public functions/methods
2. Edge cases and error handling
3. Mock objects where needed
4. Setup and teardown if required
5. Good test naming conventions

Here's the code to test:
\`\`\`
$file_content
\`\`\`

Please generate complete, runnable test code."
  
  local test_file="${file%.*}_test.${file##*.}"
  case "${file##*.}" in
    py) test_file="test_$(basename "${file%.*}").py" ;;
    js|ts) test_file="$(basename "${file%.*}").test.${file##*.}" ;;
    go) test_file="${file%.*}_test.go" ;;
    java) test_file="$(basename "${file%.*}")Test.java" ;;
    rs) test_file="${file%.*}_test.rs" ;;
  esac
  
  echo "$prompt" | ollama run "$model" > "$test_file"
  echo "✅ Tests generated: $test_file"
}

# AI-powered error explanation
ai_debug() {
  local error_log="$1"
  local model="${2:-deepseek-coder}"
  
  if [[ -z "$error_log" ]]; then
    echo "Usage: ai_debug <error_message_or_file> [model]"
    echo "Example: ai_debug error.log"
    echo "Or pipe error: some_command 2>&1 | ai_debug -"
    return 1
  fi
  
  local error_content=""
  if [[ "$error_log" == "-" ]]; then
    # Read from stdin
    error_content=$(cat)
  elif [[ -f "$error_log" ]]; then
    # Read from file
    error_content=$(cat "$error_log")
  else
    # Treat as direct error message
    error_content="$error_log"
  fi
  
  echo "🐛 Analyzing error with $model..."
  echo ""
  
  local prompt="Please analyze this error message and provide:

1. What the error means in simple terms
2. Common causes of this error
3. Step-by-step troubleshooting guide
4. Code examples of fixes (if applicable)
5. Prevention tips for the future

Error details:
$error_content"
  
  echo "$prompt" | ollama run "$model"
}

# AI-powered code translation between languages
ai_translate() {
  local source_file="$1"
  local target_lang="$2"
  local model="${3:-codellama}"
  
  if [[ -z "$source_file" || -z "$target_lang" ]]; then
    echo "Usage: ai_translate <source_file> <target_language> [model]"
    echo "Example: ai_translate script.py javascript deepseek-coder"
    echo "Supported languages: python, javascript, typescript, go, rust, java, c++, c#"
    return 1
  fi
  
  if [[ ! -f "$source_file" ]]; then
    echo "❌ File not found: $source_file"
    return 1
  fi
  
  echo "🔄 Translating $(basename "$source_file") to $target_lang with $model..."
  
  local source_content=$(cat "$source_file")
  local prompt="Translate this code from ${source_file##*.} to $target_lang. 

Requirements:
1. Maintain the same functionality and logic
2. Follow $target_lang best practices and conventions
3. Add appropriate imports/dependencies
4. Include comments explaining any significant changes
5. Ensure the code is idiomatic for $target_lang

Source code:
\`\`\`
$source_content
\`\`\`

Please provide the complete translated code with proper syntax."
  
  # Determine output file extension
  local ext=""
  case "$target_lang" in
    python) ext="py" ;;
    javascript) ext="js" ;;
    typescript) ext="ts" ;;
    go) ext="go" ;;
    rust) ext="rs" ;;
    java) ext="java" ;;
    "c++"|cpp) ext="cpp" ;;
    "c#"|csharp) ext="cs" ;;
    *) ext="txt" ;;
  esac
  
  local output_file="${source_file%.*}_translated.$ext"
  echo "$prompt" | ollama run "$model" > "$output_file"
  echo "✅ Translation completed: $output_file"
}

# AI-powered refactoring suggestions
ai_refactor() {
  local file="$1"
  local focus="${2:-general}"
  local model="${3:-deepseek-coder}"
  
  if [[ -z "$file" ]]; then
    echo "Usage: ai_refactor <file> [focus] [model]"
    echo "Focus options: general, performance, readability, security, testing"
    echo "Example: ai_refactor src/api.py performance"
    return 1
  fi
  
  if [[ ! -f "$file" ]]; then
    echo "❌ File not found: $file"
    return 1
  fi
  
  echo "♻️ Generating refactoring suggestions for $file (focus: $focus) with $model..."
  
  local file_content=$(cat "$file")
  local focus_instruction=""
  
  case "$focus" in
    performance)
      focus_instruction="Focus on performance improvements: optimization, caching, algorithm efficiency, memory usage."
      ;;
    readability)
      focus_instruction="Focus on code readability: naming, structure, comments, simplification."
      ;;
    security)
      focus_instruction="Focus on security improvements: input validation, authentication, data protection."
      ;;
    testing)
      focus_instruction="Focus on testability: dependency injection, modularity, separation of concerns."
      ;;
    *)
      focus_instruction="Provide general refactoring suggestions covering all aspects."
      ;;
  esac
  
  local prompt="Analyze this code and provide refactoring suggestions. $focus_instruction

For each suggestion, provide:
1. What to change and why
2. Before/after code examples
3. Benefits of the change
4. Potential risks or considerations

Here's the code:
\`\`\`
$file_content
\`\`\`"
  
  echo "$prompt" | ollama run "$model"
}

# AI-powered project initialization
ai_init() {
  local project_type="$1"
  local project_name="$2"
  local model="${3:-codellama}"
  
  if [[ -z "$project_type" || -z "$project_name" ]]; then
    echo "Usage: ai_init <project_type> <project_name> [model]"
    echo "Project types: web, api, cli, mobile, desktop, ml, data"
    echo "Example: ai_init web my-blog-app"
    return 1
  fi
  
  echo "🚀 Initializing $project_type project: $project_name with AI assistance..."
  
  # Create project directory
  mkdir -p "$project_name"
  cd "$project_name"
  
  local prompt="Create a complete project structure for a $project_type project called '$project_name'. 

Please provide:
1. Recommended tech stack and reasoning
2. Project directory structure
3. Essential configuration files (package.json, requirements.txt, etc.)
4. Basic code files with TODO comments
5. README.md with setup instructions
6. .gitignore file appropriate for the tech stack
7. Development workflow recommendations

Make the project production-ready and following modern best practices."
  
  echo "$prompt" | ollama run "$model" > ".ai_project_plan.md"
  
  echo "✅ AI project plan generated: .ai_project_plan.md"
  echo "📝 Review the plan and run the suggested commands to set up your project"
  
  # Basic gitignore based on project type
  case "$project_type" in
    web|api)
      echo "node_modules/
.env
.env.local
dist/
build/" > .gitignore
      ;;
    ml|data)
      echo "*.pyc
__pycache__/
.env
.venv/
data/
models/
.ipynb_checkpoints/" > .gitignore
      ;;
    *)
      echo ".env
.DS_Store
*.log
tmp/" > .gitignore
      ;;
  esac
  
  # Initialize git
  git init
  echo "📦 Project initialized: $project_name"
}

# AI development environment setup
ai_env() {
  local project_type="${1:-detect}"
  
  echo "🤖 Setting up AI-powered development environment..."
  
  # Detect project type if not specified
  if [[ "$project_type" == "detect" ]]; then
    if [[ -f "package.json" ]]; then
      project_type="javascript"
    elif [[ -f "requirements.txt" || -f "pyproject.toml" ]]; then
      project_type="python"
    elif [[ -f "go.mod" ]]; then
      project_type="go"
    elif [[ -f "Cargo.toml" ]]; then
      project_type="rust"
    elif [[ -f "pom.xml" || -f "build.gradle" ]]; then
      project_type="java"
    elif [[ -f "pubspec.yaml" ]]; then
      project_type="flutter"
    else
      project_type="general"
    fi
  fi
  
  echo "📊 Detected project type: $project_type"
  
  # Set up environment variables for AI development
  export OLLAMA_HOST="127.0.0.1:11434"
  export AI_MODEL_DEFAULT="codellama"
  export AI_MODEL_DOCS="deepseek-coder"
  export AI_MODEL_REVIEW="mistral"
  
  # Start Ollama if not running
  if ! pgrep -f ollama > /dev/null; then
    echo "🚀 Starting Ollama server..."
    ollama serve > /dev/null 2>&1 &
    sleep 2
  fi
  
  # Check for recommended models
  echo "🔍 Checking AI models..."
  local models_needed=()
  
  if ! ollama list | grep -q "codellama"; then
    models_needed+=("codellama")
  fi
  
  if ! ollama list | grep -q "deepseek-coder"; then
    models_needed+=("deepseek-coder")
  fi
  
  if [[ ${#models_needed[@]} -gt 0 ]]; then
    echo "📥 Recommended models not found. Would you like to download them?"
    echo "Models needed: ${models_needed[*]}"
    read -p "Download now? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      for model in "${models_needed[@]}"; do
        echo "⬇️ Downloading $model..."
        ollama pull "$model"
      done
    fi
  fi
  
  # Project-specific setup
  case "$project_type" in
    python)
      export PYTHONPATH="${PYTHONPATH}:$(pwd)"
      echo "🐍 Python AI environment configured"
      ;;
    javascript)
      echo "⚡ JavaScript AI environment configured"
      ;;
    go)
      export CGO_ENABLED=1
      echo "🐹 Go AI environment configured"
      ;;
    *)
      echo "🔧 General AI environment configured"
      ;;
  esac
  
  echo "✅ AI development environment ready!"
  echo ""
  echo "Available AI commands:"
  echo "  ai_explain <file>     - Explain code"
  echo "  ai_review <file>      - Code review"
  echo "  ai_commit            - Generate commit message"
  echo "  ai_docs <file>       - Generate documentation"
  echo "  ai_test <file>       - Generate tests"
  echo "  ai_debug <error>     - Debug errors"
  echo "  ai_translate <file>  - Translate code"
  echo "  ai_refactor <file>   - Refactoring suggestions"
  echo "  ollama_manager list  - Manage AI models"
} 