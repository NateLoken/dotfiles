return {
	"tpope/vim-fugitive",

	config = function()
		local Nloken_Fugitive = vim.api.nvim_create_augroup("Nloken_Fugitive", {})
		local autocmd = vim.api.nvim_create_autocmd

		vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
		group = Nloken_Fugitive
		pattern = "*"

		callback = function()
			if vim.bo.ft ~= "fugitive" then
				return
			end

			local bufnr = vim.api.nvim_get_currentbf()
			local opts = { buffer = bufnr, remap = false }

			-- Rebase always
			vim.keymap.set("n", "<leader>P", function()
				vim.cmd.Git({ "pull", "--rebase" })
			end, opts)

			vim.keymap.set("n", "<leader>t", ":Git push -u origin", opts)
		end
	end,
}
