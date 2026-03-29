# LearningGo Makefile
# All targets mirror the nix run commands for non-Nix users

.PHONY: all build run test coverage lint format clean doc tidy vet release new debug debug-setup bench generate help precommit-install precommit reuse

PROJECT_NAME := LearningGo
VERSION := $(shell git describe --tags --always 2>/dev/null || echo "dev")

# Default target
all: help

## Build & Run
build: ## Build the project
	@echo "🔨 Building $(PROJECT_NAME)..."
	@mkdir -p ./bin
	@go build -v -o ./bin/$(PROJECT_NAME) ./...
	@echo "✅ Build complete: ./bin/$(PROJECT_NAME)"

run: ## Run the project
	@echo "🚀 Running $(PROJECT_NAME)..."
	@go run ./main.go

## Testing
test: ## Run all tests
	@echo "🧪 Running tests..."
	@go test -v -race -coverprofile=coverage.out ./...
	@echo "✅ Tests complete!"

coverage: ## Generate coverage report
	@echo "📊 Generating coverage report..."
	@go test -v -race -coverprofile=coverage.out ./...
	@go tool cover -html=coverage.out -o coverage.html
	@echo "✅ Coverage report: coverage.html"
	@xdg-open coverage.html 2>/dev/null || open coverage.html 2>/dev/null || true

bench: ## Run benchmarks
	@echo "⚡ Running benchmarks..."
	@go test -bench=. -benchmem ./...
	@echo "✅ Benchmarks complete!"

## Code Quality
lint: ## Run linter
	@echo "🔍 Linting code..."
	@golangci-lint run ./...
	@echo "✅ Lint complete!"

format: ## Format code
	@echo "✨ Formatting code..."
	@gofmt -w -s .
	@goimports -w .
	@echo "✅ Format complete!"

vet: ## Run go vet
	@echo "🔬 Running go vet..."
	@go vet ./...
	@echo "✅ Vet complete!"

## Modules & Dependencies
tidy: ## Tidy go modules
	@echo "📦 Tidying go modules..."
	@go mod tidy
	@echo "✅ Modules tidied!"

generate: ## Run go generate
	@echo "⚙️ Running go generate..."
	@go generate ./...
	@echo "✅ Generation complete!"

## Debugging
debug: ## Start debugger (dlv)
	@echo "🐛 Starting debugger..."
	@dlv debug ./main.go

debug-setup: ## Build debug binary
	@echo "🐛 Building debug binary..."
	@mkdir -p ./bin
	@go build -gcflags="all=-N -l" -o ./bin/$(PROJECT_NAME)-debug ./main.go
	@echo "✅ Debug binary: ./bin/$(PROJECT_NAME)-debug"
	@echo ""
	@echo "To start debugging:"
	@echo "  dlv exec ./bin/$(PROJECT_NAME)-debug"

## Documentation
doc: ## Start godoc server
	@echo "📚 Starting documentation server on http://localhost:6060..."
	@echo "Press Ctrl+C to stop"
	@godoc -http=:6060

## Cleanup
clean: ## Clean build artifacts
	@echo "🧹 Cleaning build artifacts..."
	@rm -rf ./bin ./dist ./coverage.out ./coverage.html
	@go clean -cache -testcache
	@echo "✅ Clean complete!"

## Release
release: ## Build for all platforms
	@echo "📦 Building release $(VERSION) for all platforms..."
	@mkdir -p dist
	@echo "  🐧 Building for Linux amd64..."
	@GOOS=linux GOARCH=amd64 go build -ldflags="-s -w -X main.Version=$(VERSION)" -o dist/$(PROJECT_NAME)-linux-amd64 ./main.go
	@echo "  🐧 Building for Linux arm64..."
	@GOOS=linux GOARCH=arm64 go build -ldflags="-s -w -X main.Version=$(VERSION)" -o dist/$(PROJECT_NAME)-linux-arm64 ./main.go
	@echo "  🍎 Building for macOS amd64..."
	@GOOS=darwin GOARCH=amd64 go build -ldflags="-s -w -X main.Version=$(VERSION)" -o dist/$(PROJECT_NAME)-darwin-amd64 ./main.go
	@echo "  🍎 Building for macOS arm64..."
	@GOOS=darwin GOARCH=arm64 go build -ldflags="-s -w -X main.Version=$(VERSION)" -o dist/$(PROJECT_NAME)-darwin-arm64 ./main.go
	@echo "  🪟 Building for Windows amd64..."
	@GOOS=windows GOARCH=amd64 go build -ldflags="-s -w -X main.Version=$(VERSION)" -o dist/$(PROJECT_NAME)-windows-amd64.exe ./main.go
	@echo "✅ Release builds complete in ./dist/"
	@ls -la dist/

## Pre-commit
precommit-install: ## Install pre-commit hooks
	@echo "🔧 Installing pre-commit hooks..."
	@pre-commit install
	@pre-commit install --hook-type commit-msg
	@echo "✅ Pre-commit hooks installed!"

precommit: ## Run all pre-commit checks
	@echo "🔍 Running pre-commit checks..."
	@pre-commit run --all-files
	@echo "✅ Pre-commit checks complete!"

reuse: ## Check REUSE license compliance
	@echo "📜 Checking REUSE license compliance..."
	@reuse lint
	@echo "✅ REUSE check complete!"

## Help
help: ## Show this help
	@echo ""
	@echo "╔══════════════════════════════════════════════════════════════════╗"
	@echo "║           🐹 LearningGo Makefile Commands                        ║"
	@echo "╚══════════════════════════════════════════════════════════════════╝"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@echo "Made with 💗 by Kartoza | https://kartoza.com"
	@echo ""
