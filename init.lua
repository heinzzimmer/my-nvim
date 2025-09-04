-- Bootstrap lazy.nvim
--
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
vim.o.cursorline = false
vim.opt.tabstop = 2 -- how many spaces a TAB counts for
vim.opt.shiftwidth = 2 -- how many spaces to use when auto-indenting
vim.opt.expandtab = true -- convert tabs to spaces
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic" })

vim.lsp.config["tsserver"] = {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	root_markers = {
		{ "package.json", "tsconfig.json", "jsconfig.json" },
		".git",
	},
	settings = {
		typescript = {
			preferences = {
				importModuleSpecifierPreference = "non-relative", -- or "relative"
				includeCompletionsWithInsertText = true,
			},
		},
		javascript = {
			preferences = {
				importModuleSpecifierPreference = "non-relative", -- or "relative"
				includeCompletionsWithInsertText = true,
			},
		},
	},
}
vim.lsp.enable("tsserver")

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client and client.server_capabilities.documentHighlightProvider then
			client.server_capabilities.documentHighlightProvider = false
		end
	end,
})

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		{
			"nvim-telescope/telescope.nvim",
			tag = "0.1.8",
			dependencies = { "nvim-lua/plenary.nvim" },
			config = function()
				local builtin = require("telescope.builtin")
				vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
				vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
				vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
				vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
			end,
		},
		{
			"nvim-lualine/lualine.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			opts = {},
		},
		{
			"folke/tokyonight.nvim",
			lazy = false,
			priority = 1000,
			config = function()
				vim.cmd([[colorscheme tokyonight-night]])
			end,
		},
		-- {
		-- 	"maxmx03/solarized.nvim",
		-- 	lazy = false,
		-- 	priority = 1000,
		-- 	---@type solarized.config
		-- 	opts = {},
		-- 	config = function(_, opts)
		-- 		vim.o.termguicolors = true
		-- 		vim.o.background = "dark"
		-- 		require("solarized").setup(opts)
		-- 		vim.cmd.colorscheme("solarized")
		-- 	end,
		-- },
		-- {
		-- 	"morhetz/gruvbox",
		-- 	config = function()
		-- 		vim.g.gruvbox_contrast_dark = "hard"
		-- 		vim.cmd.colorscheme("gruvbox")
		-- 	end,
		-- },
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
			config = function()
				require("nvim-autopairs").setup({})
			end,
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
			"nvim-neo-tree/neo-tree.nvim",
			branch = "v3.x",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"MunifTanjim/nui.nvim",
				"nvim-tree/nvim-web-devicons", -- optional, but recommended
			},
			lazy = true,
			cmd = "Neotree",
			keys = {
				{ "<leader>e", "<cmd>Neotree float<cr>", desc = "Float Neotree" },
			},
			config = function()
				require("neo-tree").setup({
					close_if_last_window = true,
					open_files_using_relative_paths = true,
					filesystem = {
						open_on_setup = false,
						filtered_items = {
							visible = true,
							hide_dotfiles = false,
							hide_gitignored = false,
						},
					},
					window = {
						position = "left",
						width = 30,
					},
				})
			end,
		},
		{ "echasnovski/mini.nvim", version = "*" },
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
				},
				appearance = {
					nerd_font_variant = "mono",
				},
				completion = { ghost_text = { enabled = false }, documentation = { auto_show = true } },
				sources = {
					default = { "lsp", "path", "snippets", "buffer" },
				},
				fuzzy = { implementation = "prefer_rust_with_warning" },
				highlight = {
					insert = false,
				},
			},
			opts_extend = { "sources.default" },
		},
	},
	install = { colorscheme = { "solarized" } },
	checker = { enabled = true },
})

