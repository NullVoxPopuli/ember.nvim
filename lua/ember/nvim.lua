-- Lua treats dots in paths as /, so this plugin name is equiv of
-- "ember/nvim"

local M = {}

function M.setup()
  require 'nvim-treesitter'.install {
    -- Web Languages
    "javascript", "typescript",
    "html", "css", "regex",
    -- Web Framework Languages
    "glimmer", "glimmer_javascript", "glimmer_typescript",
    -- Documentation Languages
    "markdown", "markdown_inline",
    -- "help", -- missing?
    -- "comment", -- slow?
    "jsdoc",
  }

  -- Needed for markdown highlighting
  vim.treesitter.language.register('glimmer_javascript', 'gjs')
  vim.treesitter.language.register('glimmer_typescript', 'gts')
end

return M
