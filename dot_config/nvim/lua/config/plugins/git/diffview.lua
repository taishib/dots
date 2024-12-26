require("diffview").setup({
  diff_binaries = false, -- Show diffs for binaries
  icons = { -- Only applies when use_icons is true.
    folder_closed = "",
    folder_open = "",
  },
  signs = {
    fold_closed = "",
    fold_open = "",
    done = "",
  },
  view = {
    merge_tool = {
      layout = "diff3_mixed",
    },
  },
  keymaps = {
    view = {
      ["<leader>wh"] = require("diffview.actions").toggle_files,
    },
    file_history_panel = {
      {
        "n",
        "<C-g>",
        require("diffview.actions").open_in_diffview,
        { desc = "Open the entry under the cursor in a diffview" },
      },
      {
        "n",
        "<C-s>",
        function()
          local lazy = require("diffview.lazy")
          ---@type FileHistoryView|LazyModule
          local FileHistoryView = lazy.access("diffview.scene.views.file_history.file_history_view", "FileHistoryView")
          local view = require("diffview.lib").get_current_view()
          if view and view:instanceof(FileHistoryView.__get()) then
            ---@cast view DiffView|FileHistoryView
            local file = view:infer_cur_file()
            local item = view.panel:get_item_at_cursor()

            if file and item then
              local nio = require("nio")
              local path = file.absolute_path
              nio.run(function()
                nio.process.run({ cmd = "git", args = { "stash", "--keep-index" } }).result()
                nio.process
                  .run({
                    cmd = "git",
                    args = { "commit", "--fixup=" .. item.commit.hash, "--", path },
                  })
                  .result()
                nio.process.run({ cmd = "git", args = { "stash", "pop", "--index" } }).result()
                vim.notify("Fixup " .. item.commit.hash, vim.log.levels.INFO)
              end)
            end
          end
        end,
        { desc = "Fixup current file staged change" },
      },
    },
  },
})
