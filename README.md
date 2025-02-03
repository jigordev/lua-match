# Lua-Match

`lua-match` is a Lua library that provides a powerful pattern-matching function to handle complex cases based on different conditions, such as values, ranges, and table comparisons.

## Installation

To use `lua-match` in your Lua project, you can install library using luarocks.

```bash
luarocks install lua-match
```

## Usage

### Function Signature

```lua
match(value, cases)
```

- **`value`**: The value that will be checked against the cases.
- **`cases`**: A table containing the patterns and corresponding actions. The keys of this table can be values, ranges, tables, or functions, and the values are the functions to be executed if the condition matches.

### Example

```lua
local match = require("match")

-- Define cases with different conditions
local result1 = match(10, {
    [1] = function() return "Value is 1" end,
    {5, 15} = function() return "Value is between 5 and 15" end,
    ["_"] = function() return "Value not found" end
})

print(result1)  -- Output: "Value is between 5 and 15"

local result2 = match(3, {
    [1] = function() return "Value is 1" end,
    {5, 15} = function() return "Value is between 5 and 15" end,
    ["_"] = function() return "Value not found" end
})

print(result2)  -- Output: "Value not found"
```

### How It Works

- **String, Number, or Boolean Key**: When a string, number, or boolean is used as the key in the `cases` table, it checks if the value matches the key and then executes the corresponding function.
  
- **Table Key (Range Check)**: If the key is a table, the library checks if the table contains two numbers and validates if the value is within the specified range.
  
- **Table Key (Equality Check)**: If the table is not a range, it checks if the table matches the value exactly (using deep comparison).
  
- **Function Key**: If the key is a function, the function is called with the value. If the result matches the value or evaluates to `true`, the corresponding action is executed.

- **Fallback (`_`)**: If none of the conditions match, the function defined in the `_` key is executed (or a default action of returning `nil`).

## License

This library is available under the MIT License. See the LICENSE file for more details.