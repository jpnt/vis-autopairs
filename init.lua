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

    local close = auto_pairs[key]
    if close then
        -- Process all selections in reverse order to handle multiple cursors
        local sorted = {}
        for _, sel in ipairs(win.selections) do
            table.insert(sorted, sel)
        end
        table.sort(sorted, function(a, b) return a.pos > b.pos end)

        for _, sel in ipairs(sorted) do
            local pos = sel.pos
            win.file:insert(pos, key .. close)
            sel.pos = pos + 1 -- Move cursor between the pair
        end
        return true
    end

    if key == ")" or key == "}" or key == "]" then
        -- Check if next character matches and skip if so
        local sorted = {}
        for _, sel in ipairs(win.selections) do
            table.insert(sorted, sel)
        end
        table.sort(sorted, function(a, b) return a.pos > b.pos end)

        for _, sel in ipairs(sorted) do
            local cursor = sel.pos
            local next_char = win.file:content(cursor, cursor + 1):sub(1, 1)
            if next_char == key then
                sel.pos = cursor + 1
            end
        end
        return true
    end

    return false
end)

-- Handle backspace for auto-pairs considering all cursors
vis:map(vis.modes.INSERT, "<Backspace>", function()
    local win = vis.win
    if not win or not win.file then return false end

    local sorted = {}
    for _, sel in ipairs(win.selections) do
        table.insert(sorted, sel)
    end
    table.sort(sorted, function(a, b) return a.pos > b.pos end)

    for _, sel in ipairs(sorted) do
        local cursor = sel.pos
        if cursor == 0 then goto continue end

        local prev_char = win.file:content(cursor - 1, cursor):sub(1, 1)
        local next_char = win.file:content(cursor, cursor + 1):sub(1, 1)

        if auto_pairs[prev_char] == next_char then
            win.file:delete(cursor - 1, 2)
            sel.pos = cursor - 1
        else
            win.file:delete(cursor - 1, 1)
            sel.pos = cursor - 1
        end

        ::continue::
    end

    return true
end, "Handle backspace for auto-pairs")