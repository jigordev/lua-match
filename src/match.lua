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

function match(value, cases)
    local none = cases["_"] or function (value) return nil end

    for k, v in pairs(cases) do 
        local t = type(k)
        if t == "nil" then
            return none(value)
        elseif t == "string" or t == "number" or t == "boolean" then
            return k == value and v(value) or none(value)
        elseif t == "table" then
            if all_numbers(k) and #k == 2 then
                if in_range(value, k[1], k[2]) then
                    return v(value)
                else
                    return none(value)
                end
            elseif tables_eq(k, value) then
                return v(value)
            else
                return none(value)
            end
        elseif t == "function" then
            local result = k(value)
            return (result or result == value) and v(value) or none(value)
        end
    end

    return none(value)
end

return match