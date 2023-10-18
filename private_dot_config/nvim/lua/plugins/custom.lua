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
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader>gs", false },
      {
        "<leader>sB",
        function ()
          require('telescope.builtin').live_grep({
          grep_open_files = true
        })
        end,
        desc = "Search in buffers"
      }
    },
  },

  {
    "ggandor/flit.nvim",
    enabled = true,
    dependencies = { "ggandor/leap.nvim" },
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
    "folke/flash.nvim",
    enabled = true,
    --@type Flash.Config
    event = "VeryLazy",
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        false,
      },
      {
        "S",
        mode = { "n", "x", "o" },
        false,
      },
      {
        "r",
        mode = "o",
        false,
      },
      {
        "R",
        mode = { "o", "x" },
        false,
      },
      {
        "<c-s>",
        mode = { "c" },
        false,
      },
    },
    opts = {
      modes = {
        char = { enabled = false }
      },
      label = {
        rainbow = { enabled = true }
      }
    },
  },

  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<leader>do", function() require("dap").step_over() end, desc = "Step Over" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "Step Out" },
    },
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        -- stylua: ignore
        keys = {
          { "<leader>du", function() require("dapui").toggle({ }) end, desc = "Dap UI" },
          { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "v"} },
          { "<leader>dS", function() require("dap").session() end, desc = "Session" },
          {
            "<leader>ds",
            function()
              local widgets = require('dap.ui.widgets')
              widgets.centered_float(widgets.scopes)
            end,
            desc = "Scopes"
          },
        },
        opts = {},
        config = function(_, opts)
          -- setup dap config by VsCode launch.json file
          -- require("dap.ext.vscode").load_launchjs()

          local dap = require("dap")
          require("dapui").setup(opts)
          dap.listeners.after.event_initialized["dapui_config"] = function()
            require("dapui").open({})
          end
          dap.listeners.before.event_terminated["dapui_config"] = function()
            require("dapui").close({})
          end
          dap.listeners.before.event_exited["dapui_config"] = function()
            require("dapui").close({})
          end
        end,
      },
      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = "mason.nvim",
        cmd = { "DapInstall", "DapUninstall" },
        opts = {
          automatic_installation = { "node2" },
          handlers = {
            function(config)
              require("mason-nvim-dap").default_setup(config)
            end,
            node2 = function(config)
              config.adapters = {
                type = "executable",
                command = "node-debug2-adapter",
              }
              config.configurations = {
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
                  name = "Node2: Attach to process (!)",
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
              }
              require("mason-nvim-dap").default_setup(config) -- don't forget this!
            end,
          },
        },
      },
    },
  },
}
