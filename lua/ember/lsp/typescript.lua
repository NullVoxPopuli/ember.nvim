local utils = require('ember.lsp.utils')

local tsFiletypes = {
  'typescript',
  'javascript',
  'typescript.glimmer',
  'javascript.glimmer',
  'typescript.tsx',
  'javascript.jsx',
}
local allFiletypes = {
  'typescript',
  'javascript',
  'typescript.glimmer',
  'javascript.glimmer',
  'typescript.tsx',
  'javascript.jsx',
  'html.handlebars',
  'handlebars',
}


-- https://neovim.io/doc/user/lsp.html
vim.lsp.config('ts_ls', {
  -- This allows us to switch types of TSServers based on the open file.
  -- We don't always need the @glint/tsserver-plugin -- for example, in backend projects.
  root_dir = utils.is_ts_project,
  settings = {
    hostInfo = "neovim native TS LS",
    maxTsServerMemory = 8000,
  },
  init_options = {
    -- https://github.com/typescript-language-server/typescript-language-server/blob/master/docs/configuration.md#preferences-options
    preferences = {
      disableAutomaticTypingAcquisition = true,
      importModuleSpecifierPreference = "shortest",
      importModuleSpecifierEnding = "auto",
    },
    -- tsserver = { logVerbosity = 'verbose', trace = "verbose" },
    plugins = {
      -- All plugins need to be defined here,
      -- even if we have to change the location later
      {
        name = "@glint/tsserver-plugin",
        location = "/your/path/to/@glint/tsserver-plugin",
        languages = tsFiletypes
      },
    },
  },
  filetypes = tsFiletypes,
  on_new_config = function(new_config, new_root_dir)
    local info = utils.read_nearest_ts_config(new_root_dir)
    local glintPlugin = new_root_dir .. "node_modules/@glint/tsserver-plugin"

    if new_config.init_options then
      if (info.isGlintPlugin) then
        new_config.init_options.plugins = {
          {
            name = "@glint/tsserver-plugin",
            location = glintPlugin,
            languages = tsFiletypes,
            enableForWorkspaceTypeScriptVersions = true,
            configNamespace = "typescript"
          }
        }
      end
    end
  end,
})


vim.lsp.config('glint', {
  root_dir = utils.is_glint_v1_project,
  filetypes = allFiletypes,
})

-- TypeScript 7's native LSP (nvim-lspconfig's `tsc`), for projects that
-- declare `contentMappers` in tsconfig.json (e.g. ember-content-mapper).
-- The mapper transforms gts/gjs for TypeScript itself, so ts_ls and glint
-- both stay detached in these projects (see lsp/utils.lua).
vim.lsp.config('tsc', {
  root_dir = utils.is_content_mapper_project,
  filetypes = tsFiletypes,
  init_options = {
    -- Content mappers spawn processes declared by the project, so TypeScript
    -- requires this explicit opt-in (VS Code sends it for trusted workspaces).
    runExternalCode = true,
  },
  get_language_id = function(_, filetype)
    if filetype == 'typescript.glimmer' then
      return 'typescript'
    end

    if filetype == 'javascript.glimmer' then
      return 'javascript'
    end

    return filetype
  end,
})

vim.lsp.enable('ts_ls')
vim.lsp.enable('glint')
vim.lsp.enable('tsc')
