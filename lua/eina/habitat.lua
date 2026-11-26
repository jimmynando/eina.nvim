-- The box eina lives in: a row of air on top, then the pet standing on a
-- floor line. The box is wider than the pet so it has room to move later.
local M = {}

M.width = 30 -- inside the border, in columns

local FLOOR = "▔"

-- Places a rendered sprite (the lines and marks from render.to_lines) in the
-- habitat, `x` columns from the left edge. Returns the habitat's lines and
-- marks; the floor's mark uses the EinaFloor highlight group.
function M.build(sprite_lines, sprite_marks, x)
  local pad = string.rep(" ", x)

  local lines = { "" } -- air above the pet
  for _, line in ipairs(sprite_lines) do
    lines[#lines + 1] = pad .. line
  end
  lines[#lines + 1] = string.rep(FLOOR, M.width)

  -- Shift the sprite's colors by the same amount as its text:
  -- one row down (the air) and `x` bytes right (the padding spaces).
  local marks = {}
  for _, mark in ipairs(sprite_marks) do
    marks[#marks + 1] = {
      row = mark.row + 1,
      col = mark.col + x,
      end_col = mark.end_col + x,
      fg = mark.fg,
      bg = mark.bg,
    }
  end
  marks[#marks + 1] = { row = #lines - 1, col = 0, end_col = #lines[#lines], group = "EinaFloor" }

  return lines, marks
end

return M
