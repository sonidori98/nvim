-- 補完の位置が「新しく名前を付ける所」か「メンバ呼び出しの所」かを見分ける
-- treesitterは入力途中だと壊れる(ERRORノードになる)ので，カーソルの前の文字列で判定する
local M = {}

-- 名前の直前に来るキーワード．空白はいくつでも良い
local keywords = {
	lua = { "local", "local function", "function" },
	python = { "def", "class", "for", "as" },
	rust = { "let", "let mut", "const", "static", "static mut", "fn", "struct", "enum", "trait", "type", "mod" },
	go = { "var", "const", "func", "type" },
	typescript = { "const", "let", "var", "function", "class", "interface", "type", "enum", "namespace" },
	sh = { "local", "declare", "readonly", "function", "for" },
	c = { "#define" },
	cpp = { "class", "namespace", "#define" },
}
keywords.javascript = keywords.typescript
keywords.typescriptreact = keywords.typescript
keywords.javascriptreact = keywords.typescript
keywords.bash = keywords.sh
keywords.zsh = keywords.sh

-- 引数の括弧の直前(関数の宣言の頭)
local function_heads = {
	lua = "function%s*[%w_.:]*%s*$",
	python = "def%s+[%w_]+%s*$",
	rust = "fn%s+[%w_]+%s*$",
	go = "func%s+[%w_]+%s*$",
	typescript = "function%s*[%w_$]*%s*$",
}
function_heads.javascript = function_heads.typescript
function_heads.typescriptreact = function_heads.typescript
function_heads.javascriptreact = function_heads.typescript

-- 「型 名前」と続くC系の宣言．これらのキーワードの次は型ではない
local c_family = { c = true, cpp = true }
local not_a_type = {
	["return"] = true,
	["else"] = true,
	["goto"] = true,
	["case"] = true,
	["new"] = true,
	["delete"] = true,
	["throw"] = true,
	["using"] = true,
	["typedef"] = true,
	["sizeof"] = true,
	["do"] = true,
	["co_return"] = true,
	["co_yield"] = true,
}
-- 型の前につくだけで，これだけでは型にならない語
local modifiers = {
	static = true,
	const = true,
	extern = true,
	inline = true,
	volatile = true,
	register = true,
	constexpr = true,
	virtual = true,
	mutable = true,
	typename = true,
	struct = true,
	enum = true,
	union = true,
	unsigned = true,
	signed = true,
	long = true,
	short = true,
}

local function has_keyword(prefix, ft)
	for _, kw in ipairs(keywords[ft] or {}) do
		local pat = kw:gsub(" ", "%%s+")
		if prefix:find("%f[%w_#$]" .. pat .. "%s+$") then
			return true
		end
	end
	return false
end

-- 引数の名前を書く位置か(型や既定値ではなく)
local function in_param_name(prefix, ft)
	local head_pat = function_heads[ft]
	if not head_pat then
		return false
	end
	local args = prefix:match("%(([^()]*)$")
	if not args then
		return false
	end
	local head = prefix:sub(1, #prefix - #args - 1)
	local segment = args:match("[^,]*$")
	return head:find(head_pat) ~= nil and (segment:find("^[%s%*&]*$") ~= nil or segment:find("^%s*mut%s+$") ~= nil)
end

-- int fo / const char *fo / for (int fo / int add(int a, int fo
local function c_declaration(prefix)
	local segment = prefix:match("[^;{}(,]*$")
	if not segment:find("^[%s%w_:<>%*&]+$") then
		return false
	end
	-- 名前の直前は「型の後ろの空白」か「ポインタ・参照の記号」．i < fo や a * fo のような式は除く
	local after_type = segment:find("[%w_]%s+$") or (segment:find(">%s+$") and segment:find("<"))
	if not (after_type or segment:find("[%*&]$")) then
		return false
	end
	local first = segment:match("[%a_][%w_]*")
	if not first or not_a_type[first] then
		return false
	end
	for word in segment:gmatch("[%a_][%w_]*") do
		if not modifiers[word] then
			return true
		end
	end
	return false
end

-- 今入力している単語より前の，行の文字列
local function line_prefix()
	local col = vim.api.nvim_win_get_cursor(0)[2]
	local before = vim.api.nvim_get_current_line():sub(1, col)
	return (before:gsub("[%w_$]*$", ""))
end

---新しく名前(変数・関数・引数・型)を付けようとしている所か
function M.is_declaring()
	local ft = vim.bo.filetype
	local prefix = line_prefix()
	if has_keyword(prefix, ft) or in_param_name(prefix, ft) then
		return true
	end
	return c_family[ft] == true and c_declaration(prefix)
end

local prose = { markdown = true, text = true, gitcommit = true, tex = true, plaintex = true }

---散文のファイルか，コードの中のコメントか(辞書が主役になる所)
function M.is_prose()
	if prose[vim.bo.filetype] then
		return true
	end
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local ok, node = pcall(vim.treesitter.get_node, { pos = { row - 1, math.max(col - 1, 0) } })
	return ok and node ~= nil and node:type():find("comment") ~= nil
end

---obj.fo / obj:fo / obj->fo / Type::fo のようなメンバの所か(散文では見ない)
function M.is_member_access()
	if prose[vim.bo.filetype] then
		return false
	end
	local prefix = line_prefix()
	return prefix:find("[.:]$") ~= nil or prefix:find("%->$") ~= nil
end

return M
