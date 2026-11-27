local habitat = require("eina.habitat")
local highlight = require("eina.highlight")
local render = require("eina.render")
local sprite = require("eina.sprite")

local M = {}

local state = {
  buf = nil,
  win = nil,
  width = 0,
  height = 0,
  -- Bar values from 0 to 100. Fixed for now: nothing changes them yet.
  status = { mood = 100, satiety = 100 },
  timer = nil, -- plays the animation while the window is open
  step = 1, -- which step of sprite.animation is showing
}

local BORDER = 2 -- the border adds one cell on each side

-- Center of the screen. `width` and `height` are the inside of the box;
-- the border comes on top.
local function position(width, height)
  return {
    relative = "editor",
    row = math.max(0, math.floor((vim.o.lines - (height + BORDER)) / 2)),
    col = math.max(0, math.floor((vim.o.columns - (width + BORDER)) / 2)),
  }
end

local function window_config(width, height)
  return vim.tbl_extend("force", position(width, height), {
    width = width,
    height = height,
    border = "rounded",
    title = " eina ",
    title_pos = "left",
    style = "minimal",
    focusable = false,
    noautocmd = true,
    zindex = 50,
  })
end

function M.is_open()
  return state.win ~= nil and vim.api.nvim_win_is_valid(state.win)
end

-- Fills the buffer with the whole habitat, showing eina with one frame.
local function draw(frame)
  local sprite_lines, sprite_marks = render.to_lines(sprite.frames[frame])
  local sprite_width = vim.fn.strdisplaywidth(sprite_lines[1])
  local x = math.floor((habitat.width - sprite_width) / 2) -- in the middle
  local lines, marks = habitat.build(sprite_lines, sprite_marks, x, state.status)

  vim.bo[state.buf].modifiable = true
  vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
  vim.bo[state.buf].modifiable = false
  highlight.apply(state.buf, marks, sprite.palette)
end

local function stop_animation()
  if state.timer then
    state.timer:stop()
    state.timer:close()
    state.timer = nil
  end
end

-- Shows the current step of the animation, then sets the timer to show the
-- next one after this step's `ms`. The timer fires once per step, because
-- each step can last a different time.
local function play()
  if not M.is_open() then
    stop_animation() -- the window was closed some other way (e.g. :only)
    return
  end
  local step = sprite.animation[state.step]
  draw(step.frame)
  state.step = state.step % #sprite.animation + 1 -- after the last, back to 1
  -- The timer calls back from outside Neovim's main loop, where most of
  -- Neovim's functions can't be used; schedule_wrap moves the call back in.
  state.timer:start(step.ms, 0, vim.schedule_wrap(play))
end

function M.open()
  if M.is_open() then
    return
  end

  state.width = habitat.width
  state.height = habitat.height
  state.buf = vim.api.nvim_create_buf(false, true) -- unlisted scratch buffer
  vim.bo[state.buf].bufhidden = "wipe"

  state.win = vim.api.nvim_open_win(state.buf, false, window_config(state.width, state.height))
  -- Use the editor background instead of the float's, so the pet blends in.
  vim.wo[state.win].winhighlight = "NormalFloat:Normal"

  stop_animation() -- in case a timer from a window closed with :only is left
  state.timer = vim.uv.new_timer()
  state.step = 1
  play()
end

function M.close()
  stop_animation()
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

-- Stay centered when the terminal is resized. Registered once, when the
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
