require("dapui").setup()
require('mason').setup()
require("nvim-dap-virtual-text").setup()

require("mason-nvim-dap").setup({
  automatic_installation = { "node2" },
  automatic_setup = {
    adapters = {
      node2 = {
        type = "executable",
        command = "node-debug2-adapter",
      },
    },
    configurations = {
      node2 = {
        {
          name = 'Node2: Launch',
          type = 'node2',
          request = 'launch',
          program = '${file}',
          cwd = vim.fn.getcwd(),
          sourceMaps = true,
          protocol = 'inspector',
          console = 'integratedTerminal',
          skipFiles = {
            "${workspaceFolder}/node_modules/**/*.js",
            "<node_internals>/**/*.js"
          }
        },
        {
          -- For this to work you need to make sure the node process is started with the `--inspect` flag.
          name = 'Node2: Attach to process',
          type = 'node2',
          request = 'attach',
          protocol = 'inspector',
          console = 'integratedTerminal',
          processId = require('dap.utils').pick_process,
          skipFiles = {
            "${workspaceFolder}/node_modules/**/*.js",
            "<node_internals>/**/*.js"
          }
        }
      }
    }
  }
})

require'mason-nvim-dap'.setup_handlers {
  function(s)
    require('mason-nvim-dap.automatic_setup')(s)
  end
}

vim.g.dap_virtual_text = true
vim.keymap.set('n', '<F5>', function() require('dap').continue() end)
vim.keymap.set('n', '<F10>', function() require('dap').step_over() end)
vim.keymap.set('n', '<F11>', function() require('dap').step_into() end)
vim.keymap.set('n', '<F12>', function() require('dap').step_out() end)
vim.keymap.set('n', '<F9>', function() require('dap').toggle_breakpoint() end)
vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end)
vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)
vim.keymap.set({'n', 'v'}, '<Leader>dh', function()
  require('dap.ui.widgets').hover()
end)
vim.keymap.set({'n', 'v'}, '<Leader>dp', function()
  require('dap.ui.widgets').preview()
end)
vim.keymap.set('n', '<Leader>df', function()
local widgets = require('dap.ui.widgets')
widgets.centered_float(widgets.frames)
end)
vim.keymap.set('n', '<Leader>ds', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.scopes)
end)
