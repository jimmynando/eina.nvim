-- Neovim runs this file at startup. Keep it small: the plugin's code is only
-- loaded (require) the first time the command is used.
if vim.g.loaded_eina then
  return
end
vim.g.loaded_eina = true

vim.api.nvim_create_user_command("Eina", function()
  require("eina").toggle()
end, { desc = "Show or hide the eina pet" })
