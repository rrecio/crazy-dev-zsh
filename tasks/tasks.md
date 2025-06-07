# Crazy Dev Task Management

## Active Tasks

| **Task ID** | **Description** | **Status** | **Priority** | **Dependencies** | **Requirements** | **Acceptance Criteria** | **Technical Notes** |
|-------------|-----------------|------------|--------------|------------------|------------------|-------------------------|---------------------|
| CORE-001 | Implement CLI Framework Foundation | In Progress | High | None | - Cobra CLI integration<br>- Viper configuration management<br>- Basic command structure<br>- Help system | - `crazy --help` shows all commands<br>- Configuration loads from YAML<br>- Commands execute without errors<br>- Version command works | 8 points | - Use `github.com/spf13/cobra`<br>- Use `github.com/spf13/viper`<br>- Follow patterns from `technical.md`<br>- Implement in `src/cmd/` |
| CORE-002 | Context Analysis Engine | Planned | High | CORE-001 | - Git repository analysis<br>- File type detection<br>- Tech stack identification<br>- Project structure mapping | - Detects Go/JS/Python projects correctly<br>- Identifies framework (React, NestJS, etc.)<br>- Maps project dependencies<br>- Caches analysis results | 13 points | - Use `go-git` for Git analysis<br>- Implement in `src/core/context/`<br>- Store results in SQLite<br>- Support incremental updates |
| AI-001 | Ollama Integration | Planned | High | CORE-002 | - Local AI model management<br>- Prompt engineering system<br>- Context-aware suggestions<br>- Fallback to cloud AI | - Ollama models install automatically<br>- AI responds to context queries<br>- Suggestions are relevant to project<br>- Graceful fallback on errors | 21 points | - Use Ollama REST API<br>- Implement in `src/ai/`<br>- Support llama3.2, codellama<br>- Rate limiting and caching |
| PLUGIN-001 | Plugin System Architecture | Planned | Medium | CORE-001 | - Plugin interface definition<br>- Hot-reloading capability<br>- Security sandboxing<br>- Plugin discovery | - Plugins load dynamically<br>- Interface is well-documented<br>- Sandboxing prevents file access<br>- Plugin registry works | 13 points | - Use Go plugin system initially<br>- Research WASM for security<br>- Implement in `src/plugins/`<br>- Version compatibility checks |
| STACK-001 | Go Tech Stack Module | Planned | Medium | CORE-002, PLUGIN-001 | - Go project detection<br>- Module management<br>- Build optimization<br>- Testing integration | - Detects Go modules correctly<br>- Suggests go mod commands<br>- Optimizes build flags<br>- Runs tests intelligently | 8 points | - Implement in `src/stacks/golang/`<br>- Use `go list` for analysis<br>- Support Air for hot reload<br>- Integration with `go test` |
| UI-001 | Terminal UI Foundation | Planned | Medium | CORE-001 | - Bubble Tea integration<br>- Theme system<br>- Interactive components<br>- Responsive layout | - Rich terminal interface works<br>- Themes switch dynamically<br>- Components are interactive<br>- Responsive to terminal size | 13 points | - Use `github.com/charmbracelet/bubbletea`<br>- Implement in `src/ui/`<br>- HSL++ color system<br>- Support 256-color terminals |

## Backlog Tasks

| **Task ID** | **Description** | **Priority** | **Estimated Points** | **Notes** |
|-------------|-----------------|--------------|---------------------|-----------|
| VOICE-001 | Voice Command Integration | Low | 21 | Whisper integration for speech-to-text |
| SYNC-001 | Cloud Configuration Sync | Low | 13 | gRPC service for cross-platform sync |
| STACK-002 | JavaScript/TypeScript Module | Medium | 8 | React, Vue, Next.js, Node.js detection |
| STACK-003 | Python/AI Module | Medium | 8 | Django, Flask, ML framework detection |
| STACK-004 | Flutter Module | Medium | 5 | Flutter project management |
| STACK-005 | Docker/K8s Module | Medium | 13 | Container and orchestration tools |
| VISUAL-001 | Visual Workflow Canvas | Low | 21 | Terminal-based GUI for pipelines |
| SECURITY-001 | Plugin Security Audit | High | 8 | Security review of plugin system |
| PERF-001 | Performance Optimization | Medium | 13 | Startup time and memory optimization |
| INSTALL-001 | Installation System | Medium | 8 | Cross-platform installer script |

## Completed Tasks

| **Task ID** | **Description** | **Completed Date** | **Points** | **Notes** |
|-------------|-----------------|-------------------|------------|-----------|
| SETUP-001 | Project Structure Setup | 2025-01-XX | 3 | Initial directories and documentation |
| ARCH-001 | Architecture Documentation | 2025-01-XX | 5 | Mermaid diagrams and technical docs |

## Sprint Planning

### Current Sprint (Sprint 1)
**Duration**: 2 weeks  
**Start Date**: TBD  
**End Date**: TBD  
**Capacity**: 40 points  

**Sprint Goal**: Establish core CLI framework and basic project analysis

**Selected Tasks**:
- CORE-001: CLI Framework Foundation (8 points)
- CORE-002: Context Analysis Engine (13 points)
- UI-001: Terminal UI Foundation (13 points)
- **Total**: 34 points

### Next Sprint (Sprint 2)
**Planned Tasks**:
- AI-001: Ollama Integration (21 points)
- PLUGIN-001: Plugin System Architecture (13 points)
- STACK-001: Go Tech Stack Module (8 points)

## Task Status Definitions

- **Planned**: Task is defined but not started
- **In Progress**: Task is actively being worked on
- **Review**: Task is complete and under review
- **Testing**: Task is in testing phase
- **Done**: Task is completed and verified
- **Blocked**: Task cannot proceed due to dependencies

## Story Point Scale

- **1-2 points**: Simple tasks (< 4 hours)
- **3-5 points**: Small features (< 1 day)
- **8 points**: Medium features (1-2 days)
- **13 points**: Large features (3-5 days)
- **21 points**: Complex features (1-2 weeks)
- **34+ points**: Epic (needs breakdown)

## Definition of Done

For a task to be considered "Done", it must meet:

1. **Functionality**: All acceptance criteria are met
2. **Code Quality**: Code follows project standards and passes linting
3. **Testing**: Unit tests written and passing (>80% coverage)
4. **Documentation**: Code is documented, README updated if needed
5. **Review**: Code has been reviewed by at least one other developer
6. **Integration**: Changes integrate cleanly with main branch

## Notes

- Tasks are estimated using Fibonacci sequence for story points
- Dependencies must be completed before dependent tasks can start
- High priority tasks should be completed first within each sprint
- Technical notes provide implementation guidance for developers
- Acceptance criteria define the specific requirements for completion 