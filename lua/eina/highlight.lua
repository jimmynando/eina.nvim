-- Colors the rendered sprite: one highlight group per fg/bg combination,
-- applied to the buffer with extmarks.
local M = {}

M.ns = vim.api.nvim_create_namespace("eina")

-- Every group we've defined, so we can restore them after :colorscheme
-- (switching colorschemes clears highlight groups it doesn't know about).
local defined = {}

-- The habitat's floor matches the border color. `default = true` lets users
-- override it with their own EinaFloor highlight.
defined.EinaFloor = { link = "FloatBorder", default = true }
vim.api.nvim_set_hl(0, "EinaFloor", defined.EinaFloor)

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("eina_highlight", { clear = true }),
  callback = function()
    for name, spec in pairs(defined) do
      vim.api.nvim_set_hl(0, name, spec)
    end
  end,
})

-- Group names can't contain characters like "#", so use their byte codes:
-- "#" on top of "o" -> EinaFg35Bg111.
local function group_for(palette, fg, bg)
  local name = "EinaFg" .. fg:byte() .. (bg and ("Bg" .. bg:byte()) or "")
  local spec = { fg = palette[fg], bg = bg and palette[bg] or nil }
  defined[name] = spec
  vim.api.nvim_set_hl(0, name, spec)
  return name
end

function M.apply(buf, marks, palette)
  vim.api.nvim_buf_clear_namespace(buf, M.ns, 0, -1)
  for _, mark in ipairs(marks) do
    vim.api.nvim_buf_set_extmark(buf, M.ns, mark.row, mark.col, {
      end_col = mark.end_col,
      -- A mark either names its group directly, or gets one from its colors.
      hl_group = mark.group or group_for(palette, mark.fg, mark.bg),
    })
  end
end

return M
