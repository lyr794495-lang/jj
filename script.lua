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

-- [ 1. ثغرة فتح المشايات وحذف حواجز الشراء ]
local MarketplaceService = game:GetService("MarketplaceService")

-- إلغاء طلب الشراء فورياً
pcall(function()
    MarketplaceService.PromptGamePassPurchaseRequested:Connect(function() return false end)
    MarketplaceService.PromptPurchaseRequested:Connect(function() return false end)
end)

-- خدعة تزييف الملكية لتجاوز فحص السيرفر UserOwnsGamePassAsync
local oldUserOwns = MarketplaceService.UserOwnsGamePassAsync
hookfunction(MarketplaceService.UserOwnsGamePassAsync, function(self, userId, gamepassId)
    return true
end)

-- حذف حواجز VIP الملموسة محلياً لفتح الطريق للآلات
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") then
                    local name = obj.Name:lower()
                    if name:find("vip") or name:find("pass") or name:find("prompt") or name:find("door") or name:find("barrier") then
                        obj.CanCollide = false
                        obj.Transparency = 1
                    end
                end
            end
        end)
    end
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

-- [ TAB: AUTO FARM - Instant Win + Anti-Kill ]
local InstantWinToggle = Tabs.AutoFarm:AddToggle("InstantWin", { Title = "INSTANT WIN (Auto Farm)", Default = false })

InstantWinToggle:OnChanged(function(Value)
    _G.InstantWin = Value

    -- حماية من الموت والوحش
    task.spawn(function()
        while _G.InstantWin do
            task.wait(0.1)
            pcall(function()
                local char = game.Players.LocalPlayer.Character
                if char and char:FindFirstChild("Humanoid") then
                    char.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                    if char.Humanoid.Health < char.Humanoid.MaxHealth then
                        char.Humanoid.Health = char.Humanoid.MaxHealth
                    end
                end
                for _, p in pairs(workspace:GetDescendants()) do
                    if p:IsA("BasePart") and (p.Name:lower():find("kill") or p.Name:lower():find("boss") or p.Name:lower():find("lava")) then
                        p.CanTouch = false
                    end
                end
            end)
        end
    end)

    -- التفريم
    task.spawn(function()
        while _G.InstantWin do
            task.wait(0.05)
            pcall(function()
                local player = game.Players.LocalPlayer
                local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if not hrp then return end

                local winPad = nil
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("BasePart") and (v.Name:lower():find("win") or v.Name:lower():find("endpad")) then
                        if not v:IsDescendantOf(player.Character) then
                            winPad = v
                            break
                        end
                    end
                end

                if winPad then
                    hrp.CFrame = winPad.CFrame + Vector3.new(0, 3, 0)
                    if firetouchinterest then
                        firetouchinterest(hrp, winPad, 0)
                        task.wait(0.02)
                        firetouchinterest(hrp, winPad, 1)
                    end
                end
            end)
        end
    end)
end)

-- [ TAB: GAMEPASSES - زر التفعيل المباشر للقيم باس ]
Tabs.Gamepasses:AddSection("Gamepass Unlocker")

Tabs.Gamepasses:AddButton({
    Title = "Unlock All Treadmills & VIP",
    Callback = function()
        pcall(function()
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") then
                    local name = v.Name:lower()
                    if name:find("vip") or name:find("treadmill") or name:find("gate") or name:find("door") then
                        v.CanCollide = false
                        v.Transparency = 1
                    end
                end
            end
        end)
    end
})

Window:SelectTab(1)
