-- ==============================================================================
-- BYMAX SAVE MANAGER - V6 (.TXT EXTENSION BYPASS & ERROR ISOLATION)
-- ==============================================================================
local HttpService = game:GetService("HttpService")

local SaveManager = {
    Prefix = "BymaxCfg_",
    Library = nil
}

function SaveManager:SetLibrary(lib)
    self.Library = lib
end

function SaveManager:SetPrefix(prefixName)
    self.Prefix = prefixName .. "_"
end

-- ========================================================
-- NO MORE .JSON! WE USE .TXT TO BYPASS EXECUTOR BLOCKS
-- ========================================================
function SaveManager:GetPath(name)
    return self.Prefix .. name .. ".txt"
end

function SaveManager:GetAutoPath()
    return self.Prefix .. "Autoload.txt"
end

function SaveManager:GetConfigs()
    local list = {}
    
    local s, files = pcall(function() return listfiles("") end)
    if not s or type(files) ~= "table" then
        s, files = pcall(function() return listfiles(".") end)
    end
    if not s or type(files) ~= "table" then
        s, files = pcall(function() return listfiles() end)
    end

    if s and type(files) == "table" then
        for _, file in ipairs(files) do
            -- Match .txt files instead of .json
            local pattern = self.Prefix .. "([^/\\]+)%.txt$"
            local fileName = file:match(pattern)
            if fileName and fileName ~= "Autoload" then 
                table.insert(list, fileName) 
            end
        end
    end
    return list
end

function SaveManager:Save(name)
    if not self.Library or not name or name == "" then return end
    
    local data = {}
    for flag, element in pairs(self.Library.Flags) do
        local val = element.Value
        -- Sadece desteklenen tipleri kaydet, bozuk veri executor'ı çökertmesin
        if typeof(val) == "Color3" then
            data[flag] = {R = val.R, G = val.G, B = val.B, IsColor3 = true}
        elseif type(val) == "string" or type(val) == "number" or type(val) == "boolean" or type(val) == "table" then
            data[flag] = val
        end
    end
    
    -- ADIM 1: Veriyi çevir (Burada patlarsa veri bozuk demektir)
    local encodeSuccess, encodedData = pcall(function()
        return HttpService:JSONEncode(data)
    end)

    if not encodeSuccess then
        self.Library:Notify("Error", "Data Encode failed!", 4)
        warn("[Bymax SaveManager] JSONEncode Error:", encodedData)
        return
    end
    
    -- ADIM 2: Dosyayı .txt olarak kaydet (Burada patlarsa executor engelliyor demektir)
    local writeSuccess, writeError = pcall(function()
        writefile(self:GetPath(name), encodedData)
    end)
    
    if writeSuccess then 
        self.Library:Notify("Config Saved", "Saved:\n" .. name, 3)
    else 
        self.Library:Notify("Error", "Writefile blocked! Check F9", 4) 
        warn("[Bymax SaveManager] Writefile Error:", writeError)
    end
end

function SaveManager:Load(name)
    if not self.Library or not name or name == "" then return end
    
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
        self.Library:Notify("Config Loaded", "Loaded:\n" .. name, 3)
    else 
        self.Library:Notify("Error", "Load failed! File broken/missing.", 4) 
        warn("[Bymax SaveManager] Load Error:", err)
    end
end

function SaveManager:Delete(name)
    if not name or name == "" then return end
    local s = pcall(function() delfile(self:GetPath(name)) end)
    if s then 
        self.Library:Notify("Config Deleted", "Removed:\n" .. name, 3) 
    end
end

function SaveManager:SetAutoload(name)
    if not name or name == "" then return end
    local s = pcall(function() writefile(self:GetAutoPath(), name) end)
    if s then 
        self.Library:Notify("Autoload Set", "Default config:\n" .. name, 3) 
    end
end

function SaveManager:DoAutoload()
    local s, content = pcall(readfile, self:GetAutoPath())
    if s and content and content ~= "" then
        self.Library:Notify("Autoload", "Loading default config...", 2)
        self:Load(content)
    end
end

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
            self.Library:Notify("Refreshed", "Config list updated!", 2) 
        end 
    })
end

return SaveManager
