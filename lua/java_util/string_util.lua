local string_util = {}

function string_util.first_to_upper(str)
  return str:gsub("^%l", string.upper)
end

return string_util
