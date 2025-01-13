local auto_pairs = {
	["("] = ")",
	["{"] = "}",
	["["] = "]",
	['"'] = '"',
	["'"] = "'",
	["`"] = "`",
}

vis.events.subscribe(vis.events.INPUT, function(key)
	local win = vis.win
	if not win or not win.file then return false end

	local cursor = win.selection.pos

	local close = auto_pairs[key]
	if close then
		win.file:insert(cursor, key .. close)
		win.selection.pos = cursor + 1
		return true
	end

	if key == ")" or key == "}" or key == "]" then
		local next_char = win.file:content(cursor, cursor + 1):sub(1, 1)
		if next_char == key then
			win.selection.pos = cursor + 1
			return true
		end
	end

	return false
end)

-- vis.events.INPUT does not handle backspace
vis:map(vis.modes.INSERT, "<Backspace>", function()
	local win = vis.win
	if not win or not win.file then return false end

	local cursor = win.selection.pos
	local file = win.file

	if cursor == 0 then return false end

	local prev_char = file:content(cursor - 1, cursor):sub(1, 1)
	local next_char = file:content(cursor, cursor + 1):sub(1, 1)

	if auto_pairs[prev_char] == next_char then
		file:delete(cursor - 1, 2)
		win.selection.pos = cursor - 1
		return true
	end

	file:delete(cursor - 1, 1)
	win.selection.pos = cursor - 1
	return true
end, "Handle backspace for auto-pairs")
