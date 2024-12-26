return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false, -- set this if you want to always pull the latest change
    opts = {
      provider = "copilot",
      mappings = {
        ask = "<leader>ac",
        edit = "<leader>ae",
        refresh = "<leader>ar",
        focus = "<leader>af",
        toggle = {
          default = "<leader>at",
          debug = "<leader>aD",
          hint = "<leader>ah",
          suggestion = "<leader>as",
        },
      },
    },
    keys = { "<leader>a", desc = "Avante" },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "echasnovski/mini.icons",
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            -- use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
  {
    "gbprod/yanky.nvim",
    keys = {
      { "<leader>p", false },
    },
  },
  {
    "tzachar/highlight-undo.nvim",
    config = true,
    event = "VeryLazy",
  },
  {
    "gbprod/stay-in-place.nvim",
    config = true,
    event = "VeryLazy",
  },
  {
    "Wansmer/treesj",
    keys = {
      { "J", "<cmd>TSJToggle<cr>", desc = "Join Toggle" },
    },
    opts = { use_default_keymaps = false, max_join_length = 150 },
  },
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },
  {
    "fazibear/screen_saviour.nvim",
    cmd = "ScreenSaviour",
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      preset = "helix", -- classic, modern, helix
      win = {
        wo = {
          winblend = 0,
        },
      },
      icons = {
        keys = {
          Space = " ",
        },
      },
      spec = {
        { "<leader>l", group = "+lazy" },
        { "<leader>p", group = "+project" },
      },
    },
  },
  {
    "epwalsh/obsidian.nvim",
    keys = {
      { "<leader>z", gruop = "obsidian" },
      { "<leader>zo", "<cmd>ObsidianOpen<CR>", desc = "Open on App" },
      { "<leader>zg", "<cmd>ObsidianSearch<CR>", desc = "Grep" },
      { "<leader>zO", "<cmd>ObsidianSearch<CR>", desc = "Obsidian Grep" },
      { "<leader>zn", "<cmd>ObsidianNew<CR>", desc = "New Note" },
      { "<leader>z<space>", "<cmd>ObsidianQuickSwitch<CR>", desc = "Find Files" },
      { "<leader>zb", "<cmd>ObsidianBacklinks<CR>", desc = "Backlinks" },
      { "<leader>zt", "<cmd>ObsidianTags<CR>", desc = "Tags" },
      { "<leader>zt", "<cmd>ObsidianTemplate<CR>", desc = "Template" },
      { "<leader>zl", "<cmd>ObsidianLink<CR>", desc = "Link" },
      { "<leader>zL", "<cmd>ObsidianLinks<CR>", desc = "Links" },
      { "<leader>zN", "<cmd>ObsidianLinkNew<CR>", desc = "New Link" },
      { "<leader>ze", "<cmd>ObsidianExtractNote<CR>", desc = "Extract Note" },
      { "<leader>zw", "<cmd>ObsidianWorkspace<CR>", desc = "Workspace" },
      { "<leader>zr", "<cmd>ObsidianRename<CR>", desc = "Rename" },
      { "<leader>zi", "<cmd>ObsidianPasteImg<CR>", desc = "Paste Image" },
      { "<leader>zd", "<cmd>ObsidianDailies<CR>", desc = "Daily Notes" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("config.plugins.tools.obsidian")
    end,
  },
  {
    "ejrichards/mise.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "OXY2DEV/helpview.nvim",
    ft = "help",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  },
  {
    "h-hg/fcitx.nvim",
    event = "InsertEnter",
  },
  {
    "voldikss/vim-translator",
    cmd = { "TranslateW", "TranslateW --target_lang=en" },
    keys = {
      -- Popup
      { "<localleader>t", "", desc = "Translate" },
      { "<localleader>tj", "<cmd>TranslateW<CR>", mode = "n", desc = "Translate words into Japanese" },
      { "<localleader>tj", ":'<,'>TranslateW<CR>", mode = "v", desc = "Translate lines into Japanese" },
      { "<localleader>te", "<cmd>TranslateW --target_lang=en<CR>", mode = "n", desc = "Translate words into English" },
      { "<localleader>te", ":'<,'>TranslateW --target_lang=en<CR>", mode = "v", desc = "Translate lines into English" },
      -- Replace
      { "<localleader>tr", "", desc = "Translate Replace" },
      -- Replace to Japanese
      { "<localleader>trj", ":'<,'>TranslateR<CR>", mode = "v", desc = "Replace to Japanese" },
      {
        "<localleader>trj",
        function()
          vim.api.nvim_feedkeys("^vg_", "n", false)
          -- Execute the conversion command after a short delay.
          vim.defer_fn(function()
            vim.api.nvim_feedkeys(":TranslateR\n", "n", false)
          end, 100) -- 100ms delay
        end,
        mode = "n",
        desc = "Replace to Japanese",
      },
      -- Replace to English
      { "<localleader>tre", ":'<,'>TranslateR --target_lang=en<CR>", mode = "v", desc = "Replace to English" },
      {
        "<localleader>tre",
        function()
          vim.api.nvim_feedkeys("^vg_", "n", false)
          -- Run translator command after a short delay
          vim.defer_fn(function()
            vim.api.nvim_feedkeys(":TranslateR --target_lang=en\n", "n", false)
          end, 100) -- 100ms delay
        end,
        mode = "n",
        desc = "Replace to English",
      },
    },
    config = function()
      vim.g.translator_target_lang = "ja"
      vim.g.translator_default_engines = { "google" }
      vim.g.translator_history_enable = true
      vim.g.translator_window_type = "popup"
      vim.g.translator_window_max_width = 0.5
      vim.g.translator_window_max_height = 0.9 -- 1 is not working
    end,
  },
  {
    "potamides/pantran.nvim",
    keys = {
      { "<localleader>tw", "<cmd>Pantran<CR>", mode = { "n", "v" }, desc = "Show Translate Window" },
    },
    config = function()
      require("pantran").setup({
        default_engine = "google",
        engines = {
          google = {
            fallback = {
              default_source = "en",
              default_target = "ja",
            },
            -- NOTE: must set `DEEPL_AUTH_KEY` env-var
            -- deepl = {
            --   default_source = "",
            --   default_target = "",
            -- },
          },
        },
        ui = {
          width_percentage = 0.8,
          height_percentage = 0.8,
        },
        window = {
          title_border = { "⭐️ ", " ⭐️    " }, -- for google
          window_config = { border = "rounded" },
        },
        controls = {
          mappings = { -- Help Popup order cannot be changed
            edit = {
              -- normal mode mappings
              n = {
                -- ["j"] = "gj",
                -- ["k"] = "gk",
                ["S"] = require("pantran.ui.actions").switch_languages,
                ["e"] = require("pantran.ui.actions").select_engine,
                ["s"] = require("pantran.ui.actions").select_source,
                ["t"] = require("pantran.ui.actions").select_target,
                ["<C-y>"] = require("pantran.ui.actions").yank_close_translation,
                ["g?"] = require("pantran.ui.actions").help,
                --disable default mappings
                ["<C-Q>"] = false,
                ["gA"] = false,
                ["gS"] = false,
                ["gR"] = false,
                ["ga"] = false,
                ["ge"] = false,
                ["gr"] = false,
                ["gs"] = false,
                ["gt"] = false,
                ["gY"] = false,
                ["gy"] = false,
              },
              -- insert mode mappings
              i = {
                ["<C-y>"] = require("pantran.ui.actions").yank_close_translation,
                ["<C-t>"] = require("pantran.ui.actions").select_target,
                ["<C-s>"] = require("pantran.ui.actions").select_source,
                ["<C-e>"] = require("pantran.ui.actions").select_engine,
                ["<C-S>"] = require("pantran.ui.actions").switch_languages,
              },
            },
            -- Keybindings here are used in the selection window.
            select = {},
          },
        },
      })
    end,
  },
}
