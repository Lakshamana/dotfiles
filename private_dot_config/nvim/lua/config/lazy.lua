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
    { import = "lazyvim.plugins.extras.lang.elixir" },
    { import = "lazyvim.plugins.extras.lang.kotlin" },
    { import = "lazyvim.plugins.extras.lang.go" },
    { import = "lazyvim.plugins.extras.lang.rust" },
    { import = "lazyvim.plugins.extras.lang.json" },
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
          -- Set light or dark variant
          variant = "default", -- use "light" for the light variant. Also accepts "auto" to set dark or light colors based on the current value of `vim.o.background`

          -- Enable transparent background
          transparent = false,

          -- Reduce the overall saturation of colours for a more muted look
          saturation = 1, -- accepts a value between 0 and 1. 0 will be fully desaturated (greyscale) and 1 will be the full color (default)

          -- Enable italics comments
          italic_comments = false,

          -- Replace all fillchars with ' ' for the ultimate clean look
          hide_fillchars = false,

          -- Apply a modern borderless look to pickers like Telescope, Snacks Picker & Fzf-Lua
          borderless_pickers = false,

          -- Set terminal colors used in `:terminal`
          terminal_colors = true,

          -- Improve start up time by caching highlights. Generate cache with :CyberdreamBuildCache and clear with :CyberdreamClearCache
          cache = false,

          -- Override highlight groups with your own colour values
          highlights = {
            -- Highlight groups to override, adding new groups is also possible
            -- See `:h highlight-groups` for a list of highlight groups or run `:hi` to see all groups and their current values

            -- Example:
            Comment = { fg = "#696969", bg = "NONE", italic = true },
            LspInlayHint = { fg = "#6d6d6d", bg = "#0d0d0d" },

            -- More examples can be found in `lua/cyberdream/extensions/*.lua`
          },

          -- Override a highlight group entirely using the built-in colour palette
          -- overrides = function(colors) -- NOTE: This function nullifies the `highlights` option
          --   -- Example:
          --   return {
          --     Comment = { fg = colors.green, bg = "NONE", italic = true },
          --     ["@property"] = { fg = colors.magenta, bold = true },
          --   }
          -- end,

          -- Override a color entirely
          ---@diagnostic disable-next-line: missing-fields
          colors = {
            -- For a list of colors see `lua/cyberdream/colours.lua`
            -- Example:
            bg = "#000000",
            green = "#00ff00",
            magenta = "#ff00ff",
          },

          -- Disable or enable colorscheme extensions
          extensions = {
            telescope = false,
            snacks = true,
            notify = true,
            mini = true,
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

local capabilities = vim.lsp.protocol.make_client_capabilities()

vim.lsp.config("*", {
  capabilities = capabilities,
})

vim.lsp.config("emmet_language_server", {
  filetypes = {
    "css",
    "eruby",
    "html",
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

-- lspconfig.tailwindcss.setup({
--   filetypes = { "html", "eelixir", "heex" },
--   init_options = {
--     userLanguages = {
--       elixir = "html-eex",
--       eelixir = "html-eex",
--       heex = "html-eex",
--     },
--   },
--   settings = {
--     tailwindCSS = {
--       experimental = {
--         classRegex = {
--           'class[:]\\s*"([^"]*)"',
--         },
--       },
--     },
--   },
-- })

vim.lsp.config("ts_ls", {
  init_options = {
    preferences = {
      includeInlayParameterNameHints = "all",
      includeCompletionsWithInsertText = true,
      includeInlayParameterNameHintsWhenArgumentMatchesName = false,
      includeInlayVariableTypeHintsWhenTypeMatchesName = false,
      includeInlayFunctionParameterTypeHints = true,
      includeInlayVariableTypeHints = false,
      includeInlayPropertyDeclarationTypeHints = true,
      includeInlayFunctionLikeReturnTypeHints = false,
      includeInlayEnumMemberValueHints = true,
    },
    -- plugins = {
    --   {
    --     name = "@vue/typescript-plugin",
    --     location = require("mason-registry").get_package("vue-language-server"):get_install_path()
    --       .. "/node_modules/@vue/language-server",
    --     languages = { "vue" },
    --   },
    -- },
    filetypes = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "vue",
    },
  },
})

vim.lsp.config("vuels", {})

vim.lsp.config("kotlin_language_server", {
  cmd = { "kotlin-language-server" },
  root_dir = require("lspconfig.util").root_pattern(
    "settings.gradle",
    "settings.gradle.kts",
    "build.gradle",
    "build.gradle.kts",
    ".git"
  ),
  settings = {
    kotlin = {
      inlayHints = {
        typeHints = true,
        parameterHints = true,
        chainedHints = true,
      },
      externalSources = {
        useKlsScheme = true,
      },
      indexing = {
        enabled = true,
      },
    },
  },
  init_options = {
    gradleProjectPath = vim.fn.getcwd() .. "/build.gradle.kts", -- or .gradle
  },
})

vim.lsp.config("vtsls", {
  settings = {
    complete_function_calls = false,
    typescript = {
      suggest = {
        completeFunctionCalls = false,
      },
      preferences = {
        includeCompletionsForImportModuleSpecifier = "minimal",
        includeCompletionsWithSnippetText = false, -- Disable snippets
        includeCompletionsWithInsertText = false,
      },
    },
    javascript = {
      suggest = {
        completeFunctionCalls = false,
      },
      preferences = {
        includeCompletionsForImportModuleSpecifier = "minimal",
        includeCompletionsWithSnippetText = false, -- Disable snippets
        includeCompletionsWithInsertText = false,
      },
    },
  },
})

-- lspconfig.volar.setup({
--   init_options = {
--     vue = {
--       hybridMode = false,
--     },
--   },
-- })
