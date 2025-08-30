-- [[ Configure Telescope ]]

-- Check if telescope is available
local has_telescope, telescope = pcall(require, 'telescope')

if has_telescope then
  -- See `:help telescope` and `:help telescope.setup()`
  telescope.setup {
    defaults = {
      mappings = {
        i = {
          ['<C-u>'] = false,
          ['<C-d>'] = false,
        },
      },
      file_ignore_patterns = { ".git/", ".cache", "%.o", "%.a", "%.out", "%.class",
        "%.pdf", "%.mkv", "%.mp4", "%.zip" },
    },
  }

  -- Enable telescope fzf native, if installed
  pcall(telescope.load_extension, 'fzf')
else
  vim.notify('Telescope not available - skipping file search setup', vim.log.levels.INFO)
end

-- See `:help telescope.builtin`
