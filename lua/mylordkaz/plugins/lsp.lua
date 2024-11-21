local lsp_zero = require('lsp-zero')
local cmp = require('cmp')
local null_ls = require('null-ls')

-- LSP Configuration
lsp_zero.extend_lspconfig({
	capabilities = require('cmp_nvim_lsp').default_capabilities(),
	lsp_attach = function(client, bufnr)
		lsp_zero.default_keymaps({ buffer = bufnr })
	end,
	float_border = 'rounded',
	sign_text = true,
})

-- Mason Setup
require('mason').setup({})
require('mason-lspconfig').setup({
	ensure_installed = {
		'ts_ls',      -- JS/TS
		'lua_ls',     -- Lua
		'gopls',      -- Go
		'svelte',     -- Svelte
		'intelephense', -- PHP
		'eslint',     -- Linting
		'tailwindcss' -- Tailwind
	},
	handlers = {
		function(server_name)
			require('lspconfig')[server_name].setup({})
		end,
		["lua_ls"] = function()
			local lspconfig = require("lspconfig")
			lspconfig.lua_ls.setup {
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim", "it", "describe", "before_each", "after_each" },
						}
					}
				}
			}
		end,

		-- TypeScript config
		ts_ls = function()
			require('lspconfig').ts_ls.setup({
				settings = {
					typescript = {
						inlayHints = {
							includeInlayParameterNameHints = 'all',
							includeInlayParameterNameHintsWhenArgumentMatchesName = false,
							includeInlayFunctionParameterTypeHints = true,
							includeInlayVariableTypeHints = true,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
							includeInlayEnumMemberValueHints = true,
						}
					},
					javascript = {
						inlayHints = {
							includeInlayParameterNameHints = 'all',
							includeInlayParameterNameHintsWhenArgumentMatchesName = false,
							includeInlayFunctionParameterTypeHints = true,
							includeInlayVariableTypeHints = true,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
							includeInlayEnumMemberValueHints = true,
						}
					}
				}
			})
		end,

		-- Tailwind config
		tailwindcss = function()
			require('lspconfig').tailwindcss.setup({
				settings = {
					tailwindCSS = {
						experimental = {
							classRegex = {
								"tw`([^`]*)",     -- tw`...`
								'tw="([^"]*)',    -- <div tw="..." />
								'tw={"([^"}]*)',  -- <div tw={"..."} />
								"tw\\.\\w+`([^`]*)", -- tw.xxx`...`
								"tw\\(.*?\\)`([^`]*)", -- tw(..)`...`
								"className=\"([^\"]*)", -- className="..."
								"className={\"([^\"}]*)", -- className={"..."}
								"class=\"([^\"]*)", -- class="..."
								"class={\"([^\"}]*)", -- class={"..."}
							},
						},
						validate = true,
					},
				},
			})
		end,

		-- Svelte config
		svelte = function()
			require('lspconfig').svelte.setup({
				settings = {
					svelte = {
						plugin = {
							typescript = {
								enabled = true,
							},
						},
					},
				},
			})
		end,

		-- Golang config
		gopls = function()
			require('lspconfig').gopls.setup({
				settings = {
					gopls = {
						analyses = {
							unusedparams = true,
						},
						staticcheck = true,
						gofumpt = true,
						usePlaceholders = true,
						hints = {
							assignVariableTypes = true,
							compositeLiteralFields = true,
							compositeLiteralTypes = true,
							constantValues = true,
							functionTypeParameters = true,
							parameterNames = true,
							rangeVariableTypes = true,
						},
					},
				},
			})
		end,
	}
})

-- Completion Setup
cmp.setup({
	sources = {
		{ name = 'path' },
		{ name = 'nvim_lsp' },
		{ name = 'buffer',  keyword_length = 3 },
		{ name = 'luasnip', keyword_length = 2 },
	},
	formatting = lsp_zero.cmp_format(),
	mapping = cmp.mapping.preset.insert({
		['<C-u>'] = cmp.mapping.scroll_docs(-4),
		['<C-d>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<CR>'] = cmp.mapping.confirm({ select = true }),
		['<Tab>'] = cmp.mapping.select_next_item(),
		['<S-Tab>'] = cmp.mapping.select_prev_item(),
	}),
	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body)
		end,
	}
})

-- Formatting and Linting Setup
require('mason-null-ls').setup({
	ensure_installed = {
		'prettier',
		'gofmt',
		'golangci-lint',
		'eslint_d',
		'php-cs-fixer',
		'markuplint',
		'tidy',

	}
})

null_ls.setup({
	sources = {
		-- Formatting
		null_ls.builtins.formatting.prettier, -- Default settings
		null_ls.builtins.formatting.gofmt,
		null_ls.builtins.formatting.phpcsfixer,

		-- Diagnostics
		null_ls.builtins.diagnostics.eslint_d,
		null_ls.builtins.diagnostics.golangci_lint,

	},
	debug = false,
})

-- Format on save
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*" },
	callback = function(args)
		-- Only format if a formatter is available for the current filetype
		local filetype = vim.bo[args.buf].filetype
		local have_nls = #require("null-ls.sources").get_available(filetype, "NULL_LS_FORMATTING") > 0

		vim.lsp.buf.format({
			bufnr = args.buf,
			timeout_ms = 3000,
			filter = function(client)
				-- Use null-ls when available, otherwise use the first available formatter
				if have_nls then
					return client.name == "null-ls"
				end
				return client.name ~= "null-ls"
			end,
		})
	end,
})

-- Load snippets
require("luasnip.loaders.from_vscode").lazy_load()
