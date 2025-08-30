-- Plugin configuration for modern profile

local plugins = {
  -- Git integration
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Editor enhancements
  'tpope/vim-sleuth',
  'styled-components/vim-styled-components',

  -- LSP Configuration
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',
      {
        'j-hui/fidget.nvim',
        tag = 'legacy',
        opts = {}
      },
      'folke/neodev.nvim',
    },
  },

  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
    },
  },

  -- Keybinding help
  {
    'folke/which-key.nvim',
    opts = {}
  },

  -- Theme
  {
    'navarasu/onedark.nvim',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'onedark'
    end,
  },

  -- Documentation generation
  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = true,
    version = "*",
    opts = {
      languages = {
        typescript = {
          template = {
            annotation_convention = "jsdoc",
          },
        },
      }
    }
  },

  -- Rainbow delimiters
  {
    'HiPhish/rainbow-delimiters.nvim',
  },

  -- Status line
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      options = {
        theme = 'onedark',
        globalstatus = true,
      },
      sections = {
        lualine_c = {
          {
            'filename',
            path = 1,
          },
        },
        lualine_x = { 
          'fileformat', 
          'filetype',
          -- Add folding status indicator
          function()
            local fold_level = vim.opt.foldlevel:get()
            return fold_level > 1 and '🔓' or '🔒'
          end,
        },
        lualine_y = {},
      },
    },
  },

  -- Indentation guides
  {
    'lukas-reineke/indent-blankline.nvim',
    main = "ibl",
    opts = {
      indent = { char = "┊" },
      scope = {
        show_start = false,
        show_end = false,
      }
    },
  },

  -- Comments
  {
    'numToStr/Comment.nvim',
    opts = {}
  },

  -- Project Tree (nvim-tree)
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('nvim-tree').setup({
        sort_by = "case_sensitive",
        view = {
          width = 30,
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = false,
        },
      })

      -- Keymaps for nvim-tree (matching legacy profile)
      vim.keymap.set('n', '<leader><space>', ':NvimTreeToggle<CR>', { desc = 'Toggle File Tree' })
      vim.keymap.set('n', 't', ':NvimTreeToggle<CR>', { desc = 'Toggle Node' })
      vim.keymap.set('n', '<leader>f', function()
        require('nvim-tree.api').tree.open({ find_file = true })
      end, { desc = 'Reveal File In Tree' })
    end,
  },

  -- Fuzzy finder
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
    config = function()
      require('telescope').setup({
        defaults = {
          mappings = {
            i = {
              ['<C-u>'] = false,
              ['<C-d>'] = false,
            },
          },
        },
      })

      -- Enable telescope fzf native, if installed
      pcall(require('telescope').load_extension, 'fzf')
      
      -- Note: Keymaps are now handled in core/keymaps.lua to match legacy profile
    end,
  },

  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },

  -- Multiple cursors
  {
    "mg979/vim-visual-multi",
    branch = "master"
  },

  -- Tailwind tools
  {
    "luckasRanarison/tailwind-tools.nvim",
    name = "tailwind-tools",
    build = ":UpdateRemotePlugins",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {}
  },

  -- Todo comments
  {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      signs = true,
      sign_priority = 8,
      keywords = {
        FIX = {
          icon = " ", -- icon used for the sign, and in search results
          color = "error", -- can be a hex color, or a named color (see below)
          alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
        },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
      },
      highlight = {
        before = "", -- "fg" or "bg" or empty
        keyword = "wide", -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty
        after = "fg", -- "fg" or "bg" or empty
        pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlighting (vim regex)
        comments_only = true, -- uses treesitter to match keywords in comments only
        max_line_len = 400, -- ignore lines longer than this
        exclude = {}, -- list of file types to exclude highlighting
      },
      search = {
        command = "rg",
        args = {
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
        },
        pattern = [[\b(KEYWORDS):]], -- ripgrep regex
      },
    },
  },

  -- Nvim-ufo
  {
    'kevinhwang91/nvim-ufo',
    dependencies = { 'kevinhwang91/promise-async' },
    config = function()
      require('ufo').setup({
        -- Prevent auto-folding while typing
        enable_get_line = false,
        
        -- Set reasonable default fold levels
        fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
          local newVirtText = {}
          local suffix = ('  ... %d '):format(endLnum - lnum)
          local sufWidth = vim.fn.strdisplaywidth(suffix)
          local targetWidth = width - sufWidth
          local curWidth = 0
          for _, chunk in ipairs(virtText) do
            local chunkText = chunk[1]
            local chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if targetWidth > curWidth + chunkWidth then
              curWidth = curWidth + chunkWidth
              table.insert(newVirtText, chunk)
            else
              chunkText = truncate(chunkText, targetWidth - curWidth)
              local hlGroup = chunk[2]
              table.insert(newVirtText, { chunkText, hlGroup })
              chunkWidth = vim.fn.strdisplaywidth(chunkText)
              if curWidth + chunkWidth < targetWidth then
                suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
              end
              break
            end
          end
          table.insert(newVirtText, { suffix, 'MoreMsg' })
          return newVirtText
        end,
        
        -- Better fold provider selection
        provider_selector = function(bufnr, filetype, buftype)
          return { 'treesitter', 'indent' }
        end,
        
        -- Prevent disruptive folding
        close_fold_kinds = {},
        
        -- Start with no folding
        initial_fold_level = 999,
        
        -- Prevent auto-folding on buffer changes
        preview = {
          win_config = {
            border = 'rounded',
            winblend = 0,
            winhighlight = 'Normal:Normal',
          },
        },
      })
      
      -- Keymaps for folding (less aggressive)
      vim.keymap.set('n', 'zR', require('ufo').openAllFolds, { desc = 'Open all folds' })
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds, { desc = 'Close all folds' })
      vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds, { desc = 'Open folds except kinds' })
      vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith, { desc = 'Close folds with' })
      
      -- Simple toggle shortcut: <leader>z to toggle between no folding and level 1
      vim.keymap.set('n', '<leader>z', function()
        local current_level = vim.opt.foldlevel:get()
        if current_level > 1 then
          -- Currently unfolded, fold to level 1
          vim.opt.foldlevel = 1
          -- Silent - no notification needed
        else
          -- Currently folded, unfold everything
          vim.opt.foldlevel = 999
          -- Silent - no notification needed
        end
      end, { desc = 'Toggle folding on/off' })
      
      -- Set initial fold level for all buffers (no folding)
      vim.api.nvim_create_autocmd('BufReadPost', {
        callback = function()
          -- Set fold level to 999 (no folding initially)
          vim.opt.foldlevel = 999
          vim.opt.foldlevelstart = 999
        end,
      })
    end,
  },

  -- GitHub Copilot
  {
    'github/copilot.vim',
    config = function()
      -- Copilot settings
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_tab_fallback = ""
      
      -- Keymaps for Copilot
      vim.keymap.set('i', '<C-J>', 'copilot#Accept("<CR>")', {
        expr = true,
        replace_keycodes = false
      })
      vim.keymap.set('i', '<C-K>', '<Plug>(copilot-accept-line)', {})
      vim.keymap.set('i', '<C-L>', '<Plug>(copilot-accept-word)', {})
    end,
  },

  -- Modern command line UI (noice.nvim)
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
    config = function()
      require('noice').setup({
        -- Replace the UI for messages, cmdline and the popupmenu
        cmdline = {
          enabled = true,
          view = 'cmdline_popup',
          opts = {
            position = {
              row = '50%',
              col = '50%',
            },
            size = {
              width = 60,
              height = 'auto',
            },
          },
        },
        -- Disable general message notifications to stop the noise
        messages = {
          enabled = false,
        },
        -- Only show critical notifications (errors, warnings)
        -- Disable info notifications that are just noise
        notify = {
          enabled = true,
          view = 'notify',
          -- Only show errors and warnings
          filter = function(notification)
            return notification.level >= vim.log.levels.WARN
          end,
        },
        popupmenu = {
          enabled = true,
          backend = 'nui',
        },
        lsp = {
          progress = {
            enabled = true,
            format = 'lsp_progress',
            format_done = 'lsp_progress_done',
            throttle = 1000 / 30,
            view = 'mini',
          },
          override = {
            ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
            ['vim.lsp.util.stylize_markdown'] = true,
            ['cmp.entry.get_documentation'] = true,
          },
          -- Completely disable LSP message display to stop the noise
          message = {
            enabled = false,
          },
        },
        views = {
          cmdline_popup = {
            position = {
              row = '50%',
              col = '50%',
            },
            size = {
              width = 60,
              height = 'auto',
            },
          },
          popupmenu = {
            relative = 'editor',
            position = {
              row = 8,
              col = '50%',
            },
            size = {
              width = 60,
              height = 10,
            },
            border = {
              style = 'rounded',
              padding = { 0, 1 },
            },
          },
        },
        routes = {
          {
            filter = {
              event = 'msg_show',
              kind = '',
              find = 'written',
            },
            opts = { skip = true },
          },
          -- Filter out LSP noise messages
          {
            filter = {
              event = 'notify',
              find = 'fewer lines',
            },
            opts = { skip = true },
          },
          {
            filter = {
              event = 'notify',
              find = 'before #',
            },
            opts = { skip = true },
          },
          {
            filter = {
              event = 'notify',
              find = 'seconds ago',
            },
            opts = { skip = true },
          },
          {
            filter = {
              event = 'notify',
              find = 'more lines',
            },
            opts = { skip = true },
          },
          -- Block the specific messages you're seeing
          {
            filter = {
              event = 'notify',
              find = 'Already at newest change',
            },
            opts = { skip = true },
          },
          {
            filter = {
              event = 'notify',
              find = 'Already at oldest change',
            },
            opts = { skip = true },
          },
          -- Block all LSP info messages that are just noise
          {
            filter = {
              event = 'notify',
              kind = 'info',
              find = 'lines',
            },
            opts = { skip = true },
          },
          {
            filter = {
              event = 'notify',
              kind = 'info',
              find = 'before #',
            },
            opts = { skip = true },
          },
          {
            filter = {
              event = 'notify',
              kind = 'info',
              find = 'seconds ago',
            },
            opts = { skip = true },
          },
          {
            filter = {
              event = 'notify',
              kind = 'info',
              find = 'Already at',
            },
            opts = { skip = true },
          },
        },
        commands = {
          history = {
            view = 'split',
            opts = { enter = true, format = 'details' },
            filter = {
              any = {
                { event = 'notify' },
                { error = true },
                { warning = true },
                { event = 'msg_show', kind = { '' } },
                { event = 'lsp', kind = 'message' },
              },
            },
          },
        },
      })
    end,
  },

  -- Markdown preview
  {
    'iamcco/markdown-preview.nvim',
    build = function() vim.fn['mkdp#util#install']() end,
    config = function()
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_refresh_slow = 0
      vim.g.mkdp_command_for_global = 0
      vim.g.mkdp_open_to_the_world = 0
      vim.g.mkdp_open_ip = ''
      vim.g.mkdp_browser = ''
      vim.g.mkdp_echo_preview_url = 0
      vim.g.mkdp_browserfunc = ''
      vim.g.mkdp_preview_options = {
        mkit = {},
        katex = {},
        uml = {},
        maid = {},
        disable_sync_scroll = 0,
        sync_scroll_type = 'middle',
        hide_yaml_meta = 1,
        sequence_diagrams = {},
        flowchart_diagrams = {},
        content_editable = false,
        disable_filename = 0,
      }
      vim.g.mkdp_markdown_css = ''
      vim.g.mkdp_highlight_css = ''
      vim.g.mkdp_page_title = '「${name}」'
      vim.g.mkdp_filetypes = { 'markdown' }
      vim.g.mkdp_theme = 'dark'
      
      -- Keymaps for markdown preview
      vim.keymap.set('n', '<leader>mp', ':MarkdownPreview<CR>', { desc = 'Markdown [P]review' })
      vim.keymap.set('n', '<leader>ms', ':MarkdownPreviewStop<CR>', { desc = 'Markdown [S]top preview' })
      vim.keymap.set('n', '<leader>mt', ':MarkdownPreviewToggle<CR>', { desc = 'Markdown [T]oggle preview' })
    end,
  },
}

require('lazy').setup(plugins, {})
