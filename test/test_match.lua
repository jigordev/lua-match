local match = require("match")

local function test_match()
    local cases = {
        [1] = function(value) return value * 2 end,
        [2] = function(value) return value + 1 end,
        ["_"] = function(value) return value end
    }

    assert(match(1, cases) == 2)
    assert(match(2, cases) == 3)
    assert(match(3, cases) == 3)

    local range_cases = {
        [{1, 5}] = function(value) return value * 3 end,
        [{6, 10}] = function(value) return value + 1 end,
        ["_"] = function(value) return "out of range" end
    }

    assert(match(3, range_cases) == 9)
    assert(match(7, range_cases) == 8)
    assert(match(11, range_cases) == "out of range")
end

local function runtests()
    test_match()
    print("All tests passed successfully!")
end

runtests()
