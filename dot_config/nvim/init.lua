-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.g.maplocalleader = ","

if vim.loader then
  vim.loader.enable()
end
