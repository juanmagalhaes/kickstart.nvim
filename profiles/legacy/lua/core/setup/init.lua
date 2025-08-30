-- Load setup files for legacy profile

-- Load file search setup
dofile(vim.fn.stdpath("config") .. "/profiles/legacy/lua/core/setup/file-search.lua")

-- Load syntax highlight setup
dofile(vim.fn.stdpath("config") .. "/profiles/legacy/lua/core/setup/syntax-highlight.lua")

-- Load language servers setup
dofile(vim.fn.stdpath("config") .. "/profiles/legacy/lua/core/setup/language-servers.lua")

-- Load completion engine setup
dofile(vim.fn.stdpath("config") .. "/profiles/legacy/lua/core/setup/completion-engine.lua")
