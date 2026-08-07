-- Lua treats dots in paths as /,
-- so these are equiv
--   "ember/nvim"
--   "ember.nvim"

local M = {}

function M.config()
  require('ember.lsp.typescript')
end

-- Parser revisions that ember.nvim pins, overriding nvim-treesitter's bundled
-- pins. nvim-treesitter (main) is archived and won't re-pin, so its versions
-- lag behind upstream fixes (e.g. the glimmer comment-with-equals parsing fix).
-- Bump these as the upstream parsers gain fixes worth shipping.
M.parser_revisions = {
  glimmer = {
    url = 'https://github.com/ember-tooling/tree-sitter-glimmer',
    revision = 'c67a73679db2945a686ca45d3e5318d86138e72a',
  },
  glimmer_javascript = {
    url = 'https://github.com/ember-tooling/tree-sitter-glimmer-javascript',
    revision = 'd9cf7a2f1dad3c6b660148eaf77e955d418fdb8b',
  },
  glimmer_typescript = {
    url = 'https://github.com/ember-tooling/tree-sitter-glimmer-typescript',
    revision = '12d98944c1d5077b957cbdb90d663a7c4d50118c',
  },
}

function M.setup()
  -- nvim-treesitter reloads its parsers table right before every install /
  -- update (reload_parsers()), which wipes any one-time mutation of
  -- install_info. The documented extension point is the `User TSUpdate`
  -- autocmd it fires afterward, so re-apply our pins there. Registered before
  -- install{} below so that the install picks them up too.
  vim.api.nvim_create_autocmd('User', {
    pattern = 'TSUpdate',
    callback = function()
      local parsers = require('nvim-treesitter.parsers')
      for lang, info in pairs(M.parser_revisions) do
        if parsers[lang] then
          parsers[lang].install_info = {
            url = info.url,
            revision = info.revision,
          }
        end
      end
    end,
  })

  local treesitter = require 'nvim-treesitter'
  local languages = {
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

  -- Existing parsers can outlive their query files after a plugin migration.
  -- nvim-treesitter.install() skips those parsers, so force only the languages
  -- whose queries are actually missing.
  local query_dir = require('nvim-treesitter.config').get_install_dir('queries')
  local missing_queries = {}
  for _, language in ipairs(languages) do
    if not vim.uv.fs_stat(vim.fs.joinpath(query_dir, language)) then
      missing_queries[#missing_queries + 1] = language
    end
  end

  local complete_languages = {}
  for _, language in ipairs(languages) do
    if not vim.list_contains(missing_queries, language) then
      complete_languages[#complete_languages + 1] = language
    end
  end

  if #complete_languages > 0 then
    treesitter.install(complete_languages)
  end
  if #missing_queries > 0 then
    treesitter.install(missing_queries, { force = true })
  end

  -- These aliases are needed for markdown highlighting
  vim.treesitter.language.register('glimmer_javascript', 'gjs')
  vim.treesitter.language.register('glimmer_typescript', 'gts')
  vim.treesitter.language.register('glimmer', 'hbs')


  vim.api.nvim_create_autocmd('FileType', {
    pattern = {
      'javascript', 'typescript',
      'html', 'css',
      'handlebars', 'glimmer', 'javascript.glimmer', 'typescript.glimmer',
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
