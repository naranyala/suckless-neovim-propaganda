local uv = vim.loop

-- Since we're on Windows, use Windows-specific separator
local sep = "\\"

-- Lazy.nvim specific paths (Windows)
local lazy_path = vim.fn.stdpath("data") .. sep .. "lazy"
local plugin_dirs = {
	lazy_path, -- Lazy.nvim stores plugins directly under the 'lazy' directory
}

-- Get directory size recursively
local function get_dir_size(path)
	local total_size = 0
	local handle, err = uv.fs_scandir(path)
	if not handle then
		if err then
			print("Error scanning directory " .. path .. ": " .. err)
		end
		return total_size
	end
	while true do
		local name, type, err = uv.fs_scandir_next(handle)
		if not name then
			if err then
				print("Error reading directory entry: " .. err)
			end
			break
		end
		local full_path = path .. sep .. name
		if type == "file" then
			local stat, stat_err = uv.fs_stat(full_path)
			if stat then
				total_size = total_size + stat.size
			elseif stat_err then
				print("Error getting file stats for " .. full_path .. ": " .. stat_err)
			end
		elseif type == "directory" then
			total_size = total_size + get_dir_size(full_path)
		end
	end
	return total_size
end

-- Get sizes of installed Lazy.nvim plugins
local function get_plugin_sizes()
	local plugins = {}

	for _, plugin_path in ipairs(plugin_dirs) do
		local handle, err = uv.fs_scandir(plugin_path)
		if handle then
			while true do
				local name, type = uv.fs_scandir_next(handle)
				if not name then
					break
				end
				-- Skip lazy.nvim itself and only process plugin directories
				if type == "directory" and name ~= "lazy.nvim" then
					local full_path = plugin_path .. sep .. name
					local size_bytes = get_dir_size(full_path)
					local size_mb = size_bytes / (1024 * 1024)
					table.insert(plugins, {
						name = name,
						size = size_mb,
						size_display = string.format("%.2f MB", size_mb),
					})
				end
			end
		elseif err then
			print("Error scanning plugin directory " .. plugin_path .. ": " .. err)
		end
	end

	table.sort(plugins, function(a, b)
		return a.size > b.size
	end)
	return plugins
end

-- Show floating panel
local function show_plugin_size_panel()
	local data = get_plugin_sizes()
	if #data == 0 then
		print("No Lazy.nvim plugins found in " .. lazy_path)
		return
	end

	local total_size = 0
	for _, plugin in ipairs(data) do
		total_size = total_size + plugin.size
	end

	local max_name_length = 0
	for _, plugin in ipairs(data) do
		max_name_length = math.max(max_name_length, #plugin.name)
	end

	local width = math.min(max_name_length + 20, vim.o.columns - 10)
	local height = math.min(#data + 4, vim.o.lines - 10)
	local buf = vim.api.nvim_create_buf(false, true)
	local win_width = vim.o.columns
	local win_height = vim.o.lines
	local row, col = math.floor((win_height - height) / 2), math.floor((win_width - width) / 2)

	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
		title = " Lazy.nvim Plugin Sizes ",
		title_pos = "center",
	})

	local lines = { "Installed Lazy.nvim Plugins:" }
	for _, plugin in ipairs(data) do
		local padding = string.rep(" ", max_name_length - #plugin.name)
		table.insert(lines, string.format("%s%s - %s", plugin.name, padding, plugin.size_display))
	end
	table.insert(lines, "")
	table.insert(lines, string.format("Total: %.2f MB", total_size))

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
	vim.api.nvim_set_option_value("wrap", false, { win = win })

	local mappings = {
		["<Esc>"] = "close",
		["q"] = "close",
	}

	for key, action in pairs(mappings) do
		vim.keymap.set("n", key, function()
			vim.api.nvim_win_close(win, true)
		end, { buffer = buf, silent = true })
	end
end

-- Error handling wrapper
local function safe_call(fn)
	return function(...)
		local ok, err = pcall(fn, ...)
		if not ok then
			vim.notify("Error in PluginSize: " .. err, vim.log.levels.ERROR)
		end
	end
end

-- Register command with error handling
show_plugin_size_panel = safe_call(show_plugin_size_panel)
vim.api.nvim_create_user_command("PluginSize", show_plugin_size_panel, {
	desc = "Show sizes of installed Lazy.nvim plugins",
	nargs = 0,
})
