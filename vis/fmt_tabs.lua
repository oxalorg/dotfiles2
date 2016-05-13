local fmt_space_tab = function(win, repl, width)
	local save_line, save_col = win.cursor.line, win.cursor.col
	local lines = {}
	for i=1, #win.file.lines, 1 do
		local line = win.file.lines[i]
		local indent, content = line:match('^(%s+)(.*)$')
		if indent then
			local spaces = string.rep(' ', width)
			indent = indent:gsub(spaces, '\t')
			indent = indent:gsub(' +\t', '\t')
			indent = indent:gsub('\t', repl)
			line = indent .. content
		end
		table.insert(lines, line)
	end
	local str = table.concat(lines, '\n')
	win.file:delete(0, win.file.size)
	win.file:insert(0, str)
	win.cursor:to(save_line, save_col)
end

fmt_trailing = function(win)
	local save_line, save_col = win.cursor.line, win.cursor.col
	local lines = {}
	for i=1, #win.file.lines, 1 do
		local line = win.file.lines[i]
		line = line:gsub('%s+$', '')
		table.insert(lines, line)
	end
	local str = table.concat(lines, '\n')
	win.file:delete(0, win.file.size)
	win.file:insert(0, str)
	win.cursor:to(save_line, save_col)
end

fmt_line_end = function(win, lineend)
	local save_line, save_col = win.cursor.line, win.cursor.col
	local lines = {}
	for i=1, #win.file.lines, 1 do
		local line = win.file.lines[i]
		table.insert(lines, line)
	end
	local str = table.concat(lines, lineend)
	win.file:delete(0, win.file.size)
	win.file:insert(0, str)
	win.cursor:to(save_line, save_col)
end

vis:command_register('FmtSpace', function(argv, force, win, cursor, range)
	local spaces = string.rep(' ', width)
	fmt_space_tab(win, spaces, width)
end)
vis:command_register('FmtTab', function(argv, force, win, cursor, range)
	fmt_space_tab(win, '\t', width)
end)
vis:command_register('FmtTrailing', function(argv, force, win, cursor, range)
	fmt_trailing(win)
end)
vis:command_register('FmtNL', function(argv, force, win, cursor, range)
	fmt_line_end(win, '\n')
end)
vis:command_register('FmtCRNL', function(argv, force, win, cursor, range)
	fmt_line_end(win, '\r\n')
end)
