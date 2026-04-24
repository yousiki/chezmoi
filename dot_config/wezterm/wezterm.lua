local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- ═══════════════════════════════════════════════════════════════════════════
-- Appearance
-- ═══════════════════════════════════════════════════════════════════════════

local function resolve_color_scheme()
  local ok, appearance = pcall(function() return wezterm.gui.get_appearance() end)
  if ok and type(appearance) == 'string' and appearance:find('Light', 1, true) then
    return 'Catppuccin Frappe'
  end
  return 'Catppuccin Mocha'
end

config.color_scheme = resolve_color_scheme()

-- ═══════════════════════════════════════════════════════════════════════════
-- Font
-- ═══════════════════════════════════════════════════════════════════════════

config.font = wezterm.font_with_fallback({
  { family = 'Maple Mono NF CN' },
  'Apple Color Emoji',
})
config.font_size = 13.0
config.line_height = 1.2
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }

-- Switch font weight by theme: light needs heavier weight for readability
local font_weight_overrides_by_window = {}

local function build_font(is_light)
  local weight = is_light and 'Medium' or 'Regular'
  return wezterm.font_with_fallback({
    { family = 'Maple Mono NF CN', weight = weight },
    'Apple Color Emoji',
  })
end

-- ═══════════════════════════════════════════════════════════════════════════
-- Cursor
-- ═══════════════════════════════════════════════════════════════════════════

config.default_cursor_style = 'BlinkingBar'
config.cursor_thickness = '2px'
config.cursor_blink_rate = 500
config.cursor_blink_ease_in = 'Constant'
config.cursor_blink_ease_out = 'Constant'

-- ═══════════════════════════════════════════════════════════════════════════
-- Window
-- ═══════════════════════════════════════════════════════════════════════════

config.initial_cols = 110
config.initial_rows = 28
config.window_decorations = 'INTEGRATED_BUTTONS|RESIZE'
config.window_background_opacity = 1.0
config.text_background_opacity = 1.0
config.window_padding = { left = '30px', right = '30px', top = '30px', bottom = '0px' }

config.window_frame = {
  font = wezterm.font({ family = 'Maple Mono NF CN', weight = 'Regular' }),
  font_size = 13.0,
}

config.window_close_confirmation = 'NeverPrompt'
config.native_macos_fullscreen_mode = true
config.quit_when_all_windows_are_closed = false

-- ═══════════════════════════════════════════════════════════════════════════
-- Tab Bar
-- ═══════════════════════════════════════════════════════════════════════════

config.enable_tab_bar = true
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.tab_max_width = 32
config.hide_tab_bar_if_only_one_tab = true
config.show_tab_index_in_tab_bar = true
config.show_new_tab_button_in_tab_bar = false

-- ═══════════════════════════════════════════════════════════════════════════
-- Pane
-- ═══════════════════════════════════════════════════════════════════════════

config.inactive_pane_hsb = {
  saturation = 0.8,
  brightness = 0.7,
}
config.swallow_mouse_click_on_pane_focus = true
config.swallow_mouse_click_on_window_focus = true

-- ═══════════════════════════════════════════════════════════════════════════
-- Rendering
-- ═══════════════════════════════════════════════════════════════════════════

config.bold_brightens_ansi_colors = false
config.enable_scroll_bar = false
config.front_end = 'WebGpu'
config.webgpu_power_preference = 'LowPower'
config.animation_fps = 60
config.max_fps = 60
config.status_update_interval = 1000

-- ═══════════════════════════════════════════════════════════════════════════
-- Scrollback & Selection
-- ═══════════════════════════════════════════════════════════════════════════

config.scrollback_lines = 10000
config.selection_word_boundary = ' \t\n{}[]()"\'-'

-- ═══════════════════════════════════════════════════════════════════════════
-- Shell
-- ═══════════════════════════════════════════════════════════════════════════

local user_shell = os.getenv('SHELL')
config.default_prog = { user_shell or '/bin/zsh', '-l' }

-- ═══════════════════════════════════════════════════════════════════════════
-- macOS Keys
-- ═══════════════════════════════════════════════════════════════════════════

config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = true

-- ═══════════════════════════════════════════════════════════════════════════
-- Key Bindings
-- ═══════════════════════════════════════════════════════════════════════════

config.keys = {
  -- Clear screen + scrollback
  {
    key = 'k', mods = 'CMD',
    action = wezterm.action.Multiple({
      wezterm.action.SendKey({ key = 'l', mods = 'CTRL' }),
      wezterm.action.ClearScrollback('ScrollbackAndViewport'),
    }),
  },
  {
    key = 'r', mods = 'CMD',
    action = wezterm.action.Multiple({
      wezterm.action.SendKey({ key = 'l', mods = 'CTRL' }),
      wezterm.action.ClearScrollback('ScrollbackAndViewport'),
    }),
  },

  -- App
  { key = 'q', mods = 'CMD', action = wezterm.action.QuitApplication },
  { key = 'n', mods = 'CMD', action = wezterm.action.SpawnWindow },
  { key = 'h', mods = 'CMD', action = wezterm.action.HideApplication },
  { key = 'm', mods = 'CMD', action = wezterm.action.Hide },

  -- Smart close: pane > tab > hide
  {
    key = 'w', mods = 'CMD',
    action = wezterm.action_callback(function(win, pane)
      local mux_win = win:mux_window()
      local tabs = mux_win and mux_win:tabs() or {}
      local current_tab = pane:tab()
      local panes = current_tab and current_tab:panes() or {}
      if #panes > 1 then
        win:perform_action(wezterm.action.CloseCurrentPane { confirm = false }, pane)
      elseif #tabs > 1 then
        win:perform_action(wezterm.action.CloseCurrentTab { confirm = false }, pane)
      else
        win:perform_action(wezterm.action.HideApplication, pane)
      end
    end),
  },
  {
    key = 'w', mods = 'CMD|SHIFT',
    action = wezterm.action.CloseCurrentTab({ confirm = false }),
  },

  -- Tabs
  { key = 't', mods = 'CMD', action = wezterm.action.SpawnTab('CurrentPaneDomain') },
  { key = '[', mods = 'CMD|SHIFT', action = wezterm.action.ActivateTabRelative(-1) },
  { key = ']', mods = 'CMD|SHIFT', action = wezterm.action.ActivateTabRelative(1) },
  { key = '1', mods = 'CMD', action = wezterm.action.ActivateTab(0) },
  { key = '2', mods = 'CMD', action = wezterm.action.ActivateTab(1) },
  { key = '3', mods = 'CMD', action = wezterm.action.ActivateTab(2) },
  { key = '4', mods = 'CMD', action = wezterm.action.ActivateTab(3) },
  { key = '5', mods = 'CMD', action = wezterm.action.ActivateTab(4) },
  { key = '6', mods = 'CMD', action = wezterm.action.ActivateTab(5) },
  { key = '7', mods = 'CMD', action = wezterm.action.ActivateTab(6) },
  { key = '8', mods = 'CMD', action = wezterm.action.ActivateTab(7) },
  { key = '9', mods = 'CMD', action = wezterm.action.ActivateTab(8) },

  -- Splits
  { key = 'd', mods = 'CMD', action = wezterm.action.SplitHorizontal({ domain = 'CurrentPaneDomain' }) },
  { key = 'D', mods = 'CMD|SHIFT', action = wezterm.action.SplitVertical({ domain = 'CurrentPaneDomain' }) },

  -- Pane navigation
  { key = 'LeftArrow',  mods = 'CMD|OPT', action = wezterm.action.ActivatePaneDirection('Left') },
  { key = 'RightArrow', mods = 'CMD|OPT', action = wezterm.action.ActivatePaneDirection('Right') },
  { key = 'UpArrow',    mods = 'CMD|OPT', action = wezterm.action.ActivatePaneDirection('Up') },
  { key = 'DownArrow',  mods = 'CMD|OPT', action = wezterm.action.ActivatePaneDirection('Down') },

  -- Pane zoom
  { key = 'Enter', mods = 'CMD|SHIFT', action = wezterm.action.TogglePaneZoomState },

  -- Pane resize
  { key = 'LeftArrow',  mods = 'CMD|CTRL', action = wezterm.action.AdjustPaneSize { 'Left', 5 } },
  { key = 'RightArrow', mods = 'CMD|CTRL', action = wezterm.action.AdjustPaneSize { 'Right', 5 } },
  { key = 'UpArrow',    mods = 'CMD|CTRL', action = wezterm.action.AdjustPaneSize { 'Up', 5 } },
  { key = 'DownArrow',  mods = 'CMD|CTRL', action = wezterm.action.AdjustPaneSize { 'Down', 5 } },

  -- Font size
  { key = '=', mods = 'CMD', action = wezterm.action.IncreaseFontSize },
  { key = '-', mods = 'CMD', action = wezterm.action.DecreaseFontSize },
  { key = '0', mods = 'CMD', action = wezterm.action.ResetFontSize },

  -- Fullscreen
  { key = 'f', mods = 'CMD|CTRL', action = wezterm.action.ToggleFullScreen },

  -- Shell editing
  { key = 'LeftArrow',  mods = 'OPT', action = wezterm.action.SendKey({ key = 'b', mods = 'ALT' }) },
  { key = 'RightArrow', mods = 'OPT', action = wezterm.action.SendKey({ key = 'f', mods = 'ALT' }) },
  { key = 'LeftArrow',  mods = 'CMD', action = wezterm.action.SendKey({ key = 'a', mods = 'CTRL' }) },
  { key = 'RightArrow', mods = 'CMD', action = wezterm.action.SendKey({ key = 'e', mods = 'CTRL' }) },
  { key = 'Backspace',  mods = 'CMD', action = wezterm.action.SendKey({ key = 'u', mods = 'CTRL' }) },
  { key = 'Backspace',  mods = 'OPT', action = wezterm.action.SendKey({ key = 'w', mods = 'CTRL' }) },

  -- Newline without executing
  { key = 'Enter', mods = 'CMD',   action = wezterm.action.SendString('\n') },
  { key = 'Enter', mods = 'SHIFT', action = wezterm.action.SendString('\n') },
}

-- ═══════════════════════════════════════════════════════════════════════════
-- Mouse Bindings
-- ═══════════════════════════════════════════════════════════════════════════

config.mouse_bindings = {
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'NONE',
    action = wezterm.action.CompleteSelection('ClipboardAndPrimarySelection'),
  },
  -- Pair Down+Up so mouse-aware TUIs receive a balanced click sequence
  {
    event = { Down = { streak = 1, button = 'Left' } },
    mods = 'CMD',
    action = wezterm.action.Nop,
  },
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CMD',
    action = wezterm.action.OpenLinkAtMouseCursor,
  },
}

-- ═══════════════════════════════════════════════════════════════════════════
-- Tab Title (show cwd basename)
-- ═══════════════════════════════════════════════════════════════════════════

local function tab_title(tab)
  local title = tab.tab_title
  if title and #title > 0 then
    return title
  end
  local pane = tab.active_pane
  if pane then
    local cwd = pane.current_working_dir
    if cwd then
      local path = cwd.file_path or tostring(cwd):match('file://[^/]*(/.*)') or ''
      path = path:gsub('/$', '')
      local name = path:match('([^/]+)$') or ''
      if name ~= '' then
        return (pane.is_zoomed and name .. ' [Z]') or name
      end
    end
    return pane.title or ''
  end
  return ''
end

wezterm.on('format-tab-title', function(tab, _, _, _, _, max_width)
  local title = tab_title(tab)
  title = wezterm.truncate_right(title, math.max(8, max_width - 6))
  return string.format(' [%d] %s ', tab.tab_index + 1, title)
end)

-- ═══════════════════════════════════════════════════════════════════════════
-- Sync font weight on theme change (light = Medium, dark = Regular)
-- ═══════════════════════════════════════════════════════════════════════════

wezterm.on('window-config-reloaded', function(window)
  local overrides = window:get_config_overrides() or {}
  local scheme = overrides.color_scheme or config.color_scheme
  local is_light = scheme == 'Catppuccin Frappe'

  if font_weight_overrides_by_window[window] ~= is_light then
    font_weight_overrides_by_window[window] = is_light
    overrides.font = build_font(is_light)
    window:set_config_overrides(overrides)
  end
end)

-- ═══════════════════════════════════════════════════════════════════════════
-- Right status: clock in fullscreen only
-- ═══════════════════════════════════════════════════════════════════════════

wezterm.on('update-right-status', function(window)
  local dims = window:get_dimensions()
  if not dims.is_full_screen then
    window:set_right_status('')
    return
  end
  window:set_right_status(wezterm.format({
    { Foreground = { Color = '#6c7086' } },
    { Text = ' ' .. wezterm.strftime('%H:%M') .. ' ' },
  }))
end)

return config
