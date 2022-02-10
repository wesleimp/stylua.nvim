local Job = require("plenary.job")
local Path = require("plenary.path")

local lspconfig_util = require("lspconfig.util")

local DEFAULT_OPTS = {
  column_width = 120,
  line_endings = "Unix",
  indent_type = "Tabs",
  indent_width = 4,
  quote_style = "AutoPreferDouble",
  call_parentheses = "Always",
}

local M = {}
M._config = {}

local root_finder = lspconfig_util.root_pattern(".git")

local function find_stylua(path)
  if M._config[path] == nil then
    local file_path = Path:new(path)
    local root_path = Path:new(root_finder(path))

    local file_parents = file_path:parents()
    local root_parents = root_path:parents()

    local relative_diff = #file_parents - #root_parents
    for index, dir in ipairs(file_parents) do
      if index > relative_diff then
        break
      end

      local stylua_path = Path:new { dir, "stylua.toml" }
      if stylua_path:exists() then
        M._config[path] = stylua_path:absolute()
        break
      end

      stylua_path = Path:new { dir, ".stylua.toml" }
      if stylua_path:exists() then
        M._config[path] = stylua_path:absolute()
        break
      end
    end
  end

  return M._config[path]
end
function M.setup(opts)
  local conf = vim.tbl_deep_extend("force", DEFAULT_OPTS, opts or {})

  M._config.column_width = conf.column_width
  M._config.line_endings = conf.line_endings
  M._config.indent_type = conf.indent_type
  M._config.indent_width = conf.indent_width
  M._config.quote_style = conf.quote_style
  M._config.call_parentheses = conf.call_parentheses
end

function M.format(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local filepath = Path:new(vim.api.nvim_buf_get_name(bufnr)):absolute()
  local stylua_toml = find_stylua(filepath)

  local args
  if stylua_toml then
    args  = { "--config-path", stylua_toml }
  else
    args = {
      "--column-width", M._config.column_width,
      "--line-endings", M._config.line_endings,
      "--indent-type", M._config.indent_type,
      "--indent-width", M._config.indent_width,
      "--quote-style", M._config.quote_style,
      "--call-parentheses", M._config.call_parentheses,
    }
  end

  table.insert(args, "-")

  local errors = {}
  local job = Job:new({
    command = "stylua",
    args = args,
    writer = vim.api.nvim_buf_get_lines(0, 0, -1, false),
    on_stderr = function (_, data)
      table.insert(errors, data)
    end
  })

  local output = job:sync()
  if job.code ~= 0 then
    vim.schedule(function()
      error(string.format("[stylua] %s", errors[0] or "Failed to format due to errors"))
    end)

    return
  end

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, output)
end

return M
