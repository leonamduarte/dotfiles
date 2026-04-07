---@type LazySpec
return {
  "mikavilpas/yazi.nvim",
  version = "*", -- use the latest stable version
  event = "VeryLazy",
  dependencies = {
    { "nvim-lua/plenary.nvim", lazy = true },
  },
  keys = {
    -- 👇 in this section, choose your own keymappings!
    {
      "<leader>-,",
      mode = { "n", "v" },
      "<cmd>Yazi<cr>",
      desc = "Open yazi at the current file",
    },
    {
      -- Open in the current working directory
      "<leader>cw",
      "<cmd>Yazi cwd<cr>",
      desc = "Open the file manager in nvim's working directory",
    },
    {
      "<c-up>",
      "<cmd>Yazi toggle<cr>",
      desc = "Resume the last yazi session",
    },
  },
  ---@type YaziConfig | {}
  opts = {
    open_for_directories = false,
    open_multiple_tabs = false,
    change_neovim_cwd_on_close = false,
    highlight_groups = {
      hovered_buffer = nil,
      hovered_buffer_in_same_directory = nil,
    },
    floating_window_scaling_factor = 0.9,
    yazi_floating_window_winblend = 0,
    yazi_floating_window_border = "rounded",
    yazi_floating_window_zindex = nil,
    log_level = vim.log.levels.OFF,
    open_file_function = function(chosen_file, config, state)
      vim.cmd("edit " .. vim.fn.fnameescape(chosen_file))
    end,
    keymaps = {
      show_help = "<f1>",
      open_file_in_vertical_split = "<c-v>",
      open_file_in_horizontal_split = "<c-x>",
      open_file_in_tab = "<c-t>",
      grep_in_directory = "<c-s>",
      replace_in_directory = "<c-g>",
      cycle_open_buffers = "<tab>",
      copy_relative_path_to_selected_files = "<c-y>",
      send_to_quickfix_list = "<c-q>",
      change_working_directory = "<c-\\>",
      open_and_pick_window = "<c-o>",
    },
    set_keymappings_function = function(yazi_buffer_id, config, context) end,
    clipboard_register = "*",
    hooks = {
      yazi_opened = function(preselected_path, yazi_buffer_id, config)
      end,
      yazi_closed_successfully = function(chosen_file, config, state)
        if state and state.last_directory then
          local ok, path_nav = pcall(require, "config.path_navigation")
          if ok then
            path_nav._last_dir = path_nav.normalize_path(state.last_directory.filename)
          end
        end
      end,
      yazi_opened_multiple_files = function(chosen_files, config, state) end,
      on_yazi_ready = function(buffer, config, process_api) end,
      before_opening_window = function(window_options) end,
    },
    highlight_hovered_buffers_in_same_directory = true,
    integrations = {
      grep_in_directory = function(directory) end,
      grep_in_selected_files = function(selected_files) end,
      replace_in_directory = function(directory) end,
      replace_in_selected_files = function(selected_files) end,
      resolve_relative_path_application = "",
      resolve_relative_path_implementation = function(args, get_relative_path) end,
      bufdelete_implementation = "bundled-snacks",
      picker_add_copy_relative_path_action = nil,
    },
    future_features = {
      use_cwd_file = true,
      new_shell_escaping = true,
    },
  },
  init = function()
    vim.g.loaded_netrwPlugin = 1
  end,
}
