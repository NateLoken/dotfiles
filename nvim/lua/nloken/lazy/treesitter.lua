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
