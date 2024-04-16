-- shoutout to Blan_11 https://www.reddit.com/r/neovim/comments/14lchi0/nvim_lazynvim_and_catppuccin_theme/
return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
        require("catppuccin").setup({
            flavour = "macchiato",
            transparent_background = true,
        })
        -- setup must be called before loading
        vim.cmd.colorscheme "catppuccin-macchiato"
    end
}
