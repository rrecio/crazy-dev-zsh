# 🚀 Crazy Dev ZSH

<div align="center">

[![macOS](https://img.shields.io/badge/macOS-000000?style=for-the-badge&logo=apple&logoColor=white)](https://www.apple.com/macos/)
[![Zsh](https://img.shields.io/badge/Zsh-F15A24?style=for-the-badge&logo=zsh&logoColor=white)](https://www.zsh.org/)
[![AI Powered](https://img.shields.io/badge/AI-Powered-00D4FF?style=for-the-badge&logo=openai&logoColor=white)](https://ollama.ai/)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)
[![Stars](https://img.shields.io/github/stars/rrecio/crazy-dev-zsh?style=for-the-badge&logo=github)](https://github.com/rrecio/crazy-dev-zsh)

**🎯 The Ultimate Developer Terminal Experience**

*Supercharge your productivity with AI-powered development tools, beautiful powerline prompts, and intelligent automation for every tech stack imaginable.*

```
 ██████╗██████╗  █████╗ ███████╗██╗   ██╗    ██████╗ ███████╗██╗   ██╗    ███████╗███████╗██╗  ██╗
██╔════╝██╔══██╗██╔══██╗╚══███╔╝╚██╗ ██╔╝    ██╔══██╗██╔════╝██║   ██║    ╚══███╔╝██╔════╝██║  ██║
██║     ██████╔╝███████║  ███╔╝  ╚████╔╝     ██║  ██║█████╗  ██║   ██║      ███╔╝ ███████╗███████║
██║     ██╔══██╗██╔══██║ ███╔╝    ╚██╔╝      ██║  ██║██╔══╝  ╚██╗ ██╔╝     ███╔╝  ╚════██║██╔══██║
╚██████╗██║  ██║██║  ██║███████╗   ██║       ██████╔╝███████╗ ╚████╔╝     ███████╗███████║██║  ██║
 ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝   ╚═╝       ╚═════╝ ╚══════╝  ╚═══╝      ╚══════╝╚══════╝╚═╝  ╚═╝
```

</div>

**⏱️ 2-minute setup • 🎯 Choose your tech stacks • 🚀 Boost productivity instantly**

---

## 🌟 **Sponsored by [Owera Software](https://owera.ai)**

<div align="center">

**🚀 AI-Powered Development Solutions**

Built with ❤️ by [Rodrigo Recio](mailto:info@owera.ai) • [Contact us](mailto:info@owera.ai) for custom development

[Visit Owera.ai →](https://owera.ai)

</div>

---

## 🚀 **Get Started Right Now**

<div align="center">

**👇 Copy, paste, and run this command:**

```bash
curl -fsSL https://raw.githubusercontent.com/rrecio/crazy-dev-zsh/main/install.sh | bash
```

*Interactive installer • Choose your tools • Works in 2 minutes*

</div>

---

## 📖 **Table of Contents**

- [✨ What Makes This Special?](#-what-makes-this-special)
- [🚀 Quick Start](#-quick-start)
- [🎭 Prompt Preview](#-prompt-preview)
- [🏗️ Tech Stack Support](#️-tech-stack-support)
- [🤖 AI-Powered Development](#-ai-powered-development)
- [⚙️ Advanced Features](#️-advanced-features)
- [🎮 Key Bindings](#-key-bindings)
- [🎛️ Customization](#️-customization)
- [📋 Requirements](#-requirements)
- [🎓 Usage Examples](#-usage-examples)

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

> **⚠️ Important:** This is designed for **macOS only**. Make sure you have [Homebrew](https://brew.sh/) or it will be installed automatically.

### 🎯 **Interactive Install** *(Recommended for first-time users)*

```bash
curl -fsSL https://raw.githubusercontent.com/rrecio/crazy-dev-zsh/main/install.sh | bash
```

**What happens?** The installer will:
1. 🎨 Show a beautiful welcome screen
2. 📝 Let you **choose which tech stacks** you want (iOS, Flutter, Go, etc.)
3. 🍺 Install Homebrew if needed
4. 📦 Install only the tools you selected
5. ⚙️ Configure your shell with the new prompt
6. 🎉 Ready to use in seconds!

### ⚡ **Install Everything** *(For power users)*

```bash
curl -fsSL https://raw.githubusercontent.com/rrecio/crazy-dev-zsh/main/install.sh | DOTFILES_INSTALL_ALL=1 bash
```

### 🎛️ **Custom Installation** *(Automated/CI-friendly)*

```bash
# Example: Install only JavaScript, Docker, and Python/AI tools
curl -fsSL https://raw.githubusercontent.com/rrecio/crazy-dev-zsh/main/install.sh | \
  DOTFILES_INSTALL_JAVASCRIPT=1 \
  DOTFILES_INSTALL_DOCKER=1 \
  DOTFILES_INSTALL_PYTHON_AI=1 bash
```

### 🔄 **After Installation**

1. **Restart your terminal** or run `source ~/.zshrc`
2. **You'll see the new prompt** with beautiful segments
3. **Try some commands** like `gst` (git status) or `ll` (better ls)
4. **Need help?** Run `dotfiles_help` for a quick guide

---

## 🏗️ **Tech Stack Support**

> **💡 Tip:** Each tech stack is optional! Install only what you need during setup.

### 📊 **Quick Overview**

| Tech Stack | Install Variable | Key Tools | Cool Commands |
|------------|-----------------|-----------|---------------|
| 📱 **iOS/Swift** | `DOTFILES_INSTALL_IOS=1` | SwiftLint, Xcode tools | `smart_xcodebuild`, `ios_sim boot` |
| 🦋 **Flutter** | `DOTFILES_INSTALL_FLUTTER=1` | Flutter SDK, Android Studio | `flutter_hot run`, `device list` |
| 🐹 **Go** | `DOTFILES_INSTALL_GO=1` | Go, Air hot reload | `go_new MyAPI`, `air` |
| 🟨 **JavaScript** | `DOTFILES_INSTALL_JAVASCRIPT=1` | Node, yarn, pnpm, bun | `js_new MyApp react`, `jsrun build` |
| 🐍 **Python/AI** | `DOTFILES_INSTALL_PYTHON_AI=1` | Python, Ollama, Jupyter | `ai_explain`, `conda activate ai-dev` |
| 🐳 **Docker** | `DOTFILES_INSTALL_DOCKER=1` | Docker, kubectl, K9s | `dock clean`, `k get all` |
| ☁️ **Cloud** | `DOTFILES_INSTALL_CLOUD=1` | AWS CLI, Terraform | `smart_deploy`, `awswhoami` |

<details>
<summary>📱 <strong>iOS & Swift Development - Full Details</strong></summary>

**What You Get:**
- SwiftLint & SwiftFormat for code quality
- Xcode build tools (xcbeautify) for beautiful output
- Swift Package Manager (mint) for tool management
- iOS Simulator management
- Smart Xcode project detection

**Key Commands:**
```bash
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

### ⚙️ **Environment Variables Reference**

<details>
<summary><strong>📦 Installation Variables</strong></summary>

```bash
# Install everything at once
DOTFILES_INSTALL_ALL=1

# Individual tech stacks
DOTFILES_INSTALL_IOS=1              # iOS/Swift tools
DOTFILES_INSTALL_FLUTTER=1          # Flutter/Dart tools
DOTFILES_INSTALL_GO=1               # Go tools
DOTFILES_INSTALL_JAVASCRIPT=1       # JavaScript/TypeScript tools
DOTFILES_INSTALL_PYTHON_AI=1        # Python/AI tools
DOTFILES_INSTALL_DOCKER=1           # Docker/Kubernetes tools
DOTFILES_INSTALL_CLOUD=1            # Cloud deployment tools
```

</details>

<details>
<summary><strong>🗑️ Uninstallation Variables</strong></summary>

```bash
DOTFILES_UNINSTALL_ALL=1            # Remove everything
DOTFILES_UNINSTALL_CORE=1           # Remove core tools only
DOTFILES_UNINSTALL_IOS=1            # Remove iOS tools only
# ... (same pattern for other stacks)
```

</details>

<details>
<summary><strong>🔧 Debug & Performance</strong></summary>

```bash
CRAZY_DEV_ZSH_DEBUG=true           # Enable debug mode
# Shows prompt render times and performance info
```

</details>

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

## ❓ **FAQ & Troubleshooting**

<details>
<summary><strong>🔧 Installation Issues</strong></summary>

**Q: Installation fails with permission errors**
   ```bash
# Fix: Make sure you have admin privileges
sudo -v
# Then retry the installation
   ```

**Q: "command not found" after installation**
   ```bash
# Fix: Restart your terminal or reload config
   source ~/.zshrc
   ```

**Q: Prompt looks broken or has strange characters**
- Install a [Nerd Font](https://www.nerdfonts.com/) (recommended: MesloLGS NF)
- Set it as your terminal font

</details>

<details>
<summary><strong>🗑️ Uninstalling</strong></summary>

```bash
# Uninstall everything
./install.sh uninstall

# Uninstall specific tech stacks
./install.sh uninstall
# Then choose what to remove during the interactive process

# Automated uninstall
DOTFILES_UNINSTALL_ALL=1 ./install.sh uninstall
```

</details>

<details>
<summary><strong>🎨 Customization</strong></summary>

**Q: How do I customize the prompt?**
- Edit `~/.dotfiles/zsh/custom.zsh` for personal tweaks
- Use `CRAZY_DEV_ZSH_DEBUG=true` to see prompt performance

**Q: How do I disable certain segments?**
- Set environment variables in your `custom.zsh`
- Example: `PROMPT_SHOW_BATTERY=false`

</details>

<details>
<summary><strong>🚀 Performance</strong></summary>

**Q: Prompt feels slow**
```bash
# Check render time
CRAZY_DEV_ZSH_DEBUG=true
prompt_bench
```

**Q: Terminal startup is slow**
- The prompt uses smart caching - first load might be slower
- Subsequent loads should be much faster

</details>

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

---

### 🌟 **About**

**Created by:** [Rodrigo Recio](mailto:info@owera.ai)  
**Sponsored by:** [Owera Software - AI-Powered Development Solutions](https://owera.ai)  
**Contact:** [info@owera.ai](mailto:info@owera.ai)  

*Transforming development workflows with intelligent automation and beautiful tooling.*

</div> 