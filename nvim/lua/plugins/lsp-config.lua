return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "lemminx", "vue_ls", "ts_ls" },
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- Configure LSP servers directly
      --require("lspconfig").lua_ls.setup({})
      local lspconfig = require("lspconfig")
      lspconfig.lua_ls.setup({})

      -- Configure LemMinX for XML/XSLT files
      lspconfig.lemminx.setup({
        filetypes = { "xml", "xsd", "xsl", "xslt", "svg" },
        settings = {
          xml = {
            format = {
              enabled = true,
              splitAttributes = "alignWithFirstAttr",
              joinContentLines = false,
              spaceBeforeEmptyCloseTag = true,
            },
            validation = {
              enabled = true,
              schema = true,
              noGrammar = "hint",
            },
          },
        },
      })

      -- Configure TypeScript Language Server with Vue plugin support
      --local vue_language_server_path = vim.fn.stdpath('data') .. '/mason/packages/vue-language-server/node_modules/@vue/language-server'
      local vue_language_server_path = vim.fn.expand '$MASON/packages' ..
      '/vue-language-server' .. '/node_modules/@vue/language-server'

      local vue_plugin = {
        name = '@vue/typescript-plugin',
        location = vue_language_server_path,
        languages = { 'vue' },
        configNamespace = 'typescript',
      }
      local vtsls_config = {
        settings = {
          vtsls = {
            tsserver = {
              globalPlugins = {
                vue_plugin,
              },
            },
          },
        },
        filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
      }
      -- If you are on most recent `nvim-lspconfig`
      local vue_ls_coonfig = {}
      -- If you are not on most recent `nvim-lspconfig` or you want to override
      local vue_ls_config = {
        on_init = function(client)
          client.handlers['tsserver/request'] = function(_, result, context)
            local clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = 'vtsls' })
            if #clients == 0 then
              vim.notify('Could not find `vtsls` lsp client, `vue_ls` would not work without it.', vim.log.levels.ERROR)
              return
            end
            local ts_client = clients[1]

            local param = unpack(result)
            local id, command, payload = unpack(param)
            ts_client:exec_cmd({
              title = 'vue_request_forward', -- You can give title anything as it's used to represent a command in the UI, `:h Client:exec_cmd`
              command = 'typescript.tsserverRequest',
              arguments = {
                command,
                payload,
              },
            }, { bufnr = context.bufnr }, function(_, r)
              local response = r and r.body
              -- TODO: handle error or response nil here, e.g. logging
              -- NOTE: Do NOT return if there's an error or no response, just return nil back to the vue_ls to prevent memory leak
              local response_data = { { id, response } }

              ---@diagnostic disable-next-line: param-type-mismatch
              client:notify('tsserver/response', response_data)
            end)
          end
        end,
      }
      -- nvim 0.11 or above
      vim.lsp.config('vtsls', vtsls_config)
      vim.lsp.config('vue_ls', vue_ls_config)
      vim.lsp.enable({ 'vtsls', 'vue_ls' })

      vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
      vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, {})
      vim.keymap.set({ 'n', 'v' }, '<leader>cf', vim.lsp.buf.format, { desc = 'Format code' })

      -- Diagnostic navigation
      vim.keymap.set('n', '<leader>dn', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
      vim.keymap.set('n', '<leader>dp', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })
      vim.keymap.set('n', '<leader>dl', vim.diagnostic.open_float, { desc = 'Show diagnostic' })

      -- XSLT development keybindings
      vim.keymap.set('n', '<leader>xl', function()
        vim.cmd('!xmllint --noout ' .. vim.fn.shellescape(vim.fn.expand('%')))
      end, { desc = 'Check XML/XSLT syntax with xmllint' })

      vim.keymap.set('n', '<leader>xp', function()
        local current_file = vim.fn.expand('%')
        local input_file = vim.fn.input('Input XML file: ')
        if input_file ~= '' then
          local output_file = vim.fn.input('Output file (leave empty to display): ')
          if output_file ~= '' then
            vim.cmd('!xsltproc ' ..
            vim.fn.shellescape(current_file) ..
            ' ' .. vim.fn.shellescape(input_file) .. ' > ' .. vim.fn.shellescape(output_file))
            print('XSLT transformation saved to: ' .. output_file)
          else
            vim.cmd('!xsltproc ' .. vim.fn.shellescape(current_file) .. ' ' .. vim.fn.shellescape(input_file))
          end
        end
      end, { desc = 'Run XSLT transformation with xsltproc' })

      vim.keymap.set('n', '<leader>xs', function()
        local current_file = vim.fn.expand('%')
        local input_file = vim.fn.input('Input XML file: ')
        if input_file ~= '' then
          local output_file = vim.fn.input('Output file (leave empty to display): ')
          if output_file ~= '' then
            vim.cmd('!saxon -s:' .. vim.fn.shellescape(input_file) ..
            ' -xsl:' .. vim.fn.shellescape(current_file) ..
            ' -o:' .. vim.fn.shellescape(output_file))
            print('XSLT transformation saved to: ' .. output_file)
          else
            vim.cmd('!saxon -s:' .. vim.fn.shellescape(input_file) ..
            ' -xsl:' .. vim.fn.shellescape(current_file))
          end
        end
      end, { desc = 'Run XSLT transformation with Saxon-HE' })

      vim.keymap.set('n', '<leader>xt', function()
        local processor = vim.fn.confirm('Choose XSLT processor:', "&xsltproc\n&Saxon-HE", 1)
        if processor == 0 then return end
        
        local current_file = vim.fn.expand('%')
        local input_file = vim.fn.input('Input XML file: ')
        if input_file ~= '' then
          local output_file = vim.fn.input('Output file (leave empty to display): ')
          
          if processor == 1 then
            -- xsltproc
            if output_file ~= '' then
              vim.cmd('!xsltproc ' ..
              vim.fn.shellescape(current_file) ..
              ' ' .. vim.fn.shellescape(input_file) .. ' > ' .. vim.fn.shellescape(output_file))
              print('XSLT transformation saved to: ' .. output_file)
            else
              vim.cmd('!xsltproc ' .. vim.fn.shellescape(current_file) .. ' ' .. vim.fn.shellescape(input_file))
            end
          else
            -- Saxon-HE
            if output_file ~= '' then
              vim.cmd('!saxon -s:' .. vim.fn.shellescape(input_file) ..
              ' -xsl:' .. vim.fn.shellescape(current_file) ..
              ' -o:' .. vim.fn.shellescape(output_file))
              print('XSLT transformation saved to: ' .. output_file)
            else
              vim.cmd('!saxon -s:' .. vim.fn.shellescape(input_file) ..
              ' -xsl:' .. vim.fn.shellescape(current_file))
            end
          end
        end
      end, { desc = 'Choose XSLT processor and run transformation' })
    end
  }
}
