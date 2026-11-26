local highlight = require("eina.highlight")
local render = require("eina.render")
local sprite = require("eina.sprite")

local M = {}

local state = { buf = nil, win = nil, width = 0, height = 0 }

-- Bottom-right corner, just above the statusline and command line.
local function position(width, height)
  local statusline = vim.o.laststatus > 0 and 1 or 0
  return {
    relative = "editor",
    row = math.max(0, vim.o.lines - vim.o.cmdheight - statusline - height),
    col = math.max(0, vim.o.columns - width - 1),
  }
end

local function window_config(width, height)
  return vim.tbl_extend("force", position(width, height), {
    width = width,
    height = height,
    style = "minimal",
    focusable = false,
    noautocmd = true,
    zindex = 50,
  })
end

function M.is_open()
  return state.win ~= nil and vim.api.nvim_win_is_valid(state.win)
end

function M.open()
  if M.is_open() then
    return
  end

  local lines, marks = render.to_lines(sprite.base)
  state.width = vim.fn.strdisplaywidth(lines[1])
  state.height = #lines

  state.buf = vim.api.nvim_create_buf(false, true) -- unlisted scratch buffer
  vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
  highlight.apply(state.buf, marks, sprite.palette)
  vim.bo[state.buf].modifiable = false
  vim.bo[state.buf].bufhidden = "wipe"

  state.win = vim.api.nvim_open_win(state.buf, false, window_config(state.width, state.height))
  -- Use the editor background instead of the float's, so the pet blends in.
  vim.wo[state.win].winhighlight = "NormalFloat:Normal"
end

function M.close()
  if M.is_open() then
    vim.api.nvim_win_close(state.win, true)
  end
  state.win, state.buf = nil, nil
end

function M.toggle()
  if M.is_open() then
    M.close()
  else
    M.open()
  end
end

-- Stay in the corner when the terminal is resized. Registered once, when the
-- module loads, so it can't pile up; it does nothing while the pet is closed.
vim.api.nvim_create_autocmd("VimResized", {
  group = vim.api.nvim_create_augroup("eina_window", { clear = true }),
  callback = function()
    if M.is_open() then
      vim.api.nvim_win_set_config(state.win, position(state.width, state.height))
    end
  end,
})

return M
