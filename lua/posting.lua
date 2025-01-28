local M = {}

local buf = 0
local window = nil
local job_id = nil

---@class Keybind
---@field bind string
---@field command string
---@field desc string

---@alias Keybinds Keybind[]

---@class UI
---@field border string
---@field height number
---@field width number
---@field x number
---@field y number

---@class Options
---@field keybinds Keybinds
---@field ui UI
local opts = {
	keybinds = {},
	ui = {
		relative = "editor",
		width = 0.95,
		height = 0.87,
		x = 0.5,
		y = 0.5,
		style = "minimal",
		border = "rounded",
	},
}

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

	local launch_command = "posting " .. (args.args or "")
	if buf == 0 or not vim.api.nvim_buf_is_valid(buf) then
		local config_path = locate_config()
		local quit_command = get_quit_command(config_path)
		buf = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_buf_set_name(buf, launch_command)
		vim.api.nvim_buf_set_keymap(
			buf,
			"t",
			quit_command,
			[[<C-\><C-n>:ClosePosting<CR>]],
			{ noremap = true, silent = true }
		)
	end

	if window == nil or not vim.api.nvim_win_is_valid(window) then
		local height = math.ceil(vim.o.lines * opts.ui.height)
		local width = math.ceil(vim.o.columns * opts.ui.width)
		local row = math.ceil((vim.o.lines - height) * opts.ui.y - 1)
		local col = math.ceil((vim.o.columns - width) * opts.ui.x)
		window = vim.api.nvim_open_win(buf, true, {
			relative = "editor",
			width = width,
			height = height,
			row = row,
			col = col,
			style = "minimal",
			border = "rounded",
		})
	end

	if not job_id then
		job_id = vim.fn.termopen(launch_command)
	end

	vim.cmd("startinsert")
end

function M.close()
	if window and vim.api.nvim_win_is_valid(window) then
		vim.api.nvim_win_close(window, true)
	end
end

function M.setup(user_opts)
	if user_opts then
		opts = vim.tbl_deep_extend("force", opts, user_opts)
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

	vim.api.nvim_set_keymap(
		"n",
		"<leader>p",
		":OpenPosting<CR>",
		{ noremap = true, silent = true, desc = "Open Posting" }
	)

	for _, keybind in ipairs(user_opts.keybinds) do
		vim.api.nvim_set_keymap(
			"n",
			keybind.binding,
			keybind.command,
			{ noremap = true, silent = true, desc = keybind.desc }
		)
	end
end

return M
