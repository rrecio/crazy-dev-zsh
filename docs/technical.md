# Crazy Dev Technical Documentation

## Technology Stack

### Core Framework
- **Language**: Go (primary), TypeScript (plugins), Shell scripting
- **CLI Framework**: Cobra CLI for command structure
- **Configuration**: Viper for configuration management
- **Database**: SQLite (local), PostgreSQL (cloud sync)
- **Caching**: Redis for performance optimization

### AI & Machine Learning
- **Local AI**: Ollama integration for offline AI capabilities
- **Cloud AI**: OpenAI API, Anthropic Claude API
- **Speech Recognition**: Whisper (local) for voice commands
- **Context Processing**: Vector embeddings with ChromaDB

### User Interface
- **Terminal UI**: Bubble Tea framework for rich terminal interfaces
- **Themes**: HSL++ color engine with 100+ accessible colors
- **Graphics**: Terminal graphics using ANSI escape sequences
- **Voice**: Local speech-to-text with WebRTC

### Plugin System
- **Architecture**: Plugin-based architecture with hot-reloading
- **Language Support**: Go plugins, WASM modules for cross-language support
- **Registry**: Centralized plugin registry with version management
- **Security**: Plugin sandboxing and permission system

### Cloud & Sync
- **Sync Backend**: gRPC-based service for configuration sync
- **Authentication**: JWT tokens with refresh mechanism
- **Storage**: Encrypted cloud storage for user configurations
- **CDN**: Global CDN for plugin distribution

## Design Decisions

### 1. Go as Primary Language
- **Rationale**: Performance, single binary distribution, excellent CLI tooling
- **Trade-offs**: Steeper learning curve for contributors vs. performance benefits

### 2. Plugin Architecture
- **Rationale**: Extensibility without bloating core, community contributions
- **Implementation**: Interface-based plugins with dependency injection

### 3. Local-First AI
- **Rationale**: Privacy, offline capability, reduced latency
- **Fallback**: Cloud AI for complex tasks requiring larger models

### 4. Terminal-Centric UI
- **Rationale**: Developer familiarity, keyboard-driven workflow
- **Enhancement**: Rich graphics while maintaining terminal efficiency

## Implementation Guidelines

### Code Organization
```
src/
├── cmd/           # CLI commands
├── core/          # Core functionality
├── ai/            # AI engine components
├── plugins/       # Plugin system
├── ui/            # Terminal UI components
├── sync/          # Cloud sync functionality
├── stacks/        # Tech stack modules
└── utils/         # Utility functions
```

### Naming Conventions
- **Files**: snake_case for Go files, kebab-case for configs
- **Functions**: camelCase for public, camelCase for private
- **Constants**: UPPER_SNAKE_CASE
- **Interfaces**: Suffix with 'er' (e.g., `ContextAnalyzer`)

### Error Handling
- Use Go's idiomatic error handling with wrapped errors
- Implement structured logging with levels
- Graceful degradation for AI failures

### Testing Strategy
- Unit tests for all core functionality (>80% coverage)
- Integration tests for plugin system
- End-to-end tests for critical workflows
- Performance benchmarks for AI operations

### Security Considerations
- Plugin sandboxing with restricted file system access
- Encrypted storage for sensitive configurations
- Rate limiting for AI API calls
- Input validation for all user commands

## Performance Requirements
- **Startup Time**: < 100ms for basic commands
- **AI Response**: < 2s for local AI, < 5s for cloud AI
- **Memory Usage**: < 50MB baseline, < 200MB with active AI
- **Plugin Loading**: < 500ms for plugin activation

## Development Workflow
1. Feature branches from `main`
2. TDD approach with tests written first
3. Code review required for all changes
4. Automated CI/CD with GitHub Actions
5. Semantic versioning for releases

## Dependencies
- Go 1.21+
- Redis (optional, for caching)
- SQLite (embedded)
- Ollama (optional, for local AI)
- Git (required for project analysis)

## Platform Support
- **Primary**: macOS (Apple Silicon + Intel)
- **Secondary**: Linux (Ubuntu, Arch, Fedora)
- **Tertiary**: Windows (WSL2)

## Configuration Management
- YAML-based configuration files
- Environment variable overrides
- User-specific and project-specific configs
- Hot-reloading of configuration changes 