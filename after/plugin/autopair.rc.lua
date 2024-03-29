local loaded, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
if not loaded then
	return
end
local loaded_cmp, cmp = pcall(require, "cmp")
if not loaded_cmp then
	return
end

cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
local handlers = require("nvim-autopairs.completion.handlers")

cmp.event:on(
	"confirm_done",
	cmp_autopairs.on_confirm_done({
		filetypes = {
			-- "*" is a alias to all filetypes
			["*"] = {
				["("] = {
					kind = {
						cmp.lsp.CompletionItemKind.Function,
						cmp.lsp.CompletionItemKind.Method,
					},
					handler = handlers["*"],
				},
			},
			lua = {
				["("] = {
					kind = {
						cmp.lsp.CompletionItemKind.Function,
						cmp.lsp.CompletionItemKind.Method,
					},
					---@param char string
					---@param item item completion
					---@param bufnr buffer number
					handler = function(char, item, bufnr)
						-- Your handler function. Inpect with print(vim.inspect{char, item, bufnr})
					end,
				},
			},
			-- Disable for tex
			tex = false,
		},
	})
)

local npairs = require("nvim-autopairs")
local Rule = require("nvim-autopairs.rule")

npairs.setup({
	check_ts = true,
	ts_config = {
		lua = { "string" }, -- it will not add a pair on that treesitter node
		javascript = { "template_string" },
		java = false, -- don't check treesitter on java
	},
})

local ts_conds = require("nvim-autopairs.ts-conds")

-- press % => %% only while inside a comment or string
npairs.add_rules({
	Rule("%", "%", "lua"):with_pair(ts_conds.is_ts_node({ "string", "comment" })),
	Rule("$", "$", "lua"):with_pair(ts_conds.is_not_ts_node({ "function" })),
})
