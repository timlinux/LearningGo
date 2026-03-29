# 🐹 LearningGo

A comprehensive Go learning environment with all the tooling pre-configured so you can focus on learning Go, not wrestling with setup.

[![REUSE compliant](https://reuse.software/badge/reuse-compliant.svg)](https://reuse.software/)
[![Go Version](https://img.shields.io/badge/Go-1.22-00ADD8?logo=go)](https://go.dev/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

---

## Features

- **Zero-config development environment** - Just `nix develop` and you're ready
- **Neovim integration** - Full IDE experience with `<leader>p` project menu
- **Pre-commit hooks** - Automated linting, formatting, and quality checks
- **EU REUSE compliance** - Proper license management from day one
- **Cross-platform builds** - Build for Linux, macOS, and Windows
- **Templates** - Quick-start templates for common Go patterns

---

## Quick Start

### For Nix Users (Recommended)

```bash
# Enter the development environment
nix develop

# See all available commands
go-help

# Run your code
make run

# Open Neovim with full Go support
nvim main.go
# Press <leader>p for the project menu
```

### For Non-Nix Users

You'll need to install the following manually:

#### Prerequisites

| Tool | Installation |
|------|--------------|
| **Go 1.22+** | [Download](https://go.dev/dl/) |
| **golangci-lint** | `go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest` |
| **delve** | `go install github.com/go-delve/delve/cmd/dlv@latest` |
| **goimports** | `go install golang.org/x/tools/cmd/goimports@latest` |
| **godoc** | `go install golang.org/x/tools/cmd/godoc@latest` |
| **gomodifytags** | `go install github.com/fatih/gomodifytags@latest` |
| **gotests** | `go install github.com/cweill/gotests/gotests@latest` |
| **impl** | `go install github.com/josharian/impl@latest` |
| **pre-commit** | `pip install pre-commit` |
| **reuse** | `pip install reuse` |

#### Setup

```bash
# Clone the repository
git clone https://github.com/timlinux/LearningGo.git
cd LearningGo

# Install pre-commit hooks
pre-commit install
pre-commit install --hook-type commit-msg

# Verify Go setup
go version

# Run your first build
make build

# Run the program
make run
```

---

## Commands Reference

All commands are available as both `make` targets and `nix run` apps:

### Build & Run

| Make | Nix | Description |
|------|-----|-------------|
| `make build` | `nix run .#build` | Build the project |
| `make run` | `nix run .#run` | Run the project |
| `make clean` | `nix run .#clean` | Clean build artifacts |
| `make release` | `nix run .#release` | Build for all platforms |

### Testing

| Make | Nix | Description |
|------|-----|-------------|
| `make test` | `nix run .#test` | Run all tests |
| `make coverage` | `nix run .#coverage` | Generate coverage report |
| `make bench` | `nix run .#bench` | Run benchmarks |

### Code Quality

| Make | Nix | Description |
|------|-----|-------------|
| `make lint` | `nix run .#lint` | Run linter |
| `make format` | `nix run .#format` | Format code |
| `make vet` | `nix run .#vet` | Run go vet |

### Modules & Dependencies

| Make | Nix | Description |
|------|-----|-------------|
| `make tidy` | `nix run .#tidy` | Tidy go modules |
| `make generate` | `nix run .#generate` | Run go generate |

### Debugging

| Make | Nix | Description |
|------|-----|-------------|
| `make debug` | `nix run .#debug` | Start debugger (dlv) |
| `make debug-setup` | `nix run .#debug-setup` | Build debug binary |

### Documentation

| Make | Nix | Description |
|------|-----|-------------|
| `make doc` | `nix run .#doc` | Start godoc server |

### Templates

| Nix | Description |
|-----|-------------|
| `nix run .#new` | Create new Go file from template |

---

## Neovim Integration

The project includes a comprehensive Neovim setup. All commands are accessible via `<leader>p`:

### Project Menu (`<leader>p`)

| Key | Action |
|-----|--------|
| `<leader>pb` | Build project |
| `<leader>pr` | Run project |
| `<leader>pR` | Release (all platforms) |
| `<leader>pc` | Clean artifacts |
| `<leader>pt` | Run tests |
| `<leader>pT` | Test under cursor |
| `<leader>pC` | Coverage report |
| `<leader>pB` | Run benchmarks |
| `<leader>pl` | Lint code |
| `<leader>pf` | Format code |
| `<leader>pv` | Go vet |
| `<leader>pm` | Tidy modules |
| `<leader>pd` | Debug (dlv) |
| `<leader>pn` | New file from template |
| `<leader>pa` | Code actions |
| `<leader>pi` | Go to implementation |
| `<leader>ph` | Show help |
| `<leader>p?` | Show full menu |

### Requirements for Neovim

- [which-key.nvim](https://github.com/folke/which-key.nvim) - For the project menu
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - For gopls integration
- Add to your init.lua: `vim.o.exrc = true`

---

## Project Structure

```
LearningGo/
├── main.go              # Your main application entry point
├── main_test.go         # Example tests
├── go.mod               # Go module definition
├── flake.nix            # Nix development environment
├── Makefile             # Make targets (mirrors nix commands)
├── .exrc                # Neovim project settings
├── .nvim.lua            # Neovim Lua configuration
├── .pre-commit-config.yaml  # Pre-commit hooks
├── .golangci.yml        # Linter configuration
├── templates/           # Go file templates
│   ├── main.go.tmpl
│   ├── pkg.go.tmpl
│   ├── test.go.tmpl
│   ├── bench.go.tmpl
│   ├── handler.go.tmpl
│   ├── model.go.tmpl
│   └── interface.go.tmpl
├── LICENSES/            # REUSE license files
│   └── MIT.txt
├── .reuse/              # REUSE configuration
│   └── dep5
├── SPECIFICATION.md     # Technical specification
├── PACKAGES.md          # Package documentation
└── README.md            # This file
```

---

## Learning Resources

Here are some excellent resources for learning Go:

- [A Tour of Go](https://go.dev/tour/) - Interactive introduction
- [Go by Example](https://gobyexample.com/) - Annotated example programs
- [Effective Go](https://go.dev/doc/effective_go) - Best practices
- [Go Documentation](https://go.dev/doc/) - Official docs
- [Go Playground](https://go.dev/play/) - Online Go editor

---

## Pre-commit Hooks

This project uses pre-commit hooks to ensure code quality:

- **Go formatting** - `gofmt`, `goimports`
- **Go linting** - `golangci-lint` with comprehensive rules
- **Go static analysis** - `go vet`
- **EU REUSE compliance** - License checking
- **Spell checking** - `codespell`
- **Markdown linting** - `markdownlint`
- **YAML linting** - `yamllint`
- **Shell script linting** - `shellcheck`
- **Secret detection** - `detect-secrets`
- **Commit message format** - Conventional commits

### Installing Hooks

```bash
# With Nix
nix develop
pre-commit install
pre-commit install --hook-type commit-msg

# Without Nix
pip install pre-commit
pre-commit install
pre-commit install --hook-type commit-msg
```

---

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run `make lint` and `make test`
5. Commit with conventional commit messages
6. Open a pull request

---

## License

This project is licensed under the MIT License - see [LICENSES/MIT.txt](LICENSES/MIT.txt) for details.

This project is [REUSE](https://reuse.software/) compliant.

---

## Support

- [GitHub Issues](https://github.com/timlinux/LearningGo/issues) - Report bugs or request features
- [GitHub Sponsors](https://github.com/sponsors/kartoza) - Support development

---

Made with 💗 by [Kartoza](https://kartoza.com) | [Donate!](https://github.com/sponsors/kartoza) | [GitHub](https://github.com/timlinux/LearningGo)
