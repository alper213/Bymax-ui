-- ==============================================================================
-- BYMAX UI LIBRARY - OFFICIAL MASTERCLASS EXAMPLE (V28 FINAL)
-- ==============================================================================
-- Bu script, kütüphanenin tüm özelliklerini nasıl kullanacağınızı öğretir.
-- Her bölüm yorum satırlarıyla (comments) açıklanmıştır.
-- ==============================================================================

-- 1. ADIM: KÜTÜPHANEYİ ÇEKME
-- GitHub Cache Bypass kullanarak her zaman en güncel sürümü aldığınızdan emin olun.
local cacheBypass = "?t=" .. tostring(math.random(100000, 999999))
local Library = loadstring(game:HttpGet("https://github.com/alper213/Bymax-ui/raw/refs/heads/main/libaryui.lua" .. cacheBypass))()

-- 2. ADIM: ANA PENCEREYİ OLUŞTURMA
-- Library:CreateWindow("Menü Başlığı", "Watermark Yazısı")
local Window = Library:CreateWindow("Bymax Premium Hub", "Bymax V28 | Private")

-- ==============================================================================
-- SEKME 1: COMBAT (TEMEL ELEMENTLER)
-- ==============================================================================
local TabCombat = Window:CreateTab("Combat")

-- Groupbox Oluşturma: CreateGroupbox("Başlık", "Taraf") -> "Left" veya "Right"
local AimGroup = TabCombat:CreateGroupbox("Aimbot Features", "Left")

-- [TOGGLE] - Aç/Kapat Butonu
-- Hold = true yaparsanız sadece tuşa basılı tuttuğunuzda çalışır.
AimGroup:CreateToggle({
    Name = "Legit Aimbot",
    Default = false,
    Keybind = "E", -- Menüden değiştirilebilir kısayol tuşu
    Hold = false,  -- True olursa basılı tutmalı çalışır
    Callback = function(Value)
        print("Aimbot Durumu:", Value)
        if Value then
            Library:Notify("Combat", "Aimbot Aktif!", 2)
        end
    end
})

-- [SLIDER] - Kaydırmalı Sayı Seçici
AimGroup:CreateSlider({
    Name = "Aimbot Field of View",
    Min = 0,
    Max = 500,
    Default = 100,
    Increment = 5, -- Sayıların kaçar kaçar artacağı
    Callback = function(Value)
        print("FOV Ayarlandı:", Value)
    end
})

-- [KEYBIND] - Bağımsız Tuş Atama
AimGroup:CreateKeybind({
    Name = "Quick Teleport Key",
    Default = "V",
    Callback = function(Key)
        print("Teleport tuşuna basıldı:", Key)
        Library:Notify("Movement", "Işınlanma tetiklendi!", 2)
    end
})

-- [TEXTBOX] - Yazı Giriş Alanı
local MiscGroup = TabCombat:CreateGroupbox("Miscellaneous", "Right")

MiscGroup:CreateTextBox({
    Name = "Target Player Name",
    Placeholder = "İsim yazın...",
    Callback = function(Text)
        print("Hedef Oyuncu Değişti:", Text)
        Library:Notify("Target", "Hedef: " .. Text, 3)
    end
})

-- [BUTTON] - Klasik Tıklanabilir Buton
MiscGroup:CreateButton({
    Name = "Server Hop (Sunucu Değiştir)",
    Callback = function()
        print("Sunucu değiştiriliyor...")
    end
})

-- ==============================================================================
-- SEKME 2: VISUALS (DROPDOWN & COLORPICKER)
-- ==============================================================================
local TabVisuals = Window:CreateTab("Visuals")

-- --- DROPDOWN USTALIK SINIFI ---
local ESPGroup = TabVisuals:CreateGroupbox("ESP Customization", "Left")

-- Dropdown'u bir değişkene kaydediyoruz ki sonra güncelleyebilelim
local MyDropdown = ESPGroup:CreateDropdown({
    Name = "Select ESP Type",
    Options = {"Box", "Tracer", "Skeleton"}, -- Başlangıç seçenekleri
    Callback = function(Value)
        print("Seçilen ESP:", Value)
    end
})

-- [REFRESH] - Dropdown Seçeneklerini Canlı Güncelleme
-- Sunucudaki oyuncu listesini çekmek için mükemmeldir.
ESPGroup:CreateButton({
    Name = "Seçenekleri Yenile",
    Callback = function()
        local NewList = {"Admin", "Moderator", "Player", "Guest"}
        MyDropdown:Refresh(NewList) -- Listeyi anında değiştirir
        Library:Notify("UI", "Liste başarıyla güncellendi!", 2)
    end
})

-- [SET] - Dropdown Değerini Kodla Değiştirme
ESPGroup:CreateButton({
    Name = "Zorla 'Admin' Seç",
    Callback = function()
        MyDropdown:Set("Admin") -- Menüyü açmadan Admin'i seçer
    end
})

-- --- COLOR PICKER ---
local ColorGroup = TabVisuals:CreateGroupbox("Interface Colors", "Right")

ColorGroup:CreateColorPicker({
    Name = "Main ESP Color",
    Default = Color3.fromRGB(40, 100, 255),
    Callback = function(Value)
        -- Eğer kullanıcı ColorPicker içindeki "Rainbow: ON" yaparsa,
        -- bu fonksiyon saniyede 60 kez yeni renklerle çalışır!
        print("Renk Güncellendi:", Value)
    end
})

ColorGroup:CreateLabel("Rainbow modu pürüzsüz çalışır.")

-- ==============================================================================
-- SEKME 3: SETTINGS (GİZLEME & KAPATMA)
-- ==============================================================================
local TabSettings = Window:CreateTab("Settings")

local MenuGroup = TabSettings:CreateGroupbox("Menu Interface", "Left")

-- Menüyü Tamamen Kapatma/Silme
MenuGroup:CreateButton({
    Name = "Unload UI (Hileyi Kapat)",
    Callback = function()
        Window:Unload() -- Tüm GUI ve Bildirim sistemini siler
    end
})

-- Menü Aç/Kapa Tuşunu Değiştirme
MenuGroup:CreateKeybind({
    Name = "Menu Bind",
    Default = "RightShift",
    Callback = function(Key)
        Window.MenuBind = Enum.KeyCode[Key]
        Library:Notify("Settings", "Menü tuşu [" .. Key .. "] olarak atandı.", 3)
    end
})

local WidgetGroup = TabSettings:CreateGroupbox("Extra Widgets", "Right")

-- Watermark Gizle/Aç
WidgetGroup:CreateToggle({
    Name = "Show Watermark",
    Default = true,
    Callback = function(Value)
        if Library.Watermark then
            Library.Watermark.Visible = Value
        end
    end
})

-- Keybind Listesini Gizle/Aç
WidgetGroup:CreateToggle({
    Name = "Show Keybind List",
    Default = true,
    Callback = function(Value)
        if Library.KeybindList then
            Library.KeybindList.Visible = Value
        end
    end
})

-- Discord Link Kopyalama
WidgetGroup:CreateButton({
    Name = "Copy Discord Link",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/bymax")
            Library:Notify("Discord", "Link kopyalandı!", 3)
        end
    end
})

-- ==============================================================================
-- BAŞLANGIÇ BİLDİRİMİ
-- ==============================================================================
Library:Notify("Welcome", "Bymax Premium başarıyla yüklendi. İyi oyunlar!", 5)

-- Flag Sistemini Kullanma Örneği:
-- Herhangi bir hile döngüsünde: if Library.Flags["AimEnabled"] then ... end
