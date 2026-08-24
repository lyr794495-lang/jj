local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "clover.",
    SubTitle = "Speed Keyboard Escape",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "user" }),
    AutoFarm = Window:AddTab({ Title = "Auto Farm", Icon = "zap" }),
    Gamepasses = Window:AddTab({ Title = "Gamepasses", Icon = "star" }),
    Support = Window:AddTab({ Title = "Support", Icon = "heart" })
}

-- [ 1. تعطيل وإلغاء إحداثيات الشراء لمنع ظهور النافذة ]
local MarketplaceService = game:GetService("MarketplaceService")
pcall(function()
    MarketplaceService.PromptGamePassPurchaseRequested:Connect(function() return false end)
    MarketplaceService.PromptPurchaseRequested:Connect(function() return false end)
end)

-- [ TAB: MAIN ]
Tabs.Main:AddInput("JumpPowerInput", {
    Title = "Jump Power",
    Default = "50",
    Numeric = true,
    Callback = function(Value)
        pcall(function()
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = tonumber(Value)
        end)
    end
})

local FreezeToggle = Tabs.Main:AddToggle("FreezePosition", { Title = "Freeze Position", Default = false })
FreezeToggle:OnChanged(function(Value)
    pcall(function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = Value
    end)
end)

local NoclipToggle = Tabs.Main:AddToggle("Noclip", { Title = "Noclip", Default = false })
NoclipToggle:OnChanged(function(Value)
    _G.Noclip = Value
    task.spawn(function()
        while _G.Noclip do
            task.wait()
            pcall(function()
                for _, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end)
        end
    end)
end)

Tabs.Main:AddSection("Fly Settings")

local FlySpeedVal = 50
local FlyToggle = Tabs.Main:AddToggle("FlyEnabled", { Title = "Fly Enabled", Default = false })

Tabs.Main:AddInput("FlySpeedInput", {
    Title = "Fly Speed",
    Default = "50",
    Numeric = true,
    Callback = function(Value) FlySpeedVal = tonumber(Value) or 50 end
})

local bv, bg
FlyToggle:OnChanged(function(Value)
    _G.Flying = Value
    local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if _G.Flying then
        bv = Instance.new("BodyVelocity", hrp)
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bg = Instance.new("BodyGyro", hrp)
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)

        task.spawn(function()
            while _G.Flying and task.wait() do
                local cam = workspace.CurrentCamera
                local moveDir = game.Players.LocalPlayer.Character.Humanoid.MoveDirection
                bv.Velocity = (cam.CFrame.LookVector * (moveDir.Z * FlySpeedVal)) + (cam.CFrame.RightVector * (moveDir.X * FlySpeedVal))
                bg.CFrame = cam.CFrame
            end
        end)
    else
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
    end
end)

-- [ TAB: AUTO FARM - Instant Win +150K Wins ]
local InstantWinToggle = Tabs.AutoFarm:AddToggle("InstantWin", { Title = "INSTANT WIN (+150K Wins)", Default = false })
InstantWinToggle:OnChanged(function(Value)
    _G.InstantWin = Value
    task.spawn(function()
        while _G.InstantWin do
            task.wait(0.1)
            pcall(function()
                local player = game.Players.LocalPlayer
                local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if not hrp then return end

                local targetPad = nil
                
                -- البحث المباشر عن منصة 150K Wins
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        if obj.Name:find("150K") or (obj.Parent and obj.Parent.Name:find("150K")) or obj.Name:lower() == "win" then
                            targetPad = obj
                            break
                        end
                    end
                end

                -- في حال عدم العثور عليها بالاسم، يتم اختيار المنصة الأكثر ارتفاعاً (أبعد منصة)
                if not targetPad then
                    local maxY = -math.huge
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj:IsA("BasePart") and (obj.Name:lower():find("win") or obj.Name:lower():find("end")) then
                            if obj.Position.Y > maxY then
                                maxY = obj.Position.Y
                                targetPad = obj
                            end
                        end
                    end
                end

                if targetPad then
                    hrp.CFrame = targetPad.CFrame + Vector3.new(0, 3, 0)
                    if firetouchinterest then
                        firetouchinterest(hrp, targetPad, 0)
                        task.wait(0.05)
                        firetouchinterest(hrp, targetPad, 1)
                    end
                end
            end)
        end
    end)
end)

local GodToggle = Tabs.AutoFarm:AddToggle("Godmode", { Title = "Godmode (Anti-Kill/Monster)", Default = false })
GodToggle:OnChanged(function(Value)
    _G.Godmode = Value
    task.spawn(function()
        while _G.Godmode do
            task.wait(0.2)
            pcall(function()
                local char = game.Players.LocalPlayer.Character
                if char:FindFirstChild("Humanoid") then
                    char.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                    char.Humanoid.Health = char.Humanoid.MaxHealth
                end
                for _, p in pairs(workspace:GetDescendants()) do
                    if p:IsA("BasePart") and (p.Name:lower():find("kill") or p.Name:lower():find("monster") or p.Name:lower():find("npc")) then
                        p.CanTouch = false
                    end
                end
            end)
        end
    end)
end)

-- [ TAB: GAMEPASSES - سرعة الآلات الوهمية بدون طلب شراء ]
Tabs.Gamepasses:AddSection("Treadmills Speed Boost")

local CustomSpeedVal = 16
Tabs.Gamepasses:AddInput("CustomSpeedInput", {
    Title = "Treadmill Speed Multiplier",
    Default = "150",
    Numeric = true,
    Callback = function(Value)
        CustomSpeedVal = tonumber(Value) or 16
    end
})

local FakeTreadmillToggle = Tabs.Gamepasses:AddToggle("FakeTreadmills", { Title = "Enable Treadmill Speed Bypass", Default = false })
FakeTreadmillToggle:OnChanged(function(Value)
    _G.FakeTreadmills = Value
    task.spawn(function()
        while _G.FakeTreadmills do
            task.wait(0.1)
            pcall(function()
                local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.WalkSpeed = CustomSpeedVal
                end
            end)
        end
    end)
end)

Window:SelectTab(1)
