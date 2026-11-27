-- Sprites are drawn as text: one character per pixel.
-- "." is an empty pixel; any other character is a color from the palette.
-- All frames must have the same size.
local M = {}

M.frames = {
  -- assets/eina.png, without the mouth
  idle = {
    "..##.....##..",
    ".####...####.",
    ".####...####.",
    "..####.####..",
    "..#########..",
    "..#.......#..",
    ".#..#...#..#.",
    ".#.........#.",
    "##.........##",
    "##.........##",
    ".#.........#.",
    "..##.....##..",
    "...#######...",
  },
  -- idle with both eyes one square to the left
  left = {
    "..##.....##..",
    ".####...####.",
    ".####...####.",
    "..####.####..",
    "..#########..",
    "..#.......#..",
    ".#.#...#...#.",
    ".#.........#.",
    "##.........##",
    "##.........##",
    ".#.........#.",
    "..##.....##..",
    "...#######...",
  },
  -- idle with both eyes one square to the right
  right = {
    "..##.....##..",
    ".####...####.",
    ".####...####.",
    "..####.####..",
    "..#########..",
    "..#.......#..",
    ".#...#...#.#.",
    ".#.........#.",
    "##.........##",
    "##.........##",
    ".#.........#.",
    "..##.....##..",
    "...#######...",
  },
}

-- Played in a loop while eina is open: show each frame for `ms`
-- milliseconds, then move on to the next.
M.animation = {
  { frame = "idle", ms = 3000 },
  { frame = "left", ms = 1000 },
  { frame = "idle", ms = 3000 },
  { frame = "right", ms = 1000 },
}

-- Colors are hex codes or color names (see :help gui-colors).
M.palette = { ["#"] = "#ebdbb2" } -- light cream, readable on dark themes

return M
