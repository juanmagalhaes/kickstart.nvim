-- Neovim Profile-Based Configuration
-- This init.lua loads different configuration profiles based on config.lua

-- Set leader key early
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Load profile configuration
local config_path = vim.fn.stdpath("config") .. "/config.lua"
local config = dofile(config_path)

-- Load the selected profile
local profile_path = vim.fn.stdpath("config") .. "/profiles/" .. config.profile .. "/init.lua"

if vim.fn.filereadable(profile_path) == 1 then
  vim.notify('Loading profile: ' .. config.profile, vim.log.levels.INFO)
  dofile(profile_path)
else
  vim.notify('Failed to load profile: ' .. profile_path, vim.log.levels.ERROR)
  -- Fallback to legacy profile
  vim.notify('Falling back to legacy profile', vim.log.levels.WARN)
  local legacy_path = vim.fn.stdpath("config") .. "/profiles/legacy/init.lua"
  if vim.fn.filereadable(legacy_path) == 1 then
    dofile(legacy_path)
  else
    vim.notify('Legacy profile also not found!', vim.log.levels.ERROR)
  end
end

-- vim: ts=2 sts=2 sw=2 et
