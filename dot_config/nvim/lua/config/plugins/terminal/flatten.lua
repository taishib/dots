---@type Terminal?
local saved_terminal

require("flatten").setup({
  one_per = {
    kitty = true, -- Flatten all instance in the current Kitty session
    wezterm = true, -- Flatten all instance in the current Wezterm session
  },
})
