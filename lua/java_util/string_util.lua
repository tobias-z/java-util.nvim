local string_util = {}

function string_util.first_to_upper(str)
  return str:gsub("^%l", string.upper)
end

function string_util.starts_with(str, pattern)
  return str:find("^" .. pattern) ~= nil
end

return string_util