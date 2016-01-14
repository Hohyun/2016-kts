-- TAOCP Vol. 4a
-- 7.2.1.2 Generating all permutations.
-- Implementing Algorithm P and T in luajit.

local ffi = require "ffi"
local ffi_new = ffi.new

local write = io.write

local _M = { _VERSION = "0.1.0" }


-- local functions
local function prt(a, len)
   if type(len) == "table" then
      len = #a
   else
      len = len or #a
   end
   for i=1,len do
      write(a[i], " ")
   end
end

local function visit(a, c, o, s, j)
   prt(a, c)
   if c and type(c) == "table" then
      write("\t");  prt(c)
      if o then
         write("\t"); prt(o)
         write("\t", s)
         write("\t", j)
      end
   end
   write("\n")
end

_M.visit = visit


-- Algorithm P (Plain changes)
function _M.permutation(a, debug)
   if not a then return end
   local debug = debug or false
   
   -- Initialize.
   local n = #a
   local c, o = {}, {}
   for i=1,n do
      c[i], o[i] = 0, 1
   end

   -- Visit.
   if not debug then
      visit(a)
   else
      visit(a, c, o, 0, n)
   end

   -- Prepare for change.
   local j, s = n, 0
   
   while true do
      -- Ready to change?
      local q = c[j] + o[j]
      if q < 0 or q == j then
         if q == j then
            -- Increase s.
            if j == 1 then -- Terminate.
               return
            end
            s = s + 1
         end

         -- Switch direction.
         o[j] = -o[j]
         j = j - 1
      else
         -- Change.
         a[j-c[j]+s], a[j-q+s] = a[j-q+s], a[j-c[j]+s]
         c[j] = q
         if not debug then
            visit(a)
         else
            visit(a, c, o, s, j)
         end
         j, s = n, 0
      end
   end
end


-- Algorithm T (Plain change transitions)
function _M.transitions(n)
   local n = n or 10 -- default decimal
   if n < 2 then
      return nil, "n should be >= 2."
   end

   -- Initialize.
   local N = 1 -- n!
   local m, d, t

   for i=1,n do N = N * i end
   d = ffi_new("unsigned int")
   t = ffi_new("unsigned int[?]", N)
   
   m = 2
   d = N / 2
   t[d] = 1;

   -- Loop on m.
   while m ~= n do
      local k = 0
      m = m + 1
      d = d / m
      while k < N do
         -- Hunt down.
         k = k + d
         for j=m-1,1,-1 do
            t[k] = j
            k = k + d
         end
         -- Offset.
         t[k] = t[k] + 1
         k = k + d
         -- Hunt up.
         for j=1,m-1,1 do
            t[k] = j
            k = k + d
         end
      end
   end

   return t, N-1
end

return _M
