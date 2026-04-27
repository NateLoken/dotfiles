return {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    opts = {
        install_dir = vim.fn.stdpath("data") .. "/site",
    },
    config = function(_, opts)
        local ts = require("nvim-treesitter")
        ts.setup(opts)
        ts.install({ "html", "lua", "vim", "vimdoc", "rust", "c", "javascript", "typescript" })
        --require("nvim-treesitter").setup(opts)

        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "lua", "vim", "vimdoc", "query", "markdown", "html" },
            callback = function(args)
                pcall(vim.treesitter.start, args.buf)
            end,
        })

        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "lua", "vim", "vimdoc", "query", "markdown", "html" },
            callback = function(args)
                vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
        })
    end,
}

-- return {
--     "nvim-treesitter/nvim-treesitter",
--     --build = ":TSUpdate",
--     config = function()
--         require('nvim-treesitter.configs').setup({
--             -- A list of parser names, or "all" (the five listed parsers should always be installed)
--             ensure_installed = { "javascript", "typescript", "c", "rust", "lua", "vim", "vimdoc", "query" },
--
--             -- Install parsers synchronously (only applied to `ensure_installed`)
--             sync_install = false,
--
--             -- Automatically install missing parsers when entering buffer
--             -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
--             auto_install = true,
--
--             highlight = {
--                 enable = true,
--
--                 -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
--                 -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
--                 -- Using this option may slow down your editor, and you may see some duplicate highlights.
--                 -- Instead of true it can also be a list of languages
--                 additional_vim_regex_highlighting = { "markdown" },
--             },
--         })
--     end
-- }
