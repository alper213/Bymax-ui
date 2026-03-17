-- ==============================================================================
-- BYMAX SAVE MANAGER (LINORIA STYLE MODULAR CONFIG)
-- ==============================================================================
local HttpService = game:GetService("HttpService")

local SaveManager = {
    Folder = "BymaxConfigs",
    Library = nil
}

-- Kütüphaneyi tanımlamak için
function SaveManager:SetLibrary(lib)
    self.Library = lib
end

-- Klasör ismini değiştirmek için
function SaveManager:SetFolder(folderName)
    self.Folder = folderName
    -- Sessizce klasör açmayı dener, hata verirse umursamaz (Çökme engellendi)
    pcall(function() makefolder(self.Folder) end)
end

-- Klasör kontrolü (Her işlemden önce)
function SaveManager:CheckFolder()
    pcall(function() makefolder(self.Folder) end)
end

function SaveManager:GetConfigs()
    local list = {}
    self:CheckFolder()
    pcall(function()
        for _, file in ipairs(listfiles(self.Folder)) do
            local fileName = file:match("([^/\\]+)%.json$")
            if fileName then table.insert(list, fileName) end
        end
    end)
    return list
end

function SaveManager:Save(configName)
    if not self.Library then return end
    if not configName or configName == "" then return end
    
    self:CheckFolder()
    
    local data = {}
    for flag, element in pairs(self.Library.Flags) do
        local val = element.Value
        if typeof(val) == "Color3" then
            val = {R = val.R, G = val.G, B = val.B, IsColor3 = true}
        end
        data[flag] = val
    end
    
    local success, err = pcall(function()
        local encoded = HttpService:JSONEncode(data)
        writefile(self.Folder .. "/" .. configName .. ".json", encoded)
    end)
    
    if success then
        self.Library:Notify("Config", "Saved: " .. configName, 3)
    else
        self.Library:Notify("Error", "Save failed! Executor bug.", 4)
    end
end

function SaveManager:Load(configName)
    if not self.Library then return end
    if not configName or configName == "" then return end
    
    local path = self.Folder .. "/" .. configName .. ".json"
    local success, err = pcall(function()
        local content = readfile(path)
        local decoded = HttpService:JSONDecode(content)
        
        for flag, savedValue in pairs(decoded) do
            if self.Library.Flags[flag] and self.Library.Flags[flag].Set then
                if type(savedValue) == "table" and savedValue.IsColor3 then
                    savedValue = Color3.new(savedValue.R, savedValue.G, savedValue.B)
                end
                self.Library.Flags[flag]:Set(savedValue)
            end
        end
    end)
    
    if success then
        self.Library:Notify("Config", "Loaded: " .. configName, 3)
    else
        self.Library:Notify("Error", "Load failed! File not found.", 4)
    end
end

function SaveManager:Delete(configName)
    if not configName or configName == "" then return end
    local path = self.Folder .. "/" .. configName .. ".json"
    
    local success = pcall(function() delfile(path) end)
    if success then
        self.Library:Notify("Config", "Deleted: " .. configName, 3)
    else
        self.Library:Notify("Error", "Delete failed!", 3)
    end
end

-- ========================================================
-- CONFIG SEKMESİNİ ÇİZEN FONKSİYON
-- ========================================================
function SaveManager:BuildConfigSection(targetTab)
    if not self.Library then return end
    
    local ConfigGroup = targetTab:CreateGroupbox("Configuration", "Right")
    local configNameBox = ""
    local selectedConfig = ""

    ConfigGroup:CreateTextBox({
        Name = "Config Name",
        Placeholder = "Type here...",
        Callback = function(val) configNameBox = val end
    })

    local configDropdown = ConfigGroup:CreateDropdown({
        Name = "Select Config",
        Options = self:GetConfigs(),
        Callback = function(val) selectedConfig = val end
    })

    ConfigGroup:CreateButton({
        Name = "Save Config",
        Callback = function()
            local nameToSave = (configNameBox ~= "") and configNameBox or selectedConfig
            if nameToSave ~= "" then
                self:Save(nameToSave)
                configDropdown:Refresh(self:GetConfigs())
            end
        end
    })

    ConfigGroup:CreateButton({
        Name = "Load Config",
        Callback = function()
            if selectedConfig ~= "" then self:Load(selectedConfig) end
        end
    })

    ConfigGroup:CreateButton({
        Name = "Delete Config",
        Callback = function()
            if selectedConfig ~= "" then
                self:Delete(selectedConfig)
                configDropdown:Refresh(self:GetConfigs())
                configDropdown:Set("...")
                selectedConfig = ""
            end
        end
    })

    ConfigGroup:CreateButton({
        Name = "Refresh List",
        Callback = function()
            configDropdown:Refresh(self:GetConfigs())
            self.Library:Notify("Config", "List Refreshed!", 2)
        end
    })
end

return SaveManager
