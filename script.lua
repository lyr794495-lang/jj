-- تحميل مكتبة Fluent UI العصريّة بنفس شكل الصورة
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- إنشاء النافذة الرئيسية
local Window = Fluent:CreateWindow({
    Title = "Night Hub | Speed Keyboard Escape",
    SubTitle = "by Clover",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 400),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- إضافة التبويبات القريبة من شكل الصورة
local Tabs = {
    Main = Window:AddTab({ Title = "Main / Farm", Icon = "home" }),
    Player = Window:AddTab({ Title = "Speed", Icon = "user" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- [ تبويب التفريم والتجميع التلقائي ]
Tabs.Main:AddParagraph({
    Title = "تجميع الكؤوس والورود تلقائياً",
    Content = "قم بتفعيل الخيار بالأسفل ليقوم السكربت بتجميعهما من الماب تلقائياً."
})

local AutoFarmToggle = Tabs.Main:AddToggle("AutoFarmKeyboards", {
    Title = "Auto Farm Cups / Keyboards",
    Default = false
})

AutoFarmToggle:OnChanged(function(Value)
    _G.AutoFarmCups = Value
    
    task.spawn(function()
        while _G.AutoFarmCups do
            task.wait(0.1)
            pcall(function()
                -- البحث عن الكؤوس والأدوات التجميعية وتخطي العقبات
                for _, obj in pairs(workspace:GetDescendants()) do
                    if not _G.AutoFarmCups then break end
                    if obj:IsA("BasePart") and (obj.Name:lower():find("cup") or obj.Name:lower():find("trophy") or obj.Name:lower():find("key") or obj.Name:lower():find("wins")) then
                        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = obj.CFrame
                            task.wait(0.2)
                        end
                    end
                end
            end)
        end
    end)
end)

Tabs.Main:AddButton({
    Title = "تشغيل سكربت تفريم خارجي قوي",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/qx221/qx47/refs/heads/main/hi-lol.lua"))()
    end
})

-- [ تبويب السرعة والقفز ]
Tabs.Player:AddSlider("WalkSpeedSlider", {
    Title = "WalkSpeed (السرعة)",
    Description = "تغيير سرعة اللاعب",
    Default = 16,
    Min = 16,
    Max = 500,
    Rounding = 0,
    Callback = function(Value)
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    end
})

Tabs.Player:AddSlider("JumpPowerSlider", {
    Title = "JumpPower (القفز)",
    Description = "تغيير قوة القفز",
    Default = 50,
    Min = 50,
    Max = 500,
    Rounding = 0,
    Callback = function(Value)
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
        end
    end
})

-- اختيار التبويب الرئيسي عند التشغيل
Window:SelectTab(1)
