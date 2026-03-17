-- ==============================================================================
-- BYMAX UI - SAVE MANAGER (MODULAR CONFIG SYSTEM)
-- ==============================================================================
local HttpService = game:GetService("HttpService")

local SaveManager = {
    Folder = "Bymax_Configs",
    Library = nil
}

function SaveManager:SetLibrary(lib)
    self.Library = lib
end

function SaveManager:SetFolder(folderName)
    self.Folder = folderName
    pcall(function()
        if not isfolder(self.Folder) then
            makefolder(self.Folder)
        end
    end)
end

function SaveManager:GetConfigs()
    local list = {}
    pcall(function()
        if not isfolder(self.Folder) then makefolder(self.Folder) end
        for _, file in ipairs(listfiles(self.Folder)) do
            local fileName = file:match("([^/\\]+)%.json$")
            if fileName then table.insert(list, fileName) end
        end
    end)
    return list
end

function SaveManager:Save(name)
    if not self.Library then return end
    pcall(function()
        if not isfolder(self.Folder) then makefolder(self.Folder) end
    end)
    
    local data = {}
    for flag, element in pairs(self.Library.Flags) do
        local val = element.Value
        if typeof(val) == "Color3" then
            val = {R = val.R, G = val.G, B = val.B, IsColor3 = true}
        end
        data[flag] = val
    end
    
    local s, err = pcall(function()
        local encoded = HttpService:JSONEncode(data)
        writefile(self.Folder .. "/" .. name .. ".json", encoded)
    end)
    
    if s then
        self.Library:Notify("Config System", "Successfully saved:\n" .. name, 4)
    else
        self.Library:Notify("Error", "Failed to save config!", 4)
        warn("[Bymax SaveManager] Save Error:", err)
    end
end

function SaveManager:Load(name)
    if not self.Library then return end
    local path = self.Folder .. "/" .. name .. ".json"
    
    local s, err = pcall(function()
        local decoded = HttpService:JSONDecode(readfile(path))
        for flag, savedValue in pairs(decoded) do
            if self.Library.Flags[flag] and self.Library.Flags[flag].Set then
                if type(savedValue) == "table" and savedValue.IsColor3 then
                    savedValue = Color3.new(savedValue.R, savedValue.G, savedValue.B)
                end
                self.Library.Flags[flag]:Set(savedValue)
            end
        end
    end)
    
    if s then
        self.Library:Notify("Config System", "Successfully loaded:\n" .. name, 4)
    else
        self.Library:Notify("Error", "Failed to load config!", 4)
        warn("[Bymax SaveManager] Load Error:", err)
    end
end

function SaveManager:Delete(name)
    local path = self.Folder .. "/" .. name .. ".json"
    local s, err = pcall(function() delfile(path) end)
    if s then
        self.Library:Notify("Config System", "Deleted config:\n" .. name, 4)
    else
        self.Library:Notify("Error", "Failed to delete config!", 4)
    end
end

function SaveManager:BuildConfigSection(targetTab)
    if not self.Library then warn("[Bymax SaveManager] Library not set!") return end
    
    local Group = targetTab:CreateGroupbox("Configuration", "Right")
    local boxName = ""
    local selected = ""
    
    Group:CreateTextBox({
        Name = "Config Name",
        Placeholder = "Type name here...",
        Callback = function(val) boxName = val end
    })
    
    local drop = Group:CreateDropdown({
        Name = "Select Config",
        Options = self:GetConfigs(),
        Callback = function(val) selected = val end
    })
    
    Group:CreateButton({
        Name = "Save Config",
        Callback = function()
            local t = (boxName ~= "") and boxName or selected
            if t ~= "" then
                self:Save(t)
                drop:Refresh(self:GetConfigs())
            end
        end
    })
    
    Group:CreateButton({
        Name = "Load Config",
        Callback = function()
            if selected ~= "" then self:Load(selected) end
        end
    })
    
    Group:CreateButton({
        Name = "Delete Config",
        Callback = function()
            if selected ~= "" then
                self:Delete(selected)
                drop:Refresh(self:GetConfigs())
                drop:Set("...")
                selected = ""
            end
        end
    })
    
    Group:CreateButton({
        Name = "Refresh List",
        Callback = function()
            drop:Refresh(self:GetConfigs())
            self.Library:Notify("Config System", "List Refreshed!", 2)
        end
    })
end

return SaveManager
