return {
  'lewis6991/gitsigns.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  config = function()
    local gitsigns = require('gitsigns')
    gitsigns.setup({
      attach_to_untracked = true,
    })

    local ts_repeat_move = require('nvim-treesitter.textobjects.repeatable_move')

    -- Repeatable hunk move
    local next_hunk, prev_hunk = ts_repeat_move.make_repeatable_move_pair(function()
      gitsigns.nav_hunk('next')
    end, function()
      gitsigns.nav_hunk('prev')
    end)

    vim.keymap.set('n', '<leader>h', gitsigns.preview_hunk, { desc = 'Git preview hunk' })
    vim.keymap.set('n', '<leader>H', function()
      gitsigns.diffthis(nil, { vertical = true, split = 'rightbelow' })
    end, { desc = 'Git hunk diff' })

    vim.keymap.set('n', '<leader>b', gitsigns.blame_line, { desc = 'Git preview blame' })
    vim.keymap.set('n', '<leader>B', gitsigns.blame, { desc = 'Git blame' })

    vim.keymap.set('n', ']h', next_hunk, { desc = 'Git next hunk' })
    vim.keymap.set('n', '[h', prev_hunk, { desc = 'Git previous hunk' })

    vim.keymap.set('o', 'ah', gitsigns.select_hunk, { desc = 'Select hunk' })
    vim.keymap.set('o', 'ih', gitsigns.select_hunk, { desc = 'Select hunk' })

    -- Uses ':' in visual mode due to a bug (Only lines after cursor were being selected)
    vim.keymap.set('x', 'ah', ':Gitsigns select_hunk<CR>', { desc = 'Select hunk' })
    vim.keymap.set('x', 'ih', ':Gitsigns select_hunk<CR>', { desc = 'Select hunk' })
  end,
}
