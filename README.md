
# lua-serializer
A serializer for lua. Translates lua tables into custom binary data. Not human readable.

## Usage

Using the serializer is very simple! Here is an example:

```lua
local serializer = require 'serializer'

local data = {
  hello = "world" -- you can store data as if it were a normal lua table!
  1, 2, 3, 4, 5, -- mixed table-arrays are allowed
  [true] = "you can index booleans too, yes",
  ["is_this_valid?"] = true
}

local binary_data = serializer.encode(data)
--> string of binary data!

local recovered_data = serializer.decode(binary_data)
--> your data is back from the bits!

print(recovered_data.hello) -- outputs "world"
```

But there are some rules:

1. You cannot index the types: `function`, `table`, `userdata`, `thread`
2. You cannot store the types: `function`, `userdata`, `thread`
3. Your floats might lose precision! Non-integer values are stored using
  fixed point numbers. Furthermore, to implement this, I had to limit the amount
  of bytes used per number data to 4 bytes. So integers can go from `-65536` to
  `65535`, and non-integers can only go from `-32768` to `32767`. Since lua
  prior to `v5.3` treats all numbers as float, I separate float from integer by
  checking them against C's `FLOAT_EPSILON` value.
4. There is protection against circular tables! If you're trying to serialize a
  circular table, it will throw an ugly error at you. You dirty dirty circular
  table user. Were you trying to make my code loop infinitely?
5. You can forget about your metatables. I completely ignore them. If you use
  `__index` shenanigans it will get completely messed up results on you.
6. It's efficient enough. Don't @ me with how comparing stirngs linearly is
  better than comparing their hash because I really do not care. It's not gonna
  give you a significant change of efficiency. Plus this serializer is not made
  for constant usage throughout your program! Read & write files as needed.
  Haven't you heard that disk-access is slow anyway?

## MIT LICENSE
Feel free to use it for your program or whatever. Issues are welcome.

