-- Turns a sprite into text lines using half-blocks.
-- A terminal cell is about twice as tall as it is wide, so each cell holds
-- two square pixels stacked vertically: "▀" = top only, "▄" = bottom only.
local M = {}

local EMPTY = "."

local function is_filled(pixel)
  return pixel ~= nil and pixel ~= "" and pixel ~= EMPTY
end

-- Returns a list of strings, one per text row (ceil(height / 2) rows).
function M.to_lines(sprite)
  local lines = {}
  for y = 1, #sprite, 2 do
    local top = sprite[y]
    local bottom = sprite[y + 1] or "" -- odd height: last bottom row is empty
    local cells = {}
    for x = 1, #top do
      local t = is_filled(top:sub(x, x))
      local b = is_filled(bottom:sub(x, x))
      if t and b then
        cells[x] = "█"
      elseif t then
        cells[x] = "▀"
      elseif b then
        cells[x] = "▄"
      else
        cells[x] = " "
      end
    end
    lines[#lines + 1] = table.concat(cells)
  end
  return lines
end

return M
