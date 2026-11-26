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

M.palette = { ["#"] = "black" }

return M
