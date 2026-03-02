-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
  {
    'tpope/vim-fugitive',
  },
  {
    'mfussenegger/nvim-jdtls',
  },
  {
    'tpope/vim-abolish',
  },
  {
    'mfussenegger/nvim-dap',
    event = 'VeryLazy',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'nvim-neotest/nvim-nio',
      'jay-babu/mason-nvim-dap.nvim',
      'theHamsta/nvim-dap-virtual-text',
    },
    keys = {
      { '<leader>dc', function() require('dap').continue() end, desc = '[D]ebug: [C]ontinue' },
      { '<leader>di', function() require('dap').step_into() end, desc = '[D]ebug: Step [I]nto' },
      { '<leader>do', function() require('dap').step_over() end, desc = '[D]ebug: Step [O]ver' },
      { '<leader>dO', function() require('dap').step_out() end, desc = '[D]ebug: Step [O]ut' },
      { '<leader>db', function() require('dap').toggle_breakpoint() end, desc = '[D]ebug: Toggle [B]reakpoint' },
      { '<leader>dB', function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end, desc = '[D]ebug: Conditional [B]reakpoint' },
      { '<leader>du', function() require('dapui').toggle() end, desc = '[D]ebug: Toggle [U]I' },
    },
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'

      -- Let mason-nvim-dap auto-configure adapters installed via :Mason
      require('mason-nvim-dap').setup {
        automatic_installation = true,
        handlers = {},
        ensure_installed = {},
      }

      -- Show variable values inline while debugging
      require('nvim-dap-virtual-text').setup {}

      dapui.setup {
        icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
        controls = {
          icons = {
            pause = '⏸', play = '▶', step_into = '⏎',
            step_over = '⏭', step_out = '⏮', step_back = 'b',
            run_last = '▶▶', terminate = '⏹', disconnect = '⏏',
          },
        },
      }

      -- Auto open/close the UI when a debug session starts/ends
      dap.listeners.after.event_initialized['dapui_config'] = dapui.open
      dap.listeners.before.event_terminated['dapui_config'] = dapui.close
      dap.listeners.before.event_exited['dapui_config'] = dapui.close
    end,
  },
}
