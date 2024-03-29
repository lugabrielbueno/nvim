local loaded, cmp = pcall(require, "cmp")
if not loaded then
	return
end
vim.opt.completeopt = { "menu", "menuone", "noselect" }
cmp.setup({
	view = {
		entries = "custom", --native or wildmenu or custom
	},
	formatting = {
		format = require("lspkind").cmp_format({
			mode = "symbol_text",
			menu = {
				nvim_lsp = "[LSP]",
				treesitter = "[Tree-sitter]",
				luasnip = "[LuaSnip]",
				nvim_lua = "[Lua]",
				buffer = "[Buffer]",
				path = "[Path]",
			},
		}),
	},
	--		format = function(entry, vim_item)
	-- fancy icons and a name of kind
	--			vim_item.kind = require("lspkind").presets.default[vim_item.kind] ..
	--			" " .. vim_item.kind
	-- set a name for each source
	--vim_item.menu = ({
	--	ultisnips = "[UltiSnips]",
	--	nvim_lsp = "[LSP]",
	--
	--	buffer = "[Buffer]",
	--	nvim_lua = "[Lua]",
	--	cmp_tabnine = "[TabNine]",
	--})[entry.source.name]
	--			return vim_item
	--		end
	--	},
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			--vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
			require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
			-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
			--vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
		end,
	},
	window = {
		--	documentation = {
		--		winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
		--		border = "rounded",
		--	},
		--	completion = {
		--		border = "rounded",
		--		winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
		--	},
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
		["<Tab>"] = function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			else
				fallback()
			end
		end,
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" }, -- For luasnip users.
		{ name = "nvim_lua" },
		{ name = "buffer" },
		{ name = "path" },
		--{ name = "nvim_lsp_signature_help" },
		--{ name = "treesitter" },
		--{ name = 'ultisnips' }, -- For ultisnips users.
		--{ name = 'snippy' }, -- For snippy users.
	}, {}),
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
	sources = cmp.config.sources({
		{ name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
	}, {
		{ name = "buffer" },
	}),
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline("/", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})
