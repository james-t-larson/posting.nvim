local M = {}

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

---@class TerminalData
---@field buf number
---@field window number
---@field job_id number
local terminal_data = {}
local current_window = 0

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

local function validate_args(paths)
	for _, path in ipairs(paths) do
		arg = path
		if not path or path == "" then
			return true
		end

		path = vim.fn.expand(path)
		path = vim.fn.fnamemodify(path, ":p")

		local ok, _, code = os.rename(path, path)
		if not ok then
			if code == 13 then
				vim.api.nvim_err_writeln("File or directory is not accessible: " .. arg)
				return false
			end

			vim.api.nvim_err_writeln("File or directory does not exist, or you are in the wrong directory: " .. arg)
			return false
		end
	end

	return true
end

---@return string config_path
local function locate_config()
	local message = vim.fn.system("posting locate config")
	return message:match("(/[%w%p]+)")
end

---@param path string
---@return string quit_binding
local function get_quit_binding(path)
	local default_quit_binding = "<C-C>"
	local file = io.open(path, "r")
	if not file then
		return default_quit_binding
	end

	local content = file:read("*a")
	file:close()
	return content:match("quit:%s*(%S+)") or default_quit_binding
end

---@param key string
---@return table terminal_data
local function get_terminal_data(key)
	if not terminal_data[key] then
		terminal_data[key] = {
			buf = 0,
			window = 0,
			job_id = 0,
		}
	end

	return {
		terminal_data[key].buf,
		terminal_data[key].window,
		terminal_data[key].job_id,
	}
end

local function set_terminal_data(key, data)
	terminal_data[key] = data
end

---@param args string
---@return table arg_paths
local function parse_args(args)
	local arg_paths = {}
	for _, arg in string.gmatch(args, "(%-%-%S+)%s+(%S+)") do
		table.insert(arg_paths, arg)
	end

	return arg_paths
end

function M.open(args)
	local arg_paths = parse_args(args.args)
	local args_valid = validate_args(arg_paths)
	local installation_valid = validate_installation()
	if not installation_valid or not args_valid then
		return
	end

	local launch_command = "posting " .. (args.args or "")
	local buf, window, job_id = unpack(get_terminal_data(launch_command))
	if buf == 0 or not vim.api.nvim_buf_is_valid(buf) then
		local config_path = locate_config()
		local quit_binding = get_quit_binding(config_path)
		buf = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_buf_set_name(buf, launch_command)
		vim.api.nvim_buf_set_keymap(
			buf,
			"t",
			quit_binding,
			[[<C-\><C-n>:ClosePosting<CR>]],
			{ noremap = true, silent = true }
		)
	end

	if window == 0 or not vim.api.nvim_win_is_valid(window) then
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
			border = opts.ui.border,
		})
		current_window = window
	end

	if job_id == 0 then
		job_id = vim.fn.termopen(launch_command)
	end

	set_terminal_data(launch_command, {
		buf = buf,
		window = window,
		job_id = job_id,
	})

	vim.cmd("startinsert")
end

function M.close()
	if current_window and vim.api.nvim_win_is_valid(current_window) then
		vim.api.nvim_win_close(current_window, true)
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
