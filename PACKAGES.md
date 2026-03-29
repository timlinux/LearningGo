# LearningGo - Package Documentation

## Overview

This document describes the package architecture for LearningGo. As this is a learning project, packages will be added as you explore different Go concepts.

---

## Current Packages

### `main` (root package)

**Location:** `/`
**Purpose:** Application entry point and learning sandbox

**Files:**
- `main.go` - Entry point with example functions
- `main_test.go` - Example tests demonstrating table-driven testing

**Key Functions:**
- `main()` - Application entry point
- `sayHello(name string) string` - Returns a greeting
- `sum(numbers []int) int` - Calculates sum of integers

---

## Suggested Package Structure for Learning

As you learn Go, consider organizing your code into these packages:

### `pkg/` - Reusable Library Code

```
pkg/
├── strings/      # String manipulation utilities
├── math/         # Mathematical operations
├── collections/  # Data structures (stack, queue, etc.)
└── http/         # HTTP utilities
```

### `internal/` - Internal Implementation

```
internal/
├── config/       # Configuration handling
└── utils/        # Internal utilities
```

### `cmd/` - Multiple Entry Points

```
cmd/
├── myapp/        # Main application
└── mycli/        # CLI tool
```

---

## Package Design Guidelines

### 1. Package Naming

- Use short, lowercase names
- Avoid underscores and camelCase
- Name should describe what the package does

```go
// Good
package http
package json
package user

// Bad
package httpHandlers
package json_parser
package UserManagement
```

### 2. Package Documentation

Every package should have a doc comment:

```go
// Package user provides functionality for managing users
// including creation, authentication, and authorization.
package user
```

### 3. Exported vs Unexported

- Exported names start with uppercase: `func PublicFunc()`
- Unexported names start with lowercase: `func privateFunc()`
- Only export what's necessary

### 4. Interface Design

- Keep interfaces small (1-3 methods)
- Define interfaces where they're used, not where they're implemented

```go
// Good - small, focused interface
type Reader interface {
    Read(p []byte) (n int, err error)
}

// Bad - too many methods
type DoEverything interface {
    Read() error
    Write() error
    Delete() error
    Update() error
    // ... many more
}
```

---

## Dependencies

### Standard Library Packages Used

| Package | Purpose |
|---------|---------|
| `fmt` | Formatted I/O |
| `testing` | Unit testing |
| `context` | Request contexts |
| `time` | Time operations |
| `encoding/json` | JSON encoding/decoding |
| `net/http` | HTTP client/server |

### External Dependencies

Currently, this project uses only the standard library. As you learn, you might add:

| Package | Purpose | Install |
|---------|---------|---------|
| `github.com/stretchr/testify` | Testing assertions | `go get github.com/stretchr/testify` |
| `github.com/spf13/cobra` | CLI framework | `go get github.com/spf13/cobra` |
| `github.com/gorilla/mux` | HTTP router | `go get github.com/gorilla/mux` |

---

## Adding New Packages

### 1. Create the Package

```bash
mkdir -p pkg/mypackage
```

### 2. Add Package File

Use the template: `nix run .#new` and select "pkg"

### 3. Add Tests

Use the template: `nix run .#new` and select "test"

### 4. Update This Document

Add your new package to the documentation above.

---

## Package Dependency Graph

```
main
└── (no dependencies yet - add as you learn!)
```

As you add packages, update this graph to show dependencies.

---

Made with 💗 by [Kartoza](https://kartoza.com) | [Donate!](https://github.com/sponsors/kartoza) | [GitHub](https://github.com/kartoza/LearningGo)
