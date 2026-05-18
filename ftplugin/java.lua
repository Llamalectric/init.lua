local jdtls = require 'jdtls'

local mason_path = vim.fn.stdpath 'data' .. '/mason/packages'
local mason_jdtls = mason_path .. '/jdtls'

-- Workspace dir per project (avoids cross-project contamination)
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = vim.fn.stdpath 'data' .. '/jdtls-workspace/' .. project_name

-- Debug + test bundles for nvim-dap integration
local bundles = vim.split(vim.fn.glob(mason_path .. '/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar', true), '\n')
vim.list_extend(bundles, vim.split(vim.fn.glob(mason_path .. '/java-test/extension/server/*.jar', true), '\n'))
bundles = vim.tbl_filter(function(jar)
  return jar ~= '' and not jar:find 'com.microsoft.java.test.runner-jar-with-dependencies'
end, bundles)

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

  init_options = {
    bundles = bundles,
    extendedClientCapabilities = vim.tbl_deep_extend(
      'force',
      jdtls.extendedClientCapabilities,
      { resolveAdditionalTextEditsSupport = true }
    ),
  },

  on_attach = function(_, bufnr)
    jdtls.setup_dap { hotcodereplace = 'auto' }
    require('jdtls.dap').setup_dap_main_class_configs()

    local opts = { buffer = bufnr, silent = true }
    vim.keymap.set('n', '<leader>dt', function() require('jdtls').test_nearest_method() end, vim.tbl_extend('force', opts, { desc = '[D]ebug: [T]est nearest method' }))
    vim.keymap.set('n', '<leader>dT', function() require('jdtls').test_class() end, vim.tbl_extend('force', opts, { desc = '[D]ebug: [T]est class' }))
  end,
}

jdtls.start_or_attach(config)
