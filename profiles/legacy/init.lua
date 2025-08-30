-- Legacy Neovim Configuration Profile
-- This is your original configuration preserved as a profile

-- Load utils first
local utils_path = vim.fn.stdpath("config") .. "/profiles/legacy/lua/core/utils.lua"
local utils = dofile(utils_path)

-- Bootstrap plugin manager
dofile(vim.fn.stdpath("config") .. "/profiles/legacy/lua/core/bootstrap-plugin-manager.lua")

-- Load plugins
dofile(vim.fn.stdpath("config") .. "/profiles/legacy/lua/core/plugins/init.lua")

-- Load settings
dofile(vim.fn.stdpath("config") .. "/profiles/legacy/lua/core/settings/init.lua")

-- Load keymaps using the import system
local keymaps_path = vim.fn.stdpath("config") .. "/profiles/legacy/lua/core/keymaps/init.lua"
dofile(keymaps_path)

-- Load setup
dofile(vim.fn.stdpath("config") .. "/profiles/legacy/lua/core/setup/init.lua")

-- vim: ts=2 sts=2 sw=2 et
