# Crazy Dev: AI-Driven Developer Terminal

```
   ▄████▄   ██▀███   ▄▄▄      ▒███████▒▓██   ██▓    ▓█████▄ ▓█████ ██▒   █▓
  ▒██▀ ▀█  ▓██ ▒ ██▒▒████▄    ▒ ▒ ▒ ▄▀░ ▒██  ██▒    ▒██▀ ██▌▓█   ▀▓██░   █▒
  ▒▓█    ▄ ▓██ ░▄█ ▒▒██  ▀█▄  ░ ▒ ▄▀▒░   ▒██ ██░    ░██   █▌▒███   ▓██  █▒░
  ▒▓▓▄ ▄██▒▒██▀▀█▄  ░██▄▄▄▄██   ▄▀▒   ░  ░ ▐██▓░    ░▓█▄   ▌▒▓█  ▄  ▒██ █░░
  ▒ ▓███▀ ░░██▓ ▒██▒ ▓█   ▓██▒▒███████▒  ░ ██▒▓░    ░▒████▓ ░▒████▒  ▒▀█░  
  ░ ░▒ ▒  ░░ ▒▓ ░▒▓░ ▒▒   ▓▒█░░▒▒ ▓░▒░▒   ██▒▒▒      ▒▒▓  ▒ ░░ ▒░ ░  ░ ▐░  
    ░  ▒     ░▒ ░ ▒░  ▒   ▒▒ ░░░▒ ▒ ░ ▒ ▓██ ░▒░      ░ ▒  ▒  ░ ░  ░  ░ ░░  
  ░          ░░   ░   ░   ▒   ░ ░ ░ ░ ░ ▒ ▒ ░░       ░ ░  ░    ░       ░░  
  ░ ░         ░           ░  ░  ░ ░     ░ ░            ░       ░  ░     ░  
  ░                           ░         ░ ░          ░                  ░  
```

> The next-generation terminal that anticipates your needs, automates repetitive tasks, and provides intelligent, context-aware assistance.

## 🚀 Quick Start

```bash
# Install Crazy Dev
curl -fsSL https://raw.githubusercontent.com/crazy-dev/main/install.sh | bash

# Initialize in your project
crazy init

# Get AI-powered suggestions
crazy suggest

# Ask the AI assistant
crazy ask "How do I optimize my Go server?"
```

## 📋 Project Structure

This project follows a structured development approach inspired by AI-powered development best practices:

```
crazy-dev-zsh/
├── docs/                    # Architecture and technical documentation
│   ├── architecture.mermaid # System architecture diagram
│   ├── technical.md         # Technical specifications
│   └── status.md           # Project status and milestones
├── tasks/                   # Structured task management
│   └── tasks.md            # Detailed task definitions
├── src/                     # Source code
│   ├── cmd/                # CLI commands
│   ├── core/               # Core functionality
│   ├── ai/                 # AI engine components
│   ├── plugins/            # Plugin system
│   ├── ui/                 # Terminal UI components
│   ├── sync/               # Cloud sync functionality
│   ├── stacks/             # Tech stack modules
│   └── utils/              # Utility functions
├── .cursorrules            # AI development guidelines
├── go.mod                  # Go module definition
└── README.md               # This file
```

## 🛠️ Development Setup

### Prerequisites

- Go 1.21+
- Git
- Optional: Ollama (for local AI)

### Setup

```bash
# Clone the repository
git clone https://github.com/crazy-dev/crazy-dev-zsh.git
cd crazy-dev-zsh

# Install dependencies
go mod download

# Run tests
go test ./...

# Build the project
go build -o crazy ./src/cmd/main.go
```

## 🎯 Key Features

### 🤖 AI-Powered Intelligence
- **Context Analysis**: Understands your project structure and tech stack
- **Predictive Suggestions**: Anticipates your next command
- **Error Prevention**: Catches issues before they happen
- **Natural Language**: Ask questions in plain English

### 🔧 Tech Stack Support
- **iOS/Swift**: Xcode optimization, SwiftLint integration
- **Flutter**: Device management, hot reload
- **Go**: Air integration, API generation
- **JavaScript/TypeScript**: React/Vue/Next.js setup, bundle analysis
- **React Native/Expo**: Device management, hot reload
- **Android/Kotlin**: Device management, hot reload
- **Python/AI**: Jupyter integration, ML model optimization
- **Docker/K8s**: Container visualization, auto-scaling
- **Cloud**: Multi-provider support, cost optimization


### 🎨 Rich Terminal Experience
- **Dynamic Themes**: Adapts to your project type
- **Visual Workflows**: Terminal-based GUI for complex operations
- **Voice Commands**: Hands-free operation
- **Cross-Platform Sync**: Consistent experience across devices

## 📚 Documentation

- **[Architecture](docs/architecture.mermaid)**: System design and component relationships
- **[Technical Specs](docs/technical.md)**: Implementation details and guidelines
- **[Project Status](docs/status.md)**: Current progress and milestones
- **[Task Management](tasks/tasks.md)**: Detailed task definitions and sprint planning

## 🔄 Development Workflow

This project uses a structured development approach:

1. **Architecture-First**: All features are designed with the overall architecture in mind
2. **Task-Driven**: Development follows structured tasks with clear acceptance criteria
3. **Test-Driven**: Tests are written before implementation
4. **AI-Assisted**: Uses Cursor with custom rules for consistent code generation
5. **Documentation-Focused**: All changes are documented and reviewed

### Working with Tasks

Tasks are managed in `tasks/tasks.md` with detailed specifications:

```bash
# View current tasks
cat tasks/tasks.md

# Start working on a task
git checkout -b feature/CORE-001-cli-framework

# Follow the acceptance criteria and technical notes
# Write tests first, then implement
# Update documentation as needed
```

### AI Development Guidelines

This project uses `.cursorrules` to ensure consistent AI-generated code:

- Follows established architecture patterns
- Maintains code quality standards
- Includes comprehensive error handling
- Generates appropriate tests
- Updates documentation automatically

## 🧪 Testing

```bash
# Run all tests
go test ./...

# Run tests with coverage
go test -cover ./...

# Run specific test
go test ./src/core/context/

# Run benchmarks
go test -bench=. ./...
```

## 🚀 Building and Deployment

```bash
# Build for current platform
go build -o crazy ./src/cmd/main.go

# Build for multiple platforms
GOOS=linux GOARCH=amd64 go build -o crazy-linux ./src/cmd/main.go
GOOS=darwin GOARCH=amd64 go build -o crazy-darwin ./src/cmd/main.go
GOOS=windows GOARCH=amd64 go build -o crazy-windows.exe ./src/cmd/main.go

# Install locally
go install ./src/cmd/main.go
```

## 🤝 Contributing

1. **Read the Documentation**: Familiarize yourself with the architecture and guidelines
2. **Check Tasks**: Look at `tasks/tasks.md` for available work
3. **Follow Standards**: Use the `.cursorrules` for consistent development
4. **Write Tests**: Maintain >80% test coverage
5. **Update Docs**: Keep documentation current with changes

### Pull Request Process

1. Create a feature branch: `feature/TASK-ID-description`
2. Follow TDD: Write tests first
3. Implement following `.cursorrules` guidelines
4. Update relevant documentation
5. Ensure all tests pass
6. Submit PR with clear description

## 📄 License

MIT License - see LICENSE file for details

## 🌟 Why Crazy Dev?

- **10x Productivity**: Automate 90% of repetitive tasks
- **Zero Configuration**: Works out of the box with intelligent defaults
- **Future-Proof**: Extensible plugin system grows with your needs
- **Privacy-First**: Local AI processing with optional cloud features
- **Developer-Centric**: Built by developers, for developers

---

**Ready to revolutionize your development workflow?** Get started with Crazy Dev today! 