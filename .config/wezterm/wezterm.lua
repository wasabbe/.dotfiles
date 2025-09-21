-- Most of the binding from https://mwop.net/blog/2024-07-04-how-i-use-wezterm.html
-- Pull in the wezterm API
local wezterm            = require 'wezterm'
local mux                = wezterm.mux
local smart_splits       = wezterm.plugin.require('https://github.com/mrjones2014/smart-splits.nvim')
local act                = wezterm.action

-------------------------------
--- work space switcher
--- --------------------------
local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")

-------------------------------
--- RESSURECT
--- --------------------------
local resurrect          = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")

resurrect.state_manager.periodic_save({
  interval_seconds = 900, -- 15 minutes
  save_workspaces = true,
  save_windows = true,
  save_tabs = true
})

resurrect.state_manager.set_max_nlines(2000)

-- -------------------------------------------------false
-- CONFIGURATION
-- --------------------------------------------------------------------

-- This table will hold the configuration.
--local resurrect = require("resurrect.config")
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.adjust_window_size_when_changing_font_size = false
config.automatically_reload_config = true
config.enable_scroll_bar = false
config.font = wezterm.font('GeistMono Nerd Font')
config.font_size = 18.0
config.hide_tab_bar_if_only_one_tab = false
config.status_update_interval = 1000
config.window_background_opacity = 0.90

-- The leader is similar to how tmux defines a set of keys to hit in order to
-- invoke tmux bindings. Binding to ctrl-a here to mimic tmux
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 2000 }
config.mouse_bindings = {
  -- Open URLs with Ctrl+Click
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CTRL',
    action = act.OpenLinkAtMouseCursor,
  }
}
config.send_composed_key_when_right_alt_is_pressed = false
config.pane_focus_follows_mouse = true
config.scrollback_lines = 10000
config.use_dead_keys = false
config.warn_about_missing_glyphs = false
config.window_decorations = 'RESIZE'
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

-- Tab bar
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.switch_to_last_active_tab_when_closing_tab = true
--config.tab_max_width = 32
--
--config.unix_domains = {
--  {
--    name = 'unix',
--  },
--}
--
---- This causes `wezterm` to act as though it was started as
---- `wezterm connect unix` by default, connecting to the unix
---- domain on startup.
---- If you prefer to connect manually, leave out this line.
--config.default_gui_startup_args = { 'connect', 'unix' }
--
------------------------------------------
--- Custom Hooks
------------------------------------------
local function basename(s)
  return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

-- Save workspace state whenever you switch to a different workspace (UI, command palette, etc)
wezterm.on("mux-switch-workspace", function(window, workspace_name)
  resurrect.state_manager.save_state(resurrect.workspace_state.get_workspace_state())
end)

wezterm.on("smart_workspace_switcher.workspace_switcher.created", function(window, path, label)
  wezterm.log_info("This event got triggered by workspace creation")
  window:gui_window():set_right_status(basename(path) .. "  ")
  local workspace_state = resurrect.workspace_state

  workspace_state.restore_workspace(resurrect.state_manager.load_state(label, "workspace"), {
    window = window,
    relative = true,
    restore_text = true,
    resize_window = false,
    on_pane_restore = resurrect.tab_state.default_on_pane_restore,
  })
end)

wezterm.on("smart_workspace_switcher.workspace_switcher.chosen", function(window, path, label)
  wezterm.log_info(window)
  window:gui_window():set_right_status(basename(path) .. "  ")
end)

wezterm.on("smart_workspace_switcher.workspace_switcher.selected", function(window, path, label)
  wezterm.log_info(window)
  local workspace_state = resurrect.workspace_state
  resurrect.state_manager.save_state(workspace_state.get_workspace_state())
  resurrect.state_manager.write_current_state(label, "workspace")
end)

------------------------------------------
------------------------------------------

-- Custom key bindings
config.keys = {
  -- -- Disable Alt-Enter combination (already used in tmux to split pane)
  -- {
  --     key = 'Enter',
  --     mods = 'ALT',
  --     action = act.DisableDefaultAssignment,
  -- },
  {
    key = '[',
    mods = 'LEADER',
    action = act.ActivateCopyMode,
    description = 'Enter copy mode',
  },

  -- ----------------------------------------------------------------
  -- TABS
  -- ----------------------------------------------------------------

  {
    key = 'w',
    mods = 'LEADER',
    action = act.ShowTabNavigator,
    description = 'Show tab navigator',
  },
  {
    key = 'c',
    mods = 'LEADER',
    action = act.SpawnTab 'CurrentPaneDomain',
    description = 'Create new tab',
  },
  {
    key = ',',
    mods = 'LEADER',
    action = act.PromptInputLine {
      description = 'Enter new name for tab',
      action = wezterm.action_callback(
        function(window, _, line)
          if line then
            window:active_tab():set_title(line)
          end
        end
      ),
    },
    description = 'Rename current tab',
  },
  {
    key = 'n',
    mods = 'LEADER',
    action = act.ActivateTabRelative(1),
    description = 'Activate next tab',
  },
  {
    key = 'p',
    mods = 'LEADER',
    action = act.ActivateTabRelative(-1),
    description = 'Activate previous tab',
  },
  {
    key = '&',
    mods = 'LEADER|SHIFT',
    action = act.CloseCurrentTab { confirm = true },
    description = 'Close current tab',
  },

  -- ----------------------------------------------------------------
  -- PANES
  -- ----------------------------------------------------------------

  {
    key = '|',
    mods = 'LEADER|SHIFT',
    action = act.SplitPane {
      direction = 'Right',
      size = { Percent = 50 },
    },
    description = 'Split pane vertically',
  },
  {
    key = '-',
    mods = 'LEADER',
    action = act.SplitPane {
      direction = 'Down',
      size = { Percent = 50 },
    },
    description = 'Split pane horizontally',
  },
  {
    key = 'x',
    mods = 'LEADER',
    action = act.CloseCurrentPane { confirm = true },
    description = 'Close current pane',
  },
  {
    key = '{',
    mods = 'LEADER|SHIFT',
    action = act.PaneSelect { mode = "SwapWithActiveKeepFocus" },
    description = 'Swap active pane with another',
  },
  {
    key = 'z',
    mods = 'LEADER',
    action = act.TogglePaneZoomState,
    description = 'Toggle pane zoom state',
  },
  {
    key = 'f',
    mods = 'ALT',
    action = act.TogglePaneZoomState,
    description = 'Toggle pane zoom state (alt+f)',
  },
  {
    key = ';',
    mods = 'LEADER',
    action = act.ActivatePaneDirection('Prev'),
    description = 'Activate previous pane',
  },
  {
    key = 'o',
    mods = 'LEADER',
    action = act.ActivatePaneDirection('Next'),
    description = 'Activate next pane',
  },
  {
    key = '$',
    mods = 'LEADER|SHIFT',
    action = act.PromptInputLine {
      description = 'Enter new name for session',
      action = wezterm.action_callback(
        function(line)
          if line then
            mux.rename_workspace(
              mux.get_active_workspace(),
              line
            )
          end
        end
      ),
    },
    description = 'Rename current session',
  },
  {
    key = 'n',
    mods = 'LEADER',
    action = wezterm.action.PromptInputLine {
      description = "Enter new workspace name",
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:perform_action(
            act.SwitchToWorkspace {
              name = line,
            },
            pane
          )
        end
      end)
    },
    description = 'Switch to workspace by name',
  },
  {
    key = 's',
    mods = 'LEADER',
    action = workspace_switcher.switch_workspace(),
    description = 'Show workspace launcher',
  },
  {
    key = "d",
    mods = "LEADER|CTRL",
    action = wezterm.action_callback(function(win, pane)
      resurrect.fuzzy_loader.fuzzy_load(win, pane, function(id)
          resurrect.state_manager.delete_state(id)
        end,
        {
          title = "Delete State",
          description = "Select State to Delete and press Enter = accept, Esc = cancel, / = filter",
          fuzzy_description = "Search State to Delete: ",
          is_fuzzy = true,
        })
    end),
  },
}

-- and finally, return the configuration to wezterm
config.color_scheme = 'Catppuccin Macchiato'

smart_splits.apply_to_config(config, {
  -- the default config is here, if you'd like to use the default keys,
  -- you can omit this configuration table parameter and just use
  -- smart_splits.apply_to_config(config)
  -- directional keys to use in order of: left, down, up, right
  -- if you want to use separate direction keys for move vs. resize, you
  -- can also do this:
  direction_keys = {
    move = { 'h', 'j', 'k', 'l' },
    resize = { 'LeftArrow', 'DownArrow', 'UpArrow', 'RightArrow' },
  },
  -- modifier keys to combine with direction_keys
  modifiers = {
    move = 'META',   -- modifier to use for pane movement, e.g. CTRL+h to move left
    resize = 'META', -- modifier to use for pane resize, e.g. META+h to resize to the left
  },
  -- log level to use: info, warn, error
  log_level = 'info',
})

wezterm.on("gui-startup", resurrect.state_manager.resurrect_on_gui_startup)

return config
