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
		"solidity_ls", -- Solidity
		"efm",
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

-- Solidity
lspconfig.solidity_ls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	filetypes = { "solidity" },
	root_dir = lspconfig.util.root_pattern("hardhat.config.*", "foundry.toml", "remappings.txt", ".git"),
	settings = {
		solidity = {
			includePath = "",
			remappings = {
				["@openzeppelin/"] = "lib/openzeppelin-contracts/",
				["account-abstraction/"] = "lib/account-abstraction/",
			},
		},
	},
})

-- Astro configuration
lspconfig.astro.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

local languages = {
	lua = {
		{
			formatCommand = "stylua --search-parent-directories --stdin-filepath ${INPUT} -",
			formatStdin = true,
		},
	},
	javascript = {
		{
			formatCommand = "prettierd ${INPUT}",
			formatStdin = true,
		},
		{
			lintCommand = "eslint_d --format unix --stdin --stdin-filename ${INPUT}",
			lintStdin = true,
			lintFormats = { "%f:%l:%c: %m" },
			lintIgnoreExitCode = true,
		},
	},
	typescript = {
		{
			formatCommand = "prettierd ${INPUT}",
			formatStdin = true,
		},
		{
			lintCommand = "eslint_d --format unix --stdin --stdin-filename ${INPUT}",
			lintStdin = true,
			lintFormats = { "%f:%l:%c: %m" },
			lintIgnoreExitCode = true,
		},
	},
	json = {
		{
			formatCommand = "prettierd ${INPUT}",
			formatStdin = true,
		},
	},
	solidity = {
		{
			formatCommand = "prettierd ${INPUT} --plugin=prettier-plugin-solidity",
			formatStdin = true,
		},
		{
			lintCommand = "solhint --formatter unix ${INPUT}",
			lintStdin = false,
			lintFormats = { "%f:%l:%c: %m" },
		},
	},
	go = {
		{
			formatCommand = "gofmt -s",
			formatStdin = true,
		},
		{
			lintCommand = "golangci-lint run --out-format line-number --disable=errcheck ${INPUT}",
			lintStdin = false,
			lintFormats = { "%f:%l:%c: %m" },
		},
	},
}

lspconfig.efm.setup({
	init_options = { documentFormatting = true, codeAction = true },
	filetypes = { "lua", "javascript", "typescript", "json", "solidity", "go" },
	settings = {
		rootMarkers = { ".git/" },
		languages = languages,
	},
	capabilities = capabilities,
	on_attach = on_attach,
})

-- Format on save
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.lua", "*.js", "*.ts", "*.json", "*.sol", "*.go" },
	callback = function()
		vim.lsp.buf.format({ timeout_ms = 3000 })
	end,
})

-- Load snippets
require("luasnip.loaders.from_vscode").lazy_load()
