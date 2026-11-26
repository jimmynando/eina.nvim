local highlight = require("eina.highlight")
local render = require("eina.render")
local sprite = require("eina.sprite")

local M = {}

local state = { buf = nil, win = nil }

-- Bottom-right corner, just above the statusline and command line.
local function window_config(width, height)
  local statusline = vim.o.laststatus > 0 and 1 or 0
  return {
    relative = "editor",
    width = width,
    height = height,
    row = math.max(0, vim.o.lines - vim.o.cmdheight - statusline - height),
    col = math.max(0, vim.o.columns - width - 1),
    style = "minimal",
    focusable = false,
    noautocmd = true,
    zindex = 50,
  }
end

function M.open()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    return
  end

  local lines, marks = render.to_lines(sprite.base)
  local width = vim.fn.strdisplaywidth(lines[1])

  state.buf = vim.api.nvim_create_buf(false, true) -- unlisted scratch buffer
  vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
  highlight.apply(state.buf, marks, sprite.palette)
  vim.bo[state.buf].modifiable = false
  vim.bo[state.buf].bufhidden = "wipe"

  state.win = vim.api.nvim_open_win(state.buf, false, window_config(width, #lines))
  -- Use the editor background instead of the float's, so the pet blends in.
  vim.wo[state.win].winhighlight = "NormalFloat:Normal"
end

function M.close()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, true)
  end
  state.win, state.buf = nil, nil
end

return M
