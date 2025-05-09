-- Basic settings

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.smartindent = true
vim.opt.signcolumn = "no"


-- config diag display
vim.diagnostic.config({
	float = {
		border = "rounded",
		source = true,
	},
	virtual_text = false,
	signs = true,
})


vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*",
	callback = function()
		vim.opt.formatoptions = vim.opt.formatoptions - "r" - "o"
	end,
})



-- Schemes

-- For Catppuccin
-- vim.cmd.colorscheme "catppuccin-mocha" -- or catppuccin-latte, catppuccin-frappe, catppuccin-macchiato

-- For Sonokai
-- vim.g.sonokai_style = 'default'  -- or 'atlantis', 'andromeda', 'shusia', 'maia', 'espresso'
-- vim.cmd.colorscheme "sonokai"

-- For Tokyodark
-- vim.cmd.colorscheme "tokyodark"

-- For Bluloco
-- vim.cmd.colorscheme "bluloco"

-- For Modus
vim.cmd.colorscheme "modus_vivendi"

vim.cmd([[
	  hi NvimTreeWinSeparator guifg=none guibg=none
	  hi NvimTreeNormal guibg=none	
	]])

-- For GitHub Dark Blind
-- vim.cmd.colorscheme 'github_dark_high_contrast'
