require("nightfox").setup({
  options = {
    -- Compiled file's destination location
    transparent = false, -- Disable setting background
    terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
    styles = { -- Style to be applied to different syntax groups
      comments = "italic",
      keywords = "bold",
      types = "italic,bold",
    },
    modules = {},
  },
  palettes = {},
  specs = {},
  groups = {
    all = {
      NormalFloat = { bg = "NONE" },
      NormalNC = { bg = "NONE" },
    },
  },
})

-- setup must be called before loading
-- vim.cmd("colorscheme nightfox")
