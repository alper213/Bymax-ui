I'm tired i sent open source the ai and make it directory


# Bymax UI Library  (Official Release)

Bymax UI is a high-performance, lightweight interface library designed specifically for Roblox scripters. This version focuses on eliminating alignment bugs, ensuring mobile compatibility, and preventing executor-level crashes common in other libraries.

![Menu Preview](https://github.com/alper213/Bymax-ui/blob/main/Ekran%20g%C3%B6r%C3%BCnt%C3%BCs%C3%BC%202026-03-17%20231144.png?raw=true)

## Key Technical Features

* **Mobile Optimization:** Optimized touch-target areas for sliders, buttons, and dropdowns.
* **Tweened Notifications:** Custom notification system with smooth slide animations.
* **Anti-Crash Logic:** Bypasses problematic folder creation methods to ensure stability across all executors. Saves data as .txt in the root workspace.
* **Hold-to-Use Logic:** Integrated support for toggles that only activate while a key is held down.
* **Premium Aesthetics:** Dynamic borders that adjust to title length and active tab indicators.



## Installation

To load the library into your script, use the following code block:

```lua
local Library = loadstring(game:HttpGet("[https://github.com/alper213/Bymax-ui/raw/refs/heads/main/libaryui.lua](https://github.com/alper213/Bymax-ui/raw/refs/heads/main/libaryui.lua)"))()
local Window = Library:CreateWindow("Bymax Universal Hub", "Beta Premium")
```

---

## Quick Start Guide

### 1. Navigation
Create tabs for the main menu header.

```lua
local Tab = Window:CreateTab("Main")
```

### 2. Organizing Features
Use groupboxes to categorize your scripts. Supports "Left" and "Right" alignments.

```lua
local Group = Tab:CreateGroupbox("Aimbot Settings", "Left")
```

### 3. Adding Interactive Elements

#### Toggles (Supports Hold Mode)
```lua
Group:CreateToggle({
    Name = "Legit Mode",
    Default = false,
    Keybind = "E",
    Hold = true, -- Feature stays active only while holding 'E'
    Callback = function(Value)
        print("Feature Status:", Value)
    end
})
```

#### Dynamic Sliders
```lua
Group:CreateSlider({
    Name = "Walkspeed",
    Min = 16,
    Max = 100,
    Default = 16,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})
```

#### Advanced Dropdowns
Supports real-time refreshing and value setting.

```lua
local Dropdown = Group:CreateDropdown({
    Name = "Targets",
    Options = {"Player1", "Player2"},
    Callback = function(v) print(v) end
})

-- To refresh later: Dropdown:Refresh({"NewPlayer1", "NewPlayer2"})
```

---

## Full API Documentation & Example
I have provided a comprehensive example script that showcases every single feature and function available in this library.

👉 [**Click here to view the Full Example Script**](https://github.com/alper213/Bymax-ui/raw/refs/heads/main/example.lua)

---

## Global Functions

| Function | Description |
| :--- | :--- |
| `Library:Notify(Title, Text, Time)` | Pops up a smooth notification. |
| `Window:Unload()` | Destroys the UI and stops all library processes. |
| `Library.Watermark.Visible = false` | Controls the visibility of the top-left watermark. |
| `Library.KeybindList.Visible = false` | Controls the visibility of the active keybinds widget. |

---
