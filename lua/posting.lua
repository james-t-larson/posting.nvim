local M = {}

local buf = 0
local window = nil
local job_id = nil

function M.open(args)
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
		buf = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_buf_set_name(buf, "posting")
		vim.api.nvim_buf_set_keymap(
			buf,
			"t",
			"x", -- should get this value from the posting config
			[[<C-\><C-n>:Close<CR>]],
			{ noremap = true, silent = true }
		)
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

function M.toggle(args)
	if window and vim.api.nvim_win_is_valid(window) then
		M.close()
	else
		M.open(args)
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
