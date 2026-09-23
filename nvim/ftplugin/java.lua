local jdtls = require('jdtls')

-- Find root of project
local root_markers = {'gradlew', '.git', 'mvnw', 'pom.xml', 'build.gradle'}
local root_dir = require('jdtls.setup').find_root(root_markers)
if root_dir == "" then
  return
end

local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = vim.fn.stdpath('data') .. '/site/java/workspace-root/' .. project_name
os.execute("mkdir -p " .. workspace_dir)

-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
  -- The command that starts the language server
  -- See: https://github.com/eclipse-jdtls/eclipse.jdt.ls#running-from-the-command-line
  cmd = {
    'jdtls',
    '-data', workspace_dir
  },

  -- This is the default if not provided, you can remove it. Or adjust as needed.
  -- One dedicated LSP server & client will be started per unique root_dir
  root_dir = root_dir,

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse-jdtls/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {
      eclipse = {
        downloadSources = true,
      },
      configuration = {
        updateBuildConfiguration = "interactive",
      },
      maven = {
        downloadSources = true,
      },
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      references = {
        includeDecompiledSources = true,
      },
      format = {
        enabled = true,
        -- Uncomment to use google-java-format instead of eclipse formatter
        -- settings = {
        --   url = vim.fn.stdpath "config" .. "/lang-servers/intellij-java-google-style.xml",
        --   profile = "GoogleStyle",
        -- },
      },
    },
    signatureHelp = { enabled = true },
    completion = {
      favoriteStaticMembers = {
        "org.hamcrest.MatcherAssert.assertThat",
        "org.hamcrest.Matchers.*",
        "org.hamcrest.CoreMatchers.*",
        "org.junit.jupiter.api.Assertions.*",
        "java.util.Objects.requireNonNull",
        "java.util.Objects.requireNonNullElse",
        "org.mockito.Mockito.*"
      },
      importOrder = {
        "java",
        "javax",
        "com",
        "org"
      },
    },
    extendedClientCapabilities = extendedClientCapabilities,
    sources = {
      organizeImports = {
        starThreshold = 9999,
        staticStarThreshold = 9999,
      },
    },
    codeGeneration = {
      toString = {
        template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
      },
      useBlocks = true,
    },
  },

  flags = {
    allow_incremental_sync = true,
  },
  
  -- Language server `initializationOptions`
  -- You need to extend the `bundles` with paths to jar files
  -- if you want to use additional eclipse.jdt.ls plugins.
  --
  -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  --
  -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
  init_options = {
    bundles = {}
  },
}

-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require('jdtls').start_or_attach(config)

-- Add Java-specific keymaps
local opts = { noremap=true, silent=true }
vim.api.nvim_buf_set_keymap(0, "n", "<leader>co", "<Cmd>lua require'jdtls'.organize_imports()<CR>", opts)
vim.api.nvim_buf_set_keymap(0, "n", "<leader>crv", "<Cmd>lua require('jdtls').extract_variable()<CR>", opts)
vim.api.nvim_buf_set_keymap(0, "x", "<leader>crv", "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", opts)
vim.api.nvim_buf_set_keymap(0, "n", "<leader>crc", "<Cmd>lua require('jdtls').extract_constant()<CR>", opts)
vim.api.nvim_buf_set_keymap(0, "x", "<leader>crc", "<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>", opts)
vim.api.nvim_buf_set_keymap(0, "x", "<leader>crm", "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", opts)