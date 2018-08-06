
local serializer = require 'serializer'

local lua_data = {
  [true] = "true",
  [false] = "false",
  [0] = "zero",
  1, 2, 3, 4, 5,
  1024.125,
  {
    fucked = true,
    safe = false
  },
  insidetable = {
    is_this_ok = "yes",
  }
}

print("Serializing data...")
local binary_data = serializer.encode(lua_data)
print("De-serializing data...")
local recovered_data = serializer.decode(binary_data)

print("Checking..")

local margin = 0.05 -- yeah it's imprecise
local strf = string.format
local function check(original, recovery)
  local success = true
  local err
  for k, v in pairs(original) do
    local rv = recovery[k]
    if type(v) == "table" then
      success, err = assert(check(v, rv))
    end
    local valid_t = (type(v) == type(rv))
    local valid = (v == rv) or (type(v) == "number" and abs(v - rv) <= margin)
    if not valid_t or not valid then
      err = strf("Wrong data! <%s> expected, got <%s>", v, rv)
    end
  end
  return success, err
end

return assert(check(lua_data, recovered_data))

