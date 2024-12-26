local smart_splits = require("smart-splits")

smart_splits.setup({
  resize_mode = {
    hooks = {
      on_leave = require("bufresize").register,
    },
  },
  ignore_events = {
    "WinResized",
    "BufWinEnter",
    "BufEnter",
    "WinEnter",
  },
})
