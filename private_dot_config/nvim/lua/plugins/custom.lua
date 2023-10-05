local dapui = require("dapui")

return {
  { "ellisonleao/gruvbox.nvim" },

  {
    "kristijanhusak/vim-dadbod-ui",
    keys = {
      { "<leader>uD", ":DBUIToggle<CR>", desc = "Dadbod UI" },
    },
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      {
        "kristijanhusak/vim-dadbod-completion",
        ft = { "sql", "mysql", "plsql" },
      },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      -- Your DBUI configuration
      vim.g.nu = 1
      vim.g.relativenumber = 1
      vim.g.nofoldenable = 1
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },

  {
    "akinsho/toggleterm.nvim",
    version = "*",
    lazy = false,
    opts = {
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
      direction = "vertical",
      close_on_exit = true, -- close the terminal window when the process exits
      shell = vim.o.shell, -- change the default shell
      -- This field is only relevant if direction is set to 'float'
      float_opts = {
        -- The border key is *almost* the same as 'nvim_open_win'
        -- see :h nvim_open_win for details on borders however
        -- the 'curved' border is a custom border type
        -- not natively supported but implemented in this plugin.
        border = "single",
        width = 50,
        height = 10,
        winblend = 3,
        highlights = {
          border = "Normal",
          background = "Normal",
        },
      },
    },
  },

  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader>gs", vim.NIL },
    },
  },

  {
    "ggandor/flit.nvim",
    enabled = true,
    keys = function()
      ---@type LazyKeys[]
      local ret = {}
      for _, key in ipairs({ "f", "F", "t", "T" }) do
        ret[#ret + 1] = { key, mode = { "n", "x", "o" }, desc = key }
      end
      return ret
    end,
    opts = { labeled_modes = "nx" },
  },

  {
    "ggandor/leap.nvim",
    enabled = true,
  },

  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = "mason.nvim",
    cmd = { "DapInstall", "DapUninstall" },
    opts = {
      automatic_installation = { "node2" },
      automatic_setup = {
        adapters = {
          mix_task = {
            type = "executable",
            command = "elixir-ls-debugger",
          },
          python = {
            type = "executable",
            command = "debugpy-adapter",
          },
          node2 = {
            type = "executable",
            command = "node-debug2-adapter",
          },
        },
        configurations = {
          elixir = {
            {
              type = "mix_task",
              name = "mix test",
              task = "test",
              taskArgs = { "--trace" },
              request = "launch",
              startApps = true, -- for Phoenix projects projectDir = "${workspaceRoot}",
              requireFiles = {
                "test/**/test_helper.exs",
                "test/**/*_test.exs",
              },
            },
          },
          python = {
            {
              type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
              request = "launch",
              name = "Python: Launch file",
              program = "${file}", -- This configuration will launch the current file if used.
              pythonPath = venv_path and (venv_path .. "/bin/python") or nil,
            },
            {
              type = "python",
              name = "Python: Attach",
              request = "attach",
              justMyCode = true,
              connect = {
                host = "127.0.0.1",
                port = 5678,
              },
              pathMappings = {
                {
                  localRoot = "${workspaceFolder}",
                  remoteRoot = ".",
                },
              },
            },
          },
          node2 = {
            {
              name = "Node2: Launch",
              type = "node2",
              request = "launch",
              program = "${file}",
              cwd = vim.fn.getcwd(),
              sourceMaps = true,
              protocol = "inspector",
              console = "integratedTerminal",
              skipFiles = {
                "${workspaceFolder}/node_modules/**/*.js",
                "<node_internals>/**/*.js",
              },
            },
            {
              -- For this to work you need to make sure the node process is started with the `--inspect` flag.
              name = "Node2: Attach to process",
              type = "node2",
              request = "attach",
              protocol = "inspector",
              console = "integratedTerminal",
              -- processId = require('dap.utils').pick_process,
              port = 9229,
              skipFiles = {
                "${workspaceFolder}/node_modules/**/*.js",
                "<node_internals>/**/*.js",
              },
            },
          },
        },
      },
    },
  },

  {
    "rcarriga/nvim-dap-ui",
    -- stylua: ignore
    keys = {
      { "<leader>du", function() dapui.toggle({ }) end, desc = "Dap UI" },
      { "<leader>de", function() dapui.eval() end, desc = "Eval", mode = {"n", "v"} },
    },
    opts = {},
    config = function(_, opts)
      -- setup dap config by VsCode launch.json file
      -- require("dap.ext.vscode").load_launchjs()
      local dap = require("dap")
      dapui.setup(opts)
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({})
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close({})
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close({})
      end
    end,
  },
}
