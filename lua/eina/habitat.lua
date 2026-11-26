-- The box eina lives in, top to bottom:
--   actions row   [f] Feed   [b] Books ...
--   air           (empty rows, however many fit)
--   the pet       standing on...
--   the floor     ▔▔▔▔▔▔▔▔
--   status bars   mood and satiety
-- The box is wider than the pet so it has room to move later.
local M = {}

M.width = 44 -- inside the border, in columns
M.height = 14

-- Shown above eina. Display only for now: the keys don't do anything yet.
M.actions = {
  { key = "f", label = "Feed" },
  { key = "b", label = "Books" },
  { key = "s", label = "Stats" },
  { key = "q", label = "Close" },
}

local FLOOR = "▔"
local LOW = 30 -- bars turn red below this percentage
local LABEL_WIDTH = 8 -- "Satiety" plus a space
-- What's left after " " + label and a 1-column right margin.
local BAR_WIDTH = M.width - 1 - LABEL_WIDTH - 1

-- Joins text pieces into one line. Each piece is { text, group }; pieces with
-- a group get a mark so they're colored. Returns the line and its marks.
local function join(row, pieces)
  local texts, marks, col = {}, {}, 0
  for _, piece in ipairs(pieces) do
    local text, group = piece[1], piece[2]
    texts[#texts + 1] = text
    if group then
      marks[#marks + 1] = { row = row, col = col, end_col = col + #text, group = group }
    end
    col = col + #text -- in bytes, since block characters take 3
  end
  return table.concat(texts), marks
end

local function actions_pieces()
  local pieces = { { " " } }
  for i, action in ipairs(M.actions) do
    if i > 1 then
      pieces[#pieces + 1] = { "  " }
    end
    pieces[#pieces + 1] = { "[" .. action.key .. "]", "EinaKey" }
    pieces[#pieces + 1] = { " " .. action.label }
  end
  return pieces
end

-- A bar like " Mood    ████████████░░░░░░". `percent` goes from 0 to 100.
local function bar_pieces(label, percent, group)
  percent = math.max(0, math.min(100, percent))
  local filled = math.floor(percent / 100 * BAR_WIDTH + 0.5)
  return {
    { " " .. label .. string.rep(" ", LABEL_WIDTH - #label) },
    { string.rep("█", filled), percent < LOW and "EinaLow" or group },
    { string.rep("░", BAR_WIDTH - filled), "EinaBarEmpty" },
  }
end

-- Lays out the whole habitat. `sprite_lines` and `sprite_marks` come from
-- render.to_lines; `x` is how many columns from the left edge the pet stands;
-- `status` holds the bar values, e.g. { mood = 100, satiety = 80 }.
-- Returns the habitat's lines and marks.
function M.build(sprite_lines, sprite_marks, x, status)
  local lines, marks = {}, {}
  local function add(pieces)
    local line, line_marks = join(#lines, pieces)
    lines[#lines + 1] = line
    vim.list_extend(marks, line_marks)
  end

  add(actions_pieces())

  -- Whatever height is left over becomes air, so the pet always stands on
  -- the floor and the box keeps the same size.
  local air = M.height - #sprite_lines - 5 -- actions, floor, 2 bars and the gap between them
  for _ = 1, air do
    add({})
  end

  -- Shift the sprite's colors by the same amount as its text:
  -- down past the rows above it, and `x` bytes right (the padding spaces).
  local top = #lines
  for _, line in ipairs(sprite_lines) do
    lines[#lines + 1] = string.rep(" ", x) .. line
  end
  for _, mark in ipairs(sprite_marks) do
    marks[#marks + 1] = {
      row = mark.row + top,
      col = mark.col + x,
      end_col = mark.end_col + x,
      fg = mark.fg,
      bg = mark.bg,
    }
  end

  add({ { string.rep(FLOOR, M.width), "EinaFloor" } })
  add(bar_pieces("Mood", status.mood, "EinaMood"))
  add({}) -- gap between the bars
  add(bar_pieces("Satiety", status.satiety, "EinaSatiety"))

  return lines, marks
end

return M
