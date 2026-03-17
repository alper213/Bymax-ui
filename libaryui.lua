-- ==============================================================================
-- BYMAX UI LIBRARY - V25 (LAYOUT PADDING & GROUPBOX ALIGNMENT FIX)
-- ==============================================================================
local Library = {
    Flags = {}, 
    Theme = {
        MainBG = Color3.fromRGB(25, 25, 25),
        Border = Color3.fromRGB(45, 45, 45),
        Accent = Color3.fromRGB(40, 100, 255),
        Text = Color3.fromRGB(210, 210, 210),
        DarkBG = Color3.fromRGB(20, 20, 20),
        ItemBG = Color3.fromRGB(30, 30, 30)
    },
    Watermark = nil,
    KeybindList = nil
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
-- NOTIFICATION SYSTEM 
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
    task.spawn(function() task.wait(duration) CloseNotification() end)
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

    if isMobile then
        local MobileToggleBtn = Instance.new("TextButton")
        MobileToggleBtn.Name = "MobileToggle"
        MobileToggleBtn.Size = UDim2.new(0, 50, 0, 50)
        MobileToggleBtn.Position = UDim2.new(1, -70, 0, 15)
        MobileToggleBtn.BackgroundColor3 = Library.Theme.DarkBG
        MobileToggleBtn.TextColor3 = Library.Theme.Accent
        MobileToggleBtn.Font = Enum.Font.Code
        MobileToggleBtn.TextSize = 13
        MobileToggleBtn.Text = "MENU"
        MobileToggleBtn.Active = true
        MobileToggleBtn.Draggable = true 
        MobileToggleBtn.Parent = ScreenGui
        Instance.new("UICorner", MobileToggleBtn).CornerRadius = UDim.new(0, 8)
        Instance.new("UIStroke", MobileToggleBtn).Color = Library.Theme.Border
        MobileToggleBtn.Activated:Connect(function() ScreenGui.Enabled = not ScreenGui.Enabled end)
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

        -- ========================================================
        -- PADDING FIX: Move Groupboxes down and away from edges
        -- ========================================================
        local LeftColumn = Instance.new("Frame")
        LeftColumn.Size = UDim2.new(0.48, 0, 1, 0)
        LeftColumn.Position = UDim2.new(0.01, 0, 0, 15) -- Pushed 15px from top
        LeftColumn.BackgroundTransparency = 1
        LeftColumn.Parent = Page
        
        local LeftLayout = Instance.new("UIListLayout")
        LeftLayout.SortOrder = Enum.SortOrder.LayoutOrder
        LeftLayout.Padding = UDim.new(0, 15)
        LeftLayout.Parent = LeftColumn

        local RightColumn = Instance.new("Frame")
        RightColumn.Size = UDim2.new(0.48, 0, 1, 0)
        RightColumn.Position = UDim2.new(0.51, 0, 0, 15) -- Pushed 15px from top
        RightColumn.BackgroundTransparency = 1
        RightColumn.Parent = Page
        
        local RightLayout = Instance.new("UIListLayout")
        RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
        RightLayout.Padding = UDim.new(0, 15)
        RightLayout.Parent = RightColumn

        local function UpdateCanvas()
            local maxY = math.max(LeftLayout.AbsoluteContentSize.Y, RightLayout.AbsoluteContentSize.Y)
            Page.CanvasSize = UDim2.new(0, 0, 0, maxY + 40)
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
            local GroupBox = Instance.new("Frame")
            GroupBox.Size = UDim2.new(1, 0, 0, 0)
            GroupBox.BackgroundColor3 = Library.Theme.DarkBG
            GroupBox.BorderSizePixel = 0
            GroupBox.AutomaticSize = Enum.AutomaticSize.Y
            GroupBox.Parent = (side == "Right") and RightColumn or LeftColumn
            Instance.new("UIStroke", GroupBox).Color = Library.Theme.Border

            -- Left Blue Line
            local GBLineL = Instance.new("Frame")
            GBLineL.Size = UDim2.new(0, 8, 0, 1)
            GBLineL.BackgroundColor3 = Library.Theme.Accent
            GBLineL.BorderSizePixel = 0
            GBLineL.Parent = GroupBox
            
            -- Title text
            local TitleCont = Instance.new("Frame")
            TitleCont.Position = UDim2.new(0, 12, 0, -7)
            TitleCont.Size = UDim2.new(0, 0, 0, 14) 
            TitleCont.AutomaticSize = Enum.AutomaticSize.X 
            TitleCont.BackgroundTransparency = 1
            TitleCont.Parent = GroupBox

            local cleanName = gbName
            if #cleanName > 30 then cleanName = cleanName:sub(1,27).."..." end

            local GBTitle = Instance.new("TextLabel")
            GBTitle.Size = UDim2.new(1, 0, 1, 0)
            GBTitle.BackgroundTransparency = 1
            GBTitle.Text = cleanName
            GBTitle.TextColor3 = Library.Theme.Text
            GBTitle.Font = Enum.Font.Code
            GBTitle.TextSize = 12
            GBTitle.Parent = TitleCont

            -- Right Blue Line
            local GBLineR = Instance.new("Frame")
            GBLineR.BackgroundColor3 = Library.Theme.Accent
            GBLineR.BorderSizePixel = 0
            GBLineR.Parent = GroupBox

            local function UpdateTitleLines()
                local textWidth = TitleCont.AbsoluteSize.X
                local startR = 12 + textWidth + 4
                GBLineR.Position = UDim2.new(0, startR, 0, 0)
                GBLineR.Size = UDim2.new(1, -startR, 0, 1)
            end
            TitleCont:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdateTitleLines)
            task.spawn(function() RunService.RenderStepped:Wait() UpdateTitleLines() end)

            local ItemContainer = Instance.new("Frame")
            ItemContainer.Size = UDim2.new(1, -16, 0, 0)
            ItemContainer.Position = UDim2.new(0, 8, 0, 14)
            ItemContainer.BackgroundTransparency = 1
            ItemContainer.AutomaticSize = Enum.AutomaticSize.Y
            ItemContainer.Parent = GroupBox
            Instance.new("UIListLayout", ItemContainer).SortOrder = Enum.SortOrder.LayoutOrder
            ItemContainer.UIListLayout.Padding = UDim.new(0, 6)
            Instance.new("UIPadding", ItemContainer).PaddingBottom = UDim.new(0, 8)

            function GBData:CreateToggle(options)
                local name = options.Name or "Toggle"
                local state = options.Default or false
                local flag = options.Flag
                local callback = options.Callback or function() end

                local TFrame = Instance.new("Frame")
                TFrame.Size = UDim2.new(1, 0, 0, 14)
                TFrame.BackgroundTransparency = 1
                TFrame.Parent = ItemContainer

                local Btn = Instance.new("TextButton")
                Btn.Size = UDim2.new(1, 0, 1, 0)
                Btn.BackgroundTransparency = 1
                Btn.Text = ""
                Btn.Parent = TFrame

                local Box = Instance.new("Frame")
                Box.Size = UDim2.new(0, 12, 0, 12)
                Box.Position = UDim2.new(0, 0, 0, 1)
                Box.BackgroundColor3 = state and Library.Theme.Accent or Library.Theme.ItemBG
                Box.Parent = Btn
                Instance.new("UIStroke", Box).Color = Library.Theme.Border

                local Lbl = Instance.new("TextLabel")
                Lbl.Size = UDim2.new(1, -20, 1, 0)
                Lbl.Position = UDim2.new(0, 20, 0, 0)
                Lbl.BackgroundTransparency = 1
                Lbl.Text = name
                Lbl.TextColor3 = Library.Theme.Text
                Lbl.Font = Enum.Font.Code
                Lbl.TextSize = 12
                Lbl.TextXAlignment = Enum.TextXAlignment.Left
                Lbl.Parent = Btn

                if flag then Library.Flags[flag] = state end

                Btn.Activated:Connect(function()
                    state = not state
                    if flag then Library.Flags[flag] = state end
                    Box.BackgroundColor3 = state and Library.Theme.Accent or Library.Theme.ItemBG
                    pcall(callback, state)
                end)
            end

            function GBData:CreateSlider(options)
                local name = options.Name or "Slider"
                local min, max, current = options.Min or 0, options.Max or 100, options.Default or 0
                local callback = options.Callback or function() end

                local SFrame = Instance.new("Frame")
                SFrame.Size = UDim2.new(1, 0, 0, 28)
                SFrame.BackgroundTransparency = 1
                SFrame.Parent = ItemContainer

                local Lbl = Instance.new("TextLabel")
                Lbl.Size = UDim2.new(1, 0, 0, 14)
                Lbl.BackgroundTransparency = 1
                Lbl.Text = name
                Lbl.TextColor3 = Library.Theme.Text
                Lbl.Font = Enum.Font.Code
                Lbl.TextSize = 12
                Lbl.TextXAlignment = Enum.TextXAlignment.Left
                Lbl.Parent = SFrame

                local Main = Instance.new("TextButton")
                Main.Size = UDim2.new(1, 0, 0, 10)
                Main.Position = UDim2.new(0, 0, 0, 16)
                Main.BackgroundColor3 = Library.Theme.ItemBG
                Main.Text = ""
                Main.Parent = SFrame
                Instance.new("UIStroke", Main).Color = Library.Theme.Border

                local Fill = Instance.new("Frame")
                Fill.Size = UDim2.new(math.clamp((current - min)/(max - min), 0, 1), 0, 1, 0)
                Fill.BackgroundColor3 = Library.Theme.Accent
                Fill.BorderSizePixel = 0
                Fill.Parent = Main

                local Val = Instance.new("TextLabel")
                Val.Size = UDim2.new(1, 0, 1, 0)
                Val.BackgroundTransparency = 1
                Val.Text = tostring(current)
                Val.TextColor3 = Color3.fromRGB(255, 255, 255)
                Val.Font = Enum.Font.Code
                Val.TextSize = 10
                Val.Parent = Main

                local function Update(input)
                    local pos = math.clamp((input.Position.X - Main.AbsolutePosition.X) / Main.AbsoluteSize.X, 0, 1)
                    local val = math.floor(min + ((max - min) * pos))
                    Fill.Size = UDim2.new(pos, 0, 1, 0)
                    Val.Text = tostring(val)
                    pcall(callback, val)
                end

                local dragging = false
                Main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true Update(i) end end)
                UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
                UIS.InputChanged:Connect(function(i) if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then Update(i) end end)
            end

            function GBData:CreateDropdown(options)
                local name = options.Name or "Dropdown"
                local list = options.Options or {}
                local callback = options.Callback or function() end

                local DFrame = Instance.new("Frame")
                DFrame.Size = UDim2.new(1, 0, 0, 35)
                DFrame.BackgroundTransparency = 1
                DFrame.Parent = ItemContainer

                local Lbl = Instance.new("TextLabel")
                Lbl.Size = UDim2.new(1, 0, 0, 14)
                Lbl.BackgroundTransparency = 1
                Lbl.Text = name
                Lbl.TextColor3 = Library.Theme.Text
                Lbl.Font = Enum.Font.Code
                Lbl.TextSize = 12
                Lbl.TextXAlignment = Enum.TextXAlignment.Left
                Lbl.Parent = DFrame

                local Btn = Instance.new("TextButton")
                Btn.Size = UDim2.new(1, 0, 0, 18)
                Btn.Position = UDim2.new(0, 0, 0, 16)
                Btn.BackgroundColor3 = Library.Theme.ItemBG
                Btn.Text = " " .. (list[1] or "...")
                Btn.TextColor3 = Library.Theme.Text
                Btn.Font = Enum.Font.Code
                Btn.TextSize = 12
                Btn.TextXAlignment = Enum.TextXAlignment.Left
                Btn.Parent = DFrame
                Instance.new("UIStroke", Btn).Color = Library.Theme.Border

                local List = Instance.new("ScrollingFrame")
                List.Size = UDim2.new(1, 0, 0, math.min(#list * 18, 90))
                List.Position = UDim2.new(0, 0, 1, 2)
                List.BackgroundColor3 = Library.Theme.ItemBG
                List.Visible = false
                List.ZIndex = 50
                List.CanvasSize = UDim2.new(0,0,0, #list * 18)
                List.Parent = Btn
                Instance.new("UIListLayout", List)

                Btn.Activated:Connect(function() List.Visible = not List.Visible end)

                for _, v in pairs(list) do
                    local Opt = Instance.new("TextButton")
                    Opt.Size = UDim2.new(1, 0, 0, 18)
                    Opt.BackgroundColor3 = Library.Theme.ItemBG
                    Opt.Text = " " .. v
                    Opt.TextColor3 = Library.Theme.Text
                    Opt.Font = Enum.Font.Code
                    Opt.TextSize = 12
                    Opt.TextXAlignment = Enum.TextXAlignment.Left
                    Opt.ZIndex = 51
                    Opt.Parent = List
                    Opt.Activated:Connect(function()
                        Btn.Text = " " .. v
                        List.Visible = false
                        pcall(callback, v)
                    end)
                end
            end

            function GBData:CreateColorPicker(options)
                local name = options.Name or "Color"
                local def = options.Default or Color3.fromRGB(255,255,255)
                local callback = options.Callback or function() end

                local CFrame = Instance.new("Frame")
                CFrame.Size = UDim2.new(1, 0, 0, 14)
                CFrame.BackgroundTransparency = 1
                CFrame.Parent = ItemContainer

                local Lbl = Instance.new("TextLabel")
                Lbl.Size = UDim2.new(1, -30, 1, 0)
                Lbl.BackgroundTransparency = 1
                Lbl.Text = name
                Lbl.TextColor3 = Library.Theme.Text
                Lbl.Font = Enum.Font.Code
                Lbl.TextSize = 12
                Lbl.TextXAlignment = Enum.TextXAlignment.Left
                Lbl.Parent = CFrame

                local Disp = Instance.new("TextButton")
                Disp.Size = UDim2.new(0, 24, 0, 12)
                Disp.Position = UDim2.new(1, -24, 0, 1)
                Disp.BackgroundColor3 = def
                Disp.Text = ""
                Disp.Parent = CFrame
                Instance.new("UIStroke", Disp).Color = Library.Theme.Border

                local rainbow = false
                Disp.Activated:Connect(function()
                    rainbow = not rainbow
                    Library:Notify("Color", name .. " Rainbow: " .. (rainbow and "ON" or "OFF"), 2)
                    if rainbow then
                        task.spawn(function()
                            while rainbow do
                                local c = Color3.fromHSV(tick()%5/5, 1, 1)
                                Disp.BackgroundColor3 = c
                                pcall(callback, c)
                                task.wait()
                            end
                        end)
                    end
                end)
            end

            function GBData:CreateButton(options)
                local name = options.Name or "Button"
                local callback = options.Callback or function() end
                local Btn = Instance.new("TextButton")
                Btn.Size = UDim2.new(1, 0, 0, 18)
                Btn.BackgroundColor3 = Library.Theme.ItemBG
                Btn.Text = name
                Btn.TextColor3 = Library.Theme.Text
                Btn.Font = Enum.Font.Code
                Btn.TextSize = 12
                Btn.Parent = ItemContainer
                Instance.new("UIStroke", Btn).Color = Library.Theme.Border
                Btn.Activated:Connect(function() pcall(callback) end)
            end

            function GBData:CreateKeybind(options)
                local name, bind = options.Name or "Keybind", options.Default or "None"
                local callback = options.Callback or function() end

                local KFrame = Instance.new("Frame")
                KFrame.Size = UDim2.new(1, 0, 0, 14)
                KFrame.BackgroundTransparency = 1
                KFrame.Parent = ItemContainer

                local Lbl = Instance.new("TextLabel")
                Lbl.Size = UDim2.new(1, -40, 1, 0)
                Lbl.BackgroundTransparency = 1
                Lbl.Text = name
                Lbl.TextColor3 = Library.Theme.Text
                Lbl.Font = Enum.Font.Code
                Lbl.TextSize = 12
                Lbl.TextXAlignment = Enum.TextXAlignment.Left
                Lbl.Parent = KFrame

                local Btn = Instance.new("TextButton")
                Btn.Size = UDim2.new(0, 40, 1, 0)
                Btn.Position = UDim2.new(1, -40, 0, 0)
                Btn.BackgroundTransparency = 1
                Btn.Text = "[" .. bind .. "]"
                Btn.TextColor3 = Library.Theme.Accent
                Btn.Font = Enum.Font.Code
                Btn.TextSize = 11
                Btn.TextXAlignment = Enum.TextXAlignment.Right
                Btn.Parent = KFrame

                Btn.Activated:Connect(function()
                    Btn.Text = "[...]"
                    local i = UIS.InputBegan:Wait()
                    if i.UserInputType == Enum.UserInputType.Keyboard then
                        local key = i.KeyCode.Name
                        Btn.Text = "[" .. key .. "]"
                        pcall(callback, key)
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
