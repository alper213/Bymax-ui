-- ==============================================================================
-- BYMAX SAVE MANAGER - V2 (ROOT FALLBACK SYSTEM)
-- ==============================================================================
local HttpService = game:GetService("HttpService")

local SaveManager = {
    Folder = "BymaxConfigs",
    Library = nil,
    UseRoot = false -- Automatically turns true if executor refuses to make folders
}

function SaveManager:SetLibrary(lib)
    self.Library = lib
end

function SaveManager:SetFolder(folderName)
    self.Folder = folderName
    self:Init()
end

-- ========================================================
-- FOLDER BYPASS LOGIC
-- ========================================================
function SaveManager:Init()
    if not isfolder or not makefolder then
        self.UseRoot = true
        return
    end
    
    local success, err = pcall(function()
        if not isfolder(self.Folder) then
            makefolder(self.Folder)
        end
    end)
    
    -- If executor blocks folder creation, force it to save in the root workspace folder
    if not success or not isfolder(self.Folder) then
        warn("[Bymax SaveManager] Executor blocked folder creation. Forcing root directory save.")
        self.UseRoot = true
    else
        self.UseRoot = false
    end
end

function SaveManager:GetPath(name)
    if self.UseRoot then
        -- Saves as: BymaxConfigs_MySettings.json
        return self.Folder .. "_" .. name .. ".json"
    else
        -- Saves as: BymaxConfigs/MySettings.json
        return self.Folder .. "/" .. name .. ".json"
    end
end

function SaveManager:GetAutoPath()
    if self.UseRoot then
        return self.Folder .. "_Autoload.txt"
    else
        return self.Folder .. "/Autoload.txt"
    end
end

-- ========================================================
-- CORE SAVE FUNCTIONS
-- ========================================================
function SaveManager:GetConfigs()
    self:Init()
    local list = {}
    
    local searchPath = self.UseRoot and "" or self.Folder
    local s, files = pcall(function() return listfiles(searchPath) end)
    
    if s and files then
        for _, file in ipairs(files) do
            if self.UseRoot then
                local pattern = self.Folder .. "_([^/\\]+)%.json$"
                local fileName = file:match(pattern)
                if fileName then table.insert(list, fileName) end
            else
                local fileName = file:match("([^/\\]+)%.json$")
                if fileName then table.insert(list, fileName) end
            end
        end
    end
    return list
end

function SaveManager:Save(name)
    if not self.Library or not name or name == "" then return end
    self:Init()
    
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
        writefile(self:GetPath(name), encoded)
    end)
    
    if s then
        self.Library:Notify("Config Saved", "Successfully saved:\n" .. name, 3)
    else
        self.Library:Notify("Error", "Save failed! Check F9 Console.", 4)
        warn("[Bymax SaveManager] Save Error:", err)
    end
end

function SaveManager:Load(name)
    if not self.Library or not name or name == "" then return end
    self:Init()
    
    local s, err = pcall(function()
        local content = readfile(self:GetPath(name))
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
    
    if s then
        self.Library:Notify("Config Loaded", "Successfully loaded:\n" .. name, 3)
    else
        self.Library:Notify("Error", "Load failed! Config broken.", 4)
        warn("[Bymax SaveManager] Load Error:", err)
    end
end

function SaveManager:Delete(name)
    if not name or name == "" then return end
    self:Init()
    local s = pcall(function() delfile(self:GetPath(name)) end)
    if s then
        self.Library:Notify("Config Deleted", "Removed config:\n" .. name, 3)
    else
        self.Library:Notify("Error", "Delete failed!", 3)
    end
end

function SaveManager:SetAutoload(name)
    if not name or name == "" then return end
    self:Init()
    local s = pcall(function() writefile(self:GetAutoPath(), name) end)
    if s then
        self.Library:Notify("Autoload Updated", "Default config set to:\n" .. name, 3)
    end
end

function SaveManager:DoAutoload()
    self:Init()
    pcall(function()
        local content = readfile(self:GetAutoPath())
        if content and content ~= "" then
            self.Library:Notify("Autoload", "Loading your default config...", 2)
            self:Load(content)
        end
    end)
end

-- ========================================================
-- CONFIG UI BUILDER
-- ========================================================
function SaveManager:BuildConfigSection(targetTab)
    if not self.Library then 
        warn("[Bymax SaveManager] You must call SaveManager:SetLibrary(Library) first!") 
        return 
    end
    
    self:Init()
    
    local ConfigGroup = targetTab:CreateGroupbox("Configuration", "Right")
    local configNameBox = ""
    local selectedConfig = ""

    ConfigGroup:CreateTextBox({
        Name = "Config Name",
        Placeholder = "Type name here...",
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
        Name = "Set as Autoload",
        Callback = function()
            if selectedConfig ~= "" then self:SetAutoload(selectedConfig) end
        end
    })

    ConfigGroup:CreateButton({
        Name = "Refresh List",
        Callback = function()
            configDropdown:Refresh(self:GetConfigs())
            self.Library:Notify("Refreshed", "Config list updated!", 2)
        end
    })
end

return SaveManager
