# LearningGo - Technical Specification

## Overview

LearningGo is a comprehensive Go learning environment designed to provide all necessary tooling for learning and developing in Go, without requiring manual setup.

## Project Goals

1. **Zero-friction setup** - Developers should be able to start coding in Go immediately
2. **Best practices by default** - Linting, formatting, and testing are pre-configured
3. **IDE integration** - Full Neovim support with LSP and project menu
4. **Cross-platform** - Works on Linux, macOS, and Windows
5. **EU compliance** - REUSE license compliance from day one

---

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        Development Environment                   │
├─────────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────────┐  │
│  │   Nix       │  │   Make      │  │   Pre-commit Hooks      │  │
│  │   Flake     │  │   Targets   │  │   (Quality Gates)       │  │
│  └──────┬──────┘  └──────┬──────┘  └────────────┬────────────┘  │
│         │                │                      │                │
│         └────────────────┼──────────────────────┘                │
│                          │                                       │
│         ┌────────────────▼────────────────┐                      │
│         │        Go Toolchain             │                      │
│         │  (go, gopls, golangci-lint,     │                      │
│         │   delve, goimports, etc.)       │                      │
│         └────────────────┬────────────────┘                      │
│                          │                                       │
│         ┌────────────────▼────────────────┐                      │
│         │         Source Code             │                      │
│         │    (main.go, *_test.go)         │                      │
│         └─────────────────────────────────┘                      │
└─────────────────────────────────────────────────────────────────┘
```

---

## User Stories

### US-001: First-time Setup

**As a** new Go developer
**I want** to have a working development environment immediately
**So that** I can focus on learning Go instead of configuring tools

**Acceptance Criteria:**
- Running `nix develop` provides all necessary tools
- `make help` displays all available commands
- Neovim opens with full Go support

### US-002: Build and Run

**As a** developer
**I want** to build and run my Go code with simple commands
**So that** I can quickly iterate on my learning

**Acceptance Criteria:**
- `make build` compiles the project
- `make run` executes the program
- Build errors are clearly displayed

### US-003: Testing

**As a** developer
**I want** to run tests easily
**So that** I can verify my code works correctly

**Acceptance Criteria:**
- `make test` runs all tests
- `make coverage` generates a coverage report
- `make bench` runs benchmarks

### US-004: Code Quality

**As a** developer
**I want** automated code quality checks
**So that** I learn best practices as I code

**Acceptance Criteria:**
- `make lint` runs comprehensive linting
- `make format` auto-formats code
- Pre-commit hooks prevent bad code from being committed

### US-005: Neovim Integration

**As a** developer using Neovim
**I want** project-specific keybindings
**So that** I can efficiently work on Go code

**Acceptance Criteria:**
- `<leader>p` opens the project menu
- All build/test/lint commands are accessible via keyboard
- LSP integration provides code intelligence

### US-006: Cross-platform Release

**As a** developer
**I want** to build binaries for multiple platforms
**So that** I can distribute my learning projects

**Acceptance Criteria:**
- `make release` builds for Linux, macOS, and Windows
- Binaries are placed in `dist/` directory
- Version information is embedded in binaries

### US-007: New File Creation

**As a** developer
**I want** to create new Go files from templates
**So that** I start with proper structure and boilerplate

**Acceptance Criteria:**
- `nix run .#new` prompts for file type
- Templates include SPDX headers
- Generated files follow Go conventions

---

## Functional Requirements

### FR-001: Development Environment

| ID | Requirement |
|----|-------------|
| FR-001.1 | Nix flake provides reproducible environment |
| FR-001.2 | Go 1.22+ is available |
| FR-001.3 | gopls is available for LSP |
| FR-001.4 | delve is available for debugging |
| FR-001.5 | golangci-lint is available for linting |

### FR-002: Build System

| ID | Requirement |
|----|-------------|
| FR-002.1 | `make build` compiles to `./bin/` |
| FR-002.2 | `make run` executes main.go |
| FR-002.3 | `make clean` removes build artifacts |
| FR-002.4 | `make release` creates cross-platform binaries |

### FR-003: Testing

| ID | Requirement |
|----|-------------|
| FR-003.1 | `make test` runs all tests with race detector |
| FR-003.2 | `make coverage` generates HTML coverage report |
| FR-003.3 | `make bench` runs benchmarks with memory stats |

### FR-004: Code Quality

| ID | Requirement |
|----|-------------|
| FR-004.1 | `make lint` runs golangci-lint |
| FR-004.2 | `make format` runs gofmt and goimports |
| FR-004.3 | `make vet` runs go vet |
| FR-004.4 | Pre-commit hooks enforce quality on commit |

### FR-005: Editor Integration

| ID | Requirement |
|----|-------------|
| FR-005.1 | .exrc loads project configuration |
| FR-005.2 | .nvim.lua provides which-key mappings |
| FR-005.3 | All commands accessible via `<leader>p` |
| FR-005.4 | LSP integration for code intelligence |

### FR-006: License Compliance

| ID | Requirement |
|----|-------------|
| FR-006.1 | REUSE compliance via .reuse/dep5 |
| FR-006.2 | MIT license in LICENSES/ directory |
| FR-006.3 | SPDX headers in all source files |
| FR-006.4 | Pre-commit hook verifies compliance |

---

## Non-Functional Requirements

### NFR-001: Performance

- Build time should be under 5 seconds for small projects
- Tests should complete in under 10 seconds

### NFR-002: Usability

- All commands should be documented via `make help`
- Error messages should be clear and actionable
- Neovim menu should be discoverable

### NFR-003: Portability

- Works on NixOS, macOS with Nix, and Linux with Nix
- Non-Nix users can use Makefile with manual tool installation

### NFR-004: Maintainability

- All dependencies are version-pinned in flake.lock
- Pre-commit hook versions are specified

---

## Testing Requirements

### Unit Tests

- All exported functions should have tests
- Tests should use table-driven test pattern
- Tests should achieve >80% coverage

### Integration Tests

- Build process should be testable
- Cross-platform builds should be verifiable

---

## Documentation Requirements

### Code Documentation

- All exported functions have godoc comments
- Package-level documentation explains purpose
- Examples provided for complex APIs

### User Documentation

- README covers setup for Nix and non-Nix users
- All commands documented in README
- Neovim keybindings documented

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 0.1.0 | 2024-01-01 | Initial release |

---

Made with 💗 by [Kartoza](https://kartoza.com) | [Donate!](https://github.com/sponsors/kartoza) | [GitHub](https://github.com/kartoza/LearningGo)
