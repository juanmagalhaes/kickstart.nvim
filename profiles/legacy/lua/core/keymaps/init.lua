-- Load keymaps for legacy profile

-- Load general keymaps
dofile(vim.fn.stdpath("config") .. "/profiles/legacy/lua/core/keymaps/general.lua")

-- Load file search keymaps
dofile(vim.fn.stdpath("config") .. "/profiles/legacy/lua/core/keymaps/file-search.lua")
