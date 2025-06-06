# 🚀 Crazy Dev ZSH

<div align="center">

[![macOS](https://img.shields.io/badge/macOS-000000?style=for-the-badge&logo=apple&logoColor=white)](https://www.apple.com/macos/)
[![Zsh](https://img.shields.io/badge/Zsh-F15A24?style=for-the-badge&logo=zsh&logoColor=white)](https://www.zsh.org/)
[![AI Powered](https://img.shields.io/badge/AI-Powered-00D4FF?style=for-the-badge&logo=openai&logoColor=white)](https://ollama.ai/)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)
[![Stars](https://img.shields.io/github/stars/rrecio/crazy-dev-zsh?style=for-the-badge&logo=github)](https://github.com/rrecio/crazy-dev-zsh)

**🎯 The Ultimate Developer Terminal Experience**

*Supercharge your productivity with AI-powered development tools, beautiful powerline prompts, and intelligent automation for every tech stack imaginable.*

![Banner Image - Terminal with Crazy Dev ZSH](https://via.placeholder.com/800x200/1e1e2e/cdd6f4?text=🚀+Crazy+Dev+ZSH+🚀)

</div>

---

## ✨ **What Makes This Special?**

<table>
<tr>
<td width="50%">

### 🎨 **Beautiful & Fast**
- **Powerlevel10k-style prompt** with segments
- **Nerd Font icons** everywhere
- **Smart caching** for lightning performance
- **Context-aware** display

### 🤖 **AI-Powered Development**
- **Local LLM integration** with Ollama
- **Code explanation** & review
- **Auto-generated** commit messages
- **Smart debugging** assistance

</td>
<td width="50%">

### 🛠️ **Multi-Language Support**
- **iOS/Swift** with Xcode integration
- **Flutter/Dart** cross-platform
- **Go** with hot reload
- **JavaScript/TypeScript** ecosystem
- **Python/AI** with ML tools
- **Docker & Kubernetes**

### ⚡ **Intelligent Automation**
- **Smart aliases** that adapt
- **Auto-detection** of projects
- **Unified commands** across stacks
- **Performance monitoring**

</td>
</tr>
</table>

---

## 🎭 **Prompt Preview**

```bash
# Beautiful powerline segments showing context
  ~/projects/my-app   main ✚2 ●1  node 18.17.0 TS  🐳 3  󰁹 85%
❯ 
```

**Features:**
- 🖥️  **OS indicator** (Apple Silicon/Intel/Linux)
- 👤 **User/SSH status** with smart colors
- 📁 **Smart directory** with context icons
- 🌿 **Git status** with visual indicators
- 🔧 **Language versions** (Node, Python, Go, Swift, Flutter)
- 🐳 **Docker containers** & ☸️ **Kubernetes context**
- 🔋 **Battery status** & ⏱️ **Command timing**

---

## 🚀 **Quick Start**

### 🎯 **One-Line Install** *(Recommended)*

```bash
# Interactive installation - choose your tech stacks
curl -fsSL https://raw.githubusercontent.com/rrecio/crazy-dev-zsh/main/install.sh | bash
```

### ⚡ **Install Everything**

```bash
# Skip choices, install all the things!
curl -fsSL https://raw.githubusercontent.com/rrecio/crazy-dev-zsh/main/install.sh | DOTFILES_INSTALL_ALL=1 bash
```

### 🎛️ **Custom Installation**

```bash
# Install only what you need
curl -fsSL https://raw.githubusercontent.com/rrecio/crazy-dev-zsh/main/install.sh | \
  DOTFILES_INSTALL_JAVASCRIPT=1 \
  DOTFILES_INSTALL_DOCKER=1 \
  DOTFILES_INSTALL_PYTHON_AI=1 bash
```

---

## 🏗️ **Tech Stack Support**

<details>
<summary>📱 <strong>iOS & Swift Development</strong></summary>

```bash
# Environment Variables
DOTFILES_INSTALL_IOS=1

# What You Get
✅ SwiftLint & SwiftFormat
✅ Xcode build tools (xcbeautify)
✅ Swift Package Manager (mint)
✅ iOS Simulator management
✅ Smart Xcode project detection

# Cool Commands
smart_xcodebuild          # Intelligent builds
ios_sim boot "iPhone 15"  # Boot simulators
swift_new MyApp          # Create Swift packages
xc_analyze               # Project analysis
```

</details>

<details>
<summary>🦋 <strong>Flutter & Dart Development</strong></summary>

```bash
# Environment Variables  
DOTFILES_INSTALL_FLUTTER=1

# What You Get
✅ Flutter SDK auto-setup
✅ Dart language support
✅ Android Studio integration
✅ Cross-platform device management
✅ CocoaPods for iOS dependencies

# Cool Commands
flutter_new MyApp        # Create Flutter projects
flutter_hot run         # Hot reload development
device list             # All connected devices
droid boot Pixel_7      # Android emulator
flhot debug            # Debug with hot reload
```

</details>

<details>
<summary>🐹 <strong>Go Development</strong></summary>

```bash
# Environment Variables
DOTFILES_INSTALL_GO=1

# What You Get
✅ Go latest version
✅ golangci-lint for code quality
✅ Air for hot reload
✅ Smart project templates
✅ Advanced testing tools

# Cool Commands
go_new MyAPI api        # Create Go projects
gonew MyService         # Quick setup
gorun                   # Smart execution
gob && ./myapp         # Build and run
got -cover ./...       # Test with coverage
air                    # Hot reload server
```

</details>

<details>
<summary>🟨 <strong>JavaScript & TypeScript</strong></summary>

```bash
# Environment Variables
DOTFILES_INSTALL_JAVASCRIPT=1

# What You Get
✅ Node.js LTS
✅ Multiple package managers (npm, yarn, pnpm, bun)
✅ Deno runtime
✅ Smart framework detection
✅ TypeScript support

# Cool Commands
js_new MyApp react yarn    # Create projects
jsrun build               # Smart build runner
ni && nd                  # npm install & dev
ya react && yd           # yarn workflows
pi typescript && pb      # pnpm workflows
```

</details>

<details>
<summary>🐍 <strong>Python & AI Development</strong></summary>

```bash
# Environment Variables
DOTFILES_INSTALL_PYTHON_AI=1

# What You Get
✅ Python 3.11 + latest
✅ Miniconda package manager
✅ Ollama for local LLMs
✅ Jupyter Lab environment
✅ AI/ML packages pre-configured

# Cool Commands
ai_env                   # Setup AI environment
conda activate ai-dev    # Activate AI env
jupyter lab             # Start Jupyter
ollama_manager list     # Manage AI models
ai_explain src/main.py  # AI code explanation
```

</details>

<details>
<summary>🐳 <strong>Docker & Kubernetes</strong></summary>

```bash
# Environment Variables
DOTFILES_INSTALL_DOCKER=1

# What You Get
✅ Docker Desktop
✅ kubectl (Kubernetes CLI)
✅ kubectx & kubens
✅ Helm package manager
✅ K9s terminal UI

# Cool Commands
docker_manager ps        # List containers
dock clean              # Clean system
kube ctx production     # Switch context
kube ns myapp          # Switch namespace
k get all              # Get all resources
k exec mypod           # Shell into pods
```

</details>

<details>
<summary>☁️ <strong>Cloud & Deployment</strong></summary>

```bash
# Environment Variables
DOTFILES_INSTALL_CLOUD=1

# What You Get
✅ AWS CLI
✅ Heroku CLI
✅ Terraform
✅ Serverless framework
✅ Smart deployment detection

# Cool Commands
smart_deploy            # Auto-detect platform
deploy heroku prod     # Deploy to Heroku
deploy k8s staging     # Deploy to K8s
awswhoami             # Check AWS identity
hlogs                 # Stream Heroku logs
```

</details>

---

## 🤖 **AI-Powered Development**

### 🧠 **Local AI Models** *(Privacy-First)*

- **🦙 CodeLlama** - Specialized for code generation
- **🔍 DeepSeek Coder** - Optimized for code assistance  
- **⚡ Mistral** - Fast general-purpose model
- **🔐 100% Local** - No data leaves your machine

### 🛠️ **AI Commands**

<table>
<tr>
<td width="50%">

**📝 Code Analysis**
```bash
ai_explain src/main.py      # Explain code
ai_review .                 # Review changes  
ai_commit                   # Generate commits
ai_docs src/                # Generate docs
ai_test utils.py           # Generate tests
```

</td>
<td width="50%">

**🔧 Development Help**
```bash
ai_debug "TypeError: ..."   # Debug errors
ai_translate app.py go      # Translate code
ai_refactor api.py perf     # Refactor suggestions
quality                     # Code quality analysis
security                    # Security review
```

</td>
</tr>
</table>

### 💬 **Interactive AI Chat**

```bash
code        # Chat with CodeLlama
coder       # Chat with DeepSeek Coder  
mistral     # Chat with Mistral
pycode      # Python-specific help
```

---

## ⚙️ **Advanced Features**

### 🎨 **Prompt Customization**

```bash
# Debug prompt performance
CRAZY_DEV_ZSH_DEBUG=true
prompt_bench                # Benchmark render time

# Segments auto-detect context
📁 Special directory icons
🌿 Git status with counters  
🔧 Language version detection
🐳 Container status
🔋 Battery & system info
```

### 🗑️ **Easy Uninstall**

```bash
# Uninstall specific tech stacks
./install.sh uninstall

# Environment variables for automation
DOTFILES_UNINSTALL_ALL=1 ./install.sh uninstall
DOTFILES_UNINSTALL_JAVASCRIPT=1 ./install.sh uninstall
```

### ⚡ **Performance Optimized**

- **Smart caching** for expensive operations
- **Conditional loading** based on project context
- **Async-ready** architecture
- **Memory efficient** with on-demand features

---

## 🗂️ **Project Structure**

```
crazy-dev-zsh/
├── 🎯 install.sh              # Smart installer with uninstall
├── 📝 .zshrc                  # Main configuration
├── zsh/
│   ├── 🎨 prompt.zsh          # Powerlevel10k-style prompt
│   ├── ⚡ aliases.zsh         # Smart aliases (645 lines!)
│   ├── 🛠️ functions.zsh       # Utility functions (3327 lines!)
│   ├── 📦 exports.zsh         # Environment setup
│   ├── 🎯 completion.zsh      # Advanced completions
│   ├── 🌿 git.zsh            # Git integration
│   ├── 🍎 macos.zsh          # macOS optimizations
│   ├── 📊 performance.zsh     # Performance monitoring
│   └── 🎛️ custom.zsh         # Your customizations
└── config/
    ├── ⚙️ starship.toml       # Starship config (alternative)
    ├── 🌿 .gitconfig          # Git configuration
    └── 🚫 .gitignore_global   # Global ignores
```

---

## 🎮 **Key Bindings**

| Shortcut | Action |
|----------|--------|
| `Ctrl+R` | 🔍 Fuzzy history search |
| `Ctrl+T` | 📁 Fuzzy file finder |
| `Alt+C` | 📂 Fuzzy directory navigation |
| `Ctrl+Space` | ✨ Accept autosuggestion |

---

## 🎛️ **Customization**

### 📝 **Personal Config**
Edit `~/.dotfiles/zsh/custom.zsh` for your personal tweaks without touching core files.

### 🎨 **Prompt Colors**
The prompt automatically adapts colors based on context:
- 🟢 **Green** - Success states, clean git repos
- 🟡 **Yellow** - Warnings, dirty git repos  
- 🔴 **Red** - Errors, untracked files, root user
- 🔵 **Blue** - Information, languages, tools
- 🟣 **Purple** - Special states, execution time

### ⚙️ **Environment Variables**

```bash
# Installation control
DOTFILES_INSTALL_ALL=1              # Install everything
DOTFILES_INSTALL_IOS=1              # iOS tools
DOTFILES_INSTALL_FLUTTER=1          # Flutter tools
DOTFILES_INSTALL_GO=1               # Go tools
DOTFILES_INSTALL_JAVASCRIPT=1       # JS/TS tools
DOTFILES_INSTALL_PYTHON_AI=1        # Python/AI tools
DOTFILES_INSTALL_DOCKER=1           # Docker/K8s tools
DOTFILES_INSTALL_CLOUD=1            # Cloud tools

# Uninstallation control
DOTFILES_UNINSTALL_ALL=1            # Uninstall everything
DOTFILES_UNINSTALL_CORE=1           # Uninstall core tools

# Debug and performance
CRAZY_DEV_ZSH_DEBUG=true           # Debug mode
```

---

## 📋 **Requirements**

- 🍎 **macOS 10.15+** (Catalina or newer)
- 🐚 **Zsh** (default on macOS Catalina+)
- 🍺 **Homebrew** (auto-installed)
- 🔤 **Nerd Font** (recommended for icons)

---

## 🎓 **Usage Examples**

### 🚀 **Full-Stack Web Development**

```bash
# Create a new React app with TypeScript
js_new my-web-app react yarn
cd my-web-app

# The prompt now shows: 📁 my-web-app 🌿 main ⬢ 18.17.0 TS

# Install dependencies and start
ya @types/node && yd
# Yarn detected, TypeScript configured, dev server started
```

### 📱 **Mobile App Development**

```bash
# Create a Flutter app
flutter_new my_mobile_app
cd my_mobile_app

# The prompt shows: 📁 my_mobile_app 🌿 main 🦋 3.13.0

# Start development with hot reload
flhot debug
# iOS simulator boots, Android emulator available, hot reload active
```

### 🤖 **AI-Assisted Development**

```bash
# Code review with AI
git add .
ai_review .
# AI analyzes your changes and provides feedback

# Generate commit message
ai_commit
# AI creates descriptive commit based on staged changes

# Debug an error
ai_debug "AttributeError: 'NoneType' object has no attribute 'get'"
# AI suggests solutions and explains the error
```

---

## 🤝 **Contributing**

We love contributions! Here's how you can help:

1. 🍴 **Fork** the repository
2. 🌿 **Create** a feature branch (`git checkout -b amazing-feature`)
3. 💾 **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. 📤 **Push** to the branch (`git push origin amazing-feature`)
5. 🎯 **Open** a Pull Request

---

## 📜 **License**

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

---

## 🙏 **Acknowledgments**

- 🌟 **Powerlevel10k** - Inspiration for the prompt design
- 🦙 **Ollama** - Local LLM integration
- ⭐ **Starship** - Alternative prompt option
- 🍺 **Homebrew** - Package management
- 🔍 **fzf** - Fuzzy finding magic

---

<div align="center">

### 🚀 **Ready to Transform Your Terminal?**

```bash
curl -fsSL https://raw.githubusercontent.com/rrecio/crazy-dev-zsh/main/install.sh | bash
```

**⭐ Star this repo if it made your development life easier!**

[![Made with ❤️](https://img.shields.io/badge/Made%20with-❤️-red.svg?style=for-the-badge)](https://github.com/rrecio/crazy-dev-zsh)
[![Follow](https://img.shields.io/github/followers/rrecio?style=for-the-badge&logo=github)](https://github.com/rrecio)

</div> 