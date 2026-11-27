-- Turns a sprite into text lines using half-blocks.
-- A terminal cell is about twice as tall as it is wide, so each cell holds
-- two square pixels stacked vertically: "▀" = top only, "▄" = bottom only.
local M = {}

local EMPTY = "."
-- Not a pixel: a line drawn across the middle of its cell ("━"), thinner
-- than a pixel can be. It takes the whole cell, so the other pixel sharing
-- the cell is ignored. Its color comes from the palette like any pixel.
local LINE = "_"

local function is_filled(pixel)
  return pixel ~= "" and pixel ~= EMPTY
end

-- Picks the character for one cell, plus which pixel colors it as
-- foreground (fg) and background (bg). Empty halves get no bg, so the
-- window background shows through.
local function cell(top, bottom)
  if top == LINE or bottom == LINE then
    return "━", LINE
  end
  local t, b = is_filled(top), is_filled(bottom)
  if t and b then
    if top == bottom then
      return "█", top
    end
    return "▀", top, bottom
  elseif t then
    return "▀", top
  elseif b then
    return "▄", bottom
  end
  return " "
end

-- Returns two lists:
--   lines: one string per text row (ceil(height / 2) rows)
--   marks: one entry per colored cell, { row, col, end_col, fg, bg }
--          rows/cols are 0-based byte positions (what extmarks expect);
--          fg/bg are palette characters, bg may be nil
function M.to_lines(sprite)
  local lines, marks = {}, {}
  for y = 1, #sprite, 2 do
    local top_row = sprite[y]
    local bottom_row = sprite[y + 1] or "" -- odd height: last bottom row is empty
    local row = #lines
    local cells, col = {}, 0
    for x = 1, #top_row do
      local char, fg, bg = cell(top_row:sub(x, x), bottom_row:sub(x, x))
      cells[x] = char
      if fg then
        marks[#marks + 1] = { row = row, col = col, end_col = col + #char, fg = fg, bg = bg }
      end
      col = col + #char -- block characters are 3 bytes, spaces are 1
    end
    lines[#lines + 1] = table.concat(cells)
  end
  return lines, marks
end

return M
