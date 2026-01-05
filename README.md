# ember.nvim

## Features

- automatic configuration of
  - treesitter (folding, highlighting)
  - markdown codefences (nested folding, highlighting)
  - language servers
    - ts will be used in non-glint projects
    - glint v1 will be used when detected
    - glint v2 will be used when detected
    - all language servers are scoped to the project, and not editor-instance wide (like vscode), enabling you to have a mix of types of projects in the same repo (or have multiple repos open)

## Setup

```lua
use {
    'NullVoxPopuli/ember.nvim',
    requires = {
        'nvim-treesitter/nvim-treesitter',
    },
    config = function()
        require('ember.nvim').config()
    end
}
```

## Other configuration 

This configuration may interest you, but may be out of scope for this project.

<details><summary>format on save with conform</summary>

```lua
  use {
    'stevearc/conform.nvim',
    config = function()
      local config = { "prettier", stop_after_first = true }

      require('conform').setup({
        formatters_by_ft = {
          -- Use a sub-list to run only the first available formatter
          javascript = config,
          typescript = config,
          ['javascript.glimmer'] = config,
          ['typescript.glimmer'] = config,
        },
        format_on_save = {
          timeout_ms = 1000,
          lsp_fallback = true,
        },
        notify_on_error = false,
        formatters = {
          -- We don't want to enable prettierd
          -- because it requires global installation, and then
          -- we can't even have projects without prettier
          -- NOTE: make sure prettier (and prettierd) are not installed globally
          prettier = {
            require_cwd = true
          }
        }
      })
    end
  }
```

Ensure that your prettier configure in your project is using the "template tag" plugin:

```js
export default {
  printWidth: 100,
  plugins: ["prettier-plugin-ember-template-tag"],
  overrides: [
    {
      // Lol, JavaScript
      files: ["*.js", "*.ts", "*.cjs", ".mjs", ".cts", ".mts", ".gjs", ".gts"],
      options: {
        singleQuote: true,
        templateSingleQuote: false,
        trailingComma: "es5",
      },
    },
  ],
};
```

</details>

## Contributions

Welcome! Any improvement is welcome <3
