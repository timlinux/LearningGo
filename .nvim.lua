-- LearningGo - Neovim Project Configuration
-- Comprehensive Go development setup with which-key integration
-- All project commands available under <leader>p

local ok, wk = pcall(require, "which-key")
if not ok then
  vim.notify("which-key not installed. Install it for the project menu.", vim.log.levels.WARN)
  return
end

-- Helper function to run terminal commands
local function term_cmd(cmd, title)
  return function()
    vim.cmd("botright split | terminal " .. cmd)
    vim.cmd("startinsert")
    if title then
      vim.api.nvim_buf_set_name(0, title)
    end
  end
end

-- Helper function for floating terminal
local function float_term(cmd)
  return function()
    local buf = vim.api.nvim_create_buf(false, true)
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    vim.api.nvim_open_win(buf, true, {
      relative = "editor",
      width = width,
      height = height,
      row = row,
      col = col,
      style = "minimal",
      border = "rounded",
    })

    vim.fn.termopen(cmd)
    vim.cmd("startinsert")
  end
end

-- Project menu mappings - FLAT structure as requested
local mappings = {
  -- BUILD & RUN
  { "<leader>pb", term_cmd("make build", "Build"), desc = "Build project" },
  { "<leader>pr", term_cmd("make run", "Run"), desc = "Run project" },
  { "<leader>pR", term_cmd("make release", "Release"), desc = "Release (all platforms)" },
  { "<leader>pc", term_cmd("make clean", "Clean"), desc = "Clean artifacts" },

  -- TESTING
  { "<leader>pt", term_cmd("make test", "Tests"), desc = "Run tests" },
  { "<leader>pT", term_cmd("go test -v -run " .. vim.fn.expand("<cword>") .. " ./...", "Test"), desc = "Test under cursor" },
  { "<leader>pC", term_cmd("make coverage", "Coverage"), desc = "Coverage report" },
  { "<leader>pB", term_cmd("make bench", "Bench"), desc = "Run benchmarks" },

  -- CODE QUALITY
  { "<leader>pl", term_cmd("make lint", "Lint"), desc = "Lint code" },
  { "<leader>pf", term_cmd("make format", "Format"), desc = "Format code" },
  { "<leader>pv", term_cmd("make vet", "Vet"), desc = "Go vet" },

  -- MODULES & DEPS
  { "<leader>pm", term_cmd("make tidy", "Tidy"), desc = "Tidy modules" },
  { "<leader>pM", term_cmd("go mod download", "ModDown"), desc = "Download modules" },
  { "<leader>pg", term_cmd("make generate", "Generate"), desc = "Go generate" },
  { "<leader>pG", term_cmd("go get -u ./...", "Update"), desc = "Update dependencies" },

  -- DEBUGGING
  { "<leader>pd", term_cmd("make debug", "Debug"), desc = "Debug (dlv)" },
  { "<leader>pD", term_cmd("make debug-setup", "DebugSetup"), desc = "Build debug binary" },
  { "<leader>pL", term_cmd("dlv test ./...", "DebugTest"), desc = "Debug tests" },

  -- DOCUMENTATION
  { "<leader>po", term_cmd("make doc", "GoDoc"), desc = "Open godoc server" },
  { "<leader>pO", ":GoDoc<CR>", desc = "GoDoc for word under cursor" },

  -- FILE CREATION (Templates)
  { "<leader>pn", float_term("go-new-file"), desc = "New file from template" },
  { "<leader>p1", ":e %:h/main.go<CR>", desc = "New main.go here" },
  { "<leader>p2", ":e %:h/<C-R>=expand('%:t:r')<CR>_test.go<CR>", desc = "New test for current file" },

  -- LSP ACTIONS (if gopls is running)
  { "<leader>pi", vim.lsp.buf.implementation, desc = "Go to implementation" },
  { "<leader>ps", vim.lsp.buf.signature_help, desc = "Signature help" },
  { "<leader>pa", vim.lsp.buf.code_action, desc = "Code actions" },
  { "<leader>pA", vim.lsp.buf.references, desc = "All references" },
  { "<leader>pe", vim.diagnostic.open_float, desc = "Show diagnostics" },
  { "<leader>pE", vim.diagnostic.setloclist, desc = "Diagnostics list" },

  -- QUICK NAVIGATION
  { "<leader>pp", ":e main.go<CR>", desc = "Open main.go" },
  { "<leader>pP", ":e go.mod<CR>", desc = "Open go.mod" },
  { "<leader>pq", ":e Makefile<CR>", desc = "Open Makefile" },

  -- GIT INTEGRATION
  { "<leader>pS", term_cmd("git status", "GitStatus"), desc = "Git status" },
  { "<leader>pX", term_cmd("git diff", "GitDiff"), desc = "Git diff" },

  -- HELP
  { "<leader>ph", term_cmd("make help", "Help"), desc = "Show help" },
  { "<leader>pH", float_term("go-help"), desc = "Full help (nix)" },
  { "<leader>p?", ":WhichKey <leader>p<CR>", desc = "Show this menu" },
}

-- Register the project menu
wk.add({
  { "<leader>p", group = "Project (Go)", icon = "🐹" },
  unpack(mappings)
})

-- Additional Go-specific settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    -- Go formatting on save
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = 0,
      callback = function()
        vim.lsp.buf.format({ async = false })
      end,
    })

    -- Go-specific keymaps (buffer local)
    local opts = { buffer = true, silent = true }

    -- Quick struct tag management
    vim.keymap.set("n", "<leader>pj", ":GoAddTag json<CR>", vim.tbl_extend("force", opts, { desc = "Add json tags" }))
    vim.keymap.set("n", "<leader>pk", ":GoAddTag yaml<CR>", vim.tbl_extend("force", opts, { desc = "Add yaml tags" }))
    vim.keymap.set("n", "<leader>pK", ":GoRmTag<CR>", vim.tbl_extend("force", opts, { desc = "Remove tags" }))

    -- Fill struct
    vim.keymap.set("n", "<leader>pF", ":GoFillStruct<CR>", vim.tbl_extend("force", opts, { desc = "Fill struct" }))

    -- Generate interface implementation
    vim.keymap.set("n", "<leader>pI", ":GoImpl<CR>", vim.tbl_extend("force", opts, { desc = "Implement interface" }))
  end,
})

-- Notify that project config is loaded
vim.notify("🐹 LearningGo project loaded! Press <leader>p for menu", vim.log.levels.INFO)

-- Print a welcome message
vim.defer_fn(function()
  print([[
╔══════════════════════════════════════════════════════════════════╗
║           🐹 LearningGo - Neovim Ready!                          ║
╠══════════════════════════════════════════════════════════════════╣
║  Press <leader>p to open the project menu                        ║
║  Press <leader>p? to see all available commands                  ║
╚══════════════════════════════════════════════════════════════════╝
]])
end, 100)
