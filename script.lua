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

-- [ إغلاق نوافذ الشراء تلقائياً ]
local CoreGui = game:GetService("CoreGui")
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            local purchasePrompt = CoreGui:FindFirstChild("PurchasePromptApp") or game.Players.LocalPlayer.PlayerGui:FindFirstChild("PurchasePromptApp")
            if purchasePrompt then
                purchasePrompt.Enabled = false
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

-- [ TAB: AUTO FARM - إعطاء سرعة تلقائية والتفريم ]
local AutoSpeedToggle = Tabs.AutoFarm:AddToggle("AutoAddSpeed", { Title = "Auto Add Speed (تجمع السرعة تلقائياً)", Default = false })
AutoSpeedToggle:OnChanged(function(Value)
    _G.AutoAddSpeed = Value
    task.spawn(function()
        while _G.AutoAddSpeed do
            task.wait(0.01)
            pcall(function()
                -- استدعاء ريموت زيادة السرعة الخاص بالماب تلقائياً
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                for _, v in pairs(ReplicatedStorage:GetDescendants()) do
                    if v:IsA("RemoteEvent") and (v.Name:lower():find("speed") or v.Name:lower():find("add") or v.Name:lower():find("treadmill") or v.Name:lower():find("walk")) then
                        v:FireServer()
                    end
                end
                -- محاكاة للمس مشايات الـ Speed في الورك سبيس
                local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    for _, pad in pairs(workspace:GetDescendants()) do
                        if pad:IsA("BasePart") and (pad.Name:lower():find("treadmill") or pad.Name:lower():find("speed")) then
                            if firetouchinterest then
                                firetouchinterest(hrp, pad, 0)
                                firetouchinterest(hrp, pad, 1)
                            end
                        end
                    end
                end
            end)
        end
    end)
end)

local InstantWinToggle = Tabs.AutoFarm:AddToggle("InstantWin", { Title = "INSTANT WIN (+150K Wins + Godmode)", Default = false })

InstantWinToggle:OnChanged(function(Value)
    _G.InstantWin = Value

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

    task.spawn(function()
        while _G.InstantWin do
            task.wait(0.05)
            pcall(function()
                local player = game.Players.LocalPlayer
                local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if not hrp then return end

                local winPad = nil
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("BasePart") and (v.Name:lower():find("win") or v.Name:lower():find("endpad") or v.Name:find("150K")) then
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

-- [ TAB: GAMEPASSES ]
Tabs.Gamepasses:AddSection("Treadmills Bypass")

local SpeedBoostValue = 250
Tabs.Gamepasses:AddInput("SpeedInput", {
    Title = "Custom Speed (WalkSpeed)",
    Default = "250",
    Numeric = true,
    Callback = function(Value)
        SpeedBoostValue = tonumber(Value) or 250
    end
})

local EnableTreadmillBypass = Tabs.Gamepasses:AddToggle("TreadmillBypass", { Title = "Bypass Treadmills & Auto Speed", Default = false })
EnableTreadmillBypass:OnChanged(function(Value)
    _G.TreadmillBypass = Value
    task.spawn(function()
        while _G.TreadmillBypass do
            task.wait(0.05)
            pcall(function()
                local player = game.Players.LocalPlayer
                local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.WalkSpeed = SpeedBoostValue
                end
            end)
        end
    end)
end)

Window:SelectTab(1)
