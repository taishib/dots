local separator_char = "-"
local unfocused = "NonText"
local focused = "Identifier"

local function get_diagnostic_label(props)
  local icons = require("lazyvim.config").icons.diagnostics
  local label = {}

  for severity, icon in pairs(icons) do
    local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
    if n > 0 then
      table.insert(label, { icon .. n .. " ", group = props.focused and "DiagnosticSign" .. severity or unfocused })
    end
  end
  return label
end

local function get_git_diff(props)
  local git_icons = require("lazyvim.config").icons.git
  local icons = { removed = git_icons.removed, changed = git_icons.modified, added = git_icons.added }
  local highlight = { removed = "GitSignsDelete", changed = "GitSignsChange", added = "GitSignsAdd" }
  local labels = {}
  local ok, signs = pcall(vim.api.nvim_buf_get_var, props.buf, "gitsigns_status_dict")
  if ok then
    for name, icon in pairs(icons) do
      if tonumber(signs[name]) and signs[name] > 0 then
        table.insert(labels, {
          icon .. signs[name] .. " ",
          group = props.focused and highlight[name] or unfocused,
        })
      end
    end
  end
  return labels
end

local function get_toggleterm_id(props)
  local id = " " .. vim.fn.bufname(props.buf):sub(-1) .. " "
  return { { id, group = props.focused and "FloatTitle" or "Title" } }
end

local function is_toggleterm(bufnr)
  return vim.bo[bufnr].filetype == "toggleterm"
end

local edgy_filetypes = {
  "neotest-output-panel",
  "neotest-summary",
  "noice",
  "Trouble",
  "OverseerList",
  "Outline",
  "ogpt-popup",
  "ogpt-parameters-window",
  "ogpt-template",
  "ogpt-sessions",
  "ogpt-system-window",
  "ogpt-window",
  "ogpt-selection",
  "ogpt-instruction",
  "ogpt-input",
  "trouble",
  "copilot-chat",
}

local edgy_titles = {
  ["neotest-output-panel"] = "neotest",
  ["neotest-summary"] = "neotest",
  noice = "noice",
  Trouble = "trouble",
  OverseerList = "overseer",
  Outline = "outline",
  ["ogpt-popup"] = "ogpt-popup",
  ["ogpt-parameters-window"] = "ogpt-parameters-window",
  ["ogpt-template"] = "ogpt-template",
  ["ogpt-sessions"] = "ogpt-sessions",
  ["ogpt-system-window"] = "ogpt-system-window",
  ["ogpt-window"] = "ogpt-window",
  ["ogpt-selection"] = "ogpt-selection",
  ["ogpt-instruction"] = "ogpt-instruction",
  ["ogpt-input"] = "ogpt-input",
}

local function is_edgy_group(props, filename)
  return vim.tbl_contains(edgy_filetypes, vim.bo[props.buf].filetype)
end

local function get_trouble_name(props)
  local win_trouble = vim.w[props.win].trouble
  local trouble_name = win_trouble and win_trouble.mode or ""
  return trouble_name == "" and "trouble" or trouble_name
end

local function get_title(props, filename)
  local filetype = vim.bo[props.buf].filetype
  local name = edgy_titles[filetype] or filetype or filename
  name = filetype == "trouble" and get_trouble_name(props) or name
  local title = " " .. name .. " "
  return { { title, group = props.focused and "FloatTitle" or "Title" } }
end

require("incline").setup({
  window = {
    zindex = 30,
    margin = {
      vertical = { top = vim.o.laststatus == 3 and 0 or 1, bottom = 0 }, -- shift to overlap window borders
      horizontal = { left = 0, right = 2 }, -- shift for scrollbar
    },
    overlap = {
      borders = true,
      statusline = true,
      tabline = false,
      winbar = true,
    },
  },
  hide = {
    cursorline = false,
  },
  ignore = {
    buftypes = {},
    filetypes = { "neo-tree", "dashboard" },
    unlisted_buffers = false,
  },
  render = function(props)
    local filename = vim.fn.fnamemodify(vim.fn.bufname(props.buf), ":t")

    if is_toggleterm(props.buf) then
      return get_toggleterm_id(props)
    end

    if is_edgy_group(props, filename) then
      return get_title(props, filename)
    end

    local filetype_icon, filetype_color = require("nvim-web-devicons").get_icon_color(filename)
    local diagnostics = get_diagnostic_label(props)
    local diffs = get_git_diff(props)

    local color = props.focused and focused or unfocused
    local icon = props.focused and { filetype_icon, guifg = filetype_color } or { filetype_icon, group = unfocused }
    local separator = (#diagnostics > 0 and #diffs > 0) and { separator_char .. " ", group = color } or ""
    local filename_separator = (#diagnostics > 0 or #diffs > 0) and { " " .. separator_char .. " ", group = color }
      or ""

    local filename_component =
      { icon, { filetype_icon and " " or "" }, { filename, group = color }, filename_separator }

    if vim.bo[props.buf].buflisted then
      filename_component = {}
    end

    local buffer = {
      filename_component,
      { diagnostics },
      { separator },
      { diffs },
    }
    return buffer
  end,
})
