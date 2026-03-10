-- Most of the binding from https://mwop.net/blog/2024-07-04-how-i-use-wezterm.html
-- Pull in the wezterm API
local wezterm            = require 'wezterm'
local mux                = wezterm.mux
local smart_splits       = wezterm.plugin.require('https://github.com/mrjones2014/smart-splits.nvim')
local act                = wezterm.action

-------------------------------
--- PLUGINS
-------------------------------
local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
local resurrect          = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")

-------------------------------
--- RESURRECT CONFIGURATION
-------------------------------
-- Auto-save workspaces every 15 minutes
resurrect.state_manager.periodic_save({
  interval_seconds = 900,
  save_workspaces = true,
  save_windows = true,
  save_tabs = true
})

resurrect.state_manager.set_max_nlines(2000)

-------------------------------
--- WORKSPACE SWITCHER CONFIGURATION
-------------------------------
-- This table will hold the configuration.
local config = wezterm.config_builder and wezterm.config_builder() or {}

-------------------------------
--- BASIC CONFIGURATION
-------------------------------
config.color_scheme = 'Catppuccin Macchiato'
config.font = wezterm.font('GeistMono Nerd Font')
config.font_size = 18.0
config.window_background_opacity = 0.90
config.window_decorations = 'RESIZE'
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }

-- Tab bar
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = false
config.switch_to_last_active_tab_when_closing_tab = true

-- Leader key (like tmux)
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 2000 }

-- Misc
config.adjust_window_size_when_changing_font_size = false
config.automatically_reload_config = true
config.enable_scroll_bar = false
config.status_update_interval = 1000
config.send_composed_key_when_right_alt_is_pressed = false
config.pane_focus_follows_mouse = true
config.scrollback_lines = 10000
config.use_dead_keys = false
config.warn_about_missing_glyphs = false
config.mouse_bindings = {
  { event = { Up = { streak = 1, button = 'Left' } }, mods = 'CTRL', action = act.OpenLinkAtMouseCursor }
}
-------------------------------
--- EVENT HANDLERS
-------------------------------
local function basename(s)
  return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

-- Get color scheme colors
local scheme = wezterm.color.get_builtin_schemes()['Catppuccin Macchiato']

-- Update status bar and restore state when creating/switching workspaces
workspace_switcher.workspace_formatter = function(label)
  return wezterm.format({
    { Attribute = { Italic = true } },
    { Foreground = { Color = scheme.ansi[4] } }, -- yellow
    { Background = { Color = scheme.background } },
    { Text = "󱂬 : " .. label },
  })
end

wezterm.on("smart_workspace_switcher.workspace_switcher.created", function(window, path, label)
  window:gui_window():set_right_status(wezterm.format({
    { Attribute = { Intensity = "Bold" } },
    { Foreground = { Color = scheme.ansi[6] } }, -- magenta
    { Text = basename(path) .. "  " },
  }))
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
  window:gui_window():set_right_status(wezterm.format({
    { Attribute = { Intensity = "Bold" } },
    { Foreground = { Color = scheme.ansi[6] } }, -- magenta
    { Text = basename(path) .. "  " },
  }))
end)

wezterm.on("smart_workspace_switcher.workspace_switcher.selected", function(window, path, label)
  wezterm.log_info(window)
  local workspace_state = resurrect.workspace_state
  resurrect.state_manager.save_state(workspace_state.get_workspace_state())
  resurrect.state_manager.write_current_state(label, "workspace")
end)

wezterm.on("smart_workspace_switcher.workspace_switcher.start", function(window, _)
  wezterm.log_info(window)
end)
wezterm.on("smart_workspace_switcher.workspace_switcher.canceled", function(window, _)
  wezterm.log_info(window)
end)

-- Restore last workspace on startup
wezterm.on("gui-startup", resurrect.state_manager.resurrect_on_gui_startup)

-------------------------------
--- KEY BINDINGS
-------------------------------
config.keys = {
  { key = '[', mods = 'LEADER', action = act.ActivateCopyMode,             description = 'Enter copy mode' },

  -- Tabs
  { key = 'w', mods = 'LEADER', action = act.ShowTabNavigator,             description = 'Show tab navigator' },
  { key = 'c', mods = 'LEADER', action = act.SpawnTab 'CurrentPaneDomain', description = 'Create new tab' },
  {
    key = ',',
    mods = 'LEADER',
    action = act.PromptInputLine {
      description = 'Enter new name for tab',
      action = wezterm.action_callback(function(window, _, line)
        if line then window:active_tab():set_title(line) end
      end),
    },
    description = 'Rename current tab',
  },
  { key = 'n', mods = 'LEADER',       action = act.ActivateTabRelative(1),                                     description = 'Next tab' },
  { key = 'p', mods = 'LEADER',       action = act.ActivateTabRelative(-1),                                    description = 'Previous tab' },
  { key = '&', mods = 'LEADER|SHIFT', action = act.CloseCurrentTab { confirm = true },                         description = 'Close tab' },

  -- Panes
  { key = '|', mods = 'LEADER|SHIFT', action = act.SplitPane { direction = 'Right', size = { Percent = 50 } }, description = 'Split vertical' },
  { key = '-', mods = 'LEADER',       action = act.SplitPane { direction = 'Down', size = { Percent = 50 } },  description = 'Split horizontal' },
  { key = 'x', mods = 'LEADER',       action = act.CloseCurrentPane { confirm = true },                        description = 'Close pane' },
  { key = '{', mods = 'LEADER|SHIFT', action = act.PaneSelect { mode = "SwapWithActiveKeepFocus" },            description = 'Swap pane' },
  { key = 'z', mods = 'LEADER',       action = act.TogglePaneZoomState,                                        description = 'Toggle zoom' },
  { key = 'f', mods = 'ALT',          action = act.TogglePaneZoomState,                                        description = 'Toggle zoom (alt)' },
  { key = ';', mods = 'LEADER',       action = act.ActivatePaneDirection('Prev'),                              description = 'Previous pane' },
  { key = 'o', mods = 'LEADER',       action = act.ActivatePaneDirection('Next'),                              description = 'Next pane' },

  -- Workspaces (tmux-style sessions)
  -- Note: LEADER+s and LEADER+S are provided by workspace_switcher plugin
  {
    key = '$',
    mods = 'LEADER|SHIFT',
    action = act.PromptInputLine {
      description = 'Enter new name for workspace',
      action = wezterm.action_callback(function(_, _, line)
        if line then mux.rename_workspace(mux.get_active_workspace(), line) end
      end),
    },
    description = 'Rename workspace',
  },
  {
    key = 'N',
    mods = 'LEADER|SHIFT',
    action = act.PromptInputLine {
      description = "Enter new workspace name",
      action = wezterm.action_callback(function(window, pane, line)
        if line then window:perform_action(act.SwitchToWorkspace { name = line }, pane) end
      end)
    },
    description = 'Create new workspace',
  },

  -- Resurrect keybindings (auto-save enabled, manual restore for recovery)
  {
    key = "R",
    mods = "LEADER|SHIFT",
    action = wezterm.action_callback(function(win, pane)
      resurrect.fuzzy_loader.fuzzy_load(win, pane, function(id)
        local type = id:match("^([^/]+)")
        local name = id:match("([^/]+)$"):match("(.+)%..+$")
        local opts = {
          relative = true,
          restore_text = true,
          on_pane_restore = resurrect.tab_state.default_on_pane_restore
        }

        if type == "workspace" then
          resurrect.workspace_state.restore_workspace(resurrect.state_manager.load_state(name, "workspace"), opts)
        elseif type == "window" then
          resurrect.window_state.restore_window(pane:window(), resurrect.state_manager.load_state(name, "window"), opts)
        elseif type == "tab" then
          resurrect.tab_state.restore_tab(pane:tab(), resurrect.state_manager.load_state(name, "tab"), opts)
        end
      end, {
        title = "Restore State",
        description = "Select State to Restore and press Enter = restore, Esc = cancel",
        fuzzy_description = "Search State to Restore: ",
        is_fuzzy = true
      })
    end),
    description = 'Restore saved state',
  },
  {
    key = "D",
    mods = "LEADER|SHIFT",
    action = wezterm.action_callback(function(win, pane)
      resurrect.fuzzy_loader.fuzzy_load(win, pane, function(id)
        resurrect.state_manager.delete_state(id)
      end, {
        title = "Delete State",
        description = "Select State to Delete and press Enter = delete, Esc = cancel",
        fuzzy_description = "Search State to Delete: ",
        is_fuzzy = true
      })
    end),
    description = 'Delete saved state',
  },
}

-------------------------------
--- SMART SPLITS
-------------------------------
smart_splits.apply_to_config(config, {
  direction_keys = {
    move = { 'h', 'j', 'k', 'l' },
    resize = { 'LeftArrow', 'DownArrow', 'UpArrow', 'RightArrow' },
  },
  modifiers = {
    move = 'META',
    resize = 'META',
  },
  log_level = 'info',
})

-------------------------------
--- APPLY WORKSPACE SWITCHER
-------------------------------
workspace_switcher.zoxide_path = "$HOME/.local/bin/zoxide"
workspace_switcher.apply_to_config(config)

return config
