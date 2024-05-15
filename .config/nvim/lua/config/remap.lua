vim.g.mapleader = " "

-- most of these keybinds are taken from thePrimeagen

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "show root dir" })

-- move code up and down in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "move selected text down in visual mode" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "move selected text up in visual mode" })

-- doesn't move cursor when pressing J
vim.keymap.set("n", "J", "mzJ`z", { desc = "concat curr line with next line while remainig on curr line" })

-- make page jumps centered
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "centered jump page down" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "centered jump page up" })

-- make search results centered
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
-- paste into the void register
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "paste to void register" })

-- next greatest remap ever : asbjornHaland
-- paste into the system keyboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "paste into system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- put deleted text into the void register
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "paste to void register" })

vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end, { desc = "source current file" })

-- make replacing strings easier
vim.keymap.set("n", "<leader>rp", ":%s/", { desc = "shortcut to make replacing strings easier" })

-- create vertical split
vim.keymap.set("n", "<leader>vs", vim.cmd.vsplit, { desc = "make vertical split" })

-- resize splits (from TJ Devries)
vim.keymap.set("n", "<M-.>", "<c-w>5>", { desc = "make vsplit bigger" })
vim.keymap.set("n", "<M-,>", "<c-w>5<", { desc = "make vsplit smaller" })
vim.keymap.set("n", "<M-t>", "<C-W>+", { desc = "make hsplit bigger" })
vim.keymap.set("n", "<M-s>", "<C-W>-", { desc = "make hsplit smaller" })

-- navigate splits (from TJ Devries)
vim.keymap.set("n", "<M-h>", "<c-w><c-h>", { desc = "switch to left split from current" })
vim.keymap.set("n", "<M-j>", "<c-w><c-j>", { desc = "switch to bottom split from current" })
vim.keymap.set("n", "<M-k>", "<c-w><c-k>", { desc = "switch to top split from current" })
vim.keymap.set("n", "<M-l>", "<c-w><c-l>", { desc = "switch to right split from current" })
