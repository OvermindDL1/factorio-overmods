local debug = settings.startup["overmods-debug"].value and true

function debug_log(str)
  if debug then log(str) end
  return str
end

function debug_dump(obj)
  if debug then log(serpent.block(obj)) end
  return obj
end

--[[
Use:
local myTable = myString:split(", ") -- or string.split(myString, ", ")
for i = 1, #myTable do
   print( myTable[i] ) -- This will give your needed output
end
]]
function string:split(inSplitPattern, outResults)
  if not outResults then
    outResults = {}
  end
  local theStart = 1
  local theSplitStart, theSplitEnd = string.find(self, inSplitPattern, theStart)
  while theSplitStart do
    table.insert(outResults, string.sub(self, theStart, theSplitStart-1))
    theStart = theSplitEnd + 1
    theSplitStart, theSplitEnd = string.find(self, inSplitPattern, theStart)
  end
  local last = string.sub(self, theStart)
  if not (last == "") then
    table.insert(outResults, last)
  end
  return outResults
end


function string:trim()
  return self:match'^%s*(.*%S)' or ''
end



function table:map(f)
  local new_array = {}
  for i,v in ipairs(self) do
    new_array[i] = f(v)
  end
  return new_array
end


function table:filter(filterIter)
  local new_array = {}
  local idx = 1
  for k, v in pairs(self) do
    if filterIter(v, k, self) then
      new_array[idx] = v
      idx = idx + 1
    end
  end
  return new_array
end


function data_get(type, name)
  -- No, cannot index into `data.raw` for some reason...
  --return data.raw[type][name] and true
  if type == "item" then return data.raw.item[name]
    elseif type == "tool" then return data.raw.tool[name]
    elseif type == "technology" then return data.raw.technology[name]
    else return nil
  end
end


function data_exists(type, name)
  local ret = data_get(type, name) and true
  if ret
    then debug_log(type .. " " .. name .. " does exist")
    else debug_log(type .. " " .. name .. " does not exist")
  end
  return ret
end

return {

  debug_log = debug_log,
  debug_dump = debug_dump,

  data_get = data_get,

  data_exists = data_exists,
  item_exists = function(name) return data_exists("item", name) end,
  tool_exists = function(name) return data_exists("tool", name) end,
  technology_exists = function(name) return data_exists("technology", name) end,

}
