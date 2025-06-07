# Crazy Dev Makefile
# Common development tasks for the Crazy Dev project

.PHONY: help build test clean install dev lint fmt deps docs

# Default target
help: ## Show this help message
	@echo "Crazy Dev Development Commands:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

# Build targets
build: ## Build the crazy binary
	@echo "Building Crazy Dev..."
	@mkdir -p bin
	@go build -ldflags="-s -w" -o bin/crazy ./src/main.go
	@echo "✅ Build complete: bin/crazy"

build-all: ## Build for all platforms
	@echo "Building for all platforms..."
	@mkdir -p bin
	@GOOS=darwin GOARCH=amd64 go build -ldflags="-s -w" -o bin/crazy-darwin-amd64 ./src/main.go
	@GOOS=darwin GOARCH=arm64 go build -ldflags="-s -w" -o bin/crazy-darwin-arm64 ./src/main.go
	@GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -o bin/crazy-linux-amd64 ./src/main.go
	@GOOS=linux GOARCH=arm64 go build -ldflags="-s -w" -o bin/crazy-linux-arm64 ./src/main.go
	@GOOS=windows GOARCH=amd64 go build -ldflags="-s -w" -o bin/crazy-windows-amd64.exe ./src/main.go
	@echo "✅ Multi-platform build complete"

# Testing targets
test: ## Run all tests
	@echo "Running tests..."
	@go test -v ./...

test-coverage: ## Run tests with coverage report
	@echo "Running tests with coverage..."
	@go test -v -coverprofile=coverage.out ./...
	@go tool cover -html=coverage.out -o coverage.html
	@echo "✅ Coverage report generated: coverage.html"

# Code quality targets
lint: ## Run linter
	@echo "Running linter..."
	@golangci-lint run ./...

fmt: ## Format code
	@echo "Formatting code..."
	@go fmt ./...

# Dependency management
deps: ## Download dependencies
	@echo "Downloading dependencies..."
	@go mod download
	@go mod tidy

# Cleanup targets
clean: ## Clean build artifacts
	@echo "Cleaning build artifacts..."
	@rm -rf bin/
	@rm -f coverage.out coverage.html
	@echo "✅ Clean complete"

# Development setup
setup: ## Setup development environment
	@echo "Setting up development environment..."
	@go install github.com/air-verse/air@latest
	@go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
	@mkdir -p bin logs data
	@echo "✅ Development environment setup complete" 