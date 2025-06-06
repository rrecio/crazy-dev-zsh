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
    
    log_step "Installing selected packages via Homebrew"
    
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
            "bat"          # Better cat
            "eza"          # Better ls
            "fd"           # Better find
            "ripgrep"      # Better grep
            "fzf"          # Fuzzy finder
            "jq"           # JSON processor
            "htop"         # Better top
            "tree"         # Directory tree
            "dust"         # Better du
            "procs"        # Better ps
            
            # Essential development tools
            "git-delta"    # Better git diff
            "gh"           # GitHub CLI
            
            # ZSH enhancements
            "zsh-autosuggestions"
            "zsh-syntax-highlighting"
            "starship"     # Modern prompt
            
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
            if brew list --cask "$cask_name" &>/dev/null; then
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
                "dust") cmd_name="dust" ;;
                "procs") cmd_name="procs" ;;
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
    log_step "Installing additional tools"
    
    # Install Oh My Zsh (optional, for users who want it)
    if [[ ! -d "${HOME}/.oh-my-zsh" ]]; then
        read -p "Install Oh My Zsh? (optional, for extra zsh plugins) [y/N]: " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
            log_success "Oh My Zsh installed"
        fi
    fi
    
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
    log_step "Creating symlinks"
    
    # Backup and link .zshrc
    backup_file "${HOME}/.zshrc"
    ln -sf "${DOTFILES_DIR}/.zshrc" "${HOME}/.zshrc"
    log_success "Linked .zshrc"
    
    # Create config directory if it doesn't exist
    mkdir -p "${HOME}/.config"
    
    # Link starship config if it exists
    if [[ -f "${DOTFILES_DIR}/config/starship.toml" ]]; then
        backup_file "${HOME}/.config/starship.toml"
        ln -sf "${DOTFILES_DIR}/config/starship.toml" "${HOME}/.config/starship.toml"
        log_success "Linked starship config"
    fi
    
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
}

# Setup ZSH as default shell
setup_zsh() {
    log_step "Setting up ZSH as default shell"
    
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
    log_step "Creating necessary directories"
    
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

# Optimize macOS settings
optimize_macos() {
    if ! is_macos; then
        return 0
    fi
    
    log_step "Optimizing macOS settings"
    
    read -p "Apply macOS optimizations? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Show hidden files in Finder
        defaults write com.apple.finder AppleShowAllFiles -bool true
        
        # Enable tap to click
        defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
        
        # Disable dock animation
        defaults write com.apple.dock launchanim -bool false
        
        # Speed up mission control
        defaults write com.apple.dock expose-animation-duration -float 0.1
        
        # Restart affected applications
        killall Dock 2>/dev/null || true
        killall Finder 2>/dev/null || true
        
        log_success "macOS optimizations applied"
    fi
}

# Final setup steps
final_setup() {
    log_step "Final setup steps"
    
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
    echo -e "1. Restart your terminal"
    echo -e "2. Run 'dotfiles_perf' to check performance"
    echo -e "3. Run 'perf_tips' for optimization tips"
    echo -e "4. Customize ${DOTFILES_DIR}/zsh/custom.zsh"
    
    echo -e "\n${CYAN}Useful commands:${NC}"
    echo -e "• reload       - Reload configuration"
    echo -e "• dotfiles     - Go to dotfiles directory"
    echo -e "• brewup       - Update Homebrew packages"
    echo -e "• gstatus      - Enhanced git status"
    echo -e "• proj         - Navigate to projects"
    
    echo -e "\n${GREEN}Enjoy your new shell environment!${NC}"
}

# Error handling
error_exit() {
    log_error "Installation failed: $1"
    exit 1
}

# Main installation function
main() {
    echo -e "${CYAN}"
    cat << 'EOF'
╭─────────────────────────────────────╮
│     Modern ZSH Dotfiles Setup      │
│                                     │
│     Intelligent • Fast • Secure    │
╰─────────────────────────────────────╯
EOF
    echo -e "${NC}"
    
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
    setup_git
    setup_ssh
    optimize_macos
    final_setup
    
    print_summary
}

# Run main function
main "$@" 