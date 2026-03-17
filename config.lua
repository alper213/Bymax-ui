-- ==============================================================================
-- BYMAX SAVE MANAGER - V3 (ANTI-CRASH & ROOT FALLBACK SYSTEM)
-- ==============================================================================
local HttpService = game:GetService("HttpService")

local SaveManager = {
    Folder = "BymaxConfigs",
    Library = nil,
    RootMode = false,
    Tested = false
}

function SaveManager:SetLibrary(lib) 
    self.Library = lib 
end

function SaveManager:SetFolder(folderName) 
    self.Folder = folderName 
end

-- ========================================================
-- SMART FOLDER BYPASS LOGIC
-- ========================================================
function SaveManager:CheckFolder()
    if self.Tested then return end
    self.Tested = true
    
    if not isfolder or not makefolder then
        self.RootMode = true
        return
    end
    
    -- Try to make folder ONLY ONCE. If executor cries, fallback to root forever.
    local s = pcall(function()
        if not isfolder(self.Folder) then 
            makefolder(self.Folder) 
        end
    end)
    
    if not s then 
        self.RootMode = true 
    else
        local s2, exists = pcall(isfolder, self.Folder)
        if not s2 or not exists then 
            self.RootMode = true 
        end
    end
end

function SaveManager:GetPath(name)
    self:CheckFolder()
    if self.RootMode then
        return self.Folder .. "_" .. name .. ".json"
    else
        return self.Folder .. "/" .. name .. ".json"
    end
end

function SaveManager:GetAutoPath()
    self:CheckFolder()
    if self.RootMode then
        return self.Folder .. "_Autoload.txt"
    else
        return self.Folder .. "/Autoload.txt"
    end
end

-- ========================================================
-- CORE SAVE FUNCTIONS
-- ========================================================
function SaveManager:GetConfigs()
    self:CheckFolder()
    local list = {}
    
    local path = self.RootMode and "" or self.Folder
    local s, files = pcall(listfiles, path)
    
    if s and files then
        for _, file in ipairs(files) do
            local fileName
            if self.RootMode then
                fileName = file:match(self.Folder .. "_([^/\\]+)%.json$")
            else
                fileName = file:match("([^/\\]+)%.json$")
            end
            if fileName then table.insert(list, fileName) end
        end
    end
    return list
end

function SaveManager:Save(name)
    if not self.Library or not name or name == "" then return end
    self:CheckFolder()
    
    local data = {}
    for flag, element in pairs(self.Library.Flags) do
        local val = element.Value
        if typeof(val) == "Color3" then
            val = {R = val.R, G = val.G, B = val.B, IsColor3 = true}
        end
        data[flag] = val
    end
    
    local s, err = pcall(function()
        writefile(self:GetPath(name), HttpService:JSONEncode(data))
    end)
    
    if s then 
        self.Library:Notify("Config Saved", "Saved: " .. name, 3)
    else 
        self.Library:Notify("Error", "Save failed!", 4) 
    end
end

function SaveManager:Load(name)
    if not self.Library or not name or name == "" then return end
    self:CheckFolder()
    
    local s, err = pcall(function()
        local decoded = HttpService:JSONDecode(readfile(self:GetPath(name)))
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
        self.Library:Notify("Config Loaded", "Loaded: " .. name, 3)
    else 
        self.Library:Notify("Error", "Load failed!", 4) 
    end
end

function SaveManager:Delete(name)
    if not name or name == "" then return end
    self:CheckFolder()
    local s = pcall(function() delfile(self:GetPath(name)) end)
    if s then 
        self.Library:Notify("Config Deleted", "Removed: " .. name, 3) 
    end
end

function SaveManager:SetAutoload(name)
    if not name or name == "" then return end
    self:CheckFolder()
    local s = pcall(function() writefile(self:GetAutoPath(), name) end)
    if s then 
        self.Library:Notify("Autoload Set", "Default: " .. name, 3) 
    end
end

function SaveManager:DoAutoload()
    self:CheckFolder()
    local s, content = pcall(readfile, self:GetAutoPath())
    if s and content and content ~= "" then
        self.Library:Notify("Autoload", "Loading default config...", 2)
        self:Load(content)
    end
end

-- ========================================================
-- CONFIG UI BUILDER
-- ========================================================
function SaveManager:BuildConfigSection(targetTab)
    if not self.Library then return end
    
    local Group = targetTab:CreateGroupbox("Configuration", "Right")
    local configNameBox, selectedConfig = "", ""

    Group:CreateTextBox({ 
        Name = "Config Name", 
        Placeholder = "Type here...", 
        Callback = function(val) configNameBox = val end 
    })

    local drop = Group:CreateDropdown({ 
        Name = "Select Config", 
        Options = self:GetConfigs(), 
        Callback = function(val) selectedConfig = val end 
    })

    Group:CreateButton({ 
        Name = "Save Config", 
        Callback = function()
            local t = (configNameBox ~= "") and configNameBox or selectedConfig
            if t ~= "" then 
                self:Save(t)
                drop:Refresh(self:GetConfigs()) 
            end
        end 
    })

    Group:CreateButton({ 
        Name = "Load Config", 
        Callback = function() 
            if selectedConfig ~= "" then self:Load(selectedConfig) end 
        end 
    })

    Group:CreateButton({ 
        Name = "Delete Config", 
        Callback = function()
            if selectedConfig ~= "" then 
                self:Delete(selectedConfig)
                drop:Refresh(self:GetConfigs())
                drop:Set("...")
                selectedConfig = "" 
            end
        end 
    })

    Group:CreateButton({ 
        Name = "Set as Autoload", 
        Callback = function() 
            if selectedConfig ~= "" then self:SetAutoload(selectedConfig) end 
        end 
    })

    Group:CreateButton({ 
        Name = "Refresh List", 
        Callback = function() 
            drop:Refresh(self:GetConfigs())
            self.Library:Notify("Refresh", "Config list updated!", 2) 
        end 
    })
end

return SaveManager
