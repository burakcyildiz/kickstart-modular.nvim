local config = function()
  local theme = require 'lualine.themes.tokyonight'
  theme.normal.c.bg = nil

  require('lualine').setup {
    options = {
      theme = theme,
      globalstatus = true,
    },
    -- Enable if you want to see all the buffers in the modeline
    -- sections = {
    --   lualine_a = {
    --     {
    --       'buffers',
    --     },
    --   },
    -- },
  }
end

return {
  'nvim-lualine/lualine.nvim',
  lazy = false,
  config = config,
}
