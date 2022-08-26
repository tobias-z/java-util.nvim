local lsp_config = require("tobiasz.config.lsp-config.config")

local setup = {}

-- TODO: allow java 9 or lower using tools.jar

local home = os.getenv("HOME")

function setup.setup(opts)
  opts = opts or {
    port = 19999,
  }

  require("java_util.springboot.server")
    :new({
      host = "127.0.0.1",
      port = opts.port,
      on_chunck = function(chunck, socket)
        print("got chunck")
        print(vim.inspect(chunck))
        print(vim.inspect(socket))
      end,
    })
    :start()

  local client_id = vim.lsp.start_client({
    name = "boot-ls",
    cmd = {
      "java",
      string.format("-Dspring.lsp.client-port=%s", opts.port),
      string.format("-Dserver.port=%s", opts.port),
      "-Dsts.lsp.client=vscode",
      string.format("-Dsts.log.file=%s", "/home/tobiasz/.cache/nvim/java-util.nvim.log"),
      string.format("-Dlogging.file=%s", "/home/tobiasz/.cache/nvim/java-util.nvim.log"),
      "-jar",
      vim.fn.glob(home .. "/.local/share/jdtls/spring-boot/spring-boot-language-server-*-exec.jar"),
    },
    capabilities = lsp_config.capabilities,
    on_error = function(code, ...)
      print("error")
      print(vim.inspect(code))
      print(vim.inspect(...))
    end,
    commands = {},
    handlers = {
      ["sts/addClasspathListener"] = function(...)
        print(vim.inspect(...))
      end,
      ["sts/javadocHoverLink"] = function(...)
        print(vim.inspect(...))
      end,
      ["sts/javaType"] = function(...)
        print(vim.inspect(...))
      end,
      ["sts/highlight"] = function(...)
        print(vim.inspect(...))
      end,
      ["sts/progress"] = function(...)
        print(vim.inspect(...))
      end,
      ["sts/javaSuperTypes"] = function(...)
        print(vim.inspect(...))
      end,
    },
    on_attach = function(client, bufnr)
      print("attached!")
      print(vim.inspect(client))
      print(bufnr)
    end,
    on_exit = function()
      print("exited")
    end,
    on_init = function(client, results)
      print("initialized")
      print(vim.inspect(client))
      print(vim.inspect(results))
    end,
    root_dir = vim.fn.getcwd(),
    trace = "verbose",
  })

  vim.lsp.buf_attach_client(vim.api.nvim_get_current_buf(), client_id)
end

return setup
