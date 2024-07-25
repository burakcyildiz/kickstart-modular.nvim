-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal' },
  },
  opts = {
    window = {
      mappings = {
        ['[b'] = 'prev_source',
        [']b'] = 'next_source',
        ['F'] = 'telescope.nvim' and 'find_in_dir' or nil,
        ['O'] = 'system_open',
        ['Y'] = 'copy_selector',
        ['h'] = 'parent_or_close',
        ['l'] = 'child_or_open',
        ['o'] = 'open',
      },
    },
    filesystem = {
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },
  },
}
