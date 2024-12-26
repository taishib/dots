---@diagnostic disable: missing-fields
-- require("tree-sitter-just").setup({})

require("nvim-treesitter.configs").setup({
  indent = {
    enable = false,
  },
  yati = {
    enable = true,
    default_lazy = true,
    default_fallback = "auto",
  },
  endwise = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "+",
      node_incremental = "+",
      scope_incremental = false,
      node_decremental = "-",
    },
  },
  textsubjects = {
    enable = true,
    prev_selection = ",", -- (Optional) keymap to select the previous selection
    keymaps = {
      ["<cr>"] = "textsubjects-smart",
      [";"] = "textsubjects-container-outer",
      ["i;"] = {
        "textsubjects-container-inner",
        desc = "Select inside containers (classes, functions, etc.)",
      },
    },
  },
})
