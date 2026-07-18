return {
  -- 🧰 Mason: Tool installer
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        -- Lua
        "stylua",
        "selene",
        "luacheck",
        -- Shell
        "shellcheck",
        "shfmt",
        -- Web
        "tailwindcss-language-server",
        "typescript-language-server",
        "css-lsp",
        "html-lsp",
        "eslint-lsp",
        "prettierd",
        -- Others
        "yaml-language-server",
      })
    end,
  },

  -- ⚙️ LSP Configuration
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = true }, -- enable inline hints globally

      ---@type lspconfig.options
      servers = {
        -- CSS
        cssls = {},

        -- HTML
        html = {},

        -- YAML
        yamlls = {
          settings = {
            yaml = {
              keyOrdering = false,
            },
          },
        },

        -- 🌈 TailwindCSS
        tailwindcss = {
          filetypes = {
            "html",
            "css",
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
          },
        },

        -- 🧠 TypeScript / JavaScript (renamed from tsserver to ts_ls)
        ts_ls = {
          root_dir = function(...)
            return require("lspconfig.util").root_pattern("tsconfig.json", "package.json", ".git")(...)
          end,
          single_file_support = false,
          flags = {
            debounce_text_changes = 150,
          },
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "literals",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
        },

        -- 🧩 ESLint
        eslint = {
          root_dir = require("lspconfig.util").root_pattern(".eslintrc", ".eslintrc.js", ".eslintrc.json", ".git"),
        },

        -- 🧮 Lua
        lua_ls = {
          single_file_support = true,
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              completion = {
                workspaceWord = true,
                callSnippet = "Both",
              },
              hint = {
                enable = true,
                paramType = true,
                paramName = "Disable",
                semicolon = "Disable",
                arrayIndex = "Disable",
              },
              diagnostics = {
                disable = { "incomplete-signature-doc", "trailing-space" },
                unusedLocalExclude = { "_*" },
              },
              format = {
                enable = false, -- disable formatting; use stylua instead
                defaultConfig = {
                  indent_style = "space",
                  indent_size = "2",
                  continuation_indent_size = "2",
                },
              },
            },
          },
        },

        -- 🔭 Custom LSP keymaps (new method) for all servers
        ["*"] = {
          keys = {
            {
              "gd",
              function()
                require("telescope.builtin").lsp_definitions({ reuse_win = false })
              end,
              desc = "Goto Definition (Telescope)",
              has = "definition",
            },
            {
              "gr",
              function()
                require("telescope.builtin").lsp_references()
              end,
              desc = "Goto References",
              has = "references",
            },
            {
              "gi",
              function()
                require("telescope.builtin").lsp_implementations()
              end,
              desc = "Goto Implementations",
              has = "implementation",
            },
            {
              "gt",
              function()
                require("telescope.builtin").lsp_type_definitions()
              end,
              desc = "Goto Type Definitions",
              has = "typeDefinition",
            },
          },
        },
      },

      -- 🔧 Custom setup per server
      setup = {
        -- disable ts_ls formatting (use prettier)
        ts_ls = function(_, opts)
          opts.on_attach = function(client)
            client.server_capabilities.documentFormattingProvider = false
          end
        end,

        eslint = function(_, opts)
          opts.on_attach = function(client)
            client.server_capabilities.documentFormattingProvider = true
          end
        end,
      },
    },
  },
}
