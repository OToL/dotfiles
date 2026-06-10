---@diagnostic disable: unused-local

-- Pull in the wezterm API
local wezterm = require 'wezterm'
local act = wezterm.action

-- This will hold the configuration.
local config = wezterm.config_builder()

----------------------------------------------------------
--                    CORE                               -
----------------------------------------------------------

config.font_size = 10
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
--                       PLUGINS                         -
----------------------------------------------------------

local sessions = wezterm.plugin.require( "https://github.com/abidibo/wezterm-sessions")
local smart_splits = wezterm.plugin.require('https://github.com/mrjones2014/smart-splits.nvim')

----------------------------------------------------------
--                  WORKSPACE MANAGER                    -
----------------------------------------------------------

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

local kill_other_panes = wezterm.action_callback(function(window, pane)
  local cur_id = pane:pane_id()
  for _, p in ipairs(window:active_tab():panes()) do
    if p:pane_id() ~= cur_id then
      wezterm.run_child_process {
        WEZTERM_EXE, 'cli', 'kill-pane', '--pane-id', tostring(p:pane_id()),
      }
    end
  end
end)

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

----------------------------------------------------------
--                   KEY BINDINGS                        -
----------------------------------------------------------

-- Smart resize: Right/Up grow the pane; Left/Down shrink it.
-- Growing expands the current pane (falls back to opposite edge if needed).
-- Shrinking expands the neighbor toward us, which reduces our size.
local function smart_resize(dir)
  return wezterm.action_callback(function(window, pane)
    local panes = window:active_tab():panes_with_info()
    local cur_id = pane:pane_id()
    local cur
    for _, p in ipairs(panes) do
      if p.pane:pane_id() == cur_id then cur = p; break end
    end
    if not cur then return end

    local right_pane, left_pane, bottom_pane, top_pane
    for _, p in ipairs(panes) do
      if p.pane:pane_id() ~= cur_id then
        if p.left >= cur.left + cur.width  and not right_pane  then right_pane  = p.pane end
        if p.left + p.width <= cur.left    and not left_pane   then left_pane   = p.pane end
        if p.top  >= cur.top  + cur.height and not bottom_pane then bottom_pane = p.pane end
        if p.top  + p.height <= cur.top    and not top_pane    then top_pane    = p.pane end
      end
    end

    if dir == 'Right' then      -- wider: expand current pane rightward, fallback leftward
      local d = right_pane and 'Right' or 'Left'
      window:perform_action(act.AdjustPaneSize { d, 5 }, pane)
    elseif dir == 'Left' then   -- narrower: expand neighbor toward us
      local neighbor = right_pane or left_pane
      local d        = right_pane and 'Left' or 'Right'
      if neighbor then window:perform_action(act.AdjustPaneSize { d, 5 }, neighbor) end
    elseif dir == 'Up' then     -- taller: expand current pane upward, fallback downward
      local d = top_pane and 'Up' or 'Down'
      window:perform_action(act.AdjustPaneSize { d, 5 }, pane)
    elseif dir == 'Down' then   -- shorter: expand neighbor toward us
      local neighbor = bottom_pane or top_pane
      local d        = bottom_pane and 'Up' or 'Down'
      if neighbor then window:perform_action(act.AdjustPaneSize { d, 5 }, neighbor) end
    end
  end)
end

config.leader = { key = 'Space', mods = 'CTRL', timeout_milliseconds = 1000 }

config.keys = {
    -- base
    { key = 'l', mods = 'LEADER', action = open_workspace_manager },
    { key = 'w', mods = 'LEADER', action = act.CloseCurrentPane { confirm = false } },
    { key = 'v', mods = 'LEADER', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = 's', mods = 'LEADER', action = act.SplitVertical   { domain = 'CurrentPaneDomain' } },
    { key = 'm', mods = 'LEADER', action = act.TogglePaneZoomState },
    { key = 'o', mods = 'LEADER', action = kill_other_panes },
    { key = 'h', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Left' },
    { key = 'j', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Down' },
    { key = 'k', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Up' },
    { key = 'l', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Right' },
    { key = 'LeftArrow',  mods = 'CTRL|SHIFT', action = smart_resize('Left') },
    { key = 'RightArrow', mods = 'CTRL|SHIFT', action = smart_resize('Right') },
    { key = 'UpArrow',    mods = 'CTRL|SHIFT', action = smart_resize('Up') },
    { key = 'DownArrow',  mods = 'CTRL|SHIFT', action = smart_resize('Down') },
}

for i = 1, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'ALT',
    action = act.ActivateTab(i - 1),
  })
end

-- must come after config.keys is defined; apply_to_config appends into it
smart_splits.apply_to_config(config, {
  direction_keys = {
    move = { 'h', 'j', 'k', 'l' },
  },
  modifiers = {
    move = 'CTRL',
  },
  log_level = 'info',
})

----------------------------------------------------------
--                  COMMAND PALETTE                      -
----------------------------------------------------------

wezterm.on('augment-command-palette', function(_, _)
  return {
    {
      brief = 'Save session',
      icon = 'md_content_save',
      action = wezterm.action_callback(function(window, _)
        sessions.save_state(window, true)
      end),
    },
    {
      brief = 'Load session',
      icon = 'md_folder_open',
      action = wezterm.action_callback(function(window, pane)
        sessions.load_state(window, pane)
      end),
    },
    {
      brief = 'Restore session',
      icon = 'md_restore',
      action = wezterm.action_callback(function(window, _)
        sessions.restore_state(window)
      end),
    },
    {
      brief = 'Delete session',
      icon = 'md_delete',
      action = act.EmitEvent('delete_session'),
    },
    {
      brief = 'Rename current tab',
      icon = 'md_rename_box',
      action = act.PromptInputLine {
        description = wezterm.format {
          { Attribute = { Intensity = 'Bold' } },
          { Foreground = { AnsiColor = 'Fuchsia' } },
          { Text = 'Rename tab: ' },
        },
        action = wezterm.action_callback(function(window, _, line)
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
        action = wezterm.action_callback(function(window, _, line)
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
