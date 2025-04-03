-- mason.lua
require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = {
		"ts_ls", -- JS/TS
		"eslint", -- JS/TS linting
		"gopls", -- Go
		"svelte", -- Svelte
		"lua_ls", -- Lua
		"jsonls", -- JSON
		"tailwindcss", -- Tailwind
		"astro", -- Astro
	},
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Shared on_attach function
local on_attach = function(client, bufnr)
	local opts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
	vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
	vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
	vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, opts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
	vim.keymap.set("n", "<space>f", function()
		vim.lsp.buf.format({ async = true })
	end, opts)
end

-- Completion configuration
local cmp = require("cmp")
cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<Tab>"] = cmp.mapping.select_next_item(),
		["<S-Tab>"] = cmp.mapping.select_prev_item(),
	}),
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "path" },
	},
})

local lspconfig = require("lspconfig")

-- TypeScript/JavaScript configuration
lspconfig.ts_ls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		typescript = {
			inlayHints = {
				includeInlayParameterNameHints = "all",
				includeInlayFunctionParameterTypeHints = true,
				includeInlayVariableTypeHints = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
			},
		},
		javascript = {
			inlayHints = {
				includeInlayParameterNameHints = "all",
				includeInlayFunctionParameterTypeHints = true,
				includeInlayVariableTypeHints = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
			},
		},
	},
})

-- Svelte configuration
lspconfig.svelte.setup({
	capabilities = capabilities,
	on_attach = on_attach,
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

-- Lua configuration
lspconfig.lua_ls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim", "it", "describe", "before_each", "after_each" },
				disable = { "missing-fields" },
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
			telemetry = {
				enable = false,
			},
		},
	},
})

-- Go configuration
lspconfig.gopls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
				nilness = true,
				shadow = true,
				useany = true,
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

-- Astro configuration
lspconfig.astro.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- Null-ls configuration for formatters and linters
local null_ls = require("null-ls")
require("mason-null-ls").setup({
	ensure_installed = {
		"prettier", -- JS/TS/Svelte formatting
		"gofmt", -- Go formatting
		"golangci-lint", -- Go linting
		"eslint_d", -- JS/TS/Svelte linting
		"stylua", -- Lua formatting
	},
})

null_ls.setup({
	sources = {
		-- Formatting
		null_ls.builtins.formatting.prettier,
		null_ls.builtins.formatting.gofmt,
		null_ls.builtins.formatting.stylua,

		-- Diagnostics
		null_ls.builtins.diagnostics.eslint_d.with({
			condition = function(utils)
				return utils.root_has_file({ ".eslintrc.js", ".eslintrc.json", ".eslintrc" })
			end,
		}),
		null_ls.builtins.diagnostics.golangci_lint.with({
			diagnostics_format = "[#{c}] #{m} (#{s})",
			extra_args = {
				"--disable=errcheck",
			},
		}),
	},
})

-- Format on save
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*" },
	callback = function(args)
		local filetype = vim.bo[args.buf].filetype
		local have_nls = #require("null-ls.sources").get_available(filetype, "NULL_LS_FORMATTING") > 0

		vim.lsp.buf.format({
			bufnr = args.buf,
			timeout_ms = 3000,
			filter = function(client)
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
