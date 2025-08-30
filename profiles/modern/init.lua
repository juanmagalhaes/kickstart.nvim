-- Modern Neovim Configuration Profile
-- Clean, organized configuration with best practices

-- Bootstrap plugin manager
dofile(vim.fn.stdpath("config") .. "/profiles/modern/core/bootstrap.lua")

-- Load core modules
dofile(vim.fn.stdpath("config") .. "/profiles/modern/core/options.lua")
dofile(vim.fn.stdpath("config") .. "/profiles/modern/core/keymaps.lua")
dofile(vim.fn.stdpath("config") .. "/profiles/modern/core/autocmds.lua")

-- Load plugins
dofile(vim.fn.stdpath("config") .. "/profiles/modern/plugins/init.lua")

-- Load LSP and completion setup
dofile(vim.fn.stdpath("config") .. "/profiles/modern/core/lsp.lua")
dofile(vim.fn.stdpath("config") .. "/profiles/modern/core/completion.lua")

-- vim: ts=2 sts=2 sw=2 et
