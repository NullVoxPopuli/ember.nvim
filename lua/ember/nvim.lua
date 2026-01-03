-- Lua treats dots in paths as /,
-- so these are equiv
--   "ember/nvim"
--   "ember.nvim"

local M = {}

local setup = function()
  -- no-ops if any of these languages are already installed
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

function M.setup()
  vim.api.nvim_create_autocmd('BufReadPre', {
    pattern = '*', -- or e.g. '*.js'
    callback = function(args)
      setup()
    end,
  })
end

return M
