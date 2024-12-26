return {
  -- LAYOUT / CORE UI --
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = [[
    ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
    ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
    ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
    ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
    ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
    ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
        },
        sections = {
          { section = "header" },
          {
            pane = 2,
            section = "terminal",
            cmd = "colorscript -e square",
            height = 8,
            padding = 1,
          },
          { section = "keys", gap = 1, padding = 1 },
          { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
          { pane = 2, section = "startup", padding = 5 },
        },
      },
      profiler = {
        -- runtime = "~/projects/neovim/runtime/",
        presets = {
          on_stop = function()
            Snacks.profiler.scratch()
          end,
        },
      },
      input = {},
      -- styles = { terminal = { position = "top" } },
      ---@type snacks.scroll.Config
      scroll = {},
      indent = {
        animate = {
          style = "up_down",
          duration = {
            step = 60, -- ms per step
            total = 500, -- maximum duration
          },
        },
        chunk = {
          enabled = true,
        },
      },
    },
    -- stylua: ignore
    keys = {
      -- { "<leader>z", function() Snacks.zen() end, desc = "Toggle Zen Mode" },
      { "<leader>pt", function() Snacks.scratch({ icon = " ", name = "Todo", ft = "markdown", file = "~/.config/nvim/TODO.md" }) end, desc = "Todo List" },
      {
        "<leader>pd",
        function()
          if not Snacks.profiler.running() then
            Snacks.notify("Profiler debug started")
            Snacks.profiler.start()
          else
            Snacks.profiler.debug()
            Snacks.notify("Profiler debug stopped")
          end
        end,
      },
    },
  },
  {
    "folke/noice.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("config.plugins.ui.noice")
    end,
  },
  -- WINDOWS --
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      { "<leader>e", false },
      { "<leader>E", false },
    },
  },
  {
    "mrjones2014/smart-splits.nvim",
    config = function()
      require("config.plugins.window.smart-splits")
    end,
    event = "VeryLazy",
  },
  {
    "nvim-focus/focus.nvim",
    dependencies = {
      "echasnovski/mini.animate",
    },
    config = function()
      vim.api.nvim_create_autocmd("WinEnter", {
        once = true,
        callback = function()
          require("config.plugins.window.focus")
        end,
      })
    end,
    event = "VeryLazy",
    enabled = true,
  },
  {
    "willothy/nvim-window-picker",
    event = "VeryLazy",
    config = function()
      require("config.plugins.window.window-picker")
    end,
  },
  {
    "kwkarlwang/bufresize.nvim",
    event = "VeryLazy",
    config = function()
      require("config.plugins.window.bufresize")
    end,
  },
  {
    "stevearc/stickybuf.nvim",
    event = "VeryLazy",
    opts = {
      get_auto_pin = function(bufnr)
        -- Shell terminals will all have ft `terminal`, and can be switched between.
        -- They should be pinned by filetype only, not bufnr.
        if vim.bo[bufnr].filetype == "terminal" then
          return "filetype"
        end
        -- Non-shell terminals should be pinned by bufnr, not filetype.
        if vim.bo[bufnr].buftype == "terminal" then
          return "bufnr"
        end
        return require("stickybuf").should_auto_pin(bufnr)
      end,
    },
  },
  -- STATUS --
  {
    "nvim-lualine/lualine.nvim",
    enabled = false,
  },
  {
    "akinsho/bufferline.nvim",
    keys = {
      { "<leader>bb", "<Cmd>BufferLinePick<CR>", desc = "Pick Open" },
      { "<leader>bx", "<Cmd>BufferLinePickClose<CR>", desc = "Pick Close" },
    },
    enabled = true,
  },
  {
    "Bekaboo/dropbar.nvim",
    config = function()
      require("config.plugins.status.dropbar")
    end,
    event = "BufReadPost",
    keys = {
      {
        "<leader>bq",
        function()
          require("dropbar.api").pick()
        end,
        desc = "Pick Dropbar Item",
      },
    },
  },
  {
    "b0o/incline.nvim",
    event = "VeryLazy",
    config = function()
      require("config.plugins.status.incline")
    end,
  },
  {
    "lewis6991/satellite.nvim",
    event = "BufReadPost",
    config = function()
      require("config.plugins.ui.satellite")
    end,
  },
  -- COLORS --
  {
    "nvchad/ui",
    config = function()
      require("nvchad")
    end,
    keys = {
      {
        "<leader>uvt",
        function()
          require("nvchad.themes").open()
        end,
        desc = "Themes",
      },
    },
  },
  {
    "nvchad/base46",
    lazy = true,
    build = function()
      require("base46").load_all_highlights()
    end,
    -- load base46 cache when necessary
    specs = {
      {
        "nvim-treesitter/nvim-treesitter",
        optional = true,
        opts = function()
          pcall(function()
            dofile(vim.g.base46_cache .. "syntax")
            dofile(vim.g.base46_cache .. "treesitter")
          end)
        end,
      },
      {
        "folke/which-key.nvim",
        optional = true,
        opts = function()
          pcall(function()
            dofile(vim.g.base46_cache .. "whichkey")
          end)
        end,
      },
      {
        "neovim/nvim-lspconfig",
        optional = true,
        opts = function()
          pcall(function()
            dofile(vim.g.base46_cache .. "lsp")
          end)
        end,
      },
      {
        "williamboman/mason.nvim",
        optional = true,
        opts = function()
          pcall(function()
            dofile(vim.g.base46_cache .. "mason")
          end)
        end,
      },
      {
        "lewis6991/gitsigns.nvim",
        optional = true,
        opts = function()
          pcall(function()
            dofile(vim.g.base46_cache .. "git")
          end)
        end,
      },
      {
        "nvim-tree/nvim-web-devicons",
        optional = true,
        opts = function()
          pcall(function()
            dofile(vim.g.base46_cache .. "devicons")
          end)
        end,
      },
      {
        "echasnovski/mini.icons",
        optional = true,
        opts = function()
          pcall(function()
            dofile(vim.g.base46_cache .. "devicons")
          end)
        end,
      },
    },
  },
  { "nvzone/volt", lazy = true },
  {
    "nvzone/minty",
    lazy = true,
    keys = {
      {
        "<leader>uvh",
        function()
          require("minty.huefy").open()
        end,
        desc = "Huefy",
      },
      {
        "<leader>uvs",
        function()
          require("minty.shades").open()
        end,
        desc = "Shades",
      },
    },
  },
  {
    "nvzone/menu",
    lazy = true,
    keys = {
      {
        "<leader>uvm",
        function()
          require("menu").open("default")
        end,
        desc = "Menu",
      },
    },
  },
  {
    "nvzone/showkeys",
    keys = {
      {
        "<leader>uvk",
        function()
          require("showkeys").toggle()
        end,
        desc = "Keys",
      },
    },
  },
  {
    "nvzone/timerly",
    cmd = "TimerlyToggle",
    keys = { { "<leader>uvp", "<cmd>TimerlyToggle<cr>", desc = "Timer" } },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "nvchad",
    },
  },
  {
    "folke/tokyonight.nvim",
    event = "VeryLazy",
    opts = { style = "night" },
  },
  {
    "EdenEast/nightfox.nvim",
    event = "VeryLazy",
    config = function()
      require("config.plugins.colorscheme.nightfox")
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    event = "VeryLazy",
    config = function()
      require("config.plugins.colorscheme.kanagawa")
    end,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    opts = {
      styles = {
        transparency = false,
      },
      highlight_groups = {
        TelescopeBorder = { fg = "highlight_high", bg = "none" },
        TelescopeNormal = { bg = "none" },
        TelescopePromptNormal = { bg = "base" },
        TelescopeResultsNormal = { fg = "subtle", bg = "none" },
        TelescopeSelection = { fg = "text", bg = "base" },
        TelescopeSelectionCaret = { fg = "rose", bg = "rose" },
      },
    },
    event = "VeryLazy",
  },
  {
    "sainnhe/gruvbox-material",
    event = "VeryLazy",
    config = function()
      vim.g.gruvbox_material_enable_italic = true
      -- vim.g.gruvbox_material_transparent_background = 2
    end,
  },
  {
    "diegoulloao/neofusion.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "xiyaowong/transparent.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "<leader>uP", "<Cmd>TransparentToggle<CR>", desc = "Toggle Transparent" },
    },
  },
  {
    "catppuccin/nvim",
    event = "VeryLazy",
  },
}
