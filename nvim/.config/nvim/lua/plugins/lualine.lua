return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'folke/noice.nvim',
    'stevearc/oil.nvim',
  },
  config = function()
    local icons = require('custom.icons')

    local options = {
      theme = 'auto',
      disabled_filetypes = {
        statusline = {}, -- Only ignores the ft for statusline.
        winbar = {}, -- Only ignores the ft for winbar.
        -- Ignores for both \/
      },

      -- Some icons:                    
      section_separators = { left = '', right = '' },
      component_separators = { left = '', right = '' },
    }

    local sections = {
      lualine_a = {},
      lualine_b = {
        'branch',
      },
      lualine_c = {
        {
          'filetype',
          padding = { left = 1, right = 0 },
          icon_only = true,
          icon = {
            align = 'left',
          },
        },
        {
          'filename',
          path = 4, -- Parent directory and file name
          symbols = {
            modified = icons.buffer.modified,
            readonly = '',
            unnamed = 'Unnamed',
            newfile = '',
          },
        },
        -- Show macros
        {
          require('noice').api.statusline.mode.get,
          cond = require('noice').api.statusline.mode.has,
          color = { fg = '#ff9e64' },
          padding = { left = 2, right = 1 },
        },
      },
      lualine_x = {
        {
          'searchcount',
          padding = { left = 1, right = 3 },
        },
        {
          'diagnostics',
          symbols = {
            hint = icons.diagnostics.hint,
            info = icons.diagnostics.info,
            warn = icons.diagnostics.warn,
            error = icons.diagnostics.error,
          },
        },
        {
          'diff',
          padding = { left = 2, right = 1 },
          colored = true,
          symbols = {
            added = ' ',
            modified = ' ',
            removed = ' ',
          },
          -- Where to get git info from
          source = function()
            -- Using gitsigns, it updates in real time, with no need to save
            local gitsigns = vim.b.gitsigns_status_dict
            if gitsigns then
              return {
                added = gitsigns.added,
                modified = gitsigns.changed,
                removed = gitsigns.removed,
              }
            end
          end,
        },
      },
      lualine_y = {
        {
          padding = { left = 1, right = 0 },
          function()
            return vim.t.maximized and ' ' or ''
          end,
        },
        'progress',
      },
      lualine_z = {},
    }

    -- Custom
    local oil = {
      options = vim.deepcopy(options),
      sections = vim.deepcopy(sections),
      filetypes = { 'oil' },
    }

    -- Cleaner displayed path
    oil.sections.lualine_c[2] = {
      function()
        local oil_directory = vim.fn.fnamemodify(require('oil').get_current_dir(), ':~')
        local modified_symbol = vim.bo.modified and ' ' .. require('custom.icons').buffer.modified or ''
        return oil_directory .. modified_symbol
      end,
    }

    require('lualine').setup({
      options = options,
      sections = sections,
      extensions = { oil },
    })
  end,
}
