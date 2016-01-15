local alphametics = require "alphametics"

local ipairs = ipairs
local write = io.write
local concat = table.concat

local function print_puzzle (lhs, rhs)
   write(concat(lhs, " + "))
   write(" = ")
   write(concat(rhs, " + ").."\n")
end

local function puzzle (lhs, rhs)
   print_puzzle(lhs, rhs)
   local alpha = alphametics.new(lhs, rhs)
   local answers = alpha:solutions()
   if answers then
      for _, ans in ipairs(answers) do
         print_puzzle(ans[1], ans[2])
      end
   end
   alpha:clear()
   write("\n")
end

-- samples
puzzle({ "NUMBER", "NUMBER" }, { "PUZZLE" })
puzzle({ "VIOLIN", "VIOLIN", "VIOLA"}, { "TRIO", "SONATA" })
puzzle({ "SEND", "MORE" }, { "MONEY" })
puzzle({ "BONGO", "BONGO", "BONGO", "ON", "THE" }, { "CONGO" })
puzzle({ "INTO", "ONTO", "CANON", "INTACT", "AMMONIA", "OMISSION", "DIACRITIC",
         "STATISTICS", "ASSOCIATION", "ANTIMACASSAR", "CONTORTIONIST",
         "NONDISCRIMINATION", "CONTRADISTINCTION" },
       { "MISADMINISTRATION" })
puzzle({ "SATURN", "URANUS", "NEPTUNE", "PLUTO" }, { "PLANETS" })
puzzle({ "BATMAN", "GOTHAM" }, { "NIGHTS" })
puzzle({ "SIX", "SEVEN", "SEVEN" }, { "TWENTY" })

