local M = {}

local buf = 0
local window = nil
local job_id = nil

---@return boolean installation_valid
local function validate_installation()
	if vim.fn.executable("posting") ~= 1 then
		vim.api.nvim_err_write("Posting not installed, visit https://posting.sh/guide for guidance\n")
		vim.api.nvim_err_write("")
		return false
	else
		return true
	end
end

---@return string config_path
local function locate_config()
	local message = vim.fn.system("posting locate config")
	return message:match("(/[%w%p]+)")
end

---@param path string
---@return string quit_command
local function get_quit_command(path)
	local default_quit_command = "<C-C>"
	local file = io.open(path, "r")
	if not file then
		return default_quit_command
	end

	local content = file:read("*a")
	file:close()
	return content:match("quit:%s*(%S+)") or default_quit_command
end

function M.open(args)
	local installation_valid = validate_installation()
	if not installation_valid then
		return
	end

	local width = math.floor(vim.o.columns * 0.95)
	local height = math.floor(vim.o.lines * 0.87)
	local row = math.floor((vim.o.lines - height) / 2) - 1
	local col = math.floor((vim.o.columns - width) / 2)
	local opts = {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
	}

	if buf == 0 or not vim.api.nvim_buf_is_valid(buf) then
		local config_path = locate_config()
		local quit_command = get_quit_command(config_path)
		buf = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_buf_set_name(buf, "posting")
		vim.api.nvim_buf_set_keymap(buf, "t", quit_command, [[<C-\><C-n>:Close<CR>]], { noremap = true, silent = true })
	end

	if window == nil or not vim.api.nvim_win_is_valid(window) then
		window = vim.api.nvim_open_win(buf, true, opts)
	end

	if not job_id then
		job_id = vim.fn.termopen("posting " .. (args.args or ""))
	end

	vim.cmd("startinsert")
end

function M.close()
	if window and vim.api.nvim_win_is_valid(window) then
		vim.api.nvim_win_close(window, true)
	end
end

vim.api.nvim_create_user_command("OpenPosting", function(args)
	M.open(args)
end, {
	nargs = "*",
	desc = "Open posting client with optional arguments",
})

vim.api.nvim_create_user_command("ClosePosting", function()
	M.close()
end, {
	desc = "Close posting client",
})

vim.api.nvim_set_keymap("n", "<leader>p", ":OpenPosting<CR>", { noremap = true, silent = true, desc = "Open Posting" })

-- vim.api.nvim_set_keymap(
-- 	"n",
-- 	"<leader>pd",
-- 	":TogglePosting --collection posting-collection --env posting-envs/staging.env<CR>",
-- 	{ noremap = true, silent = true, desc = "Toggle Posting" }
-- )
--
return M
