--- @generic T
--- @param list T[]
--- @param func fun(value: T, index: number): boolean
--- @return T[]
local function filter(list, func)
    local result = {}

    for index, value in ipairs(list) do
        if func(value, index) then
            result[#result + 1] = value
        end
    end

    return result
end

--- @generic T, V
--- @param list T[]
--- @param fn fun(value: T, index: number): V
--- @return V[]
local function map(list, fn)
  local out = {}

  for i, v in ipairs(list) do
    out[i] = fn(v, i)
  end

  return out
end

return {
    filter = filter,
    map = map
}