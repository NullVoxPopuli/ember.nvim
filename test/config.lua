-- This example dosen't use a package manager.
-- Exact details for how to get plugins will depend on your package manager,
--   if you're using one.


local this_folder = vim.fs.dirname(debug.getinfo(1, "S").source:sub(2))
local this_plugin = vim.fs.dirname(this_folder)
local tmp = assert(vim.uv.fs_mkdtemp(vim.fn.tempname() .. "-nvim-XXXXXX"))

vim.print("Plugin path is " .. this_plugin)
vim.print("Plugins will be stored in :: '" .. tmp .. "'")

vim.opt.termguicolors = true
vim.cmd.syntax("on")

vim.env.XDG_DATA_HOME = tmp
local site = vim.fs.joinpath(vim.fn.stdpath("data"), "site")

vim.fn.mkdir(site, "p")
vim.opt.packpath:prepend(site)
vim.pack.add({
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
  { src = 'file://' .. this_plugin }
})


require 'nvim-treesitter'.setup {
  -- only needed because we launch with --clean
  install_dir = vim.fn.stdpath('data') .. '/site'
}

require('ember.nvim').config()

vim.opt.runtimepath:append(this_plugin)
