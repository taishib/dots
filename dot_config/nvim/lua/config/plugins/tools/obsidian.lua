require("obsidian").setup({
  workspaces = {
    {
      name = "personal",
      path = "~/Documentos/Obsidian/obsidianVault/root",
    },
  },

  notes_subdir = "Notes",

  daily_notes = {
    folder = "Journal/Entries/Daily",
    date_format = "%Y-%m-%d",
    alias_format = "%B %-d, %Y",
    template = "_data_/templates/journal/daily_entry.md",
  },

  mappings = {
    ["gf"] = {
      action = function()
        return require("obsidian").util.gf_passthrough()
      end,
      opts = { noremap = false, expr = true, buffer = true },
    },
    ["<C-c>"] = {
      action = function()
        return require("obsidian").util.toggle_checkbox()
      end,
      opts = { buffer = true },
    },
  },

  templates = {
    subdir = "_data_/templates",
    date_format = "%Y-%m-%d-%a",
    time_format = "%H:%M",
  },

  follow_url_func = function(url)
    vim.fn.jobstart({ "xdg-open", url })
  end,

  attachments = {
    img_folder = "_data_/media",
  },
})
