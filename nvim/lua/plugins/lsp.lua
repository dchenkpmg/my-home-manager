-- ~/.config/nvim/lua/plugins/lsp.lua
-- return {
--   {
--     "nvim-lspconfig",
--     opts = {
--       diagnostics = {
--         virtual_text = false,
--       },
--     },
--   },
-- }

return {
  { -- change nvim-lspconfig options
    "nvim-lspconfig",
    opts = {
      diagnostics = {
        virtual_text = false,
      },
      servers = {
        -- https://github.com/microsoft/pyright/discussions/5852#discussioncomment-6874502
        pyright = {
          capabilities = {
            textDocument = {
              publishDiagnostics = {
                tagSupport = {
                  valueSet = { 2 },
                },
              },
            },
          },
        },
        ruff_lsp = {
          -- https://github.com/astral-sh/ruff-lsp/issues/384
          init_options = {
            settings = {
              args = {
                -- "--ignore=F401",
              },
            },
          },
        },
      },
    },
  },
}
