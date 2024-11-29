-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- local codelldb_extension_path = vim.env.HOME .. "/.local/share/nvim/mason/packages/codelldb/codelldb/extension/"
-- local codelldb_path = codelldb_extension_path .. "adapter/codelldb"

-- vim.g.rustaceanvim = {
--   dap = {
--     autoload_configurations = true,
--     adapter = require("rustaceanvim.config").get_codelldb_adapter(
--       codelldb_path,
--       codelldb_extension_path .. "lldb/lib/liblldb.so"
--     ),
--   },
-- }
