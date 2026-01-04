-- Lua treats dots in paths as /,
-- so these are equiv
--   "ember/nvim"
--   "ember.nvim"

local M = {}

function M.config()
  require('ember.lsp.typescript')
end

function M.setup()
  vim.api.nvim_create_autocmd('User', {
    pattern = 'TSUpdate',
    callback = function()
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
    end
  })

  -- Needed for markdown highlighting
  vim.treesitter.language.register('glimmer_javascript', 'gjs')
  vim.treesitter.language.register('glimmer_typescript', 'gts')
end

return M
