local extension = require("nvim-paredit-fennel.extension")

local M = {
  extension = extension
}

function M.setup()
  local paredit = require("nvim-paredit")
  paredit.extension.add_language_extension("fennel", extension)
end

return M
