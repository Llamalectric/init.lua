local jdtls = require 'jdtls'

local mason_jdtls = vim.fn.stdpath 'data' .. '/mason/packages/jdtls'

-- Workspace dir per project (avoids cross-project contamination)
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = vim.fn.stdpath 'data' .. '/jdtls-workspace/' .. project_name

local config = {
  cmd = {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xmx1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    '-jar', vim.fn.glob(mason_jdtls .. '/plugins/org.eclipse.equinox.launcher_*.jar'),
    '-configuration', mason_jdtls .. '/config_mac_arm',
    '-data', workspace_dir,
  },

  root_dir = jdtls.setup.find_root { '.git', 'mvnw', 'gradlew', 'build.gradle', 'pom.xml' },

  settings = {
    java = {
      signatureHelp = { enabled = true },
      completion = { favoriteStaticMembers = {} },
    },
  },

  capabilities = require('blink.cmp').get_lsp_capabilities(),
}

jdtls.start_or_attach(config)
