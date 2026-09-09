-- oil.nvim - file explorer that edits the filesystem as a normal buffer.
-- Config copied verbatim from craftzdog/dotfiles @ feat/late-2026:
--   dot_config/nvim/lua/craftzdog/plugins/util.lua    (setup opts)
--   dot_config/nvim/lua/craftzdog/plugins/keymaps.lua (the `sf` binding)
--
-- Edit a line to rename, add a line to create (trailing `/` = directory),
-- `dd` to delete, then `:w` to apply. `h` goes to the parent, `q` closes.
return {
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-mini/mini.icons" },
    -- must load at startup for `default_file_explorer` to take over netrw
    lazy = false,
    keys = {
      {
        "sf",
        function()
          require("oil").open_float(nil, { preview = {} })
        end,
        desc = "Toggle file explorer (oil)",
      },
    },
    opts = {
      default_file_explorer = true,
      columns = {
        "icon",
        { "permissions", highlight = "Type" },
        { "size", highlight = "String" },
        { "mtime", highlight = "Keyword" },
      },
      keymaps = {
        ["h"] = { "actions.parent", mode = "n" },
        ["q"] = { "actions.close", mode = "n" },
      },
      view_options = {
        show_hidden = true,
      },
      float = {
        padding = 8,
        border = "rounded",
        win_options = {
          winblend = 0,
        },
        max_width = 200,
      },
      preview_win = {
        update_on_cursor_moved = true,
      },
      lsp_file_methods = {
        enabled = true,
        timeout_ms = 1000,
        autosave_changes = true,
      },
    },
  },
}
