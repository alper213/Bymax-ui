local cacheBypass = "?t=" .. tostring(math.random(100000, 999999))
local Library = loadstring(game:HttpGet("https://github.com/alper213/Bymax-ui/raw/refs/heads/main/libaryui.lua" .. cacheBypass))()

local Window = Library:CreateWindow("Bymax Universal Hub", "Bymax  | Beta")

local TabCombat = Window:CreateTab("Combat")

local AimGroup = TabCombat:CreateGroupbox("Aimbot Settings", "Left")

AimGroup:CreateToggle({
    Name = "Enable Aimbot",
    Default = false,
    Keybind = "E",
    Hold = false,
    Callback = function(Value)
        if Value then
            Library:Notify("Combat", "Aimbot activated!", 3)
        end
    end
})

AimGroup:CreateToggle({
    Name = "Legit Aim (Hold)",
    Default = false,
    Keybind = "Q",
    Hold = true,
    Callback = function(Value)
    end
})

AimGroup:CreateSlider({
    Name = "Aimbot Smoothness",
    Min = 1,
    Max = 10,
    Increment = 0.5,
    Default = 5,
    Callback = function(Value)
    end
})

local WeaponGroup = TabCombat:CreateGroupbox("Weapon Mods", "Right")

WeaponGroup:CreateTextBox({
    Name = "Custom Hitbox",
    Placeholder = "Enter Head or Torso...",
    Callback = function(Text)
    end
})

WeaponGroup:CreateButton({
    Name = "Kill All Enemies",
    Callback = function()
        Library:Notify("Combat Mod", "Executing Kill All...", 3)
    end
})

WeaponGroup:CreateKeybind({
    Name = "Panic Button",
    Default = "K",
    Callback = function(Key)
    end
})

local TabVisuals = Window:CreateTab("Visuals")

local PlayerGroup = TabVisuals:CreateGroupbox("Player Selector", "Left")

local PlayerDropdown = PlayerGroup:CreateDropdown({
    Name = "Select Target",
    Options = {"Player1", "Player2"},
    Callback = function(Value)
    end
})

PlayerGroup:CreateButton({
    Name = "Refresh Player List",
    Callback = function()
        local newPlayers = {"Alper", "Bymax", "RobloxNoob123", "HackerBoy"}
        PlayerDropdown:Refresh(newPlayers)
        Library:Notify("Dropdown", "Player list has been refreshed!", 3)
    end
})

PlayerGroup:CreateButton({
    Name = "Force Select 'Alper'",
    Callback = function()
        PlayerDropdown:Set("Alper")
        Library:Notify("Dropdown", "Force-selected Alper!", 3)
    end
})

local ColorGroup = TabVisuals:CreateGroupbox("ESP Colors", "Right")

ColorGroup:CreateColorPicker({
    Name = "Box ESP Color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(Value)
    end
})

ColorGroup:CreateLabel("Colors automatically update in real-time.")

local TabSettings = Window:CreateTab("Settings")

local MenuSettings = TabSettings:CreateGroupbox("Menu Interface", "Left")

MenuSettings:CreateKeybind({
    Name = "Menu Toggle Bind",
    Default = "RightShift",
    Callback = function(bindName)
        if bindName then 
            Window.MenuBind = Enum.KeyCode[bindName] 
            Library:Notify("Keybind Saved", "Press [" .. bindName .. "] to hide menu.", 3)
        end
    end
})

MenuSettings:CreateButton({
    Name = "Unload UI (Delete Cheat)",
    Callback = function() 
        Window:Unload() 
    end
})

local ExtrasGroup = TabSettings:CreateGroupbox("Extra Settings", "Right")

ExtrasGroup:CreateToggle({
    Name = "Show Watermark",
    Default = true,
    Callback = function(Value)
        if Library.Watermark then Library.Watermark.Visible = Value end
    end
})

ExtrasGroup:CreateToggle({
    Name = "Show Keybinds List",
    Default = true,
    Callback = function(Value)
        if Library.KeybindList then Library.KeybindList.Visible = Value end
    end
})

Library:Notify("Bymax UI", "Beta Template loaded successfully!", 5)
