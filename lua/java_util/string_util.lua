local string_util = {}

function string_util.first_to_upper(str)
  return str:gsub("^%l", string.upper)
end

function string_util.last_index_of(str, pattern)
  return string.match(str, "^.*()" .. pattern)
end

return string_util
