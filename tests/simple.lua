
local serializer = require 'serializer'

local lua_data = {
  [true] = "true",
  [false] = "false",
  [0] = "zero",
  1, 2, 3, 4, 5,
  1024.2125,
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
local abs = math.abs
local strf = string.format
local printf = function(s, ...) return print(strf(s, ...)) end

local function check(original, recovery)
  local success = true
  local err
  for k, v in pairs(original) do
    local rv = recovery[k]
    local v_t = type(v)
    local rv_t = type(rv)
    if v_t == "table" then
      success, err = assert(check(v, rv))
    else
      local valid_t = (v_t == rv_t)
      local valid = (v == rv)
      local close_enough = valid_t and v_t == "number" and abs(v - rv) <= margin
      if valid_t then
        printf("Type match (%s): <%s> == <%s>", k, v_t, rv_t)
      else
        success = false
        err = strf("Type mismatch (%s): <%s> != <%s>", k, v_t, rv_t)
      end
      if valid then
        printf("--  Data match: %s == %s", v, rv)
      elseif close_enough then
        printf("--  Data almost matches: %s ~= %s", v, rv)
      else
        success = false
        err = strf("--  Data mismatch (%s): %s != %s", k, v, rv)
      end
    end
  end
  return success, err
end

assert(check(lua_data, recovered_data))

printf("...OK!")

