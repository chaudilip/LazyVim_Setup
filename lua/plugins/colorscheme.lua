return {
  -- Default theme (set in lua/config/lazy.lua)
  {
    "craftzdog/solarized-osaka.nvim",
    lazy = true,
    priority = 1000,
    opts = function()
      return {
        transparent = true,
        style = "vivid",
      }
    end,
  },

  -- VSCode Dark+ / Light+ theme
  {
    "Mofiqul/vscode.nvim",
    lazy = true,
    opts = {
      -- set to true for transparent background like solarized-osaka
      transparent = false,
      italic_comments = true,
    },
  },

  -- Tokyo Night (ships with LazyVim, configured here)
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = { style = "night" }, -- night, storm, moon, day
  },

  -- Catppuccin (ships with LazyVim, configured here)
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    opts = { flavour = "mocha" }, -- latte, frappe, macchiato, mocha
  },

  -- Gruvbox
  {
    "ellisonleao/gruvbox.nvim",
    lazy = true,
    opts = {},
  },

  -- OneDark (Atom-style)
  {
    "navarasu/onedark.nvim",
    lazy = true,
    opts = { style = "dark" }, -- dark, darker, cool, deep, warm, warmer, light
  },

  -- Kanagawa
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    opts = {},
  },

  -- Rose Pine
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true,
    opts = {},
  },

  -- Dracula
  {
    "Mofiqul/dracula.nvim",
    lazy = true,
    opts = {},
  },

  -- Nightfox family (nightfox, dayfox, duskfox, nordfox, terafox, carbonfox)
  {
    "EdenEast/nightfox.nvim",
    lazy = true,
    opts = {},
  },
}
