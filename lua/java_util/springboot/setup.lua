local lsp_config = require("tobiasz.config.lsp-config.config")

local setup = {}

-- TODO: allow java 9 or lower using tools.jar

local capabilities = lsp_config.capabilities

capabilities.workspace.executeCommand = {
  dynamicRegistration = true,
}

local home = os.getenv("HOME")

local function execute_jdtls_command(command_params)
  local candidates = vim.lsp.get_active_clients({
    bufnr = vim.api.nvim_get_current_buf(),
    -- TODO: Make sure that the name is always this when wrapping nvim jdtls
    name = "jdt.ls",
  })

  local cand_count = vim.tbl_count(candidates)
  if cand_count > 1 then
    print("larger")
    return
  end
  if cand_count == 0 then
    print("none found")
    return
  end

  -- TODO: Check if client can execute it
  return candidates[1].request_sync("workspace/executeCommand", command_params)
end

local function request_handler(command_name)
  return function(_, result)
    return execute_jdtls_command({
      command = command_name,
      arguments = result,
    })
  end
end

local default_opts = {
  logging_file = home .. "/.cache/nvim/java-util.nvim.log",
}

function setup.setup(opts)
  opts = opts or {
    port = 19999,
  }

  local client_id = vim.lsp.start_client({
    name = "boot-ls",
    cmd = {
      "java",
      "-Dsts.lsp.client=vscode",
      string.format("-Dsts.log.file=%s", default_opts.logging_file),
      string.format("-Dlogging.file=%s", default_opts.logging_file),
      "-jar",
      vim.fn.glob(home .. "/.local/share/jdtls/spring-boot/spring-boot-language-server-*-exec.jar"),
    },
    capabilities = lsp_config.capabilities,
    on_error = function(_, _)
      print("error")
    end,
    commands = {},
    handlers = {
      ["sts/addClasspathListener"] = function(_, result)
        return execute_jdtls_command({
          command = "sts.java.addClasspathListener",
          arguments = {
            result.callbackCommandId,
          },
        })
      end,
      ["sts/removeClasspathListener"] = function(_, result)
        return execute_jdtls_command({
          command = "sts.java.removeClasspathListener",
          arguments = {
            result.callbackCommandId,
          },
        })
      end,
      ["sts/javadocHoverLink"] = request_handler("sts.java.javadocHoverLink"),
      ["sts/javaType"] = request_handler("sts.java.type"),
      ["sts/javaSuperTypes"] = request_handler("sts.java.hierarchy.supertypes"),
      ["sts/javaCodeComplete"] = request_handler("sts.java.code.completions"),
      ["sts/javaSubTypes"] = request_handler("sts.java.hierarchy.subtypes"),
      ["sts/javaSearchPackages"] = request_handler("sts.java.search.packages"),
      ["sts/javaSearchTypes"] = request_handler("sts.java.search.types"),
      ["sts/javadoc"] = request_handler("sts.java.javadoc"),
      ["sts/javaLocation"] = request_handler("sts.java.location"),
    },
    on_attach = function(client, bufnr)
      print("attached!")
      lsp_config.on_attach(client, bufnr)
    end,
    on_exit = function()
      print("exited")
    end,
    on_init = function(client, results)
      print("initialized")
      -- print(vim.inspect(client))
      -- print(vim.inspect(results))
    end,
    root_dir = vim.fn.getcwd(),
    trace = "verbose",
  })

  vim.lsp.buf_attach_client(vim.api.nvim_get_current_buf(), client_id)
end

return setup
