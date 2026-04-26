function ColorMyPencils(color)
    color = color or "gruvbox"
    vim.cmd.colorscheme(color)

    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

--return {
--    "catppuccin/nvim",
--    name = "catppuccin",
--
--    config = function()
--        require('catppuccin').setup({
--            disable_background = true
--        })
--        vim.cmd("colorscheme catppuccin")
--
--        ColorMyPencils()
--    end
--}

return {
    "ellisonleao/gruvbox.nvim",
    name = "gruvbox",
    priority = 1000,
    config = function()
        require("gruvbox").setup({
            disable_background = true,
        })
        vim.o.background = "dark"
        vim.cmd("colorscheme gruvbox")
        ColorMyPencils()
    end,
}
