-- Sprites are drawn as text: one character per pixel.
-- "." is an empty pixel; any other character is a color from the palette.
-- All frames must have the same size.
local M = {}

M.frames = {
  -- looking straight ahead
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
  -- idle with the eyes closed: "_" draws a thin line instead of a pixel
  blink = {
    "..##.....##..",
    ".####...####.",
    ".####...####.",
    "..####.####..",
    "..#########..",
    "..#.......#..",
    ".#.._..._..#.",
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
  { frame = "idle", ms = 1500 },
  { frame = "blink", ms = 150 },
  { frame = "idle", ms = 1500 },
  { frame = "left", ms = 1000 },
  { frame = "idle", ms = 1500 },
  { frame = "blink", ms = 150 },
  { frame = "idle", ms = 1500 },
  { frame = "right", ms = 1000 },
}

-- Colors are hex codes or color names (see :help gui-colors).
M.palette = {
  ["#"] = "#ebdbb2", -- light cream, readable on dark themes
  ["_"] = "#ebdbb2", -- the closed eyes, same cream
}

return M
