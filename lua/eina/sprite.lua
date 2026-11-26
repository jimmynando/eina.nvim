-- Sprites are drawn as text: one character per pixel.
-- "." is an empty pixel; any other character is a color from the palette.
local M = {}

M.base = {
  "..##.....##..",
  ".####...####.",
  ".####...####.",
  "..####.####..",
  "..#########..",
  "..#.......#..",
  ".#.#.....#.#.",
  ".#...###...#.",
  "##.........##",
  "##.........##",
  ".#.........#.",
  "..##.....##..",
  "...#######...",
}

-- Colors are hex codes or color names (see :help gui-colors).
M.palette = { ["#"] = "#ebdbb2" } -- light cream, readable on dark themes

return M
