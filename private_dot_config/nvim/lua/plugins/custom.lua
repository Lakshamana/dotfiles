return {
  { "ellisonleao/gruvbox.nvim" },

  -- {
  --   "vim-airline/vim-airline",
  --   dependencies = {
  --     "vim-airline/vim-airline-themes",
  --   },
  --   init = function ()
  --     vim.cmd([[
  --       let g:airline_theme='google_dark'
  --       let g:airline_left_sep=''
  --     ]])
  --   end
  -- },

  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    enabled = true,
  },

  {
    "mbbill/undotree",
    init = function()
      vim.keymap.set("n", "<leader>ut", vim.cmd.UndotreeToggle)
    end,
  },

  {
    "uga-rosa/ccc.nvim",
    enabled = false,
    config = function()
      vim.opt.termguicolors = true

      local ccc = require("ccc")

      ccc.setup({
        -- Your preferred settings
        -- Example: enable highlighter
        highlighter = {
          auto_enable = true,
          lsp = true,
        },
      })
    end,
  },

  {
    "andymass/vim-matchup",
    enabled = true,
    opts = {},
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    commit = "3d08501",
    config = function()
      require("ibl").setup({
        enabled = true,
        indent = {
          char = "▏",
        },
        exclude = {
          filetypes = {
            "help",
            "neo-tree",
            "notify",
            "text",
          },
        },
      })

      -- local hooks = require("ibl.hooks")
      -- hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      {
        "MattiasMTS/cmp-dbee",
        commit = "0feabc1", --completion works using this commit
        dependencies = {
          { "kndndrj/nvim-dbee" },
        },
        ft = "sql",
        opts = {},
        config = function()
          require("cmp-dbee").setup({
            default_connection = nil,
          })
        end,
      },
    },
    config = function(_, opts)
      table.insert(opts.sources, 1, { name = "cmp-dbee" })
      table.insert(opts.sources, 1, { name = "nvim_lsp", keyword_length = 1 })

      require("cmp").setup(opts)
    end,
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

  -- {
  --   "mrcjkb/rustaceanvim",
  --   version = "^5", -- Recommended
  --   lazy = false, -- This plugin is already lazy
  -- },

  -- {
  --   "mrcjkb/rustaceanvim",
  --   enabled = false,
  --   version = "^4", -- Recommended
  --   ft = { "rust" },
  --   opts = {
  --     server = {
  --       on_attach = function(_, bufnr)
  --         vim.keymap.set(
  --           "n",
  --           "<M-3>",
  --           require("config.common").workspace_diagnostics,
  --           { noremap = true, silent = true }
  --         )
  --         vim.keymap.set("n", "<M-w>", require("config.common").document_diagnostics, { noremap = true, silent = true })
  --         vim.keymap.set("n", "<M-w>", require("config.common").document_diagnostics, { noremap = true, silent = true })
  --         vim.keymap.set("n", "<leader>cR", function()
  --           vim.cmd.RustLsp("codeAction")
  --         end, { desc = "Code Action", buffer = bufnr })
  --         vim.keymap.set("n", "<leader>D", function()
  --           vim.cmd.RustLsp("debuggables")
  --         end, { desc = "Rust debuggables", buffer = bufnr })
  --       end,
  --       default_settings = {
  --         -- rust-analyzer language server configuration
  --         ["rust-analyzer"] = {
  --           cargo = {
  --             allFeatures = true,
  --             loadOutDirsFromCheck = true,
  --             runBuildScripts = true,
  --           },
  --           -- Add clippy lints for Rust.
  --           checkOnSave = {
  --             allFeatures = true,
  --             command = "check",
  --             extraArgs = { "--no-deps" },
  --           },
  --           procMacro = {
  --             enable = true,
  --             ignored = {
  --               ["async-trait"] = { "async_trait" },
  --               ["napi-derive"] = { "napi" },
  --               ["async-recursion"] = { "async_recursion" },
  --             },
  --           },
  --         },
  --       },
  --     },
  --   },
  --   config = function(_, opts)
  --     vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
  --   end,
  -- },

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

  -- { "Issafalcon/lsp-overloads.nvim" },

  -- { "ray-x/lsp_signature.nvim" },

  -- {
  --   "jackMort/ChatGPT.nvim",
  --   event = "VeryLazy",
  --   config = function()
  --     require("chatgpt").setup({
  --       api_key_cmd = "gpg -d " .. vim.fn.expand("$HOME") .. "/openai.secret.gpg",
  --     })
  --   end,
  --   dependencies = {
  --     "MunifTanjim/nui.nvim",
  --     "nvim-lua/plenary.nvim",
  --     "nvim-telescope/telescope.nvim",
  --   },
  -- },

  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader>gs", false },
      {
        "<leader>sB",
        function()
          require("telescope.builtin").live_grep({
            grep_open_files = true,
          })
        end,
        desc = "Search in buffers",
      },
      {
        "<leader>sS",
        function()
          require("telescope.builtin").lsp_workspace_symbols({
            query = vim.fn.expand("<cword>"),
          })
        end,
        mode = { "v" },
        desc = "Search for selected Symbol (Workspace)",
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
    "neovim/nvim-lspconfig",
    opts = {
      setup = {
        rust_analyzer = function()
          return true
        end,
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
            code,
          },
        },
      },
    },
  },
}
