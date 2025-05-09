require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = {
		-- JavaScript/TypeScript
		"ts_ls",
		"eslint",
		"tailwindcss",

		-- PHP
		"intelephense", -- PHP LSP

		-- Docker
		"dockerls",
		"docker_compose_language_service",

		-- CSS/SCSS
		"cssls",

		-- Others
		"jsonls",
		"lua_ls",
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

-- PHP configuration
lspconfig.intelephense.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		intelephense = {
			filetypes = { "php", "blade", "php_only" },
			files = {
				maxSize = 1000000,
			},
		},
	},
})

-- CSS/SCSS configuration
lspconfig.cssls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		css = {
			validate = true,
		},
		scss = {
			validate = true,
		},
	},
})

-- Tailwind CSS configuration
lspconfig.tailwindcss.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- Docker configuration
lspconfig.dockerls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

lspconfig.docker_compose_language_service.setup({
	capabilities = capabilities,
	on_attach = on_attach,
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

local prettier = {
    formatCommand = "prettier --stdin-filepath ${INPUT} --single-quote false",
    formatStdin = true,
}

local eslint = {
    lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
    lintStdin = true,
    lintFormats = {"%f:%l:%c: %m"},
    lintIgnoreExitCode = true,
}

local stylelint = {
    lintCommand = "stylelint --formatter unix --stdin-filename ${INPUT} --stdin",
    lintStdin = true,
    lintFormats = {"%f:%l:%c: %m"},
    lintIgnoreExitCode = true,
    formatCommand = "stylelint --fix --stdin-filename ${INPUT} --stdin",
    formatStdin = true,
}

local pint = {
    formatCommand = "pint ${INPUT}",
    formatStdin = false,
}

local blade_formatter = {
    formatCommand = "blade-formatter --stdin",
    formatStdin = true,
}

local stylua = {
    formatCommand = "stylua --stdin-filepath ${INPUT} -",
    formatStdin = true,
}

-- efm with formatters and linters
lspconfig.efm.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    init_options = {documentFormatting = true},
    filetypes = {"javascript", "typescript", "typescriptreact", "javascriptreact", "php", "lua", "blade", "css", "scss", "json", "yaml"},
    settings = {
        rootMarkers = {".git/"},
        languages = {
            javascript = {prettier, eslint},
            typescript = {prettier, eslint},
            typescriptreact = {prettier, eslint},
            javascriptreact = {prettier, eslint},
            php = {pint},
            blade = {blade_formatter},
            css = {prettier, stylelint},
            scss = {prettier, stylelint},
            lua = {stylua},
            json = {prettier},
            yaml = {prettier},
        }
    }
})



-- Format on save
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*" },
    callback = function(args)
        local filetype = vim.bo[args.buf].filetype
        
        vim.lsp.buf.format({
            bufnr = args.buf,
            timeout_ms = 3000,
            filter = function(client)
                -- Prefer efm for formatting
                return client.name == "efm"
            end,
        })
    end,
})

-- Load snippets
require("luasnip.loaders.from_vscode").lazy_load()
