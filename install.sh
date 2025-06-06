#!/bin/bash
# ~/.dotfiles/install.sh
# Modern ZSH Dotfiles Installation Script

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Configuration
DOTFILES_DIR="${HOME}/.dotfiles"
DOTFILES_REPO="https://github.com/rrecio/crazy-dev-zsh.git"
BACKUP_DIR="${HOME}/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# Logging
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_step() {
    echo -e "\n${PURPLE}==>${NC} ${WHITE}$1${NC}"
}

# Check if running on macOS
is_macos() {
    [[ "$(uname)" == "Darwin" ]]
}

# Check if running on Apple Silicon
is_apple_silicon() {
    [[ "$(uname -m)" == "arm64" ]]
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Create backup of existing files
backup_file() {
    local file="$1"
    if [[ -f "$file" ]] || [[ -L "$file" ]]; then
        mkdir -p "$BACKUP_DIR"
        local backup_name="$(basename "$file")"
        cp "$file" "$BACKUP_DIR/$backup_name"
        log_info "Backed up $file to $BACKUP_DIR/$backup_name"
    fi
}

# Create symlink with backup
link_file() {
    local source="$1"
    local target="$2"
    
    # Check if source file exists
    if [[ ! -f "$source" ]]; then
        log_warning "Source file does not exist: $source"
        return 1
    fi
    
    # Backup existing target if it exists
    backup_file "$target"
    
    # Create directory if it doesn't exist
    mkdir -p "$(dirname "$target")"
    
    # Create symlink
    ln -sf "$source" "$target"
    log_info "Linked $source to $target"
}

# Install Homebrew
install_homebrew() {
    if command_exists brew; then
        log_info "Homebrew already installed"
        return 0
    fi
    
    log_step "Installing Homebrew"
    if is_macos; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH for current session
        if is_apple_silicon; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        else
            eval "$(/usr/local/bin/brew shellenv)"
        fi
        
        log_success "Homebrew installed successfully"
    else
        log_error "Homebrew is only available on macOS"
        return 1
    fi
}

# Tech stack selection
select_tech_stacks() {
    log_step "Tech Stack Selection"
    
    # Initialize selection arrays
    INSTALL_CORE=true
    INSTALL_IOS=false
    INSTALL_FLUTTER=false
    INSTALL_GO=false
    INSTALL_JAVASCRIPT=false
    INSTALL_PYTHON_AI=false
    INSTALL_DOCKER=false
    INSTALL_CLOUD=false
    
    # Check for environment variables for non-interactive installation
    if [[ -n "${DOTFILES_INSTALL_ALL:-}" ]]; then
        INSTALL_IOS=true
        INSTALL_FLUTTER=true
        INSTALL_GO=true
        INSTALL_JAVASCRIPT=true
        INSTALL_PYTHON_AI=true
        INSTALL_DOCKER=true
        INSTALL_CLOUD=true
        log_info "Installing all tech stacks (DOTFILES_INSTALL_ALL=true)"
        return 0
    fi
    
    # Check individual environment variables
    [[ -n "${DOTFILES_INSTALL_IOS:-}" ]] && INSTALL_IOS=true
    [[ -n "${DOTFILES_INSTALL_FLUTTER:-}" ]] && INSTALL_FLUTTER=true
    [[ -n "${DOTFILES_INSTALL_GO:-}" ]] && INSTALL_GO=true
    [[ -n "${DOTFILES_INSTALL_JAVASCRIPT:-}" ]] && INSTALL_JAVASCRIPT=true
    [[ -n "${DOTFILES_INSTALL_PYTHON_AI:-}" ]] && INSTALL_PYTHON_AI=true
    [[ -n "${DOTFILES_INSTALL_DOCKER:-}" ]] && INSTALL_DOCKER=true
    [[ -n "${DOTFILES_INSTALL_CLOUD:-}" ]] && INSTALL_CLOUD=true
    
    # If any environment variables are set, skip interactive selection
    if [[ -n "${DOTFILES_INSTALL_IOS:-}" || -n "${DOTFILES_INSTALL_FLUTTER:-}" || -n "${DOTFILES_INSTALL_GO:-}" || 
          -n "${DOTFILES_INSTALL_JAVASCRIPT:-}" || -n "${DOTFILES_INSTALL_PYTHON_AI:-}" || 
          -n "${DOTFILES_INSTALL_DOCKER:-}" || -n "${DOTFILES_INSTALL_CLOUD:-}" ]]; then
        log_info "Using environment variables for tech stack selection"
        return 0
    fi
    
    echo "Choose which development environments you'd like to set up:"
    echo "(You can select multiple options)"
    echo ""
    
    # Core tools (always installed)
    echo "✅ Core Tools (git, zsh, better alternatives) - Always included"
    echo ""
    
    # iOS/Swift Development
    read -p "📱 Install iOS/Swift development tools? (Xcode, SwiftLint, etc.) [y/N]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        INSTALL_IOS=true
        log_info "✅ iOS/Swift development selected"
    fi
    
    # Flutter Development
    read -p "🦋 Install Flutter development tools? (Dart, Android Studio, etc.) [y/N]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        INSTALL_FLUTTER=true
        log_info "✅ Flutter development selected"
    fi
    
    # Go Development
    read -p "🐹 Install Go development tools? (Go, golangci-lint, air, etc.) [y/N]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        INSTALL_GO=true
        log_info "✅ Go development selected"
    fi
    
    # JavaScript/TypeScript Development
    read -p "🟨 Install JavaScript/TypeScript tools? (Node.js, npm, yarn, pnpm, bun, deno) [y/N]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        INSTALL_JAVASCRIPT=true
        log_info "✅ JavaScript/TypeScript development selected"
    fi
    
    # Python/AI Development
    read -p "🐍 Install Python/AI development tools? (Python, miniconda, ollama, etc.) [y/N]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        INSTALL_PYTHON_AI=true
        log_info "✅ Python/AI development selected"
    fi
    
    # Docker & Kubernetes
    read -p "🐳 Install Docker & Kubernetes tools? (Docker Desktop, kubectl, helm, etc.) [y/N]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        INSTALL_DOCKER=true
        log_info "✅ Docker & Kubernetes selected"
    fi
    
    # Cloud & Deployment
    read -p "☁️  Install cloud deployment tools? (AWS CLI, Heroku CLI, Terraform, etc.) [y/N]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        INSTALL_CLOUD=true
        log_info "✅ Cloud deployment tools selected"
    fi
    
    echo ""
    read -p "🚀 Install everything above? [y/N]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        INSTALL_IOS=true
        INSTALL_FLUTTER=true
        INSTALL_GO=true
        INSTALL_JAVASCRIPT=true
        INSTALL_PYTHON_AI=true
        INSTALL_DOCKER=true
        INSTALL_CLOUD=true
        log_info "✅ All tech stacks selected"
    fi
    
    echo ""
    log_info "Selected tech stacks:"
    [[ "$INSTALL_CORE" == true ]] && echo "  ✅ Core Tools"
    [[ "$INSTALL_IOS" == true ]] && echo "  📱 iOS/Swift Development"
    [[ "$INSTALL_FLUTTER" == true ]] && echo "  🦋 Flutter Development"
    [[ "$INSTALL_GO" == true ]] && echo "  🐹 Go Development"
    [[ "$INSTALL_JAVASCRIPT" == true ]] && echo "  🟨 JavaScript/TypeScript Development"
    [[ "$INSTALL_PYTHON_AI" == true ]] && echo "  🐍 Python/AI Development"
    [[ "$INSTALL_DOCKER" == true ]] && echo "  🐳 Docker & Kubernetes"
    [[ "$INSTALL_CLOUD" == true ]] && echo "  ☁️  Cloud Deployment Tools"
    
    echo ""
    read -p "Proceed with installation? [Y/n]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        log_info "Installation cancelled by user"
        exit 0
    fi
}

# Install essential tools via Homebrew
install_homebrew_packages() {
    if ! command_exists brew; then
        log_warning "Homebrew not found, skipping package installation"
        return 0
    fi
    
    log_step "Installing Development Tools via Homebrew"
    
    local packages=()
    
    # Core utilities (always installed)
    if [[ "$INSTALL_CORE" == true ]]; then
        packages+=(
            # Core utilities
            "git"
            "curl"
            "wget"
            "zsh"
            
            # Better alternatives
            "exa"          # Better ls
            "fd"           # Better find command
            "ripgrep"      # Better grep
            "fzf"          # Fuzzy finder
            "jq"           # JSON processor
            "htop"         # Better top
            "tree"         # Directory tree
            "ncdu"         # Disk usage analyzer
            "tldr"         # Better man pages
            "httpie"       # HTTP client
            "lazygit"      # Git TUI
            
            # Essential development tools
            "git-delta"    # Better git diff
            "gh"           # GitHub CLI
            
            # ZSH enhancements
            "zsh-autosuggestions"
            "zsh-syntax-highlighting"
            
            # Cursor IDE
            "--cask cursor" # Cursor IDE
        )
    fi
    
    # iOS/Swift Development
    if [[ "$INSTALL_IOS" == true ]]; then
        packages+=(
            "swiftlint"    # Swift linting
            "swiftformat"  # Swift formatting
            "xcbeautify"   # Xcode output formatting
            "mint"         # Swift package manager
        )
    fi
    
    # Flutter/Dart Development
    if [[ "$INSTALL_FLUTTER" == true ]]; then
        packages+=(
            "dart"         # Dart SDK
            "cocoapods"    # iOS dependency manager for Flutter
            "--cask android-studio"    # Android Studio IDE
            "--cask android-platform-tools"  # Android SDK platform tools
        )
    fi
    
    # Go Development
    if [[ "$INSTALL_GO" == true ]]; then
        packages+=(
            "go"           # Go programming language
            "golangci-lint" # Go linter
            "air"          # Go hot reload
        )
    fi
    
    # JavaScript/TypeScript Development
    if [[ "$INSTALL_JAVASCRIPT" == true ]]; then
        packages+=(
            "node"         # Node.js
            "yarn"         # Yarn package manager
            "pnpm"         # PNPM package manager
            "bun"          # Bun JavaScript runtime
            "deno"         # Deno JavaScript runtime
        )
    fi
    
    # Python/AI Development
    if [[ "$INSTALL_PYTHON_AI" == true ]]; then
        packages+=(
            "python3"      # Python
            "python@3.11"  # Python for AI
            "miniconda"    # Conda package manager
            "ollama"       # Local LLM runner
        )
    fi
    
    # Docker & Kubernetes
    if [[ "$INSTALL_DOCKER" == true ]]; then
        packages+=(
            "--cask docker"        # Docker Desktop
            "kubernetes-cli"       # kubectl
            "kubectx"             # Kubernetes context switcher
            "helm"                # Kubernetes package manager
            "k9s"                 # Kubernetes CLI UI
        )
    fi
    
    # Cloud & Deployment
    if [[ "$INSTALL_CLOUD" == true ]]; then
        packages+=(
            "awscli"              # AWS CLI
            "heroku/brew/heroku"  # Heroku CLI
            "serverless"          # Serverless framework
            "terraform"           # Infrastructure as code
        )
    fi
    
    for package in "${packages[@]}"; do
        if [[ "$package" == "--cask"* ]]; then
            # Handle cask packages
            local cask_name="${package#--cask }"
            local app_path=""
            
            # Map cask names to their application paths
            case "$cask_name" in
                "cursor") app_path="/Applications/Cursor.app" ;;
                "docker") app_path="/Applications/Docker.app" ;;
                "android-studio") app_path="/Applications/Android Studio.app" ;;
                *) app_path="" ;;
            esac
            
            # Check if app already exists in Applications folder
            if [[ -n "$app_path" && -d "$app_path" ]]; then
                log_info "$cask_name already installed in Applications folder"
            elif brew list --cask "$cask_name" &>/dev/null; then
                log_info "$cask_name already installed via Homebrew"
            else
                log_info "Installing cask $cask_name..."
                brew install --cask "$cask_name" || log_warning "Failed to install $cask_name"
            fi
        else
            # Handle regular packages - check if command exists first, then check brew
            local cmd_name="$package"
            
            # Handle special cases where package name differs from command name
            case "$package" in
                "ripgrep") cmd_name="rg" ;;
                "git-delta") cmd_name="delta" ;;
                "kubernetes-cli") cmd_name="kubectl" ;;
                "fd") cmd_name="fd" ;;
                "ncdu") cmd_name="ncdu" ;;
                "tldr") cmd_name="tldr" ;;
                "httpie") cmd_name="httpie" ;;
                "lazygit") cmd_name="lazygit" ;;
                "zsh-autosuggestions"|"zsh-syntax-highlighting") cmd_name="" ;; # These don't have commands
            esac
            
            # Check if command already exists in system (skip for zsh plugins)
            if [[ -n "$cmd_name" ]] && command_exists "$cmd_name"; then
                log_info "$package already available in system"
            elif brew list "$package" &>/dev/null; then
                log_info "$package already installed via Homebrew"
            else
                log_info "Installing $package..."
                brew install "$package" || log_warning "Failed to install $package"
            fi
        fi
    done
    
    log_success "Homebrew packages installation completed"
}

# Install additional tools
install_additional_tools() {
    log_step "Installing Additional Development Tools & SDKs"
    

    
    # Install FZF key bindings
    if command_exists fzf && [[ ! -f "${HOME}/.fzf.zsh" ]]; then
        log_info "Setting up FZF key bindings..."
        "$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc
        log_success "FZF key bindings installed"
    fi
    
    # Install Flutter SDK (only if Flutter development was selected)
    if [[ "$INSTALL_FLUTTER" == true ]] && [[ ! -d "${HOME}/flutter" ]]; then
        read -p "Install Flutter SDK? (recommended for Flutter development) [Y/n]: " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Nn]$ ]]; then
            log_info "Installing Flutter SDK..."
            cd "${HOME}"
            git clone https://github.com/flutter/flutter.git -b stable
            
            # Add Flutter to PATH for current session
            export PATH="${HOME}/flutter/bin:$PATH"
            
            # Run Flutter doctor to complete setup
            flutter doctor
            
            # Accept Android licenses if Android tools were installed
            if [[ "$INSTALL_FLUTTER" == true ]]; then
                flutter doctor --android-licenses
            fi
            
            log_success "Flutter SDK installed"
        fi
    fi
    
    # Setup Node.js tools (only if JavaScript development was selected)
    if [[ "$INSTALL_JAVASCRIPT" == true ]]; then
        read -p "Install global Node.js development tools? (create-react-app, @angular/cli, etc.) [y/N]: " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            log_info "Installing global Node.js tools..."
            npm install -g create-react-app @vue/cli @angular/cli create-next-app typescript ts-node nodemon
            log_success "Global Node.js tools installed"
        fi
    fi
    
    # Setup Python/AI environment (only if Python/AI development was selected)
    if [[ "$INSTALL_PYTHON_AI" == true ]]; then
        read -p "Setup Python AI environment with common packages? [y/N]: " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            log_info "Setting up Python AI environment..."
            # Create conda environment for AI development
            conda create -n ai-dev python=3.11 -y
            conda activate ai-dev
            conda install -c conda-forge jupyter pandas numpy matplotlib scikit-learn -y
            pip install torch torchvision transformers
            log_success "Python AI environment created (ai-dev)"
        fi
    fi
    
    # Setup Docker environment (only if Docker was selected)
    if [[ "$INSTALL_DOCKER" == true ]]; then
        log_info "Docker Desktop was installed. Please start Docker Desktop manually to complete setup."
    fi
    
    # Setup Ollama for AI development
    if command_exists ollama; then
        log_info "Ollama is already installed"
    else
        read -p "Install Ollama for local AI development? (recommended) [Y/n]: " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Nn]$ ]]; then
            log_info "Installing Ollama..."
            curl -fsSL https://ollama.ai/install.sh | sh
            
            # Start Ollama service
            log_info "Starting Ollama service..."
            ollama serve > /dev/null 2>&1 &
            sleep 3
            
            # Download essential models for development
            read -p "Download essential AI models for development? (codellama, deepseek-coder) [Y/n]: " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Nn]$ ]]; then
                log_info "Downloading CodeLlama (7B) - specialized for code generation..."
                ollama pull codellama:7b
                
                log_info "Downloading DeepSeek Coder (6.7B) - optimized for code assistance..."
                ollama pull deepseek-coder:6.7b
                
                log_info "Downloading Mistral (7B) - fast general purpose model..."
                ollama pull mistral:7b
                
                log_success "Essential AI models installed"
            fi
            
            # Create Ollama directories
            mkdir -p "${HOME}/.ollama/logs"
            mkdir -p "${HOME}/.ollama/tmp"
            mkdir -p "${HOME}/.cache/ai-dev"
            
            log_success "Ollama setup completed"
            echo ""
            echo "🤖 Ollama AI Features Available:"
            echo "  • ai_explain <file>      - AI-powered code explanation"
            echo "  • ai_review <file>       - Intelligent code review"
            echo "  • ai_commit              - Auto-generate commit messages"
            echo "  • ai_docs <file>         - Generate documentation"
            echo "  • ai_debug <error>       - Debug assistance"
            echo "  • ai_test <file>         - Generate unit tests"
            echo "  • ai_translate <file>    - Translate code between languages"
            echo "  • ai_refactor <file>     - Refactoring suggestions"
            echo "  • ollama_manager list    - Manage AI models"
            echo ""
        fi
    fi
}

# Setup dotfiles repository
setup_dotfiles() {
    log_step "Setting up dotfiles repository"
    
    if [[ -d "$DOTFILES_DIR" ]]; then
        log_info "Dotfiles directory exists, updating..."
        cd "$DOTFILES_DIR"
        git pull origin main || git pull origin master
    else
        log_info "Cloning dotfiles repository..."
        git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
        cd "$DOTFILES_DIR"
    fi
    
    log_success "Dotfiles repository setup complete"
}

# Create symlinks
create_symlinks() {
    log_step "Creating Configuration Symlinks"
    
    # Backup and link .zshrc
    backup_file "${HOME}/.zshrc"
    ln -sf "${DOTFILES_DIR}/.zshrc" "${HOME}/.zshrc"
    log_success "Linked .zshrc"
    
    # Create config directory if it doesn't exist
    mkdir -p "${HOME}/.config"
    
    # Note: Starship config removed - using custom prompt themes
    
    # Link git config if it exists
    if [[ -f "${DOTFILES_DIR}/config/.gitconfig" ]]; then
        backup_file "${HOME}/.gitconfig"
        ln -sf "${DOTFILES_DIR}/config/.gitconfig" "${HOME}/.gitconfig"
        log_success "Linked git config"
    fi
    
    # Link global gitignore if it exists
    if [[ -f "${DOTFILES_DIR}/config/.gitignore_global" ]]; then
        backup_file "${HOME}/.gitignore_global"
        ln -sf "${DOTFILES_DIR}/config/.gitignore_global" "${HOME}/.gitignore_global"
        log_success "Linked global gitignore"
    fi

    # Link other config files
    log_info "Linking configuration files..."

    # Link gitconfig
    link_file "${DOTFILES_DIR}/config/.gitconfig" "${HOME}/.gitconfig"

    # Link vimrc
    link_file "${DOTFILES_DIR}/config/vimrc" "${HOME}/.vimrc"

    # Link tmux config
    link_file "${DOTFILES_DIR}/config/tmux.conf" "${HOME}/.tmux.conf"

    # Link other dotfiles as needed
    log_success "Configuration files linked"
}

# Setup ZSH as default shell
setup_zsh() {
    log_step "Configuring ZSH as Default Shell"
    
    local zsh_path
    if command_exists brew && brew list zsh &>/dev/null; then
        zsh_path="$(brew --prefix)/bin/zsh"
    else
        zsh_path="/bin/zsh"
    fi
    
    # Add to /etc/shells if not already there
    if ! grep -q "$zsh_path" /etc/shells; then
        log_info "Adding $zsh_path to /etc/shells"
        echo "$zsh_path" | sudo tee -a /etc/shells
    fi
    
    # Change default shell if not already zsh
    if [[ "$SHELL" != "$zsh_path" ]]; then
        log_info "Changing default shell to $zsh_path"
        chsh -s "$zsh_path"
        log_success "Default shell changed to ZSH"
    else
        log_info "ZSH is already the default shell"
    fi
}

# Create necessary directories
create_directories() {
    log_step "Creating Development Workspace Directories"
    
    local directories=(
        "${HOME}/.zsh/cache"
        "${HOME}/.local/bin"
        "${HOME}/Projects"
        "${HOME}/Notes"
    )
    
    for dir in "${directories[@]}"; do
        if [[ ! -d "$dir" ]]; then
            mkdir -p "$dir"
            log_info "Created directory: $dir"
        fi
    done
    
    log_success "Directory setup complete"
}

# Set up git configuration
setup_git() {
    log_step "Setting up Git configuration"
    
    # Check if git user is configured
    if ! git config --global user.name >/dev/null 2>&1; then
        read -p "Enter your Git username: " git_username
        git config --global user.name "$git_username"
    fi
    
    if ! git config --global user.email >/dev/null 2>&1; then
        read -p "Enter your Git email: " git_email
        git config --global user.email "$git_email"
    fi
    
    # Set up some useful git defaults
    git config --global init.defaultBranch main
    git config --global core.editor "code --wait"
    git config --global pull.rebase true
    git config --global core.autocrlf input
    
    log_success "Git configuration complete"
}

# Generate SSH key
setup_ssh() {
    log_step "Setting up SSH key"
    
    if [[ ! -f "${HOME}/.ssh/id_ed25519" ]]; then
        read -p "Generate SSH key? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            local email
            email=$(git config --global user.email 2>/dev/null || echo "user@example.com")
            ssh-keygen -t ed25519 -C "$email" -f "${HOME}/.ssh/id_ed25519" -N ""
            
            # Start ssh-agent and add key
            eval "$(ssh-agent -s)"
            ssh-add "${HOME}/.ssh/id_ed25519"
            
            # Copy public key to clipboard if possible
            if command_exists pbcopy; then
                pbcopy < "${HOME}/.ssh/id_ed25519.pub"
                log_success "SSH key generated and copied to clipboard"
            else
                log_success "SSH key generated at ${HOME}/.ssh/id_ed25519.pub"
                log_info "Public key content:"
                cat "${HOME}/.ssh/id_ed25519.pub"
            fi
        fi
    else
        log_info "SSH key already exists"
    fi
}

# Optimize macOS settings for better developer experience
optimize_macos() {
    if ! is_macos; then
        return 0
    fi
    
    log_step "Optimizing macOS Developer Settings"
    
    echo "The following macOS optimizations will be applied:"
    echo "  • Show hidden files in Finder (see .dotfiles, .git, etc.)"
    echo "  • Enable tap to click on trackpad"
    echo "  • Disable slow dock animations"
    echo "  • Speed up Mission Control animations"
    echo ""
    
    read -p "Apply these macOS developer optimizations? [y/N]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        log_info "Applying macOS developer optimizations..."
        
        # Show hidden files in Finder
        log_info "• Enabling hidden files in Finder..."
        defaults write com.apple.finder AppleShowAllFiles -bool true
        
        # Enable tap to click
        log_info "• Enabling tap to click on trackpad..."
        defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
        
        # Disable dock animation
        log_info "• Disabling slow dock animations..."
        defaults write com.apple.dock launchanim -bool false
        
        # Speed up mission control
        log_info "• Speeding up Mission Control animations..."
        defaults write com.apple.dock expose-animation-duration -float 0.1
        
        # Restart affected applications
        log_info "• Restarting Dock and Finder to apply changes..."
        killall Dock 2>/dev/null || true
        killall Finder 2>/dev/null || true
        
        log_success "macOS developer optimizations applied successfully!"
        log_info "You should now see hidden files in Finder and faster animations"
    else
        log_info "Skipped macOS optimizations - you can apply them later if needed"
    fi
}

# Select prompt theme
select_prompt_theme_install() {
    log_step "Choosing Your Prompt Theme"
    
    # Skip interactive selection if automation mode
    if [[ "${DOTFILES_INSTALL_ALL:-}" == "true" ]]; then
        echo "powerline" > "${HOME}/.dotfiles/.selected_theme"
        log_success "Default powerline theme selected (automation mode)"
        return 0
    fi
    
    echo "🎨 Choose your terminal prompt theme:"
    echo
    echo "%F{yellow}1)%f 🚀 Powerline - Full-featured with all segments (recommended)"
    echo "%F{yellow}2)%f ⚡ Minimal - Lightning fast and clean"
    echo "%F{yellow}3)%f 👨‍💻 Developer - Enhanced coding context"
    echo "%F{yellow}4)%f 🤖 AI-Powered - Intelligent context awareness"
    echo "%F{yellow}5)%f 🕹️ Retro - Nostalgic terminal aesthetics"
    echo "%F{yellow}6)%f 🏢 Corporate - Professional and enterprise-ready"
    echo
    
    local selection=""
    while true; do
        read -p "Enter your choice (1-6) [1]: " selection
        
        # Default to powerline if empty
        if [[ -z "$selection" ]]; then
            selection="1"
        fi
        
        case "$selection" in
            1|"powerline") 
                echo "powerline" > "${HOME}/.dotfiles/.selected_theme"
                log_success "Powerline theme selected - Full-featured with all segments"
                break
                ;;
            2|"minimal")
                echo "minimal" > "${HOME}/.dotfiles/.selected_theme"
                log_success "Minimal theme selected - Lightning fast and clean"
                break
                ;;
            3|"developer")
                echo "developer" > "${HOME}/.dotfiles/.selected_theme"
                log_success "Developer theme selected - Enhanced coding context"
                break
                ;;
            4|"ai-powered")
                echo "ai-powered" > "${HOME}/.dotfiles/.selected_theme"
                log_success "AI-Powered theme selected - Intelligent context awareness"
                break
                ;;
            5|"retro")
                echo "retro" > "${HOME}/.dotfiles/.selected_theme"
                log_success "Retro theme selected - Nostalgic terminal aesthetics"
                break
                ;;
            6|"corporate")
                echo "corporate" > "${HOME}/.dotfiles/.selected_theme"
                log_success "Corporate theme selected - Professional and enterprise-ready"
                break
                ;;
            *)
                echo "Invalid selection. Please choose 1-6."
                continue
                ;;
        esac
    done
    
    echo
    echo "💡 You can change themes anytime with these commands:"
    echo "  • switch_theme          - Interactive theme selection"
    echo "  • switch_theme minimal  - Switch directly to a theme"
    echo "  • list_themes          - See all available themes"
}

# Final setup steps
final_setup() {
    log_step "Finalizing Installation & Testing Configuration"
    
    # Create a test file to verify everything works
    echo "# Dotfiles installation test" > "${HOME}/.dotfiles_test"
    log_info "Created test file"
    
    # Source the new configuration
    if [[ -f "${HOME}/.zshrc" ]]; then
        log_info "New configuration ready. Restart your terminal or run: source ~/.zshrc"
    fi
    
    log_success "Installation completed successfully!"
}

# Print summary
print_summary() {
    echo -e "\n${CYAN}=================================${NC}"
    echo -e "${CYAN}  Installation Summary${NC}"
    echo -e "${CYAN}=================================${NC}"
    echo -e "${GREEN}✓${NC} Dotfiles installed to: ${DOTFILES_DIR}"
    echo -e "${GREEN}✓${NC} Configuration files linked"
    echo -e "${GREEN}✓${NC} ZSH set as default shell"
    echo -e "${GREEN}✓${NC} Essential tools installed"
    
    echo -e "\n${CYAN}Installed tech stacks:${NC}"
    [[ "$INSTALL_CORE" == true ]] && echo -e "${GREEN}✓${NC} Core Tools (git, zsh, better alternatives)"
    [[ "$INSTALL_IOS" == true ]] && echo -e "${GREEN}✓${NC} iOS/Swift Development"
    [[ "$INSTALL_FLUTTER" == true ]] && echo -e "${GREEN}✓${NC} Flutter Development"
    [[ "$INSTALL_GO" == true ]] && echo -e "${GREEN}✓${NC} Go Development"
    [[ "$INSTALL_JAVASCRIPT" == true ]] && echo -e "${GREEN}✓${NC} JavaScript/TypeScript Development"
    [[ "$INSTALL_PYTHON_AI" == true ]] && echo -e "${GREEN}✓${NC} Python/AI Development"
    [[ "$INSTALL_DOCKER" == true ]] && echo -e "${GREEN}✓${NC} Docker & Kubernetes"
    [[ "$INSTALL_CLOUD" == true ]] && echo -e "${GREEN}✓${NC} Cloud Deployment Tools"
    
    if [[ -d "$BACKUP_DIR" ]]; then
        echo -e "${YELLOW}ℹ${NC} Backups saved to: ${BACKUP_DIR}"
    fi
    
    echo -e "\n${PURPLE}Next steps:${NC}"
    echo -e "1. Restart your terminal or run 'exec zsh' to activate all features"
    echo -e "2. Run 'switch_theme' to change prompt themes"
    echo -e "3. Run 'dotfiles_perf' to check performance"
    echo -e "4. Customize ${DOTFILES_DIR}/zsh/custom.zsh"
    
    echo -e "\n${CYAN}🛠️  Core Commands (available after restart):${NC}"
    echo -e "• reload       - Reload shell configuration (or use 'source ~/.zshrc')"
    echo -e "• switch_theme - Change prompt theme"
    echo -e "• list_themes  - Show available prompt themes"
    echo -e "• gstatus      - Enhanced git status"
    echo -e "• proj         - Navigate to projects directory"
    echo -e "• mcd <dir>    - Make directory and cd into it"
    echo -e "• extract <file> - Extract any archive format"
    echo -e "• killport <port> - Kill process on specific port"
    echo -e "• weather      - Show weather information"
    
    # Show commands based on installed stacks
    if [[ "$INSTALL_IOS" == true ]]; then
        echo -e "\n${CYAN}📱 iOS/Swift Commands:${NC}"
        echo -e "• swift_new <name>    - Create new Swift package"
        echo -e "• ios_sim            - Manage iOS simulators"
        echo -e "• xc_analyze         - Analyze Xcode project"
        echo -e "• smart_xcodebuild   - Smart Xcode building"
    fi
    
    if [[ "$INSTALL_FLUTTER" == true ]]; then
        echo -e "\n${CYAN}🦋 Flutter Commands:${NC}"
        echo -e "• flutter_new <name> - Create Flutter project"
        echo -e "• flutter_hot        - Start hot reload development"
        echo -e "• flutter_analyze    - Analyze Flutter project"
        echo -e "• device_manager     - Manage devices/emulators"
        echo -e "• android_emulator   - Control Android emulators"
    fi
    
    if [[ "$INSTALL_GO" == true ]]; then
        echo -e "\n${CYAN}🐹 Go Commands:${NC}"
        echo -e "• go_new <name>      - Create new Go project"
        echo -e "• go_run_smart       - Smart Go running with air"
    fi
    
    if [[ "$INSTALL_JAVASCRIPT" == true ]]; then
        echo -e "\n${CYAN}🟨 JavaScript Commands:${NC}"
        echo -e "• js_new <name> <type> - Create JS project (react, vue, etc.)"
        echo -e "• js_run_smart       - Smart development server"
        echo -e "• js_test_smart      - Smart testing"
        echo -e "• js_deps_manager    - Manage dependencies"
        echo -e "• npminit           - Initialize npm project with templates"
    fi
    
    if [[ "$INSTALL_PYTHON_AI" == true ]]; then
        echo -e "\n${CYAN}🐍 Python/AI Commands:${NC}"
        echo -e "• ai_commit         - Generate commit messages with AI"
        echo -e "• ai_review         - AI code review"
        echo -e "• ai_explain <code> - Explain code with AI"
        echo -e "• ai_debug <error>  - Debug with AI assistance"
        echo -e "• ollama_manager    - Manage local AI models"
        echo -e "• ai_init           - Setup AI development environment"
    fi
    
    if [[ "$INSTALL_DOCKER" == true ]]; then
        echo -e "\n${CYAN}🐳 Docker Commands:${NC}"
        echo -e "• docker_manager    - Interactive Docker management"
        echo -e "• k8s_manager       - Kubernetes cluster management"
        echo -e "• drun <image>      - Quick container run"
    fi
    
    if [[ "$INSTALL_CLOUD" == true ]]; then
        echo -e "\n${CYAN}☁️  Cloud Commands:${NC}"
        echo -e "• smart_deploy      - Smart deployment wizard"
        echo -e "• deploy_heroku     - Deploy to Heroku"
        echo -e "• deploy_k8s        - Deploy to Kubernetes"
        echo -e "• deploy_aws        - Deploy to AWS"
    fi
    
    echo -e "\n${CYAN}🔧 System & Performance:${NC}"
    echo -e "• dotfiles_perf     - Performance monitoring"
    echo -e "• perf_tips         - Performance optimization tips"
    echo -e "• sysinfo           - System information"
    echo -e "• brewup            - Update Homebrew packages"
    echo -e "• backup <file>     - Smart backup utility"
    
    echo -e "\n${GREEN}Enjoy your supercharged development environment!${NC}"
    echo -e "${YELLOW}💡 Tip: Type any command name to see its help/options${NC}"
}

# Error handling
error_exit() {
    log_error "Installation failed: $1"
    exit 1
}

# Select packages to uninstall
select_uninstall_stacks() {
    log_step "Package Uninstallation Selection"
    
    # Initialize selection arrays
    UNINSTALL_CORE=false
    UNINSTALL_IOS=false
    UNINSTALL_FLUTTER=false
    UNINSTALL_GO=false
    UNINSTALL_JAVASCRIPT=false
    UNINSTALL_PYTHON_AI=false
    UNINSTALL_DOCKER=false
    UNINSTALL_CLOUD=false
    
    # Check for environment variables for non-interactive uninstallation
    if [[ -n "${DOTFILES_UNINSTALL_ALL:-}" ]]; then
        UNINSTALL_CORE=true
        UNINSTALL_IOS=true
        UNINSTALL_FLUTTER=true
        UNINSTALL_GO=true
        UNINSTALL_JAVASCRIPT=true
        UNINSTALL_PYTHON_AI=true
        UNINSTALL_DOCKER=true
        UNINSTALL_CLOUD=true
        log_info "Uninstalling all tech stacks (DOTFILES_UNINSTALL_ALL=true)"
        return 0
    fi
    
    # Check individual environment variables
    [[ -n "${DOTFILES_UNINSTALL_CORE:-}" ]] && UNINSTALL_CORE=true
    [[ -n "${DOTFILES_UNINSTALL_IOS:-}" ]] && UNINSTALL_IOS=true
    [[ -n "${DOTFILES_UNINSTALL_FLUTTER:-}" ]] && UNINSTALL_FLUTTER=true
    [[ -n "${DOTFILES_UNINSTALL_GO:-}" ]] && UNINSTALL_GO=true
    [[ -n "${DOTFILES_UNINSTALL_JAVASCRIPT:-}" ]] && UNINSTALL_JAVASCRIPT=true
    [[ -n "${DOTFILES_UNINSTALL_PYTHON_AI:-}" ]] && UNINSTALL_PYTHON_AI=true
    [[ -n "${DOTFILES_UNINSTALL_DOCKER:-}" ]] && UNINSTALL_DOCKER=true
    [[ -n "${DOTFILES_UNINSTALL_CLOUD:-}" ]] && UNINSTALL_CLOUD=true
    
    # If any environment variables are set, skip interactive selection
    if [[ -n "${DOTFILES_UNINSTALL_CORE:-}" || -n "${DOTFILES_UNINSTALL_IOS:-}" || -n "${DOTFILES_UNINSTALL_GO:-}" || 
          -n "${DOTFILES_UNINSTALL_JAVASCRIPT:-}" || -n "${DOTFILES_UNINSTALL_PYTHON_AI:-}" || 
          -n "${DOTFILES_UNINSTALL_DOCKER:-}" || -n "${DOTFILES_UNINSTALL_CLOUD:-}" ]]; then
        log_info "Using environment variables for tech stack uninstallation"
        return 0
    fi
    
    echo "Choose which development environments you'd like to uninstall:"
    echo "(You can select multiple options)"
    echo ""
    
    # Core tools
    read -p "🗑️  Uninstall Core Tools? (git, zsh, better alternatives) [y/N]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        UNINSTALL_CORE=true
        log_info "❌ Core Tools selected for uninstallation"
    fi
    
    # iOS/Swift Development
    read -p "🗑️  Uninstall iOS/Swift development tools? [y/N]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        UNINSTALL_IOS=true
        log_info "❌ iOS/Swift development selected for uninstallation"
    fi
    
    # Flutter Development
    read -p "🗑️  Uninstall Flutter development tools? [y/N]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        UNINSTALL_FLUTTER=true
        log_info "❌ Flutter development selected for uninstallation"
    fi
    
    # Go Development
    read -p "🗑️  Uninstall Go development tools? [y/N]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        UNINSTALL_GO=true
        log_info "❌ Go development selected for uninstallation"
    fi
    
    # JavaScript/TypeScript Development
    read -p "🗑️  Uninstall JavaScript/TypeScript tools? [y/N]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        UNINSTALL_JAVASCRIPT=true
        log_info "❌ JavaScript/TypeScript development selected for uninstallation"
    fi
    
    # Python/AI Development
    read -p "🗑️  Uninstall Python/AI development tools? [y/N]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        UNINSTALL_PYTHON_AI=true
        log_info "❌ Python/AI development selected for uninstallation"
    fi
    
    # Docker & Kubernetes
    read -p "🗑️  Uninstall Docker & Kubernetes tools? [y/N]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        UNINSTALL_DOCKER=true
        log_info "❌ Docker & Kubernetes selected for uninstallation"
    fi
    
    # Cloud & Deployment
    read -p "🗑️  Uninstall cloud deployment tools? [y/N]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        UNINSTALL_CLOUD=true
        log_info "❌ Cloud deployment tools selected for uninstallation"
    fi
    
    echo ""
    read -p "🗑️  Uninstall everything above? [y/N]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        UNINSTALL_CORE=true
        UNINSTALL_IOS=true
        UNINSTALL_FLUTTER=true
        UNINSTALL_GO=true
        UNINSTALL_JAVASCRIPT=true
        UNINSTALL_PYTHON_AI=true
        UNINSTALL_DOCKER=true
        UNINSTALL_CLOUD=true
        log_info "❌ All tech stacks selected for uninstallation"
    fi
    
    echo ""
    log_info "Selected for uninstallation:"
    [[ "$UNINSTALL_CORE" == true ]] && echo "  ❌ Core Tools"
    [[ "$UNINSTALL_IOS" == true ]] && echo "  ❌ iOS/Swift Development"
    [[ "$UNINSTALL_FLUTTER" == true ]] && echo "  ❌ Flutter Development"
    [[ "$UNINSTALL_GO" == true ]] && echo "  ❌ Go Development"
    [[ "$UNINSTALL_JAVASCRIPT" == true ]] && echo "  ❌ JavaScript/TypeScript Development"
    [[ "$UNINSTALL_PYTHON_AI" == true ]] && echo "  ❌ Python/AI Development"
    [[ "$UNINSTALL_DOCKER" == true ]] && echo "  ❌ Docker & Kubernetes"
    [[ "$UNINSTALL_CLOUD" == true ]] && echo "  ❌ Cloud Deployment Tools"
    
    echo ""
    read -p "⚠️  Are you sure you want to proceed with uninstallation? [y/N]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Nn]$ ]] || [[ -z "$REPLY" ]]; then
        log_info "Uninstallation cancelled by user"
        exit 0
    fi
}

# Uninstall homebrew packages
uninstall_homebrew_packages() {
    if ! command_exists brew; then
        log_warning "Homebrew not found, skipping package uninstallation"
        return 0
    fi
    
    log_step "Uninstalling selected packages via Homebrew"
    
    local packages=()
    
    # Core utilities
    if [[ "$UNINSTALL_CORE" == true ]]; then
        packages+=(
            # Core utilities (be careful with these)
            "bat" "exa" "fd" "ripgrep" "fzf" "jq" "htop" "tree" "ncdu" "tldr" "httpie" "lazygit"
            "git-delta" "gh" "zsh-autosuggestions" "zsh-syntax-highlighting"
            "--cask cursor"
        )
    fi
    
    # iOS/Swift Development
    if [[ "$UNINSTALL_IOS" == true ]]; then
        packages+=(
            "swiftlint" "swiftformat" "xcbeautify" "mint"
        )
    fi
    
    # Flutter/Dart Development
    if [[ "$UNINSTALL_FLUTTER" == true ]]; then
        packages+=(
            "dart" "cocoapods"
            "--cask android-studio" "--cask android-platform-tools"
        )
    fi
    
    # Go Development
    if [[ "$UNINSTALL_GO" == true ]]; then
        packages+=(
            "go" "golangci-lint" "air"
        )
    fi
    
    # JavaScript/TypeScript Development
    if [[ "$UNINSTALL_JAVASCRIPT" == true ]]; then
        packages+=(
            "node" "yarn" "pnpm" "bun" "deno"
        )
    fi
    
    # Python/AI Development
    if [[ "$UNINSTALL_PYTHON_AI" == true ]]; then
        packages+=(
            "python@3.11" "miniconda" "ollama"
        )
    fi
    
    # Docker & Kubernetes
    if [[ "$UNINSTALL_DOCKER" == true ]]; then
        packages+=(
            "--cask docker" "kubernetes-cli" "kubectx" "helm" "k9s"
        )
    fi
    
    # Cloud & Deployment
    if [[ "$UNINSTALL_CLOUD" == true ]]; then
        packages+=(
            "awscli" "heroku/brew/heroku" "serverless" "terraform"
        )
    fi
    
    for package in "${packages[@]}"; do
        if [[ "$package" == "--cask"* ]]; then
            # Handle cask packages
            local cask_name="${package#--cask }"
            if brew list --cask "$cask_name" &>/dev/null; then
                log_info "Uninstalling cask $cask_name..."
                brew uninstall --cask "$cask_name" || log_warning "Failed to uninstall $cask_name"
            else
                log_info "$cask_name not installed via Homebrew"
            fi
        else
            # Handle regular packages
            if brew list "$package" &>/dev/null; then
                log_info "Uninstalling $package..."
                brew uninstall "$package" || log_warning "Failed to uninstall $package"
            else
                log_info "$package not installed via Homebrew"
            fi
        fi
    done
    
    log_info "Running brew cleanup to remove unused dependencies..."
    brew cleanup
    
    log_success "Homebrew packages uninstallation completed"
}

# Remove additional tools and configurations
remove_additional_tools() {
    log_step "Removing additional tools and configurations"
    
    # Remove Flutter SDK
    if [[ "$UNINSTALL_FLUTTER" == true ]] && [[ -d "${HOME}/flutter" ]]; then
        read -p "Remove Flutter SDK directory? [y/N]: " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf "${HOME}/flutter"
            log_success "Flutter SDK directory removed"
        fi
    fi
    

    
    # Remove conda environments
    if [[ "$UNINSTALL_PYTHON_AI" == true ]] && command_exists conda; then
        read -p "Remove ai-dev conda environment? [y/N]: " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            conda env remove -n ai-dev -y 2>/dev/null || true
            log_success "ai-dev conda environment removed"
        fi
    fi
    
    # Remove Ollama data
    if [[ "$UNINSTALL_PYTHON_AI" == true ]] && [[ -d "${HOME}/.ollama" ]]; then
        read -p "Remove Ollama data and models? [y/N]: " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf "${HOME}/.ollama"
            rm -rf "${HOME}/.cache/ai-dev"
            log_success "Ollama data removed"
        fi
    fi
}

# Remove symlinks and restore backups
remove_symlinks() {
    log_step "Removing symlinks and configurations"
    
    # Remove .zshrc symlink
    if [[ -L "${HOME}/.zshrc" ]]; then
        rm "${HOME}/.zshrc"
        log_info "Removed .zshrc symlink"
    fi
    
    # Note: Starship config removed as we use custom prompt themes
    
    # Remove git config symlink if it exists
    if [[ -L "${HOME}/.gitconfig" ]]; then
        rm "${HOME}/.gitconfig"
        log_info "Removed .gitconfig symlink"
    fi
    
    # Remove FZF config
    if [[ -f "${HOME}/.fzf.zsh" ]]; then
        rm "${HOME}/.fzf.zsh"
        log_info "Removed FZF configuration"
    fi
    
    # Remove dotfiles directory
    read -p "Remove entire dotfiles directory? [y/N]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]] && [[ -d "$DOTFILES_DIR" ]]; then
        rm -rf "$DOTFILES_DIR"
        log_success "Dotfiles directory removed"
    fi
    
    # Restore original shell if needed
    if [[ "$SHELL" == */zsh ]] && [[ "$UNINSTALL_CORE" == true ]]; then
        read -p "Restore bash as default shell? [y/N]: " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            chsh -s /bin/bash
            log_success "Default shell restored to bash"
        fi
    fi
}

# Uninstall main function
uninstall_main() {
    echo -e "${RED}"
    cat << 'EOF'
╭─────────────────────────────────────╮
│     Dotfiles Uninstallation        │
│                                     │
│     ⚠️  Proceed with Caution ⚠️     │
╰─────────────────────────────────────╯
EOF
    echo -e "${NC}"
    
    log_warning "This will remove packages and configurations installed by this dotfiles setup"
    log_warning "Some packages might be used by other applications"
    
    # Run uninstallation steps
    select_uninstall_stacks
    uninstall_homebrew_packages
    remove_additional_tools
    remove_symlinks
    
    echo -e "\n${GREEN}Uninstallation completed!${NC}"
    echo -e "${YELLOW}You may want to restart your terminal.${NC}"
}

# Main installation function
main() {
    # Handle command line arguments
    case "${1:-}" in
        "uninstall"|"remove"|"--uninstall")
            uninstall_main
            exit 0
            ;;
        "--help"|"-h")
            echo "Usage: $0 [command]"
            echo ""
            echo "Commands:"
            echo "  (no args)     Install dotfiles and packages"
            echo "  uninstall     Uninstall packages and remove configurations"
            echo "  --help        Show this help message"
            exit 0
            ;;
    esac
    
    echo -e "${CYAN}"
    cat << 'EOF'
 ██████╗██████╗  █████╗ ███████╗██╗   ██╗    ██████╗ ███████╗██╗   ██╗    ███████╗███████╗██╗  ██╗
██╔════╝██╔══██╗██╔══██╗╚══███╔╝╚██╗ ██╔╝    ██╔══██╗██╔════╝██║   ██║    ╚══███╔╝██╔════╝██║  ██║
██║     ██████╔╝███████║  ███╔╝  ╚████╔╝     ██║  ██║█████╗  ██║   ██║      ███╔╝ ███████╗███████║
██║     ██╔══██╗██╔══██║ ███╔╝    ╚██╔╝      ██║  ██║██╔══╝  ╚██╗ ██╔╝     ███╔╝  ╚════██║██╔══██║
╚██████╗██║  ██║██║  ██║███████╗   ██║       ██████╔╝███████╗ ╚████╔╝     ███████╗███████║██║  ██║
 ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝   ╚═╝       ╚═════╝ ╚══════╝  ╚═══╝      ╚══════╝╚══════╝╚═╝  ╚═╝
EOF
    echo -e "${PURPLE}                      🚀 Supercharge Your Terminal • Lightning Fast • Developer Focused 🚀${NC}"
    echo -e "${GREEN}                                        v2.0 - The Ultimate Dev Environment${NC}"
    echo -e "${YELLOW}                                  Proudly sponsored by Owera Software (owera.ai)${NC}"
    echo -e "${CYAN}                                     Built with ❤️  by Rodrigo Recio${NC}"
    echo
    
    # Check if running on supported OS
    if ! is_macos; then
        error_exit "This installation script is designed for macOS"
    fi
    
    # Check for required tools
    if ! command_exists git; then
        error_exit "Git is required but not installed"
    fi
    
    # Run installation steps
    select_tech_stacks || error_exit "Tech stack selection cancelled"
    install_homebrew || error_exit "Failed to install Homebrew"
    install_homebrew_packages || error_exit "Failed to install packages"
    install_additional_tools
    setup_dotfiles || error_exit "Failed to setup dotfiles"
    create_directories || error_exit "Failed to create directories"
    create_symlinks || error_exit "Failed to create symlinks"
    setup_zsh || error_exit "Failed to setup ZSH"
    select_prompt_theme_install || error_exit "Failed to select prompt theme"
    setup_git
    setup_ssh
    optimize_macos
    final_setup
    
    print_summary
}

# Run main function
main "$@" 