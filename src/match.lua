local function all_numbers(tbl)
    for _, v in pairs(tbl) do
        if type(v) ~= "number" then
            return false
        end
    end
    return true
end

local function in_range(n, s, e)
    return n >= s and n <= e
end

local function tables_eq(tbl1, tbl2)
    if tbl1 == tbl2 then
        return true
    end

    if type(tbl1) ~= "table" or type(tbl2) ~= "table" then
        return false
    end

    local count1 = 0
    local count2 = 0

    for _ in pairs(tbl1) do count1 = count1 + 1 end
    for _ in pairs(tbl2) do count2 = count2 + 1 end

    if count1 ~= count2 then
        return false
    end

    for k, v in pairs(tbl1) do
        if not tables_eq(v, tbl2[k]) then
            return false
        end
    end

    return true
end

local function check_range(value, tbl)
    return all_numbers(tbl) and #tbl == 2 and in_range(value, tbl[1], tbl[2])
end

function match(value, cases)
    local fallback = cases["_"] or function (value) return nil end

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
            if (result or result == value) then
                return v(value)
            end
        end
    end

    return fallback(value)
end

return match