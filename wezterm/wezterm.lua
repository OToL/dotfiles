-- Pull in the wezterm API
local wezterm = require 'wezterm'
local act = wezterm.action

-- This will hold the configuration.
local config = wezterm.config_builder()

----------------------------------------------------------
--                    CORE                               -
----------------------------------------------------------

config.font_size = 11
config.window_decorations = "RESIZE"
config.color_scheme = 'Catppuccin Mocha'

----------------------------------------------------------
--                  PERFORMANCE                          -
----------------------------------------------------------

config.webgpu_power_preference = 'HighPerformance'   -- force dGPU (RTX 5070 Ti) over iGPU
config.max_fps = 75                                  -- match panel max refresh
config.animation_fps = 1                             -- minimal redraws for animations
config.cursor_blink_rate = 0                         -- disable blink → no idle repaints

----------------------------------------------------------
--                  TABS & STATUS BAR                    -
----------------------------------------------------------

config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = false
config.hide_tab_bar_if_only_one_tab = false
config.show_new_tab_button_in_tab_bar = true
config.tab_max_width = 32

wezterm.on('update-right-status', function(window, _pane)
  local workspace = window:active_workspace()
  local date = wezterm.strftime('%Y-%m-%d')
  local time = wezterm.strftime('%H:%M')

  window:set_right_status(wezterm.format({
    { Foreground = { AnsiColor = 'Fuchsia' } }, { Text = ' ' .. workspace .. ' ' },
    { Foreground = { AnsiColor = 'Grey' } },    { Text = '│' },
    { Foreground = { AnsiColor = 'Aqua' } },    { Text = ' ' .. date .. ' ' },
    { Foreground = { AnsiColor = 'Grey' } },    { Text = '│' },
    { Foreground = { AnsiColor = 'Yellow' } },  { Text = ' ' .. time .. ' ' },
  }))
end)

----------------------------------------------------------
--                  WORKSPACE MANAGER                    -
----------------------------------------------------------
-- One palette entry "Workspaces…" opens a fuzzy list of workspaces.
-- In the list: Enter switches, Ctrl+R renames, Ctrl+D deletes.
-- The Ctrl+R / Ctrl+D trick uses a key_table activated alongside the
-- InputSelector — its bindings preempt the selector, stash an intent,
-- then synthesise Enter so the selector's callback dispatches it.

-- Path to the wezterm CLI binary, derived from the running GUI's location
-- so this config stays portable across Windows / macOS / Linux.
local WEZTERM_EXE = wezterm.executable_dir .. '/' .. (wezterm.target_triple:find('windows') and 'wezterm.exe' or 'wezterm')

local pending_workspace_action = nil
local open_workspace_manager  -- forward decl; assigned below

local function kill_workspace(name)
  for _, win in ipairs(wezterm.mux.all_windows()) do
    if win:get_workspace() == name then
      for _, tab in ipairs(win:tabs()) do
        for _, pane in ipairs(tab:panes()) do
          wezterm.run_child_process {
            WEZTERM_EXE, 'cli', 'kill-pane',
            '--pane-id', tostring(pane:pane_id()),
          }
        end
      end
    end
  end
end

local function prompt_rename_workspace(window, pane, name)
  window:perform_action(
    act.PromptInputLine {
      description = wezterm.format {
        { Attribute = { Intensity = 'Bold' } },
        { Foreground = { AnsiColor = 'Fuchsia' } },
        { Text = "Rename workspace '" .. name .. "' to: " },
      },
      action = wezterm.action_callback(function(win, p, line)
        if line and line ~= '' and line ~= name then
          wezterm.mux.rename_workspace(name, line)
        end
        win:perform_action(open_workspace_manager, p)
      end),
    },
    pane
  )
end

local function prompt_delete_workspace(window, pane, name)
  window:perform_action(
    act.PromptInputLine {
      description = wezterm.format {
        { Attribute = { Intensity = 'Bold' } },
        { Foreground = { AnsiColor = 'Red' } },
        { Text = "Delete workspace '" .. name .. "'? (y/N): " },
      },
      action = wezterm.action_callback(function(win, p, line)
        if line and (line:lower() == 'y' or line:lower() == 'yes') then
          kill_workspace(name)
        end
        win:perform_action(open_workspace_manager, p)
      end),
    },
    pane
  )
end

open_workspace_manager = wezterm.action_callback(function(window, pane)
  local active = window:active_workspace()
  local choices = {}
  for _, name in ipairs(wezterm.mux.get_workspace_names()) do
    local label = name
    if name == active then
      label = wezterm.format {
        { Foreground = { AnsiColor = 'Green' } },
        { Text = name .. '  (current)' },
      }
    end
    table.insert(choices, { id = name, label = label })
  end

  pending_workspace_action = nil

  window:perform_action(
    act.ActivateKeyTable { name = 'workspace_manager', one_shot = false },
    pane
  )

  window:perform_action(
    act.InputSelector {
      title = 'Workspaces',
      fuzzy = true,
      description = 'Enter: switch  │  Ctrl+R: rename  │  Ctrl+C: delete  │  Esc: cancel',
      choices = choices,
      action = wezterm.action_callback(function(win, p, id, _label)
        win:perform_action(act.PopKeyTable, p)
        if not id then
          pending_workspace_action = nil
          return
        end
        local action = pending_workspace_action or 'switch'
        pending_workspace_action = nil

        if action == 'switch' then
          win:perform_action(act.SwitchToWorkspace { name = id }, p)
        elseif action == 'rename' then
          prompt_rename_workspace(win, p, id)
        elseif action == 'delete' then
          if id == win:active_workspace() then
            return  -- refuse to delete the active workspace
          end
          prompt_delete_workspace(win, p, id)
        end
      end),
    },
    pane
  )
end)

config.key_tables = {
  workspace_manager = {
    { key = 'c', mods = 'CTRL', action = wezterm.action_callback(function(win, pane)
      pending_workspace_action = 'delete'
      win:perform_action(act.PopKeyTable, pane)
      win:perform_action(act.SendKey { key = 'Enter' }, pane)
    end) },
    { key = 'r', mods = 'CTRL', action = wezterm.action_callback(function(win, pane)
      pending_workspace_action = 'rename'
      win:perform_action(act.PopKeyTable, pane)
      win:perform_action(act.SendKey { key = 'Enter' }, pane)
    end) },
  },
}

config.keys = {
  -- Open the Workspaces manager. Overrides the default Ctrl+Shift+W
  -- (CloseCurrentTab) — close a tab via the palette or the × in the tab bar.
  { key = 'W', mods = 'CTRL|SHIFT', action = open_workspace_manager },
}

----------------------------------------------------------
--                  COMMAND PALETTE                      -
----------------------------------------------------------

wezterm.on('augment-command-palette', function(_window, _pane)
  return {
    {
      brief = 'Rename current tab',
      icon = 'md_rename_box',
      action = act.PromptInputLine {
        description = wezterm.format {
          { Attribute = { Intensity = 'Bold' } },
          { Foreground = { AnsiColor = 'Fuchsia' } },
          { Text = 'Rename tab: ' },
        },
        action = wezterm.action_callback(function(window, _pane, line)
          if line then
            window:active_tab():set_title(line)
          end
        end),
      },
    },
    {
      brief = 'Rename current workspace',
      icon = 'md_briefcase_edit',
      action = act.PromptInputLine {
        description = wezterm.format {
          { Attribute = { Intensity = 'Bold' } },
          { Foreground = { AnsiColor = 'Fuchsia' } },
          { Text = 'Rename workspace: ' },
        },
        action = wezterm.action_callback(function(window, _pane, line)
          if line and line ~= '' then
            wezterm.mux.rename_workspace(window:active_workspace(), line)
          end
        end),
      },
    },
    {
      brief = 'Workspaces…',
      icon = 'md_briefcase_search',
      action = open_workspace_manager,
    },
  }
end)

return config
