return {
  { "ellisonleao/gruvbox.nvim" },

  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    opts = {
      -- add any opts here
      -- for example
      provider = "openai",
      behaviour = {
        auto_suggestions = false
      },
      providers = {
        claude = {
          endpoint = "https://api.anthropic.com",
          model = "claude-3-5-sonnet-20241022",
          extra_request_body = {
            temperature = 0,
            max_tokens = 4096,
          }
        },
        ollama = {
          endpoint = "http://127.0.0.1:11434",
          model = "phi3:mini",
          timeout = 30000, -- Timeout in milliseconds
          extra_request_body = {
            options = {
              temperature = 0.75,
              num_ctx = 20480,
              keep_alive = "5m",
            },
          },
        },
        openai = {
          endpoint = "https://api.openai.com/v1",
          -- model = "gpt-4.1-nano", -- your desired model (or use gpt-4o, etc.)
          model = "gpt-3.5-turbo-instruct",
          timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
          extra_request_body = {
            temperature = 0,
            max_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
            --reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
            disable_tools = true,
          }
        },
      },
      file_selector = {
        provider = 'snacks',
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "echasnovski/mini.pick", -- for file_selector provider mini.pick
      "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      "ibhagwan/fzf-lua", -- for file_selector provider fzf
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      indent = { enable = false },
    },
  },

  {
    "kr40/nvim-macros",
    cmd = {"MacroSave", "MacroYank", "MacroSelect", "MacroDelete"},
    opts = {
      json_file_path = vim.fs.normalize(vim.fn.stdpath("config") .. "/macros.json"), -- Location where the macros will be stored
      default_macro_register = "q", -- Use as default register for :MacroYank and :MacroSave and :MacroSelect Raw functions
      json_formatter = "none", -- can be "none" | "jq" | "yq" used to pretty print the json file (jq or yq must be installed!)
    }
  },

  {
    "mbbill/undotree",
    init = function()
      vim.keymap.set("n", "<leader>ut", vim.cmd.UndotreeToggle)
    end,
  },

  {
    "andymass/vim-matchup",
    enabled = true,
    opts = {},
  },

  {
    "folke/snacks.nvim",
    ---@class snacks.indent.Config
    ---@field enabled? boolean
    opts = {
      gitbrowse = {
        enabled = true,
      },
      indent = {
        indent = {
          -- your indent configuration comes here
          -- or leave it empty to use the default settings
          -- refer to the configuration section below
          enabled = true,
          char = "▏",
        },
        scope = {
          enabled = true,
          underline = true,
          char = "▏",
        },
      },
    },
  },

  {
    "stevearc/aerial.nvim",
    enabled = true,
    keys = {
      {
        "<leader>o",
        function()
          require("aerial").snacks_picker({})
        end,
      },
    },
  },

  {
    "zk-org/zk-nvim",
    config = function()
      require("zk").setup({ picker = "fzf_lua" })
    end,
    keys = {
      { "<leader>zi", ":ZkIndex<CR>", desc = "ZK Index", mode = { "n" } },
      { "<leader>zn", ":ZkNew<CR>", desc = "ZK New", mode = { "n" } },
      { "<leader>zl", ":ZkNotes<CR>", desc = "ZK List", mode = { "n" } },
      { "<leader>zL", ":ZkLinks<CR>", desc = "ZK Links", mode = { "n" } },
      { "<leader>zI", ":ZkInsertLink<CR>", desc = "ZK Insert Link", mode = { "n" } },
      { "<leader>zI", ":'<,'>ZkInsertLinkAtSelection<CR>", desc = "ZK Insert Link at selection", mode = { "v" } },
    },
  },

  {
    "toppair/peek.nvim",
    event = { "VeryLazy" },
    build = "deno task --quiet build:fast",
    config = function()
      require("peek").setup({
        app = "browser",
      })
      vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
      vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
    end,
    keys = {
      { "<leader>mO", ":PeekOpen<CR>", desc = "PeekOpen", mode = { "n" } },
      { "<leader>mc", ":PeekClose<CR>", desc = "PeekClose", mode = { "n" } },
    },
  },

  -- {
  --   "ray-x/lsp_signature.nvim",
  --   event = "VeryLazy",
  --   opts = {},
  --   config = function(_, opts) require'lsp_signature'.setup(opts) end
  -- },

  {
    "hrsh7th/nvim-cmp",
    opts = {
      auto_brackets = { "javascript", "typescript", "python", "elixir", "go" },
    },
  },

  {
    "Saghen/blink.cmp",
    enabled = false,
    version = "*",
    event = "InsertEnter",
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = "enter",
        cmdline = {},
      },
    },
  },

  {
    "skwee357/nvim-prose",
    opts = {
      wpm = 150,
      filetypes = { "markdown", "asciidoc", "text" },
      placeholders = {
        words = "words",
        minutes = "min",
      },
    },
  },

  {
    "altermo/ultimate-autopair.nvim",
    event = { "InsertEnter" },
    branch = "v0.6", --recommended as each new version will have breaking changes
    opts = {
      --Config goes here
    },
  },

  {
    "echasnovski/mini.pairs",
    enabled = false,
  },

  {
    "kndndrj/nvim-dbee",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    build = function()
      require("dbee").install()
    end,
    keys = {
      { "<leader>uD", ":Dbee<CR>", desc = "Dbee" },
    },
    config = function()
      require("dbee").setup({
        connections = {
          {
            name = "Local Postgres",
            type = "postgres",
            url = "postgres://root:password@127.0.0.1:5432/sslmode=disable",
          },
          {
            name = "Local MySQL",
            type = "mysql",
            url = "mysql://root:password@127.0.0.1:3306/sslmode=disable",
          },
        },
      })
    end,
  },

  {
    "folke/noice.nvim",
    enabled = true,
  },

  {
    "lervag/vimtex",
    lazy = false,
    init = function()
      vim.cmd([[
        " This is necessary for VimTeX to load properly. The "indent" is optional.
        " Note that most plugin managers will do this automatically.
        filetype plugin indent on

        " This enables Vim's and neovim's syntax-related features. Without this, some
        " VimTeX features will not work (see ":help vimtex-requirements" for more
        " info).
        syntax enable

        " Viewer options: One may configure the viewer either by specifying a built-in
        " viewer method:
        let g:vimtex_view_method = 'zathura'

        " Or with a generic interface:
        let g:vimtex_view_general_viewer = 'zathura'
        let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'

        " VimTeX uses latexmk as the default compiler backend. If you use it, which is
        " strongly recommended, you probably don't need to configure anything. If you
        " want another compiler backend, you can change it as follows. The list of
        " supported backends and further explanation is provided in the documentation,
        " see ":help vimtex-compiler".
        let g:vimtex_compiler_method = 'tectonic'

        " Most VimTeX mappings rely on localleader and this can be changed with the
        " following line. The default is usually fine and is the symbol "\".
        let maplocalleader = ","
        ]])
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    keys = {
      {
        "<leader>ghf",
        ":Gitsigns diffthis ",
        desc = "Diff from commit",
      },
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
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
  },

  {
    "nvim-tree/nvim-tree.lua",
    enabled = true,
    keys = {
      {
        "<Leader>e",
        ":NvimTreeFindFileToggle<CR>",
        mode = { "n" },
        desc = "Open Nvim Tree",
      },
    },
    config = function()
      require("nvim-tree").setup()
    end,
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
        char = { enabled = false },
        search = { enabled = true },
      },
      label = {
        rainbow = { enabled = true },
      },
    },
  },

  {
    "mfussenegger/nvim-dap",
    keys = {
      {
        "<leader>do",
        function()
          require("dap").step_over()
        end,
        desc = "Step Over",
      },
      {
        "<leader>dO",
        function()
          require("dap").step_out()
        end,
        desc = "Step Out",
      },
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
          dap.configurations.elixir = {
            {
              type = "mix_task",
              name = "Attach",
              request = "launch",
              command = "iex -S mix phx.server",
              -- task = "phx.server",
              projectDir = "${workspaceFolder}",
            },
            {
              type = "mix_task",
              name = "Launch",
              task = "run",
              taskArgs = {},
              request = "launch",
              startApps = false,
              projectDir = "${workspaceFolder}",
            },
          }

          dap.adapters.mix_task = {
            type = "executable",
            command = "elixir-ls-debugger",
            args = {},
          }

          require("dapui").setup(opts)
          -- dap.listeners.after.event_initialized["dapui_config"] = function()
          --   require("dapui").open({})
          -- end
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
                  name = "1: Launch",
                  type = "node2",
                  request = "launch",
                  program = "${file}",
                  cwd = vim.fn.getcwd(),
                  sourceMaps = true,
                  protocol = "inspector",
                  console = "integratedTerminal",
                  skipFiles = {
                    "${workspaceFolder}/node_modules/**/*.js",
                    "<node_internals>/**",
                    "<node_internals>/**/*.js",
                  },
                },
                {
                  -- For this to work you need to make sure the node process is started with the `--inspect` flag.
                  name = "2: Attach to process",
                  type = "node2",
                  request = "attach",
                  protocol = "inspector",
                  console = "integratedTerminal",
                  -- processId = require('dap.utils').pick_process,
                  port = 9229,
                  skipFiles = {
                    "${workspaceFolder}/node_modules/**/*.js",
                    "<node_internals>/**",
                    "<node_internals>/**/*.js",
                  },
                },
                {
                  type = "node",
                  request = "attach",
                  name = "3: Pick Process",
                  processId = "${command:PickProcess}",
                  restart = true,
                  protocol = "inspector",
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
