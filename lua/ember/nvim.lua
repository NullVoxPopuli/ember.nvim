-- Lua treats dots in paths as /,
-- so these are equiv
--   "ember/nvim"
--   "ember.nvim"

local M = {}

function M.config()
  require('ember.lsp.typescript')
end

function M.setup()
  -- vim.api.nvim_create_autocmd('User', {
  --   pattern = 'TSUpdate',
  --   callback = function()
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
  --   end
  -- })

  -- Needed for markdown highlighting
  vim.treesitter.language.register('glimmer_javascript', 'gjs')
  vim.treesitter.language.register('glimmer_typescript', 'gts')
  vim.treesitter.language.register('glimmer', 'hbs')


  vim.api.nvim_create_autocmd('FileType', {
    pattern = {
      'javascript', 'typescript',
      'html', 'css',
      'glimmer', 'javascript.glimmer', 'typescript.glimmer',
      'markdown',
    },
    callback = function()
      -- Folding
      vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      vim.wo[0][0].foldmethod = 'expr'

      -- indentation
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

      -- Fancy!
      vim.treesitter.start()
    end,
  })
end

return M
