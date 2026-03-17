Bymax UI Library V28 - Official Documentation

Bymax UI is a lightweight and high-performance interface library created for Roblox scripters. This version (V28) focuses on fixing common issues found in other libraries such as alignment bugs, mobile compatibility problems, and executor crashes.

Main Features
- Mobile Support: All sliders, buttons, and dropdowns are fully optimized for touch inputs.
- Smart Notifications: Smooth UI animations for user alerts located at the bottom right.
- Root Saving System: Folder creation is bypassed to prevent common executor crashes. All data is handled via .txt files in the workspace.
- Hold Logic: Toggles now support a hold-to-use mode, useful for specific features like aimbots.
- Premium Design: Active tabs include indicator lines and section titles are perfectly centered with dynamic borders.

Getting Started

To initialize the library, use the following loadstring:

local Library = loadstring(game:HttpGet("https://github.com/alper213/Bymax-ui/raw/refs/heads/main/libaryui.lua"))()
local Window = Library:CreateWindow("Your Hub Name", "Version Info")

UI Structure

1. Creating Tabs
Tabs are the main navigation buttons at the top of the menu.

local MainTab = Window:CreateTab("Main")

2. Creating Groupboxes
Groupboxes are the sections that contain your cheat features. You can place them on the "Left" or "Right" side.

local Section = MainTab:CreateGroupbox("Aimbot Settings", "Left")

3. Interactive Elements

Toggle with Keybind and Hold Mode:

Section:CreateToggle({
    Name = "Legit Aim",
    Default = false,
    Keybind = "E",
    Hold = true, -- Set to true if you want it to work only while pressing the key
    Callback = function(Value)
        print("Status:", Value)
    end
})

Slider:

Section:CreateSlider({
    Name = "WalkSpeed",
    Min = 16,
    Max = 200,
    Default = 16,
    Increment = 1,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})

Dynamic Dropdown:

local myDropdown = Section:CreateDropdown({
    Name = "Select Mode",
    Options = {"Standard", "Rage", "Legit"},
    Callback = function(Value)
        print("Selected:", Value)
    end
})

-- To refresh options later:
-- myDropdown:Refresh({"New1", "New2"})

-- To force a value:
-- myDropdown:Set("Rage")

Utility Functions
- Library:Notify("Title", "Text", Duration) - Shows a popup notification.
- Window:Unload() - Completely removes the UI and stops all processes.
- Library.Watermark.Visible = false - Hides the watermark.
- Library.KeybindList.Visible = false - Hides the keybind list widget.

Credits
Developed by Alper / Bymax. Use it in your projects as you wish, but keep the core logic intact.
