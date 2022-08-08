local fs_util = {}

function fs_util.file_exists(path)
  local _, error = vim.loop.fs_stat(path)
  return error == nil
end

function fs_util.ensure_directory(full_path)
  full_path = string.sub(full_path, 2)
  local path_to_create = ""
  for _, path in ipairs(vim.split(full_path, "/")) do
    path_to_create = string.format("%s/%s", path_to_create, path)
    if not fs_util.file_exists(path_to_create) then
      fs_util.create_dir(path_to_create)
    end
  end
end

function fs_util.create_file(full_path)
  local ok, fd = pcall(vim.loop.fs_open, full_path, "w", 420)
  if not ok then
    vim.notify(string.format("Unable to create file %s", full_path), vim.log.levels.ERROR)
    return
  end
  vim.loop.fs_close(fd)
end

function fs_util.create_dir(full_path)
  local ok = vim.loop.fs_mkdir(full_path, 493)
  if not ok then
    vim.notify(string.format("Unable to create directory %s", full_path), vim.log.levels.ERROR)
    return
  end
end

return fs_util
