-- Bootstrap lazy.nvim
opts = {}
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = true
vim.o.cursorline = true
vim.opt.tabstop = 2 -- how many spaces a TAB counts for
vim.opt.shiftwidth = 2 -- how many spaces to use when auto-indenting
vim.opt.expandtab = true -- convert tabs to spaces

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- add your plugins here
		{
			"nvim-lualine/lualine.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			opts = {},
		},
		{
			"maxmx03/solarized.nvim",
			lazy = false,
			priority = 1000,
			---@type solarized.config
			opts = {},

			config = function(_, opts)
				vim.o.termguicolors = true
				vim.o.background = "dark"
				require("solarized").setup(opts)
				vim.cmd.colorscheme("solarized")
			end,
		},
		{
			"nvim-treesitter/nvim-treesitter",
			branch = "master",
			lazy = false,
			build = ":TSUpdate",
			config = function()
				require("nvim-treesitter.configs").setup({
					ensure_installed = { "lua", "javascript", "typescript", "vim", "html", "css", "tsx" },
					highlight = {
						enable = true,
						additional_vim_regex_highlighting = false,
					},
					autotag = { enable = true },
				})
			end,
		},
		{
			"windwp/nvim-ts-autotag",
			dependencies = { "nvim-treesitter/nvim-treesitter" },
			config = function()
				require("nvim-ts-autotag").setup()
			end,
		},
		{
			"windwp/nvim-autopairs",
			event = "InsertEnter",
			config = true,
		},
		{
			"stevearc/conform.nvim",
			opts = {
				formatters_by_ft = {
					javascript = { "prettier" },
					javascriptreact = { "prettier" },
					typescript = { "prettier" },
					typescriptreact = { "prettier" },
					lua = { "stylua" },
					python = { "black" },
				},
				format_on_save = {
					timeout_ms = 500,
					lsp_fallback = true,
				},
			},
		},
		{
			"ibhagwan/fzf-lua",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			-- dependencies = { "echasnovski/mini.icons" },
			opts = {
				files = {
					fd_opts = [[--color=never --type f --hidden --exclude node_modules]],
				},
			},
			config = function()
				local fzf = require("fzf-lua")
				fzf.setup(opts)
				vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "Find files" })
				vim.keymap.set("n", "<leader>fg", fzf.live_grep, { desc = "Live grep" })
				vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "Buffers" })
				vim.keymap.set("n", "<leader>fh", fzf.help_tags, { desc = "Help tags" })
			end,
		},
		{
			"mason-org/mason-lspconfig.nvim",
			opts = {},
			dependencies = {
				{ "mason-org/mason.nvim", opts = {} },
				"neovim/nvim-lspconfig",
			},
		},
		{
			"neovim/nvim-lspconfig",
			config = function() end,
		},
		{
			"saghen/blink.cmp",
			dependencies = { "rafamadriz/friendly-snippets" },
			version = "1.*",
			opts = {
				keymap = {
					preset = "default",
					["<Up>"] = { "select_prev", "fallback" },
					["<Down>"] = { "select_next", "fallback" },
					["<CR>"] = { "accept", "fallback" },
					["<C-l>"] = {
						function(cmp)
							cmp.show({ providers = { "snippets" } })
						end,
					},
				},
				appearance = {
					nerd_font_variant = "mono",
				},
				completion = { documentation = { auto_show = false } },
				sources = {
					default = { "lsp", "path", "snippets", "buffer" },
				},
				fuzzy = { implementation = "prefer_rust_with_warning" },
			},
		},
	},
	install = { colorscheme = { "solarized" } },
	checker = { enabled = true },
})

vim.api.nvim_create_autocmd({ "BufWritePre", "BufEnter" }, {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})
