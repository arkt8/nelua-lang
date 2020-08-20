-- Iterators module
--
-- The iterators module contains some custom iterators to do 'for in' loops.

local iterators = {}

-- Helper for the izip2 iterator.
local function izip2_next(ts, i)
  i = i + 1
  local v1, v2 = ts[1][i], ts[2][i]
  if v1 == nil and v2 == nil then
    return nil
  end
  return i, v1, v2
end

-- Iterate multiples values for multiple arrays, returning the iterator index and values
-- Stops only when all values in the arrays are nil.
function iterators.izip2(t1, t2)
  return izip2_next, {t1,t2}, 0
end

-- Helper for the spairs iterator.
local function spairs_next(t, k)
  local v
  repeat
    k, v = next(t, k)
    if k == nil then return nil end
  until type(k) == 'string'
  return k, v
end

-- Like 'pairs' but only iterate on string keys.
function iterators.spairs(t)
  return spairs_next, t, nil
end

-- Like 'pairs' but only iterate on string keys with ordering.
function iterators.ospairs(t)
  local okeys = {}
  for k,_ in pairs(t) do
    if type(k) == 'string' then
      okeys[#okeys + 1] = k
    end
  end
  table.sort(okeys)
  local i = 1
  return function()
    local k = okeys[i]
    local v = t[k]
    i = i + 1
    if v ~= nil then
      return k, v
    end
  end
end

--[[
-- Like 'pairs' but ordered by keys.
function iterators.opairs(t)
  local okeys = { }
  for k,_ in pairs(t) do
    okeys[#okeys + 1] = k
  end
  table.sort(okeys)
  local i = 1
  return function()
    local k = okeys[i]
    local v = t[k]
    i = i + 1
    if v ~= nil then
      return k, v
    end
  end
end

-- Iterate multiples values for multiple arrays, returning the iterator index and values
-- Stops only when all values in the arrays are nil.
function iterators.izip(...)
  local arrays, ans = table.pack(...), {}
  local n = arrays.n
  local i = 0
  return function()
    i = i + 1
    local found
    for j=1,n do
      local v = arrays[j][i]
      if v then
        found = true
      end
      ans[j] = v
    end
    if not found then
      return nil
    end
    return i, table.unpack(ans, 1, n)
  end
end

-- Iterate multiples values from multiple iterators,
-- returning an index and the first value of each iterator,
-- stops only when all values are nil.
function iterators.izipit(...)
  local fs, ans = table.pack(...), {}
  local n = fs.n
  local i = 0
  return function()
    i = i + 1
    local found
    for j=1,n do
      local v = fs[j]()
      if v then
        found = true
      end
      ans[j] = v
    end
    if not found then
      return nil
    end
    return i, table.unpack(ans, 1, n)
  end
end
]]

return iterators
