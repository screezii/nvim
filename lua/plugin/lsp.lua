return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		build = ":TSUpdate",
		-- dependencies = {
		-- 	"nvim-treesitter/nvim-treesitter-context"
		-- },
		config = function()
			local configs = require("nvim-treesitter.configs")

			configs.setup({
				ensure_installed = { "c", "lua", "vim", "vimdoc", "java", "go", "python", "javascript", "typescript" },
				auto_install = true,
				sync_install = false,
				highlight = {
					enable = true,
					disable = { "latex", "tex" },
					additional_vim_regex_highlighting = { "latex", "tex" },
				},
				indent = {
					enable = true,
					disable = { "latex", "tex" },
				},
			})
		end,
	},
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = true,
	},
	{
		"hrsh7th/nvim-cmp",
		lazy = false,
		dependencies = {
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "williamboman/mason-lspconfig.nvim" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{
				"L3MON4D3/LuaSnip",
				build = "make install_jsregexp",
				dependencies = {
					{ "rafamadriz/friendly-snippets" },
					{ "honza/vim-snippets" },
					{ "molleweide/LuaSnip-snippets.nvim" },
				},
				config = function()
					local ls = require("luasnip")
					local types = require("luasnip.util.types")

					require("luasnip.loaders.from_vscode").lazy_load()
					require("luasnip.loaders.from_snipmate").lazy_load()
					require("luasnip.loaders.from_lua").lazy_load()

					ls.config.set_config({
						history = true,
						updateevents = "TextChanged,TextChangedI",
						enable_autosnippets = true,
						ext_opts = {
							[types.choiceNode] = {
								active = {
									virt_text = { { "●", "Comment" } },
								},
							},
						},
					})

					local function expand_snippet_or_space()
						if ls.expand_or_jumpable() then
							ls.expand_or_jump()
							return
						end

						local line = vim.api.nvim_get_current_line()
						local col = vim.api.nvim_win_get_cursor(0)[2]
						local before_cursor = line:sub(1, col)

						local ft = vim.bo.filetype
						if ft == "" then
							vim.api.nvim_feedkeys(" ", "n", false)
							return
						end

						local snippets = ls.get_snippets(ft) or {}
						for _, snippet in ipairs(snippets) do
							if snippet.trigger then
								local trigger = snippet.trigger
								if before_cursor:match(vim.pesc(trigger) .. "$") then
									vim.api.nvim_feedkeys(
										vim.api.nvim_replace_termcodes("<Tab>", true, false, true),
										"n",
										false
									)
									return
								end
							end
						end

						vim.api.nvim_feedkeys(" ", "n", false)
					end

					vim.api.nvim_create_autocmd("FileType", {
						pattern = { "tex", "latex" },
						callback = function()
							vim.keymap.set("i", "<Space>", expand_snippet_or_space, { buffer = true, silent = true })
						end,
					})

					vim.keymap.set({ "i" }, "<C-L>", function()
						ls.expand()
					end, { silent = true })
					vim.keymap.set({ "i", "s" }, "<C-J>", function()
						ls.jump(1)
					end, { silent = true })
					vim.keymap.set({ "i", "s" }, "<C-K>", function()
						ls.jump(-1)
					end, { silent = true })

					vim.keymap.set({ "i", "s" }, "<C-E>", function()
						if ls.choice_active() then
							ls.change_choice(1)
						end
					end, { silent = true })
				end,
			},
		},
		config = function()
			local cmp = require("cmp")
			local ls = require("luasnip")

			cmp.setup({
				enabled = function()
					local buftype = vim.api.nvim_buf_get_option(0, "buftype")
					local filetype = vim.api.nvim_buf_get_option(0, "filetype")

					if buftype == "prompt" or buftype == "nofile" then
						return false
					end

					if filetype == "noice" then
						return false
					end

					if filetype == "NvimTree" then
						return false
					end

					local bufname = vim.api.nvim_buf_get_name(0)
					if bufname:match("snacks") then
						return false
					end

					return true
				end,
				completion = {
					keyword_length = 1,
				},
				sources = {
					{ name = "luasnip", priority = 1000 },
					{ name = "nvim_lsp", priority = 750 },
					{ name = "path", priority = 250 },
					{ name = "buffer", priority = 500 },
				},
				sorting = {
					comparators = {
						cmp.config.compare.offset,
						cmp.config.compare.exact,
						cmp.config.compare.recently_used,
						cmp.config.compare.kind,
						cmp.config.compare.sort_text,
						cmp.config.compare.length,
						cmp.config.compare.order,
					},
				},
				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete({ silent = true }),
					["<C-u>"] = cmp.mapping.scroll_docs(-4, { silent = true }),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<C-d>"] = cmp.mapping.scroll_docs(4, { silent = true }),
					["<Tab>"] = cmp.mapping(function(fallback)
						local col = vim.fn.col(".") - 1
						local before = vim.api.nvim_get_current_line():sub(1, col)

						-- At line start or after whitespace: always insert a real Tab
						if vim.fn.mode() == "i" and (col == 0 or before:match("%s$")) then
							cmp.close()
							fallback()
						elseif cmp.visible() then
							cmp.select_next_item()
						elseif ls.expand_or_locally_jumpable() then
							ls.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if ls.jumpable(-1) then
							ls.jump(-1)
						elseif cmp.visible() then
							cmp.select_prev_item()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<C-j>"] = cmp.mapping.select_next_item({ silent = true }),
					["<C-k>"] = cmp.mapping.select_prev_item({ silent = true }),
				}),
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		cmd = { "LspInfo", "LspInstall", "LspStart" },
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			vim.api.nvim_create_autocmd("LspAttach", {
				desc = "LSP actions",
				callback = function(event)
					local opts = { buffer = event.buf }

					local function goto_definition_vsplit()
						local current_win = vim.api.nvim_get_current_win()
						vim.cmd("vsplit")
						local new_win = vim.api.nvim_get_current_win()
						vim.lsp.buf.definition()
						vim.api.nvim_set_current_win(new_win)
					end

					vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
					vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
					vim.keymap.set(
						"n",
						"gvd",
						goto_definition_vsplit,
						{ noremap = true, silent = true, desc = "Go to definition in vertical split" }
					)
					vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
					vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
					vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
					vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
					vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
					vim.keymap.set("n", "<C-k>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
					vim.keymap.set("n", "<space>a", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
				end,
			})

			require("mason-lspconfig").setup({
				automatic_installation = true,
				ensure_installed = {},
				handlers = {
					function(server_name)
						vim.lsp.config(server_name, {
							capabilities = capabilities,
						})
						vim.lsp.enable(server_name)
					end,
				},
			})

			vim.lsp.config("eslint", {
				on_attach = function(client, bufnr)
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = bufnr,
						callback = function()
							-- Use code action to fix all issues
							local params = {
								command = "eslint.applyAllFixes",
								arguments = { vim.uri_from_bufnr(bufnr) },
							}
							vim.lsp.buf.execute_command(params)
						end,
					})
				end,
				settings = {
					workingDirectory = { mode = "auto" },
				},
			})
			vim.lsp.enable("eslint")
		end,
	},
	{
		"stevearc/conform.nvim",
		event = "VeryLazy",
		opts = {
			formatters_by_ft = {
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},
		},
	},
	{
		"nvim-java/nvim-java",
	},
}
