local icons = LazyVim.config.icons
local dropbar = require("dropbar")
local utils = require("dropbar.utils")

local enable = function(buf, win)
  -- if
  --   require("cokeline.sidebar").get_win("left") == win
  --   or require("cokeline.sidebar").get_win("right") == win
  -- then
  --   return false
  -- end
  -- if vim.wo[win].diff then
  --   return false
  -- end
  local filetype = vim.bo[buf].filetype
  local disabled = {
    ["oil"] = true,
    ["trouble"] = true,
    ["qf"] = true,
    ["noice"] = true,
    ["dapui_scopes"] = true,
    ["dapui_breakpoints"] = true,
    ["dapui_stacks"] = true,
    ["dapui_watches"] = true,
    ["dapui_console"] = true,
    ["dap-repl"] = true,
    ["neocomposer-menu"] = true,
  }
  if disabled[filetype] then
    return false
  end
  if vim.api.nvim_win_get_config(win).zindex ~= nil then
    return vim.bo[buf].buftype == "terminal" and vim.bo[buf].filetype == "terminal"
  end
  return vim.bo[buf].buflisted == true and vim.bo[buf].buftype == "" and vim.api.nvim_buf_get_name(buf) ~= ""
end

local close = function()
  local menu = require("dropbar.utils").menu.get_current()
  if not menu then
    return
  end
  menu:close()
end

dropbar.setup({
  sources = {
    terminal = {
      name = function(buf)
        local term = require("toggleterm.terminal").find(function(term)
          return term.bufnr == buf
        end)
        local name
        if term then
          name = term.display_name or term.cmd or term.name
        else
          name = vim.api.nvim_buf_get_name(buf)
        end
        return " " .. name
      end,
      name_hl = "Normal",
    },
    path = {
      preview = "previous",
    },
  },
  icons = {
    kinds = {
      symbols = {
        File = " ",
        Folder = "  ",
      },
    },
    ui = {
      bar = {},
      menu = {
        indicator = "",
      },
    },
  },
  bar = {
    padding = {
      left = 0,
      right = 1,
    },
  },
  menu = {
    -- ui_select = true,
    keymaps = {
      q = close,
      ["<Esc>"] = close,
    },
    quick_navigation = true,
    scrollbar = {
      -- enabled=false,
      background = false,
    },
    win_configs = {
      -- border = {
      --   -- "/",
      --   -- "-",
      --   -- "\\",
      --   -- "|",
      --   "",
      --   "",
      --   "",
      --   "",
      -- },
      -- lower
      -- border = { "│", "─", "│", "│", "┘", "─", "└", "│" },
      -- upper
      -- border = { "┌", "─", "┐", "│", "┤", "─", "├", "│" },
      -- border = function(self)
      --   if self.fzf_state then
      --     return {
      --       "┌",
      --       "─",
      --       "┐",
      --       "│",
      --       "┤",
      --       "─",
      --       "├",
      --       "│",
      --     }
      --   end
      --   return "single"
      -- end,
    },
  },
  fzf = {
    prompt = "%#GitSignsAdd# ",
    win_configs = {
      -- border = {
      --   -- "│", --topleft
      --   -- "├", --topleft
      --   "",
      --   "",
      --   -- "─", --top
      --   -- "┤", --topright
      --   -- "│", --topright
      --   "",
      --   "│",
      --   "┘",
      --   "─",
      --   "└",
      --   "│",
      -- },
    },
    keymaps = {
      ["<C-j>"] = function()
        require("dropbar.api").fuzzy_find_navigate("down")
      end,
      ["<C-k>"] = function()
        require("dropbar.api").fuzzy_find_navigate("up")
      end,
    },
  },
})

vim.ui.select = require("dropbar.utils.menu").select
