# Crazy-Dev-Zsh for macOS

A comprehensive, intelligent zsh configuration optimized for **AI-powered full-stack development** with Swift, Flutter, Go, JavaScript/TypeScript, Python, Docker, Kubernetes, and cloud deployment using Xcode, Android Studio, Cursor IDE, and local Ollama AI models.

## ✨ Features

- **AI-Powered Development** with Ollama integration for local LLMs
- **Smart completion system** with fuzzy matching
- **Intelligent aliases** that adapt to your workflow
- **Advanced git integration** with visual status indicators
- **iOS/Swift development tools** with smart Xcode integration
- **Flutter/Dart development tools** with cross-platform support
- **Go development environment** with project templates and hot reload
- **JavaScript/TypeScript ecosystem** with modern tooling and frameworks
- **Multi-package manager support** (npm, yarn, pnpm, bun, deno)
- **Android development environment** with emulator management
- **Docker & Kubernetes integration** with intelligent management
- **Cloud deployment tools** for AWS, Heroku, and Serverless
- **AI/Python development environment** with conda and ML tools
- **Smart build systems** for all languages and frameworks
- **Unified device & container management** across all platforms
- **Cursor IDE integration** as default editor
- **Performance monitoring** and optimization
- **Security-focused** configurations
- **Modular design** for easy customization

### 🤖 AI-Powered Features

- **Code explanation** and documentation generation
- **Intelligent code review** and suggestions
- **Auto-generated commit messages** from git diffs
- **Error debugging** with AI assistance
- **Code translation** between programming languages
- **Unit test generation** for multiple frameworks
- **Refactoring suggestions** with best practices
- **Project scaffolding** with AI recommendations
- **Local LLM models** (CodeLlama, DeepSeek Coder, Mistral)
- **Privacy-focused** - all AI processing runs locally

## 🚀 Quick Install

### Interactive Installation (Recommended)
Choose which tech stacks you want during installation:

```bash
curl -fsSL https://raw.githubusercontent.com/rrecio/crazy-dev-zsh/main/install.sh | bash
```

### Install Everything
Skip the interactive selection and install all tech stacks:

```bash
curl -fsSL https://raw.githubusercontent.com/rrecio/crazy-dev-zsh/main/install.sh | DOTFILES_INSTALL_ALL=1 bash
```

### Custom Installation
Install only specific tech stacks using environment variables:

```bash
# Install only JavaScript and Docker tools
curl -fsSL https://raw.githubusercontent.com/rrecio/crazy-dev-zsh/main/install.sh | \
  DOTFILES_INSTALL_JAVASCRIPT=1 DOTFILES_INSTALL_DOCKER=1 bash

# Install iOS, Go, and Cloud tools
curl -fsSL https://raw.githubusercontent.com/rrecio/crazy-dev-zsh/main/install.sh | \
  DOTFILES_INSTALL_IOS=1 DOTFILES_INSTALL_GO=1 DOTFILES_INSTALL_CLOUD=1 bash
```

### Available Tech Stacks
- `DOTFILES_INSTALL_IOS=1` - iOS/Swift development tools
- `DOTFILES_INSTALL_FLUTTER=1` - Flutter/Dart development tools  
- `DOTFILES_INSTALL_GO=1` - Go development tools
- `DOTFILES_INSTALL_JAVASCRIPT=1` - JavaScript/TypeScript tools
- `DOTFILES_INSTALL_PYTHON_AI=1` - Python/AI development tools
- `DOTFILES_INSTALL_DOCKER=1` - Docker & Kubernetes tools
- `DOTFILES_INSTALL_CLOUD=1` - Cloud deployment tools (AWS, Heroku, etc.)

## 📁 Structure

```
├── zsh/
│   ├── aliases.zsh          # Smart aliases and shortcuts
│   ├── completion.zsh       # Advanced completion system
│   ├── exports.zsh          # Environment variables
│   ├── functions.zsh        # Utility functions
│   ├── git.zsh             # Git integration and shortcuts
│   ├── macos.zsh           # macOS-specific optimizations
│   ├── performance.zsh     # Performance monitoring
│   └── prompt.zsh          # Custom prompt with git status
├── config/
│   ├── .gitconfig          # Git configuration
│   ├── .gitignore_global   # Global gitignore
│   └── starship.toml       # Starship prompt config
├── install.sh              # Installation script
└── .zshrc                  # Main zsh configuration
```

## 🛠 Manual Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/rrecio/crazy-dev-zsh.git ~/.dotfiles
   ```

2. Run the installation:
   ```bash
   cd ~/.dotfiles && ./install.sh
   ```

3. Restart your terminal or source the configuration:
   ```bash
   source ~/.zshrc
   ```

## 🎨 Customization

Edit `~/.dotfiles/zsh/custom.zsh` to add your personal configurations without modifying the core files.

## 📋 Requirements

- macOS 10.15+
- Zsh (default on macOS Catalina+)
- Homebrew (installed automatically)

## 🔧 Key Bindings

- `Ctrl+R` - Fuzzy history search with fzf
- `Ctrl+T` - Fuzzy file finder
- `Alt+C` - Fuzzy directory navigation
- `Ctrl+Space` - Accept autosuggestion

## 📱 iOS Development Commands

- `smart_xcodebuild` - Intelligent Xcode build with auto-detection
- `ios_sim list` - List available iOS simulators
- `ios_sim boot iPhone 15` - Boot specific simulator
- `swift_new MyApp` - Create new Swift package
- `xc_analyze` - Analyze Xcode project for issues
- `xcbuild -clean -scheme MyApp` - Clean and build with smart formatting

## 🦋 Flutter Development Commands

- `flutter_new MyApp` - Create new Flutter project with AI/ML options
- `flutter_analyze` - Comprehensive Flutter project analysis
- `flutter_hot run` - Start with hot reload
- `flutter_build_smart apk` - Smart build for multiple platforms
- `flutter_deps ai` - Add AI/ML packages to Flutter project
- `device list` - List all iOS simulators and Android emulators
- `droid boot Pixel_7` - Boot Android emulator
- `flhot debug` - Start Flutter in debug mode with hot reload

## 🐹 Go Development Commands

- `go_new MyAPI api` - Create new Go project (app, lib, api, cli, web)
- `go_run_smart` - Smart Go runner with auto-detection
- `gonew MyService` - Quick Go project creation
- `gorun` - Intelligent Go execution
- `gob && ./myapp` - Build and run Go application
- `got -cover ./...` - Run tests with coverage
- `air` - Hot reload for Go development

## 🟨 JavaScript/TypeScript Development Commands

- `js_new MyApp react yarn` - Create new JS project with framework and package manager
- `js_run_smart dev` - Smart runner with auto-detected package manager
- `js_test_smart coverage` - Run tests with coverage
- `js_build_smart production` - Build for production with optimization
- `js_deps_manager ui` - Add UI framework (Tailwind, MUI, etc.)
- `jsnew MyAPI express` - Quick project creation
- `jsrun build` - Smart build runner
- `ni && nd` - NPM install and dev (with auto-detection)
- `ya react && yd` - Yarn add React and start dev server
- `pi typescript && pb` - PNPM install TypeScript and build

## 🐳 Docker & Kubernetes Commands

- `docker_manager ps` - List running containers with formatted output
- `dock images` - Show Docker images
- `dock clean` - Clean Docker system
- `k8s_manager pods` - List Kubernetes pods
- `kube ctx production` - Switch Kubernetes context
- `kube ns myapp` - Switch Kubernetes namespace
- `k get all` - Get all Kubernetes resources
- `k exec mypod` - Execute shell in pod

## ☁️ Cloud Deployment Commands

- `smart_deploy` - Auto-detect and deploy to appropriate platform
- `deploy heroku production` - Deploy to Heroku
- `deploy k8s staging` - Deploy to Kubernetes
- `deploy aws production` - Deploy to AWS (SAM/CloudFormation/CDK)
- `deploy serverless staging` - Deploy serverless functions
- `awswhoami` - Check AWS identity
- `hlogs` - Stream Heroku logs

## 🤖 AI-Powered Development Commands

### Model Management
- `ollama_manager list` - List installed AI models
- `ollama_manager download codellama` - Download AI models
- `ollama_manager run deepseek-coder` - Start interactive AI chat
- `om list` - Quick model listing
- `omd codellama` - Quick model download
- `startai` - Start Ollama server
- `stopai` - Stop Ollama server
- `aistatus` - Check Ollama server status

### Code Analysis & Generation
- `ai_explain src/main.py` - AI-powered code explanation
- `ai_review .` - Intelligent code review of changes
- `ai_commit` - Generate commit message from staged changes
- `ai_docs src/` - Generate project documentation
- `ai_test utils.py` - Generate unit tests for code
- `ai_debug "TypeError: ..."` - Debug error messages
- `ai_translate script.py javascript` - Translate code between languages
- `ai_refactor api.py performance` - Get refactoring suggestions

### Quick AI Shortcuts
- `explain src/main.py` - Explain code with AI
- `review .` - Review uncommitted changes
- `commit` - Generate AI commit message
- `docs .` - Generate documentation
- `debug error.log` - Debug errors with AI
- `translate src/app.py go` - Translate code
- `refactor utils.py security` - Refactor suggestions

### Interactive AI Chat
- `code` - Chat with CodeLlama for code questions
- `coder` - Chat with DeepSeek Coder
- `llama` - Chat with Llama2 for general help
- `mistral` - Chat with Mistral for fast responses
- `pycode` - Python-specific AI assistance
- `javacode` - Java-specific AI assistance

### AI-Enhanced Workflows
- `aicommit` - Stage all changes and generate AI commit
- `smartcommit` - Review changes and generate smart commit
- `codereview` - Review last commit with AI
- `quality` - Run code quality analysis
- `security` - Security-focused code review
- `performance` - Performance optimization suggestions

### Project Initialization
- `ai_init web my-app` - AI-assisted project setup
- `newweb my-blog` - Create new web project with AI
- `newapi my-service` - Create new API project with AI
- `newml my-model` - Create new ML project with AI

### Development Environment
- `ai_env` - Setup AI development environment
- `aienv python` - Setup Python AI environment  
- `conda activate ai-dev` - Activate AI environment
- `jupyter lab` - Start Jupyter Lab
- `cursor .` - Open current directory in Cursor IDE

## 📖 Documentation

See individual files in the `zsh/` directory for detailed documentation of each module. 