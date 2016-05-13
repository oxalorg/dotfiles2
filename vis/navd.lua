-- Open navd window
navd = function(path, search)
	if not path then
		path = vis.cwd
	end
	if not search then
		fname = vis.win.file.name
		if fname then
			search = basename(vis.win.file.name)
		else
			search = ""
		end
	end
	local list = os.capture('ls -1 -A -p -b --group-directories-first ' .. path, 'r')
	vis:message('# ' .. path .. '\n' .. list)
	vis.win.syntax = 'navd'
	vis:command('set syntax navd')
	vis:feedkeys('dggj')
	vis:feedkeys('/' .. search .. '<Enter>')

	vis:map(vis.MODE_NORMAL, '<Enter>', function()
		local win = vis.win
		local line = win.file.lines[win.cursor.line]
		if line:sub(1,1) == '#' then return end
		if line:sub(-1) == '/' then
			navd(path .. line)
		else
			local file = path .. line
			vis:feedkeys(':q<Enter>')
			vis:feedkeys(':e ' .. file .. '<Enter>')
			vis:command('map! normal <Enter> <cursor-line-down>')
			vis:map(vis.MODE_NORMAL, '-', navd)
		end
	end)
	
	vis:map(vis.MODE_NORMAL, '-', function()
		path = os.capture('dirname ' .. path) .. '/'
		search = basename(path)
		navd(path, search)
		if vis.win.syntax ~= 'navd' then
			vis:map(vis.MODE_NORMAL, '-', navd)
		end
	end)
	
	vis:map(vis.MODE_NORMAL, 'q', function()
		vis:feedkeys(':q<Enter>')
		vis:command('map! normal q <macro-record>')
	end)
	
	vis:map(vis.MODE_NORMAL, 'gh', function()
		navd(os.getenv('HOME'))
	end)
end

basename = function(path)
	if path:sub(-1,-1) == '/' then
		path = path:sub(1, -2)
	end
	local rev = path:reverse()
	local sl = rev:find('/', 1, true)
	if not sl then
		return path
	end
	sl = path:len() - sl + 2
	return path:sub(sl)
end
