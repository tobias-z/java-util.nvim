local uv = vim.loop

local Server = {}

---Creates a server that the springboot client can attach to
---@param opts table
---@field host string
---@field port number
---@field on_chunck function
function Server:new(opts)
  self._opts = opts
  return self
end

local function create_server(host, port, on_accept)
  local server = uv.new_tcp()
  server:bind(host, port)
  server:listen(128, function(err)
    assert(not err, err)
    local socket = uv.new_tcp()
    server:accept(socket)
    on_accept(socket)
  end)
  return server
end

function Server:start()
  self._server = create_server(self._opts.host, self._opts.port, function(socket)
    socket:read_start(function(err, chunk)
      print("got chunk", chunk)
      print("got error", err)
      assert(not err, err)
      if chunk then
        socket:write(chunk) -- Echo received messages to the channel.
        self._opts.on_chunck(chunk, socket)
      else -- EOF (stream closed).
        socket:close() -- Always close handles to avoid leaks.
      end
    end)
  end)
end

return Server
