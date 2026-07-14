local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Do things without affecting registers
keymap.set("n", "x", '"_x', opts)
keymap.set("n", "<Leader>p", '"0p', opts)
keymap.set("n", "<Leader>P", '"0P', opts)
keymap.set("v", "<Leader>p", '"0p', opts)

keymap.set("n", "<Leader>c", '"_c', opts)
keymap.set("n", "<Leader>C", '"_C', opts)
keymap.set("v", "<Leader>c", '"_c', opts)
keymap.set("v", "<Leader>C", '"_C', opts)

keymap.set("n", "<Leader>d", '"_d', opts)
keymap.set("n", "<Leader>D", '"_D', opts)
keymap.set("v", "<Leader>d", '"_d', opts)
keymap.set("v", "<Leader>D", '"_D', opts)

-- Diagnostics float
keymap.set("n", "<A-e>", function()
  vim.diagnostic.open_float({ focusable = true })
end, opts)

-- Increment / decrement
keymap.set("n", "+", "<C-a>", opts)
keymap.set("n", "-", "<C-x>", opts)

-- Delete word backwards (preserves registers)
keymap.set("n", "dw", 'vb"_d', opts)

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G", opts)

-- Disable continuations (insert blank line without comment continuation)
keymap.set("n", "<Leader>o", "o<Esc>^Da", opts)
keymap.set("n", "<Leader>O", "O<Esc>^Da", opts)

-- Jumplist forward (avoid terminal Enter conflicts by keeping native <C-i>)
keymap.set("n", "<C-m>", "<C-i>", opts)

-- Tabs (<Tab>/<S-Tab> cycling is handled by bufferline in lua/plugins/ui.lua)
keymap.set("n", "te", ":tabnew<CR>", opts)
keymap.set("n", "tc", ":tabclose<CR>", opts)

-- Splits
keymap.set("n", "ss", ":split<CR>", opts)
keymap.set("n", "sv", ":vsplit<CR>", opts)
keymap.set("n", "<leader>t", ":terminal<CR>", opts)

-- Move between windows
keymap.set("n", "sh", "<C-w>h", opts)
keymap.set("n", "sk", "<C-w>k", opts)
keymap.set("n", "sj", "<C-w>j", opts)
keymap.set("n", "sl", "<C-w>l", opts)

-- Resize windows
keymap.set("n", "<C-w><Left>", "<C-w><", opts)
keymap.set("n", "<C-w><Right>", "<C-w>>", opts)
keymap.set("n", "<C-w><Up>", "<C-w>+", opts)
keymap.set("n", "<C-w><Down>", "<C-w>-", opts)

-- Move current line
keymap.set("n", "<A-Up>", ":m .-1<CR>==", opts)
keymap.set("n", "<A-Down>", ":m .+2<CR>==", opts)

-- Diagnostics navigation
keymap.set("n", "<C-j>", function()
  vim.diagnostic.goto_next()
end, opts)

keymap.set("n", "<leader>r", function()
  require("craftzdog.hsl").replaceHexWithHSL()
end)

keymap.set("n", "<leader>i", function()
  require("craftzdog.lsp").toggleInlayHints()
end)

-- NERDCommenter
keymap.set("n", "cc", "<Plug>NERDCommenterComment", {})
keymap.set("n", "cu", "<Plug>NERDCommenterUncomment", {})
keymap.set("x", "cc", "<Plug>NERDCommenterComment", {})
keymap.set("x", "cu", "<Plug>NERDCommenterUncomment", {})

vim.api.nvim_create_user_command("ToggleAutoformat", function()
  require("craftzdog.lsp").toggleAutoformat()
end, {})
