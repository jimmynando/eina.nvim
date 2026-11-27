# Records demo.gif for the README with VHS (https://github.com/charmbracelet/vhs).
#
# Run from the repo root:
#   vhs demo.tape
#
# Neovim starts with --clean (no personal config) and loads eina from this
# folder, so the recording looks the same on any machine.

Output demo.gif

Set FontSize 18
Set Width 900
Set Height 600
Set TypingSpeed 80ms

# Start Neovim off camera.
Hide
Type `nvim --clean --cmd "set rtp+=."`
Enter
Sleep 1s
Show

Sleep 500ms
Type ":Eina"
Sleep 300ms
Enter

# One full animation loop: blink, look left, shiver, blink, look right.
Sleep 10.5s
