local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Change the shell based on the target platform
local function get_shell()
    if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
        return {
            default_domain = 'WSL:Ubuntu'
        }
    else
        return {
            default_prog = { '/usr/bin/env', 'fish' }
        }
    end
end

local shell_config = get_shell()
for k,v in pairs(shell_config) do
    config[k] = v
end

-- Match system theme
local function get_appearance()
    if wezterm.gui then
        return wezterm.gui.get_appearance()
    end
    return 'Dark'
end

local function scheme_for_appearance(appearance)
    if appearance:find 'Dark' then
        return 'Catppuccin Mocha'
    else
        return 'Catppuccin Latte'
    end
end

-- Set theme
local appearance = get_appearance()
config.color_scheme = scheme_for_appearance(appearance)

-- Set fonts
config.font = wezterm.font_with_fallback { 'MonoLisa' }
config.font_size = 12.0

-- Set opacity
config.window_background_opacity = 0.95

-- Mouse bindings
config.mouse_bindings = {
    -- Right click paste
    {
        event = { Down = { streak = 1, button = 'Right' } },
        action = wezterm.action.PasteFrom('Clipboard')
    }
}

-- Visual bell (flash instead of audio)
config.visual_bell = {
    fade_in_duration_ms = 75,
    fade_out_duration_ms = 75,
    target = 'CursorColor'
}

-- Window styles
config.integrated_title_button_color = 'gray'
config.window_close_confirmation = 'NeverPrompt'
config.window_decorations = 'INTEGRATED_BUTTONS'
config.window_padding = {
    top = 0,
    right = 0,
    bottom = 0,
    left = 0
}

-- Tab bar
config.switch_to_last_active_tab_when_closing_tab = true

-- Return the configuration to wezterm
return config
