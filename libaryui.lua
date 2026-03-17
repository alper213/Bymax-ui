
local Library = {
    Flags = {}, 
    Theme = {
        MainBG = Color3.fromRGB(25, 25, 25),
        Border = Color3.fromRGB(45, 45, 45),
        Accent = Color3.fromRGB(40, 100, 255),
        Text = Color3.fromRGB(210, 210, 210),
        DarkBG = Color3.fromRGB(20, 20, 20),
        ItemBG = Color3.fromRGB(30, 30, 30)
    }
}

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local TargetParent
local success = pcall(function() TargetParent = gethui and gethui() or game:GetService("CoreGui") end)
if not success or not TargetParent then
    TargetParent = Players.LocalPlayer:WaitForChild("PlayerGui")
end

local isMobile = UIS.TouchEnabled and not UIS.MouseEnabled

for _, v in pairs(TargetParent:GetChildren()) do
    if v.Name == "BymaxUILib" then v:Destroy() end
end

-- ==============================================================================
-- SMOOTH NOTIFICATION SYSTEM (WRAPPER FIX FOR UILISTLAYOUT)
-- ==============================================================================
local NotifGui = Instance.new("ScreenGui")
NotifGui.Name = "BymaxNotif"
NotifGui.Parent = TargetParent
NotifGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

local NotifLayout = Instance.new("Frame")
NotifLayout.Size = UDim2.new(0, 250, 1, -20)
NotifLayout.Position = UDim2.new(1, -260, 0, 10)
NotifLayout.BackgroundTransparency = 1
NotifLayout.Parent = NotifGui

local UIListLayoutNotif = Instance.new("UIListLayout")
UIListLayoutNotif.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayoutNotif.VerticalAlignment = Enum.VerticalAlignment.Bottom
UIListLayoutNotif.Padding = UDim.new(0, 10)
UIListLayoutNotif.Parent = NotifLayout

function Library:Notify(title, text, duration)
    duration = duration or 4

    local NWrapper = Instance.new("Frame")
    NWrapper.Size = UDim2.new(1, 0, 0, 65)
    NWrapper.BackgroundTransparency = 1
    NWrapper.Parent = NotifLayout

    local NContainer = Instance.new("Frame")
    NContainer.Size = UDim2.new(1, 0, 1, 0)
    NContainer.BackgroundColor3 = Library.Theme.DarkBG
    NContainer.BorderSizePixel = 0
    NContainer.Position = UDim2.new(1, 300, 0, 0) 
    NContainer.Parent = NWrapper
    Instance.new("UIStroke", NContainer).Color = Library.Theme.Border

    local NTopLine = Instance.new("Frame")
    NTopLine.Size = UDim2.new(1, 0, 0, 2)
    NTopLine.BackgroundColor3 = Library.Theme.Accent
    NTopLine.BorderSizePixel = 0
    NTopLine.Parent = NContainer

    local NTitle = Instance.new("TextLabel")
    NTitle.Size = UDim2.new(1, -30, 0, 20)
    NTitle.Position = UDim2.new(0, 10, 0, 5)
    NTitle.BackgroundTransparency = 1
    NTitle.Text = title
    NTitle.TextColor3 = Library.Theme.Accent
    NTitle.Font = Enum.Font.Code
    NTitle.TextSize = 13
    NTitle.TextXAlignment = Enum.TextXAlignment.Left
    NTitle.Parent = NContainer

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 20, 0, 20)
    CloseBtn.Position = UDim2.new(1, -25, 0, 5)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(200, 50, 50)
    CloseBtn.Font = Enum.Font.Code
    CloseBtn.TextSize = 14
    CloseBtn.Parent = NContainer

    local NText = Instance.new("TextLabel")
    NText.Size = UDim2.new(1, -20, 0, 35)
    NText.Position = UDim2.new(0, 10, 0, 25)
    NText.BackgroundTransparency = 1
    NText.Text = text
    NText.TextColor3 = Library.Theme.Text
    NText.Font = Enum.Font.Code
    NText.TextSize = 12
    NText.TextXAlignment = Enum.TextXAlignment.Left
    NText.TextYAlignment = Enum.TextYAlignment.Top
    NText.TextWrapped = true
    NText.Parent = NContainer

    local TweenIn = TweenService:Create(NContainer, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)})
    TweenIn:Play()

    local closed = false
    local function CloseNotification()
        if closed then return end
        closed = true
        local TweenOut = TweenService:Create(NContainer, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(1, 300, 0, 0)})
        TweenOut:Play()
        TweenOut.Completed:Wait()
        NWrapper:Destroy()
    end

    CloseBtn.Activated:Connect(CloseNotification)

    task.spawn(function()
        task.wait(duration)
        CloseNotification()
    end)
end

-- ==============================================================================
-- MAIN LIBRARY CORE
-- ==============================================================================
function Library:CreateWindow(title, wmText)
    local WindowData = {}
    WindowData.MenuBind = Enum.KeyCode.RightShift
    WindowData.Tabs = {}

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BymaxUILib"
    ScreenGui.Parent = TargetParent
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global 
    ScreenGui.ResetOnSpawn = false

    function WindowData:Unload() 
        ScreenGui:Destroy() 
        if NotifGui then NotifGui:Destroy() end
    end

    local MobileToggleBtn = nil
    if isMobile then
        MobileToggleBtn = Instance.new("TextButton")
        MobileToggleBtn.Name = "MobileToggle"
        MobileToggleBtn.Size = UDim2.new(0, 50, 0, 50)
        MobileToggleBtn.Position = UDim2.new(1, -70, 0, 15)
        MobileToggleBtn.BackgroundColor3 = Library.Theme.DarkBG
        MobileToggleBtn.TextColor3 = Library.Theme.Accent
        MobileToggleBtn.Font = Enum.Font.Code
        MobileToggleBtn.TextSize = 13
        MobileToggleBtn.Text = "MENU"
        MobileToggleBtn.BorderSizePixel = 0
        MobileToggleBtn.Active = true
        MobileToggleBtn.Draggable = true 
        MobileToggleBtn.Parent = ScreenGui
        local MTCircular = Instance.new("UICorner")
        MTCircular.CornerRadius = UDim.new(0, 8)
        MTCircular.Parent = MobileToggleBtn
        Instance.new("UIStroke", MobileToggleBtn).Color = Library.Theme.Border
    end

    local WatermarkBG = Instance.new("Frame")
    WatermarkBG.AutomaticSize = Enum.AutomaticSize.X
    WatermarkBG.Size = UDim2.new(0, 0, 0, 20)
    WatermarkBG.Position = UDim2.new(0, 15, 0, 15)
    WatermarkBG.BackgroundColor3 = Library.Theme.DarkBG
    WatermarkBG.BorderSizePixel = 0
    WatermarkBG.Active = true
    WatermarkBG.Draggable = true
    WatermarkBG.Parent = ScreenGui
    Instance.new("UIStroke", WatermarkBG).Color = Library.Theme.Border

    local WMTopLine = Instance.new("Frame")
    WMTopLine.Size = UDim2.new(1, 0, 0, 1)
    WMTopLine.BackgroundColor3 = Library.Theme.Accent
    WMTopLine.BorderSizePixel = 0
    WMTopLine.Parent = WatermarkBG

    local WMTextLabel = Instance.new("TextLabel")
    WMTextLabel.AutomaticSize = Enum.AutomaticSize.X
    WMTextLabel.Size = UDim2.new(0, 0, 1, 0)
    WMTextLabel.BackgroundTransparency = 1
    WMTextLabel.Text = wmText or "Bymax UI"
    WMTextLabel.TextColor3 = Library.Theme.Text
    WMTextLabel.Font = Enum.Font.Code
    WMTextLabel.TextSize = 12
    WMTextLabel.Parent = WatermarkBG

    local WMPadding = Instance.new("UIPadding")
    WMPadding.PaddingLeft = UDim.new(0, 6)
    WMPadding.PaddingRight = UDim.new(0, 6)
    WMPadding.Parent = WMTextLabel

    local frames = 0
    RunService.RenderStepped:Connect(function() frames = frames + 1 end)
    task.spawn(function()
        local baseText = wmText or "Bymax UI"
        while task.wait(1) do
            if not ScreenGui.Parent then break end 
            local timeStr = os.date("%H:%M:%S")
            WMTextLabel.Text = string.format("%s | %s | %d FPS", baseText, timeStr, frames)
            frames = 0
        end
    end)

    local KeybindListBG = Instance.new("Frame")
    KeybindListBG.Size = UDim2.new(0, 200, 0, 20)
    KeybindListBG.Position = UDim2.new(0, 15, 0.4, 0)
    KeybindListBG.BackgroundColor3 = Library.Theme.DarkBG
    KeybindListBG.BorderSizePixel = 0
    KeybindListBG.Active = true
    KeybindListBG.Draggable = true
    KeybindListBG.Visible = not isMobile 
    KeybindListBG.Parent = ScreenGui
    Instance.new("UIStroke", KeybindListBG).Color = Library.Theme.Border

    local KLTopLine = Instance.new("Frame")
    KLTopLine.Size = UDim2.new(1, 0, 0, 1)
    KLTopLine.BackgroundColor3 = Library.Theme.Accent
    KLTopLine.BorderSizePixel = 0
    KLTopLine.Parent = KeybindListBG

    local KLTitle = Instance.new("TextLabel")
    KLTitle.Size = UDim2.new(1, -10, 1, 0)
    KLTitle.Position = UDim2.new(0, 5, 0, 0)
    KLTitle.BackgroundTransparency = 1
    KLTitle.Text = "Keybinds"
    KLTitle.TextColor3 = Library.Theme.Text
    KLTitle.Font = Enum.Font.Code
    KLTitle.TextSize = 12
    KLTitle.TextXAlignment = Enum.TextXAlignment.Left
    KLTitle.Parent = KeybindListBG

    local KLContainer = Instance.new("Frame")
    KLContainer.Size = UDim2.new(1, 0, 0, 0)
    KLContainer.Position = UDim2.new(0, 0, 1, 0)
    KLContainer.BackgroundColor3 = Library.Theme.MainBG
    KLContainer.BackgroundTransparency = 0
    KLContainer.BorderSizePixel = 0
    KLContainer.AutomaticSize = Enum.AutomaticSize.Y
    KLContainer.Parent = KeybindListBG
    
    local KLLayout = Instance.new("UIListLayout")
    KLLayout.SortOrder = Enum.SortOrder.LayoutOrder
    KLLayout.Parent = KLContainer

    local activeKeybinds = {}
    local function UpdateKeybindList(name, key, state)
        if isMobile then return end 
        if not key or key == "" then return end
        if not activeKeybinds[name] then
            local item = Instance.new("TextLabel")
            item.Size = UDim2.new(1, -10, 0, 16)
            item.Position = UDim2.new(0, 5, 0, 0)
            item.BackgroundTransparency = 1
            item.Font = Enum.Font.Code
            item.TextSize = 11
            item.TextXAlignment = Enum.TextXAlignment.Left
            item.Parent = KLContainer
            activeKeybinds[name] = item
        end
        activeKeybinds[name].Text = "[" .. key .. "] " .. name
        activeKeybinds[name].TextColor3 = state and Library.Theme.Accent or Color3.fromRGB(130, 130, 130)
    end

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 520, 0, 480)
    MainFrame.Position = UDim2.new(0.5, -260, 0.5, -240)
    MainFrame.BackgroundColor3 = Library.Theme.MainBG
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    Instance.new("UIStroke", MainFrame).Color = Library.Theme.Border
    
    if isMobile then
        MainFrame.Size = UDim2.new(0, 450, 0, 350)
        MainFrame.Position = UDim2.new(0.5, -225, 0.5, -175)
    end

    UIS.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == WindowData.MenuBind then
            MainFrame.Visible = not MainFrame.Visible
        end
    end)
    
    if isMobile and MobileToggleBtn then
        MobileToggleBtn.Activated:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
    end

    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 25)
    TitleBar.BackgroundColor3 = Library.Theme.MainBG
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    local TitleText = Instance.new("TextLabel")
    TitleText.Size = UDim2.new(1, -10, 1, 0)
    TitleText.Position = UDim2.new(0, 10, 0, 0)
    TitleText.BackgroundTransparency = 1
    TitleText.Text = title
    TitleText.TextColor3 = Library.Theme.Text
    TitleText.Font = Enum.Font.Code
    TitleText.TextSize = 12
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.Parent = TitleBar

    local TabBar = Instance.new("Frame")
    TabBar.Size = UDim2.new(1, -20, 0, 25)
    TabBar.Position = UDim2.new(0, 10, 0, 30)
    TabBar.BackgroundTransparency = 1
    TabBar.Parent = MainFrame
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 10)
    TabLayout.Parent = TabBar

    local ContentArea = Instance.new("Frame")
    ContentArea.Size = UDim2.new(1, -20, 1, -70)
    ContentArea.Position = UDim2.new(0, 10, 0, 60)
    ContentArea.BackgroundColor3 = Library.Theme.DarkBG
    ContentArea.BorderSizePixel = 0
    ContentArea.Parent = MainFrame
    Instance.new("UIStroke", ContentArea).Color = Library.Theme.Border

    local ActiveDropdown = nil

    function WindowData:CreateTab(tabName)
        local TabData = {}
        
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(0, 0, 1, 0)
        TabBtn.AutomaticSize = Enum.AutomaticSize.X
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = tabName
        TabBtn.TextColor3 = (#self.Tabs == 0) and Library.Theme.Text or Color3.fromRGB(130, 130, 130)
        TabBtn.Font = Enum.Font.Code
        TabBtn.TextSize = 13
        TabBtn.Parent = TabBar

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, -10, 1, -10)
        Page.Position = UDim2.new(0, 5, 0, 5)
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0
        Page.ScrollBarThickness = 2
        Page.Visible = (#self.Tabs == 0)
        Page.Parent = ContentArea

        local LeftColumn = Instance.new("Frame")
        LeftColumn.Size = UDim2.new(0.49, 0, 1, 0)
        LeftColumn.BackgroundTransparency = 1
        LeftColumn.Parent = Page
        
        local LeftLayout = Instance.new("UIListLayout")
        LeftLayout.SortOrder = Enum.SortOrder.LayoutOrder
        LeftLayout.Padding = UDim.new(0, 12)
        LeftLayout.Parent = LeftColumn

        local RightColumn = Instance.new("Frame")
        RightColumn.Size = UDim2.new(0.49, 0, 1, 0)
        RightColumn.Position = UDim2.new(0.51, 0, 0, 0)
        RightColumn.BackgroundTransparency = 1
        RightColumn.Parent = Page
        
        local RightLayout = Instance.new("UIListLayout")
        RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
        RightLayout.Padding = UDim.new(0, 12)
        RightLayout.Parent = RightColumn

        local function UpdateCanvas()
            local leftY = LeftLayout.AbsoluteContentSize.Y
            local rightY = RightLayout.AbsoluteContentSize.Y
            local maxY = math.max(leftY, rightY)
            Page.CanvasSize = UDim2.new(0, 0, 0, maxY + 20)
        end
        LeftLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateCanvas)
        RightLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateCanvas)

        table.insert(self.Tabs, {Btn = TabBtn, Page = Page})

        TabBtn.MouseButton1Click:Connect(function()
            for _, t in pairs(self.Tabs) do
                t.Page.Visible = false
                t.Btn.TextColor3 = Color3.fromRGB(130, 130, 130)
            end
            Page.Visible = true
            TabBtn.TextColor3 = Library.Theme.Text
        end)

        function TabData:CreateGroupbox(gbName, side)
            local GBData = {}
            side = side or "Left"
            
            local GroupBox = Instance.new("Frame")
            GroupBox.Size = UDim2.new(1, 0, 0, 0)
            GroupBox.BackgroundColor3 = Library.Theme.DarkBG
            GroupBox.BorderSizePixel = 0
            GroupBox.AutomaticSize = Enum.AutomaticSize.Y
            GroupBox.Parent = (side == "Right") and RightColumn or LeftColumn
            Instance.new("UIStroke", GroupBox).Color = Library.Theme.Border

            local GBBlueLine = Instance.new("Frame")
            GBBlueLine.Size = UDim2.new(1, 0, 0, 1)
            GBBlueLine.BackgroundColor3 = Library.Theme.Accent
            GBBlueLine.BorderSizePixel = 0
            GBBlueLine.ZIndex = 1 
            GBBlueLine.Parent = GroupBox
            
            local TitleContainer = Instance.new("Frame")
            TitleContainer.Position = UDim2.new(0, 10, 0, -8) 
            TitleContainer.Size = UDim2.new(0, 0, 0, 16) 
            TitleContainer.AutomaticSize = Enum.AutomaticSize.X 
            TitleContainer.BackgroundColor3 = Library.Theme.DarkBG
            TitleContainer.BorderSizePixel = 0
            TitleContainer.ZIndex = 5 
            TitleContainer.Parent = GroupBox

            local GBTitle = Instance.new("TextLabel")
            GBTitle.Size = UDim2.new(1, 0, 1, 0)
            GBTitle.BackgroundTransparency = 1
            GBTitle.Text = " " .. gbName .. " "
            GBTitle.TextColor3 = Library.Theme.Text
            GBTitle.Font = Enum.Font.Code
            GBTitle.TextSize = 12
            GBTitle.TextYAlignment = Enum.TextYAlignment.Center 
            GBTitle.ZIndex = 6
            GBTitle.Parent = TitleContainer

            local ItemContainer = Instance.new("Frame")
            ItemContainer.Size = UDim2.new(1, -16, 0, 0)
            ItemContainer.Position = UDim2.new(0, 8, 0, 14)
            ItemContainer.BackgroundTransparency = 1
            ItemContainer.AutomaticSize = Enum.AutomaticSize.Y
            ItemContainer.ZIndex = 1
            ItemContainer.Parent = GroupBox

            local ItemLayout = Instance.new("UIListLayout")
            ItemLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ItemLayout.Padding = UDim.new(0, 6)
            ItemLayout.Parent = ItemContainer

            local Padding = Instance.new("UIPadding")
            Padding.PaddingBottom = UDim.new(0, 8)
            Padding.Parent = ItemContainer

            function GBData:CreateLabel(text)
                local Lbl = Instance.new("TextLabel")
                Lbl.Size = UDim2.new(1, 0, 0, 14)
                Lbl.BackgroundTransparency = 1
                Lbl.Text = text
                Lbl.TextColor3 = Library.Theme.Text
                Lbl.Font = Enum.Font.Code
                Lbl.TextSize = 12
                Lbl.TextXAlignment = Enum.TextXAlignment.Left
                Lbl.Parent = ItemContainer
            end

            function GBData:CreateButton(options)
                local name = options.Name or "Button"
                local callback = options.Callback or function() end

                local Btn = Instance.new("TextButton")
                Btn.Size = UDim2.new(1, 0, 0, 18)
                Btn.BackgroundColor3 = Library.Theme.ItemBG
                Btn.BorderSizePixel = 0
                Btn.Text = name
                Btn.TextColor3 = Library.Theme.Text
                Btn.Font = Enum.Font.Code
                Btn.TextSize = 12
                Btn.Parent = ItemContainer
                Instance.new("UIStroke", Btn).Color = Library.Theme.Border

                Btn.MouseEnter:Connect(function() Btn.TextColor3 = Library.Theme.Accent end)
                Btn.MouseLeave:Connect(function() Btn.TextColor3 = Library.Theme.Text end)
                Btn.Activated:Connect(function() 
                    pcall(callback)
                end)
            end

            function GBData:CreateTextBox(options)
                local name = options.Name or "TextBox"
                local placeholder = options.Placeholder or "Type here..."
                local flag = options.Flag
                local callback = options.Callback or function() end

                local BoxContainer = Instance.new("Frame")
                BoxContainer.Size = UDim2.new(1, 0, 0, 32)
                BoxContainer.BackgroundTransparency = 1
                BoxContainer.Parent = ItemContainer

                local Lbl = Instance.new("TextLabel")
                Lbl.Size = UDim2.new(1, 0, 0, 14)
                Lbl.BackgroundTransparency = 1
                Lbl.Text = name
                Lbl.TextColor3 = Library.Theme.Text
                Lbl.Font = Enum.Font.Code
                Lbl.TextSize = 12
                Lbl.TextXAlignment = Enum.TextXAlignment.Left
                Lbl.Parent = BoxContainer

                local InputBox = Instance.new("TextBox")
                InputBox.Size = UDim2.new(1, 0, 0, 16)
                InputBox.Position = UDim2.new(0, 0, 0, 16)
                InputBox.BackgroundColor3 = Library.Theme.ItemBG
                InputBox.BorderSizePixel = 0
                InputBox.Text = ""
                InputBox.PlaceholderText = placeholder
                InputBox.TextColor3 = Library.Theme.Text
                InputBox.Font = Enum.Font.Code
                InputBox.TextSize = 11
                InputBox.TextXAlignment = Enum.TextXAlignment.Left
                InputBox.Parent = BoxContainer
                Instance.new("UIStroke", InputBox).Color = Library.Theme.Border
                Instance.new("UIPadding", InputBox).PaddingLeft = UDim.new(0, 4)

                if flag then
                    Library.Flags[flag] = {
                        Value = "",
                        Set = function(self, val)
                            InputBox.Text = tostring(val)
                            self.Value = val
                            pcall(callback, val)
                        end
                    }
                end

                InputBox.FocusLost:Connect(function()
                    if flag then Library.Flags[flag].Value = InputBox.Text end
                    pcall(callback, InputBox.Text)
                end)
            end

            function GBData:CreateToggle(options)
                local name = options.Name or "Toggle"
                local state = options.Default or false
                local bind = options.Keybind 
                local flag = options.Flag
                local callback = options.Callback or function() end

                local TContainer = Instance.new("Frame")
                TContainer.Size = UDim2.new(1, 0, 0, 14)
                TContainer.BackgroundTransparency = 1
                TContainer.Parent = ItemContainer

                local MainBtn = Instance.new("TextButton")
                MainBtn.Size = (bind and not isMobile) and UDim2.new(1, -40, 1, 0) or UDim2.new(1, 0, 1, 0)
                MainBtn.BackgroundTransparency = 1
                MainBtn.Text = ""
                MainBtn.Parent = TContainer

                local CheckBox = Instance.new("Frame")
                CheckBox.Size = UDim2.new(0, 12, 0, 12)
                CheckBox.Position = UDim2.new(0, 0, 0, 1)
                CheckBox.BackgroundColor3 = state and Library.Theme.Accent or Library.Theme.ItemBG
                CheckBox.BorderSizePixel = 0
                CheckBox.Parent = MainBtn
                Instance.new("UIStroke", CheckBox).Color = Library.Theme.Border

                local Lbl = Instance.new("TextLabel")
                Lbl.Size = UDim2.new(1, -20, 1, 0)
                Lbl.Position = UDim2.new(0, 20, 0, 0)
                Lbl.BackgroundTransparency = 1
                Lbl.Text = name
                Lbl.TextColor3 = Library.Theme.Text
                Lbl.Font = Enum.Font.Code
                Lbl.TextSize = 12
                Lbl.TextXAlignment = Enum.TextXAlignment.Left
                Lbl.Parent = MainBtn

                if flag then
                    Library.Flags[flag] = {
                        Value = state,
                        Set = function(self, val)
                            state = val
                            self.Value = val
                            CheckBox.BackgroundColor3 = val and Library.Theme.Accent or Library.Theme.ItemBG
                            if bind then UpdateKeybindList(name, bind, val) end
                            pcall(callback, val)
                        end
                    }
                end

                local function Fire()
                    state = not state
                    if flag then Library.Flags[flag].Value = state end
                    CheckBox.BackgroundColor3 = state and Library.Theme.Accent or Library.Theme.ItemBG
                    if bind then UpdateKeybindList(name, bind, state) end
                    pcall(callback, state)
                end

                if bind then UpdateKeybindList(name, bind, state) end
                if state then pcall(callback, state) end

                MainBtn.Activated:Connect(Fire)

                if bind and not isMobile then
                    local BindBtn = Instance.new("TextButton")
                    BindBtn.Size = UDim2.new(0, 40, 1, 0)
                    BindBtn.Position = UDim2.new(1, -40, 0, 0)
                    BindBtn.BackgroundTransparency = 1
                    BindBtn.Text = "["..bind.."]"
                    BindBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
                    BindBtn.Font = Enum.Font.Code
                    BindBtn.TextSize = 11
                    BindBtn.TextXAlignment = Enum.TextXAlignment.Right
                    BindBtn.Parent = TContainer

                    local isListening = false
                    BindBtn.MouseButton1Click:Connect(function()
                        BindBtn.Text = "[...]"
                        isListening = true
                    end)

                    UIS.InputBegan:Connect(function(input, gameProcessed)
                        if isListening and input.UserInputType == Enum.UserInputType.Keyboard then
                            if input.KeyCode == Enum.KeyCode.Backspace or input.KeyCode == Enum.KeyCode.Escape then
                                bind = nil
                                BindBtn.Text = "[None]"
                            else
                                bind = input.KeyCode.Name
                                BindBtn.Text = "[" .. bind .. "]"
                            end
                            UpdateKeybindList(name, bind, state)
                            isListening = false
                        elseif not gameProcessed and not isListening and bind and input.KeyCode.Name == bind then
                            Fire()
                        end
                    end)
                end
            end

            function GBData:CreateSlider(options)
                local name = options.Name or "Slider"
                local min = options.Min or 0
                local max = options.Max or 100
                local increment = options.Increment or 1
                local current = options.Default or min
                local flag = options.Flag
                local callback = options.Callback or function() end

                local SContainer = Instance.new("Frame")
                SContainer.Size = UDim2.new(1, 0, 0, 28)
                SContainer.BackgroundTransparency = 1
                SContainer.Parent = ItemContainer

                local Lbl = Instance.new("TextLabel")
                Lbl.Size = UDim2.new(1, 0, 0, 14)
                Lbl.BackgroundTransparency = 1
                Lbl.Text = name
                Lbl.TextColor3 = Library.Theme.Text
                Lbl.Font = Enum.Font.Code
                Lbl.TextSize = 12
                Lbl.TextXAlignment = Enum.TextXAlignment.Left
                Lbl.Parent = SContainer

                local BG = Instance.new("TextButton")
                BG.Size = UDim2.new(1, 0, 0, 10)
                BG.Position = UDim2.new(0, 0, 0, 16)
                BG.BackgroundColor3 = Library.Theme.ItemBG
                BG.BorderSizePixel = 0
                BG.Text = ""
                BG.AutoButtonColor = false
                BG.Parent = SContainer
                Instance.new("UIStroke", BG).Color = Library.Theme.Border

                local Fill = Instance.new("Frame")
                Fill.Size = UDim2.new(math.clamp((current - min) / (max - min), 0, 1), 0, 1, 0)
                Fill.BackgroundColor3 = Library.Theme.Accent
                Fill.BorderSizePixel = 0
                Fill.Parent = BG

                local ValLabel = Instance.new("TextLabel")
                ValLabel.Size = UDim2.new(1, 0, 1, 0)
                ValLabel.BackgroundTransparency = 1
                ValLabel.Text = tostring(current) .. "/" .. tostring(max)
                ValLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                ValLabel.Font = Enum.Font.Code
                ValLabel.TextSize = 10
                ValLabel.Parent = BG

                if flag then
                    Library.Flags[flag] = {
                        Value = current,
                        Set = function(self, val)
                            val = math.clamp(val, min, max)
                            self.Value = val
                            Fill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
                            local formatString = (increment % 1 == 0) and "%d/%d" or "%.1f/%.1f"
                            ValLabel.Text = string.format(formatString, val, max)
                            pcall(callback, val)
                        end
                    }
                end

                if current ~= min then pcall(callback, current) end

                local isDragging = false
                
                BG.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        isDragging = true
                    end
                end)
                
                UIS.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        isDragging = false
                    end
                end)
                
                UIS.InputChanged:Connect(function(input)
                    if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        local positionX = (input.UserInputType == Enum.UserInputType.Touch) and input.Position.X or UIS:GetMouseLocation().X
                        local sliderPos = BG.AbsolutePosition.X
                        local sliderSize = BG.AbsoluteSize.X
                        local percent = math.clamp((positionX - sliderPos) / sliderSize, 0, 1)
                        
                        local val = min + ((max - min) * percent)
                        val = math.floor((val / increment) + 0.5) * increment
                        val = math.clamp(val, min, max)

                        Fill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
                        local formatString = (increment % 1 == 0) and "%d/%d" or "%.1f/%.1f"
                        ValLabel.Text = string.format(formatString, val, max)
                        
                        if flag then Library.Flags[flag].Value = val end
                        pcall(callback, val)
                    end
                end)
            end

            function GBData:CreateDropdown(options)
                local DropData = {}
                local name = options.Name or "Dropdown"
                local list = options.Options or {}
                local flag = options.Flag
                local callback = options.Callback or function() end

                local DropContainer = Instance.new("Frame")
                DropContainer.Size = UDim2.new(1, 0, 0, 35)
                DropContainer.BackgroundTransparency = 1
                DropContainer.ZIndex = 5
                DropContainer.Parent = ItemContainer

                local Lbl = Instance.new("TextLabel")
                Lbl.Size = UDim2.new(1, 0, 0, 14)
                Lbl.BackgroundTransparency = 1
                Lbl.Text = name
                Lbl.TextColor3 = Library.Theme.Text
                Lbl.Font = Enum.Font.Code
                Lbl.TextSize = 12
                Lbl.TextXAlignment = Enum.TextXAlignment.Left
                Lbl.ZIndex = 5
                Lbl.Parent = DropContainer

                local MainBtn = Instance.new("TextButton")
                MainBtn.Size = UDim2.new(1, 0, 0, 18)
                MainBtn.Position = UDim2.new(0, 0, 0, 16)
                MainBtn.BackgroundColor3 = Library.Theme.ItemBG
                MainBtn.BorderSizePixel = 0
                MainBtn.Text = " " .. (list[1] or "...")
                MainBtn.TextColor3 = Library.Theme.Text
                MainBtn.Font = Enum.Font.Code
                MainBtn.TextSize = 12
                MainBtn.TextXAlignment = Enum.TextXAlignment.Left
                MainBtn.ZIndex = 5
                MainBtn.Parent = DropContainer
                Instance.new("UIStroke", MainBtn).Color = Library.Theme.Border

                local Arrow = Instance.new("TextLabel")
                Arrow.Size = UDim2.new(0, 18, 1, 0)
                Arrow.Position = UDim2.new(1, -18, 0, 0)
                Arrow.BackgroundTransparency = 1
                Arrow.Text = "▼"
                Arrow.TextColor3 = Library.Theme.Text
                Arrow.TextSize = 8
                Arrow.ZIndex = 5
                Arrow.Parent = MainBtn

                local DropFrame = Instance.new("ScrollingFrame")
                DropFrame.Size = UDim2.new(1, 0, 0, 0)
                DropFrame.Position = UDim2.new(0, 0, 1, 2)
                DropFrame.BackgroundColor3 = Library.Theme.ItemBG
                DropFrame.BorderSizePixel = 0
                DropFrame.Visible = false
                DropFrame.ZIndex = 100 
                DropFrame.ScrollBarThickness = 2
                DropFrame.Parent = MainBtn
                Instance.new("UIStroke", DropFrame).Color = Library.Theme.Border
                
                local DropLayout = Instance.new("UIListLayout")
                DropLayout.Parent = DropFrame

                if flag then
                    Library.Flags[flag] = {
                        Value = list[1] or "",
                        Set = function(self, val)
                            MainBtn.Text = " " .. tostring(val)
                            self.Value = val
                            pcall(callback, val)
                        end
                    }
                end

                function DropData:Refresh(newList)
                    for _, child in pairs(DropFrame:GetChildren()) do
                        if child:IsA("TextButton") then child:Destroy() end
                    end
                    
                    local count = #newList
                    DropFrame.Size = UDim2.new(1, 0, 0, math.clamp(count * 18, 0, 108)) 
                    DropFrame.CanvasSize = UDim2.new(0, 0, 0, count * 18)
                    
                    if not flag or Library.Flags[flag].Value == "" then
                        MainBtn.Text = " " .. (newList[1] or "...")
                    end

                    for _, optionText in pairs(newList) do
                        local OptBtn = Instance.new("TextButton")
                        OptBtn.Size = UDim2.new(1, 0, 0, 18)
                        OptBtn.BackgroundColor3 = Library.Theme.ItemBG
                        OptBtn.BorderSizePixel = 0
                        OptBtn.Text = " " .. optionText
                        OptBtn.TextColor3 = Library.Theme.Text
                        OptBtn.Font = Enum.Font.Code
                        OptBtn.TextSize = 12
                        OptBtn.TextXAlignment = Enum.TextXAlignment.Left
                        OptBtn.ZIndex = 101
                        OptBtn.Parent = DropFrame
                        
                        OptBtn.MouseEnter:Connect(function() OptBtn.TextColor3 = Library.Theme.Accent end)
                        OptBtn.MouseLeave:Connect(function() OptBtn.TextColor3 = Library.Theme.Text end)
                        
                        OptBtn.Activated:Connect(function()
                            MainBtn.Text = " " .. optionText
                            DropFrame.Visible = false
                            DropContainer.ZIndex = 5
                            Arrow.Text = "▼"
                            ActiveDropdown = nil
                            
                            if flag then Library.Flags[flag].Value = optionText end
                            pcall(callback, optionText)
                        end)
                    end
                end

                function DropData:Set(newValue)
                    if flag then Library.Flags[flag].Value = newValue end
                    MainBtn.Text = " " .. tostring(newValue)
                    pcall(callback, newValue)
                end

                DropData:Refresh(list)

                MainBtn.Activated:Connect(function()
                    local opening = not DropFrame.Visible
                    if ActiveDropdown and ActiveDropdown ~= DropFrame then
                        ActiveDropdown.Visible = false
                        ActiveDropdown.Parent.Parent.ZIndex = 5
                    end
                    DropFrame.Visible = opening
                    DropContainer.ZIndex = opening and 50 or 5
                    Arrow.Text = opening and "▲" or "▼"
                    ActiveDropdown = opening and DropFrame or nil
                end)
                
                return DropData
            end

            function GBData:CreateColorPicker(options)
                local name = options.Name or "Color Picker"
                local defaultColor = options.Default or Color3.fromRGB(255, 255, 255)
                local flag = options.Flag
                local callback = options.Callback or function() end

                local CPContainer = Instance.new("Frame")
                CPContainer.Size = UDim2.new(1, 0, 0, 14)
                CPContainer.BackgroundTransparency = 1
                CPContainer.Parent = ItemContainer

                local Lbl = Instance.new("TextLabel")
                Lbl.Size = UDim2.new(1, -30, 1, 0)
                Lbl.BackgroundTransparency = 1
                Lbl.Text = name
                Lbl.TextColor3 = Library.Theme.Text
                Lbl.Font = Enum.Font.Code
                Lbl.TextSize = 12
                Lbl.TextXAlignment = Enum.TextXAlignment.Left
                Lbl.Parent = CPContainer

                local ColorDisplay = Instance.new("TextButton")
                ColorDisplay.Size = UDim2.new(0, 24, 0, 12)
                ColorDisplay.Position = UDim2.new(1, -24, 0, 1)
                ColorDisplay.BackgroundColor3 = defaultColor
                ColorDisplay.BorderSizePixel = 0
                ColorDisplay.Text = ""
                ColorDisplay.Parent = CPContainer
                Instance.new("UIStroke", ColorDisplay).Color = Library.Theme.Border

                local Popup = Instance.new("Frame")
                Popup.Size = UDim2.new(1, 0, 0, 205)
                Popup.Position = UDim2.new(0, 0, 1, 5)
                Popup.BackgroundColor3 = Library.Theme.ItemBG
                Popup.BorderSizePixel = 0
                Popup.Visible = false
                Popup.ZIndex = 80
                Popup.Parent = CPContainer
                Instance.new("UIStroke", Popup).Color = Library.Theme.Border

                local PopLayout = Instance.new("UIListLayout")
                PopLayout.SortOrder = Enum.SortOrder.LayoutOrder
                PopLayout.Padding = UDim.new(0, 5)
                PopLayout.Parent = Popup
                
                Instance.new("UIPadding", Popup).PaddingTop = UDim.new(0, 5)
                Instance.new("UIPadding", Popup).PaddingBottom = UDim.new(0, 5)
                Instance.new("UIPadding", Popup).PaddingLeft = UDim.new(0, 5)
                Instance.new("UIPadding", Popup).PaddingRight = UDim.new(0, 5)

                local isOpen = false
                ColorDisplay.Activated:Connect(function()
                    isOpen = not isOpen
                    Popup.Visible = isOpen
                    CPContainer.ZIndex = isOpen and 75 or 1
                    UpdateCanvas()
                end)

                local currentHSV = {Color3.toHSV(defaultColor)}

                local SatValGrid = Instance.new("ImageButton")
                SatValGrid.Size = UDim2.new(1, 0, 1, -45)
                SatValGrid.BackgroundColor3 = Color3.fromHSV(currentHSV[1], 1, 1)
                SatValGrid.Image = "rbxassetid://4155801252"
                SatValGrid.AutoButtonColor = false
                SatValGrid.ZIndex = 81
                SatValGrid.Parent = Popup
                
                local SVIndicator = Instance.new("Frame")
                SVIndicator.Size = UDim2.new(0, 6, 0, 6)
                SVIndicator.AnchorPoint = Vector2.new(0.5, 0.5)
                SVIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                SVIndicator.ZIndex = 82
                SVIndicator.Parent = SatValGrid
                Instance.new("UICorner", SVIndicator).CornerRadius = UDim.new(1, 0)
                Instance.new("UIStroke", SVIndicator).Color = Color3.fromRGB(0, 0, 0)
                
                local HueBar = Instance.new("TextButton")
                HueBar.Size = UDim2.new(1, 0, 0, 15)
                HueBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                HueBar.Text = ""
                HueBar.AutoButtonColor = false
                HueBar.ZIndex = 81
                HueBar.Parent = Popup
                
                local Gradient = Instance.new("UIGradient")
                Gradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
                    ColorSequenceKeypoint.new(0.16, Color3.fromRGB(255, 255, 0)),
                    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                    ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)),
                    ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0, 0, 255)),
                    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0))
                }
                Gradient.Parent = HueBar

                local HueIndicator = Instance.new("Frame")
                HueIndicator.Size = UDim2.new(0, 4, 1, 2)
                HueIndicator.AnchorPoint = Vector2.new(0.5, 0.5)
                HueIndicator.Position = UDim2.new(0, 0, 0.5, 0)
                HueIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                HueIndicator.ZIndex = 82
                HueIndicator.Parent = HueBar
                Instance.new("UIStroke", HueIndicator).Color = Color3.fromRGB(0, 0, 0)

                local RainbowBtn = Instance.new("TextButton")
                RainbowBtn.Size = UDim2.new(1, 0, 0, 15)
                RainbowBtn.BackgroundColor3 = Library.Theme.DarkBG
                RainbowBtn.BorderSizePixel = 0
                RainbowBtn.Text = "Rainbow: OFF"
                RainbowBtn.TextColor3 = Library.Theme.Text
                RainbowBtn.Font = Enum.Font.Code
                RainbowBtn.TextSize = 11
                RainbowBtn.ZIndex = 81
                RainbowBtn.Parent = Popup
                Instance.new("UIStroke", RainbowBtn).Color = Library.Theme.Border

                local function SetColor()
                    local col = Color3.fromHSV(currentHSV[1], currentHSV[2], currentHSV[3])
                    ColorDisplay.BackgroundColor3 = col
                    SatValGrid.BackgroundColor3 = Color3.fromHSV(currentHSV[1], 1, 1)
                    
                    SVIndicator.Position = UDim2.new(currentHSV[2], 0, 1 - currentHSV[3], 0)
                    HueIndicator.Position = UDim2.new(currentHSV[1], 0, 0.5, 0)
                    
                    if flag then Library.Flags[flag].Value = col end
                    pcall(callback, col)
                end

                if flag then
                    Library.Flags[flag] = {
                        Value = defaultColor,
                        Set = function(self, val)
                            local h, s, v = Color3.toHSV(val)
                            currentHSV = {h, s, v}
                            SetColor()
                        end
                    }
                end

                SetColor()

                local isSatValDragging = false
                local isHueDragging = false
                local rainbowConnection = nil

                RainbowBtn.Activated:Connect(function()
                    if rainbowConnection then
                        rainbowConnection:Disconnect()
                        rainbowConnection = nil
                        RainbowBtn.Text = "Rainbow: OFF"
                        RainbowBtn.TextColor3 = Library.Theme.Text
                    else
                        RainbowBtn.Text = "Rainbow: ON"
                        RainbowBtn.TextColor3 = Library.Theme.Accent
                        rainbowConnection = RunService.RenderStepped:Connect(function()
                            currentHSV[1] = (tick() * 0.2) % 1 
                            SetColor()
                        end)
                    end
                end)

                local function UpdateSatVal(input)
                    if rainbowConnection then return end 
                    local sizeX, sizeY = SatValGrid.AbsoluteSize.X, SatValGrid.AbsoluteSize.Y
                    local posX = math.clamp(input.Position.X - SatValGrid.AbsolutePosition.X, 0, sizeX)
                    local posY = math.clamp(input.Position.Y - SatValGrid.AbsolutePosition.Y, 0, sizeY)
                    currentHSV[2] = posX / sizeX
                    currentHSV[3] = 1 - (posY / sizeY)
                    SetColor()
                end

                SatValGrid.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        isSatValDragging = true; UpdateSatVal(input)
                    end
                end)
                
                local function UpdateHue(input)
                    if rainbowConnection then return end
                    local sizeX = HueBar.AbsoluteSize.X
                    local posX = math.clamp(input.Position.X - HueBar.AbsolutePosition.X, 0, sizeX)
                    currentHSV[1] = posX / sizeX
                    SetColor()
                end

                HueBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        isHueDragging = true; UpdateHue(input)
                    end
                end)

                UIS.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        isSatValDragging = false; isHueDragging = false
                    end
                end)

                UIS.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                        if isSatValDragging then UpdateSatVal(input)
                        elseif isHueDragging then UpdateHue(input) end
                    end
                end)
            end

            function GBData:CreateKeybind(options)
                local name = options.Name or "Keybind"
                local bind = options.Default
                local callback = options.Callback or function() end

                local BContainer = Instance.new("Frame")
                BContainer.Size = UDim2.new(1, 0, 0, 14)
                BContainer.BackgroundTransparency = 1
                BContainer.Parent = ItemContainer

                local Lbl = Instance.new("TextLabel")
                Lbl.Size = UDim2.new(1, -40, 1, 0)
                Lbl.BackgroundTransparency = 1
                Lbl.Text = name
                Lbl.TextColor3 = Library.Theme.Text
                Lbl.Font = Enum.Font.Code
                Lbl.TextSize = 12
                Lbl.TextXAlignment = Enum.TextXAlignment.Left
                Lbl.Parent = BContainer

                local BindBtn = Instance.new("TextButton")
                BindBtn.Size = UDim2.new(0, 40, 1, 0)
                BindBtn.Position = UDim2.new(1, -40, 0, 0)
                BindBtn.BackgroundTransparency = 1
                BindBtn.Text = bind and "["..bind.."]" or "[None]"
                BindBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
                BindBtn.Font = Enum.Font.Code
                BindBtn.TextSize = 11
                BindBtn.TextXAlignment = Enum.TextXAlignment.Right
                BindBtn.Parent = BContainer

                local isListening = false
                BindBtn.Activated:Connect(function()
                    BindBtn.Text = "[...]"
                    isListening = true
                end)

                UIS.InputBegan:Connect(function(input, gameProcessed)
                    if isListening and input.UserInputType == Enum.UserInputType.Keyboard then
                        if input.KeyCode == Enum.KeyCode.Backspace or input.KeyCode == Enum.KeyCode.Escape then
                            bind = nil
                            BindBtn.Text = "[None]"
                        else
                            bind = input.KeyCode.Name
                            BindBtn.Text = "[" .. bind .. "]"
                            pcall(callback, bind)
                        end
                        isListening = false
                    elseif not gameProcessed and not isListening and bind and input.KeyCode.Name == bind then
                        pcall(callback, bind)
                    end
                end)
            end

            return GBData
        end
        return TabData
    end
    return WindowData
end

return Library
