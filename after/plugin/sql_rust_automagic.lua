local run_formatter = function(unformatted_query)
  local command = 'python ~/.config/nvim/bin/sql-format-via-python.py'
  local formatted_query = vim.fn.system(command, unformatted_query)
  local results = {}
  for line in formatted_query:gmatch '[^\r\n]+' do
    table.insert(results, line)
  end
  return results
end

local embedded_sql = vim.treesitter.query.parse(
  'rust',
  [[
(macro_invocation
  (scoped_identifier
    path: (identifier) @path (#eq? @path "sqlx")
   )

(token_tree
  (raw_string_literal
  (string_content) @injection.content))
  (#set! injection.language "sql")
)
]]
)

local get_root = function(bufnr)
  local parser = vim.treesitter.get_parser(bufnr, 'rust', {})
  local tree = parser:parse()[1]
  return tree:root()
end

local format_sql = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  if vim.bo[bufnr].filetype ~= 'rust' then
    vim.notify 'can only be used in rust'
    return
  end

  local root = get_root(bufnr)

  local changes = {}

  for id, node in embedded_sql:iter_captures(root, bufnr, 0, -1) do
    local name = embedded_sql.captures[id]
    if name == 'injection.content' then
      local range = { node:range() }
      local indentation = string.rep(' ', range[2])

      local formatted = run_formatter(vim.treesitter.get_node_text(node, bufnr))

      for idx, line in ipairs(formatted) do
        formatted[idx] = indentation .. line
      end

      table.insert(changes, 1, { start = range[1], final = range[3], formatted = formatted })
    end
  end

  for _, change in ipairs(changes) do
    vim.api.nvim_buf_set_lines(bufnr, change.start, change.final, false, change.formatted)
  end
end

vim.api.nvim_create_user_command('SqlMagic', function()
  format_sql()
end, {})

local group = vim.api.nvim_create_augroup('rust-sql-magic', { clear = true })
vim.api.nvim_create_autocmd('BufWritePre', {
  group = group,
  pattern = '*.rs',
  callback = function()
    format_sql()
  end,
})
