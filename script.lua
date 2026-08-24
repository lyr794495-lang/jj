local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "ARASAKA Inc.",
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

-- [ TAB: MAIN ]
Tabs.Main:AddInput("JumpPowerInput", {
    Title = "Jump Power",
    Default = "50",
    Placeholder = "Enter Jump Power",
    Numeric = true,
    Finished = false,
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

-- [ TAB: AUTO FARM & GODMODE ]
local TweenService = game:GetService("TweenService")

local Farm1Toggle = Tabs.AutoFarm:AddToggle("Farm1Cup", { Title = "Auto Farm (1 Cup)", Default = false })
Farm1Toggle:OnChanged(function(Value)
    _G.Farm1 = Value
    task.spawn(function()
        while _G.Farm1 do
            task.wait(0.1)
            pcall(function()
                local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
                for _, obj in pairs(workspace:GetDescendants()) do
                    if not _G.Farm1 then break end
                    if obj:IsA("BasePart") and (obj.Name:lower():find("win") or obj.Name:lower():find("trophy")) then
                        local distance = (hrp.Position - obj.Position).Magnitude
                        local tween = TweenService:Create(hrp, TweenInfo.new(distance / 150, Enum.EasingStyle.Linear), {CFrame = obj.CFrame + Vector3.new(0, 3, 0)})
                        tween:Play()
                        tween.Completed:Wait()
                        task.wait(0.2)
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

-- [ TAB: GAMEPASSES ]
Tabs.Gamepasses:AddSection("Gamepass Bypasses")

Tabs.Gamepasses:AddButton({
    Title = "Unlock Diamond Treadmill",
    Callback = function()
        pcall(function()
            for _, v in pairs(workspace:GetDescendants()) do
                if v.Name:find("Diamond") or v.Name:find("Treadmill") then
                    v.CanTouch = true
                    if v:FindFirstChild("TouchInterest") then
                        firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v, 0)
                        firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v, 1)
                    end
                end
            end
        end)
    end
})

Tabs.Gamepasses:AddButton({
    Title = "Unlock Gold Treadmill",
    Callback = function()
        pcall(function()
            for _, v in pairs(workspace:GetDescendants()) do
                if v.Name:find("Gold") or v.Name:find("Treadmill") then
                    v.CanTouch = true
                    if v:FindFirstChild("TouchInterest") then
                        firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v, 0)
                        firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v, 1)
                    end
                end
            end
        end)
    end
})

Tabs.Gamepasses:AddSection("Rewards")
Tabs.Gamepasses:AddButton({
    Title = "Claim Group Reward",
    Callback = function()
        pcall(function()
            local remote = game:GetService("ReplicatedStorage"):FindFirstChild("ClaimGroupReward", true)
            if remote then remote:FireServer() end
        end)
    end
})

Window:SelectTab(1)
