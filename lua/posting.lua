local M = {}

local posting_buf = 0
local posting_window = nil
local posting_job_id = nil

function M.OpenPosting(args)
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

	if posting_buf == 0 or not vim.api.nvim_buf_is_valid(posting_buf) then
		posting_buf = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_buf_set_name(posting_buf, "posting")
		vim.api.nvim_buf_set_keymap(
			posting_buf,
			"t",
			"x", -- should get this value from the posting config
			[[<C-\><C-n>:TogglePosting<CR>]],
			{ noremap = true, silent = true }
		)
	end

	if posting_window == nil or not vim.api.nvim_win_is_valid(posting_window) then
		posting_window = vim.api.nvim_open_win(posting_buf, true, opts)
	end

	if not posting_job_id then
		posting_job_id = vim.fn.termopen("posting " .. (args.args or ""))
	end

	vim.cmd("startinsert")
end

function M.ClosePosting()
	if posting_window and vim.api.nvim_win_is_valid(posting_window) then
		vim.api.nvim_win_close(posting_window, true)
	end
end

function M.TogglePosting(args)
	if posting_window and vim.api.nvim_win_is_valid(posting_window) then
		M.ClosePosting()
	else
		M.OpenPosting(args)
	end
end

vim.api.nvim_create_user_command("TogglePosting", function(args)
	M.TogglePosting(args)
end, {
	nargs = "*",
	desc = "Toggle the posting API client with optional arguments",
})

vim.api.nvim_set_keymap(
	"n",
	"<leader>pd",
	":TogglePosting --collection posting-collection --env posting-envs/staging.env<CR>",
	{ noremap = true, silent = true, desc = "Toggle Posting" }
)

return M
