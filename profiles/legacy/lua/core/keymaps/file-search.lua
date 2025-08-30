-- File search keymaps for legacy profile

-- Check if telescope is available
local has_telescope, telescope = pcall(require, 'telescope.builtin')

if has_telescope then
  local function fuzzyFindFiles()
    telescope.grep_string({
      path_display = { 'smart' },
      only_sort_text = true,
      word_match = "-w",
      search = '',
    })
  end

  vim.keymap.set('n', '<C-p>', telescope.git_files, { desc = 'Search [G]it [F]iles' })
  vim.keymap.set('n', 'K', telescope.grep_string, { desc = '[S]earch current [W]ord' })
  vim.keymap.set('n', '<C-a>', fuzzyFindFiles, { desc = '[S]earch by [G]rep' })
  vim.keymap.set('n', '<C-s>', telescope.live_grep, { desc = '[S]earch Live Exact Match' })
  vim.keymap.set('n', '<leader>sh', telescope.help_tags, { desc = '[S]earch [H]elp' })
  vim.keymap.set('n', '<C-f>', telescope.find_files, { desc = '[S]earch [F]iles' })
  vim.keymap.set('n', '<leader>sd', telescope.diagnostics, { desc = '[S]earch [D]iagnostics' })
else
  -- Fallback keymaps when telescope is not available
  vim.keymap.set('n', '<C-p>', ':find ', { desc = 'Find file' })
  vim.keymap.set('n', '<C-f>', ':find ', { desc = 'Find file' })
  vim.keymap.set('n', 'K', '*', { desc = 'Search current word' })
  vim.notify('Telescope not available - using fallback keymaps', vim.log.levels.INFO)
end
