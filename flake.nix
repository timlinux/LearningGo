{
  description = "LearningGo - A comprehensive Go learning environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        # Project metadata
        projectName = "LearningGo";
        version = "0.1.0";

        # Go build helper
        goBuild = pkgs.writeShellScriptBin "go-build" ''
          #!/usr/bin/env bash
          set -euo pipefail
          echo "🔨 Building ${projectName}..."
          go build -v -o ./bin/${projectName} ./...
          echo "✅ Build complete: ./bin/${projectName}"
        '';

        goRun = pkgs.writeShellScriptBin "go-run" ''
          #!/usr/bin/env bash
          set -euo pipefail
          echo "🚀 Running ${projectName}..."
          go run ./main.go "$@"
        '';

        goTest = pkgs.writeShellScriptBin "go-test" ''
          #!/usr/bin/env bash
          set -euo pipefail
          echo "🧪 Running tests..."
          go test -v -race -coverprofile=coverage.out ./...
          echo "✅ Tests complete!"
        '';

        goTestCoverage = pkgs.writeShellScriptBin "go-test-coverage" ''
          #!/usr/bin/env bash
          set -euo pipefail
          echo "📊 Generating coverage report..."
          go test -v -race -coverprofile=coverage.out ./...
          go tool cover -html=coverage.out -o coverage.html
          echo "✅ Coverage report: coverage.html"
          ${pkgs.xdg-utils}/bin/xdg-open coverage.html 2>/dev/null || true
        '';

        goLint = pkgs.writeShellScriptBin "go-lint" ''
          #!/usr/bin/env bash
          set -euo pipefail
          echo "🔍 Linting code..."
          golangci-lint run ./...
          echo "✅ Lint complete!"
        '';

        goFormat = pkgs.writeShellScriptBin "go-format" ''
          #!/usr/bin/env bash
          set -euo pipefail
          echo "✨ Formatting code..."
          gofmt -w -s .
          goimports -w .
          echo "✅ Format complete!"
        '';

        goClean = pkgs.writeShellScriptBin "go-clean" ''
          #!/usr/bin/env bash
          set -euo pipefail
          echo "🧹 Cleaning build artifacts..."
          rm -rf ./bin ./coverage.out ./coverage.html
          go clean -cache -testcache
          echo "✅ Clean complete!"
        '';

        goDoc = pkgs.writeShellScriptBin "go-doc" ''
          #!/usr/bin/env bash
          set -euo pipefail
          echo "📚 Starting documentation server on http://localhost:6060..."
          echo "Press Ctrl+C to stop"
          godoc -http=:6060
        '';

        goModTidy = pkgs.writeShellScriptBin "go-mod-tidy" ''
          #!/usr/bin/env bash
          set -euo pipefail
          echo "📦 Tidying go modules..."
          go mod tidy
          echo "✅ Modules tidied!"
        '';

        goVet = pkgs.writeShellScriptBin "go-vet" ''
          #!/usr/bin/env bash
          set -euo pipefail
          echo "🔬 Running go vet..."
          go vet ./...
          echo "✅ Vet complete!"
        '';

        goRelease = pkgs.writeShellScriptBin "go-release" ''
          #!/usr/bin/env bash
          set -euo pipefail

          VERSION=''${1:-$(git describe --tags --always 2>/dev/null || echo "dev")}

          echo "📦 Building release $VERSION for all platforms..."
          mkdir -p dist

          # Linux
          echo "  🐧 Building for Linux amd64..."
          GOOS=linux GOARCH=amd64 go build -ldflags="-s -w -X main.Version=$VERSION" -o dist/${projectName}-linux-amd64 ./main.go

          echo "  🐧 Building for Linux arm64..."
          GOOS=linux GOARCH=arm64 go build -ldflags="-s -w -X main.Version=$VERSION" -o dist/${projectName}-linux-arm64 ./main.go

          # macOS
          echo "  🍎 Building for macOS amd64..."
          GOOS=darwin GOARCH=amd64 go build -ldflags="-s -w -X main.Version=$VERSION" -o dist/${projectName}-darwin-amd64 ./main.go

          echo "  🍎 Building for macOS arm64..."
          GOOS=darwin GOARCH=arm64 go build -ldflags="-s -w -X main.Version=$VERSION" -o dist/${projectName}-darwin-arm64 ./main.go

          # Windows
          echo "  🪟 Building for Windows amd64..."
          GOOS=windows GOARCH=amd64 go build -ldflags="-s -w -X main.Version=$VERSION" -o dist/${projectName}-windows-amd64.exe ./main.go

          echo "✅ Release builds complete in ./dist/"
          ls -la dist/
        '';

        goNewFile = pkgs.writeShellScriptBin "go-new-file" ''
          #!/usr/bin/env bash
          set -euo pipefail

          TEMPLATES_DIR="''${PWD}/templates"

          echo "📝 Create new Go file"
          echo ""
          echo "Available templates:"
          echo "  1) main     - Main application entry point"
          echo "  2) pkg      - Package with exported functions"
          echo "  3) test     - Test file"
          echo "  4) bench    - Benchmark test file"
          echo "  5) handler  - HTTP handler"
          echo "  6) model    - Data model/struct"
          echo "  7) interface - Interface definition"
          echo ""
          read -p "Select template [1-7]: " choice
          read -p "Enter filename (without .go): " filename
          read -p "Enter package name: " pkgname

          case $choice in
            1) template="main.go.tmpl" ;;
            2) template="pkg.go.tmpl" ;;
            3) template="test.go.tmpl" ;;
            4) template="bench.go.tmpl" ;;
            5) template="handler.go.tmpl" ;;
            6) template="model.go.tmpl" ;;
            7) template="interface.go.tmpl" ;;
            *) echo "Invalid choice"; exit 1 ;;
          esac

          if [[ -f "$TEMPLATES_DIR/$template" ]]; then
            sed "s/{{PACKAGE}}/$pkgname/g; s/{{FILENAME}}/$filename/g" "$TEMPLATES_DIR/$template" > "$filename.go"
            echo "✅ Created $filename.go"
          else
            echo "❌ Template not found: $template"
            exit 1
          fi
        '';

        goDebugSetup = pkgs.writeShellScriptBin "go-debug-setup" ''
          #!/usr/bin/env bash
          set -euo pipefail
          echo "🐛 Building debug binary..."
          go build -gcflags="all=-N -l" -o ./bin/${projectName}-debug ./main.go
          echo "✅ Debug binary: ./bin/${projectName}-debug"
          echo ""
          echo "To start debugging:"
          echo "  dlv exec ./bin/${projectName}-debug"
          echo ""
          echo "Or attach to running process:"
          echo "  dlv attach <pid>"
        '';

        goDebug = pkgs.writeShellScriptBin "go-debug" ''
          #!/usr/bin/env bash
          set -euo pipefail
          echo "🐛 Starting debugger..."
          dlv debug ./main.go
        '';

        goBench = pkgs.writeShellScriptBin "go-bench" ''
          #!/usr/bin/env bash
          set -euo pipefail
          echo "⚡ Running benchmarks..."
          go test -bench=. -benchmem ./...
          echo "✅ Benchmarks complete!"
        '';

        goGenerate = pkgs.writeShellScriptBin "go-generate" ''
          #!/usr/bin/env bash
          set -euo pipefail
          echo "⚙️ Running go generate..."
          go generate ./...
          echo "✅ Generation complete!"
        '';

        preCommitInstall = pkgs.writeShellScriptBin "go-precommit-install" ''
          #!/usr/bin/env bash
          set -euo pipefail
          echo "🔧 Installing pre-commit hooks..."
          pre-commit install
          pre-commit install --hook-type commit-msg
          echo "✅ Pre-commit hooks installed!"
        '';

        preCommitRun = pkgs.writeShellScriptBin "go-precommit-run" ''
          #!/usr/bin/env bash
          set -euo pipefail
          echo "🔍 Running pre-commit checks..."
          pre-commit run --all-files
          echo "✅ Pre-commit checks complete!"
        '';

        reuseCheck = pkgs.writeShellScriptBin "go-reuse-check" ''
          #!/usr/bin/env bash
          set -euo pipefail
          echo "📜 Checking REUSE license compliance..."
          reuse lint
          echo "✅ REUSE check complete!"
        '';

        showHelp = pkgs.writeShellScriptBin "go-help" ''
          #!/usr/bin/env bash
          echo ""
          echo "╔══════════════════════════════════════════════════════════════════╗"
          echo "║           🐹 LearningGo Development Environment                  ║"
          echo "╠══════════════════════════════════════════════════════════════════╣"
          echo "║                                                                  ║"
          echo "║  📦 BUILD & RUN                                                  ║"
          echo "║    nix run .#build      Build the project                        ║"
          echo "║    nix run .#run        Run the project                          ║"
          echo "║    nix run .#clean      Clean build artifacts                    ║"
          echo "║                                                                  ║"
          echo "║  🧪 TESTING                                                      ║"
          echo "║    nix run .#test       Run all tests                            ║"
          echo "║    nix run .#coverage   Generate coverage report                 ║"
          echo "║    nix run .#bench      Run benchmarks                           ║"
          echo "║                                                                  ║"
          echo "║  🔍 CODE QUALITY                                                 ║"
          echo "║    nix run .#lint       Run linter                               ║"
          echo "║    nix run .#format     Format code                              ║"
          echo "║    nix run .#vet        Run go vet                               ║"
          echo "║                                                                  ║"
          echo "║  📦 MODULES & DEPS                                               ║"
          echo "║    nix run .#tidy       Tidy go modules                          ║"
          echo "║    nix run .#generate   Run go generate                          ║"
          echo "║                                                                  ║"
          echo "║  🐛 DEBUGGING                                                    ║"
          echo "║    nix run .#debug      Start debugger (dlv)                     ║"
          echo "║    nix run .#debug-setup Build debug binary                      ║"
          echo "║                                                                  ║"
          echo "║  📚 DOCUMENTATION                                                ║"
          echo "║    nix run .#doc        Start godoc server                       ║"
          echo "║                                                                  ║"
          echo "║  🚀 RELEASE                                                      ║"
          echo "║    nix run .#release    Build for all platforms                  ║"
          echo "║                                                                  ║"
          echo "║  📝 TEMPLATES                                                    ║"
          echo "║    nix run .#new        Create new Go file from template         ║"
          echo "║                                                                  ║"
          echo "║  ✅ PRE-COMMIT                                                   ║"
          echo "║    nix run .#precommit-install  Install pre-commit hooks         ║"
          echo "║    nix run .#precommit          Run all pre-commit checks        ║"
          echo "║    nix run .#reuse              Check REUSE license compliance   ║"
          echo "║                                                                  ║"
          echo "║  💡 You can also use 'make <target>' for all commands            ║"
          echo "║                                                                  ║"
          echo "╚══════════════════════════════════════════════════════════════════╝"
          echo ""
          echo "Made with 💗 by Kartoza | https://kartoza.com"
          echo ""
        '';

      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Go toolchain
            go_1_22
            gopls
            gotools
            go-tools
            golangci-lint
            delve
            gomodifytags
            gotests
            impl
            godef
            gofumpt

            # Development utilities
            gnumake
            git
            gh

            # Pre-commit and quality tools
            pre-commit
            codespell
            shellcheck
            yamllint
            nodePackages.markdownlint-cli
            reuse

            # Our custom scripts
            goBuild
            goRun
            goTest
            goTestCoverage
            goLint
            goFormat
            goClean
            goDoc
            goModTidy
            goVet
            goRelease
            goNewFile
            goDebugSetup
            goDebug
            goBench
            goGenerate
            preCommitInstall
            preCommitRun
            reuseCheck
            showHelp
          ];

          shellHook = ''
            echo ""
            echo "╔══════════════════════════════════════════════════════════════════╗"
            echo "║           🐹 Welcome to LearningGo!                              ║"
            echo "╠══════════════════════════════════════════════════════════════════╣"
            echo "║                                                                  ║"
            echo "║  Your Go learning environment is ready!                          ║"
            echo "║                                                                  ║"
            echo "║  Quick Start:                                                    ║"
            echo "║    go-help         Show all available commands                   ║"
            echo "║    go-run          Run your program                              ║"
            echo "║    go-build        Build your program                            ║"
            echo "║    go-test         Run tests                                     ║"
            echo "║    go-new-file     Create new Go file from template              ║"
            echo "║                                                                  ║"
            echo "║  Neovim: Open with 'nvim' and press <leader>p for project menu  ║"
            echo "║                                                                  ║"
            echo "╚══════════════════════════════════════════════════════════════════╝"
            echo ""
            echo "Go version: $(go version | cut -d' ' -f3)"
            echo ""

            # Ensure bin directory exists
            mkdir -p ./bin

            # Set up Go environment
            export GOPATH="$PWD/.go"
            export GOBIN="$GOPATH/bin"
            export PATH="$GOBIN:$PATH"
          '';
        };

        # Flake apps for nix run
        apps = {
          build = { type = "app"; program = "${goBuild}/bin/go-build"; };
          run = { type = "app"; program = "${goRun}/bin/go-run"; };
          test = { type = "app"; program = "${goTest}/bin/go-test"; };
          coverage = { type = "app"; program = "${goTestCoverage}/bin/go-test-coverage"; };
          lint = { type = "app"; program = "${goLint}/bin/go-lint"; };
          format = { type = "app"; program = "${goFormat}/bin/go-format"; };
          clean = { type = "app"; program = "${goClean}/bin/go-clean"; };
          doc = { type = "app"; program = "${goDoc}/bin/go-doc"; };
          tidy = { type = "app"; program = "${goModTidy}/bin/go-mod-tidy"; };
          vet = { type = "app"; program = "${goVet}/bin/go-vet"; };
          release = { type = "app"; program = "${goRelease}/bin/go-release"; };
          new = { type = "app"; program = "${goNewFile}/bin/go-new-file"; };
          debug = { type = "app"; program = "${goDebug}/bin/go-debug"; };
          debug-setup = { type = "app"; program = "${goDebugSetup}/bin/go-debug-setup"; };
          bench = { type = "app"; program = "${goBench}/bin/go-bench"; };
          generate = { type = "app"; program = "${goGenerate}/bin/go-generate"; };
          precommit-install = { type = "app"; program = "${preCommitInstall}/bin/go-precommit-install"; };
          precommit = { type = "app"; program = "${preCommitRun}/bin/go-precommit-run"; };
          reuse = { type = "app"; program = "${reuseCheck}/bin/go-reuse-check"; };
          help = { type = "app"; program = "${showHelp}/bin/go-help"; };
          default = { type = "app"; program = "${showHelp}/bin/go-help"; };
        };
      }
    );
}
