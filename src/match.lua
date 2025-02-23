local function tables_eq(tbl1, tbl2)
    if tbl1 == tbl2 then return true end
    if type(tbl1) ~= "table" or type(tbl2) ~= "table" then return false end

    local seen_keys = {}
    for k, v in pairs(tbl1) do
        if not tables_eq(v, tbl2[k]) then return false end
        seen_keys[k] = true
    end

    for k in pairs(tbl2) do
        if not seen_keys[k] then return false end
    end

    return true
end


local function check_range(value, tbl)
    if not tbl._is_range then return false end
    local start, finish, step = tbl.start, tbl.finish, tbl.step

    if step == 0 then return value == start end
    if step > 0 then
        return value >= start and value <= finish and (value - start) % step == 0
    else
        return value <= start and value >= finish and (value - start) % step == 0
    end
end

function range(start, finish, step)
    return {start = start, finish = finish, step = step or 1, _is_range = true}
end

function match(value, cases)
    local fallback = function(_) return nil end
    if type(cases["_"]) == "function" then
        fallback = cases["_"]
    end

    for k, v in pairs(cases) do 
        if type(v) ~= "function" then
            error("Expected function as a result of the match")
        end

        local t = type(k)
        if t == "nil" then
            error("Nil cannot be used as match value")
        elseif (t == "string" or t == "number" or t == "boolean") and k == value then
            return v(value)
        elseif t == "table" then
            if check_range(value, k) then
                return v(value)
            elseif tables_eq(k, value) then
                return v(value)
            end
        elseif t == "function" then
            local result = k(value)
            if result ~= nil then return v(value) end
        end
    end

    return fallback(value)
end

return {
    match = match,
    range = range
}