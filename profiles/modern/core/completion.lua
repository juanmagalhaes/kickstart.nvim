-- Completion configuration for modern profile

local has_cmp, cmp = pcall(require, 'cmp')
if not has_cmp then
  vim.notify('nvim-cmp not found', vim.log.levels.WARN)
  return
end

local has_luasnip, luasnip = pcall(require, 'luasnip')
if has_luasnip then
  -- Load friendly snippets
  pcall(require('luasnip.loaders.from_vscode').lazy_load)
end

cmp.setup({
  snippet = {
    expand = function(args)
      if has_luasnip then
        luasnip.lsp_expand(args.body)
      end
    end,
  },
  -- Prevent completion from triggering too early
  completion = {
    completeopt = 'menu,menuone,noinsert,noselect',
  },
  -- Better trigger behavior
  preselect = cmp.PreselectMode.None,
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif has_luasnip and luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif has_luasnip and luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = (function()
    local sources = {
      { name = 'luasnip' },
      { name = 'buffer' },
      { name = 'path' },
    }
    
    -- Only add LSP source if cmp_nvim_lsp is available
    if has_cmp_lsp then
      table.insert(sources, 1, { name = 'nvim_lsp' })
    end
    
    return sources
  end)(),
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  formatting = {
    fields = { 'kind', 'abbr', 'menu' },
    format = function(entry, item)
      local icons = {
        Text = ' ',
        Method = ' ',
        Function = ' ',
        Constructor = ' ',
        Field = ' ',
        Variable = ' ',
        Class = ' ',
        Interface = ' ',
        Module = ' ',
        Property = ' ',
        Unit = ' ',
        Value = ' ',
        Enum = ' ',
        Keyword = ' ',
        Snippet = ' ',
        Color = ' ',
        File = ' ',
        Reference = ' ',
        Folder = ' ',
        EnumMember = ' ',
        Constant = ' ',
        Struct = ' ',
        Event = ' ',
        Operator = ' ',
        TypeParameter = ' ',
      }
      
      item.kind = string.format('%s %s', icons[item.kind] or ' ', item.kind)
      item.menu = ({
        nvim_lsp = '[LSP]',
        luasnip = '[Snippet]',
        buffer = '[Buffer]',
        path = '[Path]',
      })[entry.source.name]
      
      return item
    end,
  },
})
