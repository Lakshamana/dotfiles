require('nvim-dap-virtual-text').setup()
require('mason').setup()

local venv_path = os.getenv('VIRTUAL_ENV') or os.getenv('CONDA_PREFIX')

require('mason-nvim-dap').setup({
  automatic_installation = { 'node2' },
  automatic_setup = {
    adapters = {
      mix_task = {
        type = 'executable',
        command = 'elixir-ls-debugger'
      },
      python = {
        type = 'executable',
        command = 'debugpy-adapter',
      },
      node2 = {
        type = 'executable',
        command = 'node-debug2-adapter',
      },
    },
    configurations = {
      elixir = {
        {
          type = 'mix_task',
          name = 'mix test',
          task = 'test',
          taskArgs = { '--trace' },
          request = 'launch',
          startApps = true, -- for Phoenix projects
          projectDir = '${workspaceFolder}',
          requireFiles = {
            'test/**/test_helper.exs',
            'test/**/*_test.exs',
          },
        }
      },
      python = {
        {
          type = 'python', -- the type here established the link to the adapter definition: `dap.adapters.python`
          request = 'launch',
          name = 'Python: Launch file',
          program = '${file}', -- This configuration will launch the current file if used.
          pythonPath = venv_path and (venv_path .. '/bin/python') or nil,
        },
        {
          type = 'python',
          name = 'Python: Attach',
          request = 'attach',
          justMyCode = true,
          connect = {
            host = '127.0.0.1',
            port = 5678
          },
          pathMappings = {
            {
              localRoot = '${workspaceFolder}',
              remoteRoot = '.'
            }
          }
        }
      },
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
            '${workspaceFolder}/node_modules/**/*.js',
            '<node_internals>/**/*.js'
          }
        },
        {
          -- For this to work you need to make sure the node process is started with the `--inspect` flag.
          name = 'Node2: Attach to process',
          type = 'node2',
          request = 'attach',
          protocol = 'inspector',
          console = 'integratedTerminal',
          -- processId = require('dap.utils').pick_process,
          port = 9229,
          skipFiles = {
            '${workspaceFolder}/node_modules/**/*.js',
            '<node_internals>/**/*.js'
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

local dap, dapui = require('dap'), require('dapui')
dapui.setup()

dap.listeners.after.event_initialized['dapui_config'] = function()
  dapui.open()
end

vim.g.dap_virtual_text = true

vim.keymap.set('n', '<Leader>dc', function() dap.continue() end)
vim.keymap.set('n', '<Leader>do', function() dap.step_over() end)
vim.keymap.set('n', '<Leader>di', function() dap.step_into() end)
vim.keymap.set('n', '<Leader>dx', function() dap.step_out() end)
vim.keymap.set('n', '<Leader>db', function() dap.toggle_breakpoint() end)
vim.keymap.set('n', '<Leader>dt', function() dapui.toggle() end)
vim.keymap.set('n', '<Leader>dr', function() dap.repl.open() end)
vim.keymap.set('n', '<Leader>dl', function() dap.run_last() end)
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

require("toggleterm").setup{
  size = function(term)
    if term.direction == "horizontal" then
      return 10
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,
  open_mapping = [[<c-\>]],
  hide_numbers = true, -- hide the number column in toggleterm buffers
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = 3, -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
  start_in_insert = true,
  insert_mappings = true, -- whether or not the open mapping applies in insert mode
  persist_size = true,
  direction = 'horizontal',
  close_on_exit = true, -- close the terminal window when the process exits
  shell = vim.o.shell, -- change the default shell
  -- This field is only relevant if direction is set to 'float'
  float_opts = {
    -- The border key is *almost* the same as 'nvim_open_win'
    -- see :h nvim_open_win for details on borders however
    -- the 'curved' border is a custom border type
    -- not natively supported but implemented in this plugin.
    border = 'single',
    width = 100,
    height = 10,
    winblend = 3,
    highlights = {
      border = "Normal",
      background = "Normal"
    }
  }
}

function _G.set_terminal_keymaps()
  local opts = {noremap = true}

  vim.api.nvim_buf_set_keymap(0, 't', '<M-h>', [[<C-\><C-n><C-W>h]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<M-j>', [[<C-\><C-n><C-W>j]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<M-k>', [[<C-\><C-n><C-W>k]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<M-l>', [[<C-\><C-n><C-W>l]], opts)
end

vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

require("indent_blankline").setup {
    -- for example, context is off by default, use this to turn it on
    filetype_exclude = { 'text' },
    show_current_context = false,
    show_current_context_start = true,
}
