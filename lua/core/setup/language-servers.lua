local servers = {
  -- clangd = {},
  gopls = {
    go = {
      analyses = {
        unusedparams = true,
      },
      usePlaceholders = true,
      completeUnimported = true,
      staticcheck = true,
      gofumpt = true,
    },
  },
  -- pyright = {},
  -- rust_analyzer = {},
  eslint = {},
  ts_ls = {
    typescript = {
      settings = {
        preferences = {
          importModuleSpecifierPreference = "non-relative",
          preferTypeOnlyAutoImports = true,
        }
      }
    },
  },
  tailwindcss = {},

  prismals = {},

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities,
-- so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'


local lspKeymaps = require('core.keymaps.async.language-servers')

local on_attach = function(_, bufnr)
  lspKeymaps(bufnr)
end

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
  automatic_installation = false,

  handlers = {
    function(server_name)
      local server = servers[server_name] or {}
      -- This handles overriding only values explicitly passed
      -- by the server configuration above. Useful when disabling
      -- certain features of an LSP (for example, turning off formatting for ts_ls)
      server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
      server.on_attach = on_attach
      require('lspconfig')[server_name].setup(server)
    end,
  },
}

-- mason_lspconfig.setup_handlers {
--   function(server_name)
--     local lspconfig = require('lspconfig')
--     local server_config = lspconfig[server_name]
--
--     server_config.setup {
--       capabilities = capabilities,
--       on_attach = on_attach,
--       settings = servers[server_name],
--     }
--   end,
-- }

-- Tsserver run organize imports command
local function organize_imports()
  local params = {
    command = "_typescript.organizeImports",
    arguments = { vim.api.nvim_buf_get_name(0) },
    title = ""
  }
  vim.lsp.buf.execute_command(params)
end

-- TODO Add back OrganizeImports command

local tsserverKeymaps = require('core.keymaps.async.ts_ls')

local tsserver_on_attach = function(_, bufnr)
  lspKeymaps(bufnr)

  tsserverKeymaps(bufnr, {
    organize_imports = organize_imports
  })
end

require('lspconfig').ts_ls.setup {
  on_attach = tsserver_on_attach,
  capabilities = capabilities,
  commands = {
    OrganizeImports = {
      organize_imports,
      description = "Organize Imports"
    }
  }
}
