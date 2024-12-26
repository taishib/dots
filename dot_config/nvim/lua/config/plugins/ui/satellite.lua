require("satellite").setup({
  current_only = true,
  winblend = vim.o.winblend,
  excluded_filetypes = {
    "OverseerList",
    "neo-tree",
    "telescope",
    "Telescope",
    "TelescopePrompt",
    "TelescopeResults",
    "TelescopePreview",
    "chatgpt-input",
  },
  handlers = {
    cursor = {
      enable = true,
      symbols = { "│", "│" },
    },
    search = {
      enable = true,
      priority = 55, -- Below cursor and above diagnostic
    },
    diagnostic = {
      enable = true,
      signs = { "│", "│", "│" },
      min_severity = vim.diagnostic.severity.WARN,
    },
    gitsigns = {
      enable = true,
      signs = {
        add = "│",
        change = "│",
        delete = "│",
      },
    },
    marks = {
      enable = false,
      show_builtins = false, -- shows the builtin marks like [ ] < >
      key = "m",
    },
    quickfix = {
      enable = true,
      signs = { "│", "│", "│" },
    },
  },
})
