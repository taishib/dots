local conditions = require("heirline.conditions")
local utils = require("heirline.utils")
local colors = require("config.plugins.status.heirline.colors").colors
local copilot_api = require("copilot.api")
local copilot_client = require("copilot.client")

local primary_mode_colors = {
  n = { fg = colors.dark_gray },
  i = { bg = colors.green, fg = colors.black },
  v = { bg = colors.orange, fg = colors.black },
  V = { bg = colors.orange, fg = colors.black },
  ["\22"] = { bg = colors.orange, fg = colors.black },
  c = { bg = colors.blue, fg = colors.black },
  s = { bg = colors.purple, fg = colors.black },
  S = { bg = colors.purple, fg = colors.black },
  ["\19"] = { bg = colors.purple, fg = colors.black },
  R = { bg = colors.red, fg = colors.black },
  r = { bg = colors.red, fg = colors.black },
  ["!"] = { bg = colors.blue, fg = colors.black },
  t = { bg = colors.purple, fg = colors.black },
}

local secondary_mode_colors = {
  n = { fg = colors.dark_gray },
  i = { fg = colors.green },
  v = { fg = colors.orange },
  V = { fg = colors.orange },
  ["\22"] = { fg = colors.orange },
  c = { fg = colors.blue },
  s = { fg = colors.purple },
  S = { fg = colors.purple },
  ["\19"] = { fg = colors.purple },
  R = { fg = colors.red },
  r = { fg = colors.red },
  ["!"] = { fg = colors.blue },
  t = { fg = colors.purple },
}

local function get_mode()
  local mode = vim.fn.mode(1) or "n"
  return mode:sub(1, 1)
end

local primary_highlight = function()
  return primary_mode_colors[get_mode()]
end
local secondary_highlight = function()
  return secondary_mode_colors[get_mode()]
end

local left_components_length = 0

------------------------------------- Left -------------------------------------

local ViMode = {
  init = function()
    left_components_length = 4
  end,
  provider = function()
    return "   "
  end,
  hl = primary_highlight,
}

local Git = {
  condition = conditions.is_git_repo,
  init = function(self)
    ---@diagnostic disable-next-line: undefined-field
    self.status_dict = vim.b.gitsigns_status_dict
    self.text = " " .. self.status_dict.head .. " "
    -- Truncate text if it's too long more than 20 characters
    if #self.text > 20 then
      self.text = string.sub(self.text, 1, 20) .. "..."
    end
    left_components_length = left_components_length + vim.api.nvim_eval_statusline(self.text, {}).width
  end,
  provider = function(self)
    return self.text
  end,
  hl = primary_highlight,
}

local Dap = {
  condition = function()
    local session = require("dap").session()
    return session ~= nil
  end,
  init = function(self)
    self.text = "  " .. require("dap").status()
    left_components_length = left_components_length + vim.api.nvim_eval_statusline(self.text, {}).width
  end,
  provider = function(self)
    return self.text
  end,
  hl = primary_highlight,
}

local MacroRec = {
  condition = function()
    return vim.fn.reg_recording() ~= "" and vim.o.cmdheight == 0
  end,
  init = function(self)
    self.text = " " .. vim.fn.reg_recording()
    left_components_length = left_components_length + vim.api.nvim_eval_statusline(self.text, {}).width
  end,
  provider = function(self)
    return self.text
  end,
  hl = { fg = colors.orange, italic = true },
}

local Harpoonline = require("harpoonline")
Harpoonline.setup({
  on_update = function()
    vim.cmd.redrawstatus()
  end,
})
local HarpoonComponent = {
  provider = function()
    return " " .. Harpoonline.format() .. " "
  end,
  -- update = {
  --   "User",
  --   pattern = {
  --     "UpdateHarpoonStatus",
  --     "UpdateHeirlineComponents",
  --   },
  --   callback = vim.schedule_wrap(function()
  --     vim.cmd("redrawstatus")
  --   end),
  -- },
  hl = secondary_highlight,
}

------------------------------------ Center -------------------------------------

local WorkDir = {
  provider = function()
    local icon = " " .. " "
    local cwd = vim.fn.getcwd(0)
    cwd = vim.fn.fnamemodify(cwd, ":~")
    if not conditions.width_percent_below(#cwd, 0.25) then
      cwd = vim.fn.pathshorten(cwd)
    end
    local trail = cwd:sub(-1) == "/" and "" or "/"
    return icon .. cwd .. trail
  end,
  hl = secondary_highlight,
}

------------------------------------ Right -------------------------------------

local Spacer = { provider = " " }
local function rpad(child)
  return {
    condition = child.condition,
    child,
    Spacer,
  }
end

local function OverseerTasksForStatus(status)
  return {
    condition = function(self)
      return self.tasks[status]
    end,
    provider = function(self)
      return string.format("%s%d", self.symbols[status], #self.tasks[status])
    end,
    hl = function()
      return {
        fg = utils.get_highlight(string.format("Overseer%s", status)).fg,
      }
    end,
  }
end

local Overseer = {
  condition = function()
    return package.loaded.overseer
  end,
  init = function(self)
    local tasks = require("overseer.task_list").list_tasks({ unique = true })
    local tasks_by_status = require("overseer.util").tbl_group_by(tasks, "status")
    self.tasks = tasks_by_status
  end,
  static = {
    symbols = {
      ["FAILURE"] = " ",
      ["CANCELED"] = " ",
      ["SUCCESS"] = " ",
      ["RUNNING"] = " ",
    },
  },

  rpad(OverseerTasksForStatus("CANCELED")),
  rpad(OverseerTasksForStatus("RUNNING")),
  rpad(OverseerTasksForStatus("SUCCESS")),
  rpad(OverseerTasksForStatus("FAILURE")),
}

local copilot_icons = {
  Normal = " ",
  Disabled = " ",
  Warning = " ",
  Unknown = " ",
}

local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
local spinner_index = 1
local function get_spinner()
  spinner_index = spinner_index % #spinner + 1
  return spinner[spinner_index]
end

local function get_copilot_icons()
  if copilot_client.is_disabled() then
    return copilot_icons.Disabled
  end
  if copilot_api.status.data.status == "InProgress" then
    return " " .. get_spinner()
  end
  return copilot_icons[copilot_api.status.data.status] or copilot_icons.Unknown
end

local Copilot = {
  condition = function()
    return not copilot_client.is_disabled() and copilot_client.buf_is_attached(vim.api.nvim_get_current_buf())
  end,
  provider = function()
    return " " .. get_copilot_icons() .. " "
  end,
  hl = secondary_highlight,
}

local SearchCount = {
  condition = function()
    return vim.v.hlsearch ~= 0 and vim.o.cmdheight == 0
  end,
  init = function(self)
    local ok, search = pcall(vim.fn.searchcount)
    if ok and search.total then
      self.search = search
    end
  end,
  provider = function(self)
    local search = self.search
    return string.format("[%d/%d] ", search.current, math.min(search.total, search.maxcount))
  end,
  hl = secondary_highlight,
}

local Ruler = {
  -- %l = current line number
  -- %c = column number
  provider = "%3l:%-3c ",
  hl = secondary_highlight,
}

local Date = {
  provider = function()
    return "  " .. os.date("%Hh%M") .. " "
  end,
  hl = primary_highlight,
}

local ScrollBar = {
  static = {
    sbar = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" },
    -- Another variant, because the more choice the better.
    -- sbar = { '🭶', '🭷', '🭸', '🭹', '🭺', '🭻' }
  },
  provider = function(self)
    local curr_line = vim.api.nvim_win_get_cursor(0)[1]
    local lines = vim.api.nvim_buf_line_count(0)
    local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
    return string.rep(self.sbar[i], 2)
  end,
  hl = secondary_highlight,
}

local Left = { ViMode, Git, Dap, HarpoonComponent, MacroRec }
local Center = { WorkDir }
local Align = { provider = "%=", hl = { bg = "none" } }
local Right = { Overseer, ScrollBar }

return { Left, Align, Center, Align, Right }
