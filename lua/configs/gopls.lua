---@brief
---
--- https://github.com/golang/tools/tree/master/gopls
---
--- Google's lsp server for golang.

--- @class go_dir_custom_args
---
--- @field envvar_id string
---
--- @field custom_subdir string?

local mod_cache = nil
local std_lib = nil

---@param custom_args go_dir_custom_args
---@param on_complete fun(dir: string | nil)
local function identify_go_dir(custom_args, on_complete)
  local cmd = { 'go', 'env', custom_args.envvar_id }
  vim.system(cmd, { text = true }, function(output)
    local res = vim.trim(output.stdout or '')
    if output.code == 0 and res ~= '' then
      if custom_args.custom_subdir and custom_args.custom_subdir ~= '' then
        res = res .. custom_args.custom_subdir
      end
      on_complete(res)
    else
      vim.schedule(function()
        vim.notify(
          ('[gopls] identify ' .. custom_args.envvar_id .. ' dir cmd failed with code %d: %s\n%s'):format(
            output.code,
            vim.inspect(cmd),
            output.stderr
          )
        )
      end)
      on_complete(nil)
    end
  end)
end

---@return string?
local function get_std_lib_dir()
  if std_lib and std_lib ~= '' then
    return std_lib
  end

  identify_go_dir({ envvar_id = 'GOROOT', custom_subdir = '/src' }, function(dir)
    if dir then
      std_lib = dir
    end
  end)
  return std_lib
end

---@return string?
local function get_mod_cache_dir()
  if mod_cache and mod_cache ~= '' then
    return mod_cache
  end

  identify_go_dir({ envvar_id = 'GOMODCACHE' }, function(dir)
    if dir then
      mod_cache = dir
    end
  end)
  return mod_cache
end

---@param fname string
---@return string?
local function get_root_dir(fname)
  if mod_cache and fname:sub(1, #mod_cache) == mod_cache then
    local clients = vim.lsp.get_clients({ name = 'gopls' })
    if #clients > 0 then
      return clients[#clients].config.root_dir
    end
  end
  if std_lib and fname:sub(1, #std_lib) == std_lib then
    local clients = vim.lsp.get_clients({ name = 'gopls' })
    if #clients > 0 then
      return clients[#clients].config.root_dir
    end
  end
  return vim.fs.root(fname, 'go.work') or vim.fs.root(fname, 'go.mod') or vim.fs.root(fname, '.git')
end

---@type vim.lsp.Config
return {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  root_markers = { 'go.mod', 'go.work', '.git' },
  settings = {
      gopls = {
          gofumpt = true,
          codelenses = {
              gc_details = false,
              generate = true,
              regenerate_cgo = true,
              run_govulncheck = true,
              test = true,
              tidy = true,
              upgrade_dependency = true,
              vendor = true,
          },
          hints = {
              assignVariableTypes = false,
              compositeLiteralFields = false,
              compositeLiteralTypes = false,
              constantValues = false,
              functionTypeParameters = false,
              parameterNames = false,
              rangeVariableTypes = false,
          },
          analyses = {
              -- NOTE: To temporarily enable disabled analyzers for specific debugging:
              -- :lua vim.lsp.stop_client(vim.lsp.get_clients({name = "gopls"}))
              -- Then edit this file and save, LSP will restart with new settings

              -- Essential analyzers for catching common issues
              nilness = true,      -- Check for nil pointer dereferences
              unusedparams = true, -- Find unused function parameters
              unusedwrite = true,  -- Find unused writes to variables
              useany = true,       -- Suggest using 'any' instead of 'interface{}'
              unreachable = true,  -- Find unreachable code
              unusedresult = true, -- Check for unused results of calls to certain functions

              -- Helpful but not critical (enable as needed)
              simplifyslice = true,        -- Simplify slice expressions
              simplifyrange = true,        -- Simplify range loops
              simplifycompositelit = true, -- Simplify composite literals

              -- Performance-intensive analyzers (disabled for better performance)
              shadow = false,    -- Check for shadowed variables (can be slow)
              printf = false,    -- Check printf-style functions (can be slow)
              structtag = false, -- Check struct tags (can be slow)
              -- fieldalignment = false,  -- Check struct field alignment (very slow)
              -- unusedvariable = false,  -- Can be slow on large codebases

              -- Less commonly needed analyzers (disabled)
              modernize = false,
              stylecheck = false,
              appends = false,
              asmdecl = false,
              assign = false,
              atomic = false,
              atomicalign = false,
              bools = false,
              buildtag = false,
              cgocall = false,
              composite = false,
              composites = false,
              contextcheck = false,
              copylocks = false,
              deba = false,
              deepequalerrors = false,
              defers = false,
              deprecated = false,
              directive = false,
              embed = false,
              errorsas = false,
              fillreturns = false,
              framepointer = false,
              gofix = false,
              hostport = false,
              httpresponse = false,
              ifaceassert = false,
              infertypeargs = false,
              loopclosure = false,
              lostcancel = false,
              nilfunc = false,
              nonewvars = false,
              noresultvalues = false,
              shift = false,
              sigchanyzer = false,
              slog = false,
              sortslice = false,
              stdmethods = false,
              stdversion = false,
              stringintconv = false,
              testinggoroutine = false,
              tests = false,
              timeformat = false,
              unmarshal = false,
              unsafeptr = false,
              unusedfunc = false,
              unusedvariable = false,
              waitgroup = false,
              yield = false,
          },
          usePlaceholders = true,
          completeUnimported = true,
          staticcheck = true,
          directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
          semanticTokens = false,
      },
    },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    get_mod_cache_dir()
    get_std_lib_dir()
    -- see: https://github.com/neovim/nvim-lspconfig/issues/804
    on_dir(get_root_dir(fname))
  end,
}
