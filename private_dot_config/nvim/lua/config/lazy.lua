local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

vim.opt.title = true
vim.opt.swapfile = false

vim.api.nvim_create_user_command("W", "w !sudo tee >/dev/null %:p:S", { bang = true })

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    {
      "LazyVim/LazyVim",
      import = "lazyvim.plugins",
      opts = { colorscheme = "cyberdream" },
    },
    -- import any extras modules here
    -- { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.lang.elixir" },
    { import = "lazyvim.plugins.extras.lang.go" },
    { import = "lazyvim.plugins.extras.lang.rust" },
    { import = "lazyvim.plugins.extras.lang.json" },
    -- { import = "lazyvim.plugins.extras.ui.indent-blankline" },
    -- { import = "lazyvim.plugins.extras.coding.copilot" },
    { import = "lazyvim.plugins.extras.formatting.prettier" },
    { import = "lazyvim.plugins.extras.dap.core" },

    -- import/override with your plugins
    {
      "kdheepak/lazygit.nvim",
      -- optional for floating window border decoration
      dependencies = {
        "nvim-lua/plenary.nvim",
      },
    },
    "tpope/vim-surround",
    "tpope/vim-abolish",
    "mg979/vim-visual-multi",
    -- "jiangmiao/auto-pairs",
    "f-person/git-blame.nvim",
    "makerj/vim-pdf",
    { import = "plugins" },
    {
      "folke/tokyonight.nvim",
      lazy = true,
      opts = { style = "night" },
    },
    "rafi/awesome-vim-colorschemes",
    {
      "scottmckendry/cyberdream.nvim",
      config = function()
        require("cyberdream").setup({
          -- Enable transparent background
          transparent = true,

          -- Enable italics comments
          italic_comments = true,

          -- Replace all fillchars with ' ' for the ultimate clean look
          hide_fillchars = false,

          -- Modern borderless telescope theme
          borderless_telescope = true,

          -- Set terminal colors used in `:terminal`
          terminal_colors = true,

          theme = {
            variant = "default", -- use "light" for the light variant
            highlights = {
              -- Highlight groups to override, adding new groups is also possible
              -- See `:h highlight-groups` for a list of highlight groups or run `:hi` to see all groups and their current values

              -- Example:
              Comment = { fg = "#696969", bg = "NONE", italic = true },

              -- Complete list can be found in `lua/cyberdream/theme.lua`
            },

            -- Override a color entirely
            colors = {
              -- For a list of colors see `lua/cyberdream/colours.lua`
              -- Example:
              bg = "#000000",
              green = "#00ff00",
              magenta = "#ff00ff",
            },
          },
        })
      end,
    },
  },
  defaults = {
    -- By default, only Lazyim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "cyberdream", "tokyonight" } },
  checker = { enabled = true }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

local lspconfig = require("lspconfig")
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

lspconfig.emmet_language_server.setup({
  filetypes = {
    "css",
    "eruby",
    "html",
    "javascript",
    "javascriptreact",
    "less",
    "sass",
    "scss",
    "svelte",
    "pug",
    "typescriptreact",
    "vue",
    "eelixir",
    "elixir",
    "heex",
  },
  -- Read more about this options in the [vscode docs](https://code.visualstudio.com/docs/editor/emmet#_emmet-configuration).
  -- **Note:** only the options listed in the table are supported.
  init_options = {
    --- @type string[]
    excludeLanguages = {},
    --- @type string[]
    extensionsPath = {},
    --- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/preferences/)
    preferences = {},
    --- @type boolean Defaults to `true`
    showAbbreviationSuggestions = true,
    --- @type "always" | "never" Defaults to `"always"`
    showExpandedAbbreviation = "always",
    --- @type boolean Defaults to `false`
    showSuggestionsAsSnippets = false,
    --- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/syntax-profiles/)
    syntaxProfiles = {},
    --- @type table<string, string> [Emmet Docs](https://docs.emmet.io/customization/snippets/#variables)
    variables = {},
  },
})

lspconfig.tailwindcss.setup({
  capabilities = capabilities,
  filetypes = { "html", "elixir", "eelixir", "heex" },
  init_options = {
    userLanguages = {
      elixir = "html-eex",
      eelixir = "html-eex",
      heex = "html-eex",
    },
  },
  settings = {
    tailwindCSS = {
      experimental = {
        classRegex = {
          'class[:]\\s*"([^"]*)"',
        },
      },
    },
  },
})

lspconfig.ts_ls.setup({
  capabilities = capabilities,
  settings = {
    preferences = {
      includeInlayParameterNameHints = "all",
    },
  },
})

require("which-key").register({
  C = {
    name = "ChatGPT",
    c = { "<cmd>ChatGPT<CR>", "ChatGPT" },
    e = { "<cmd>ChatGPTEditWithInstruction<CR>", "Edit with instruction", mode = { "n", "v" } },
    g = { "<cmd>ChatGPTRun grammar_correction<CR>", "Grammar Correction", mode = { "n", "v" } },
    t = { "<cmd>ChatGPTRun translate<CR>", "Translate", mode = { "n", "v" } },
    k = { "<cmd>ChatGPTRun keywords<CR>", "Keywords", mode = { "n", "v" } },
    d = { "<cmd>ChatGPTRun docstring<CR>", "Docstring", mode = { "n", "v" } },
    a = { "<cmd>ChatGPTRun add_tests<CR>", "Add Tests", mode = { "n", "v" } },
    o = { "<cmd>ChatGPTRun optimize_code<CR>", "Optimize Code", mode = { "n", "v" } },
    s = { "<cmd>ChatGPTRun summarize<CR>", "Summarize", mode = { "n", "v" } },
    f = { "<cmd>ChatGPTRun fix_bugs<CR>", "Fix Bugs", mode = { "n", "v" } },
    x = { "<cmd>ChatGPTRun explain_code<CR>", "Explain Code", mode = { "n", "v" } },
    r = { "<cmd>ChatGPTRun roxygen_edit<CR>", "Roxygen Edit", mode = { "n", "v" } },
    l = { "<cmd>ChatGPTRun code_readability_analysis<CR>", "Code Readability Analysis", mode = { "n", "v" } },
  },
}, { prefix = "<leader>" })

require("nvim-tree").setup({
  update_focused_file = {
    enable = true,
  },
})
