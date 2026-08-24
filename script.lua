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

-- [ إيقاف نوافذ الشراء الإجباري ]
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

-- [ TAB: AUTO FARM - الانتقال لأعلى مرحلة (+150K Wins) ]
local AutoWalkToggle = Tabs.AutoFarm:AddToggle("AutoWalkSpeed", { Title = "Auto Walk (Gain Speed)", Default = false })
AutoWalkToggle:OnChanged(function(Value)
    _G.AutoWalk = Value
    task.spawn(function()
        while _G.AutoWalk do
            task.wait(0.05)
            pcall(function()
                local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum:Move(Vector3.new(0, 0, -1), true)
                end
            end)
        end
    end)
end)

local InstantWinToggle = Tabs.AutoFarm:AddToggle("InstantWin", { Title = "INSTANT WIN (+150K Wins Pad)", Default = false })
InstantWinToggle:OnChanged(function(Value)
    _G.InstantWin = Value
    task.spawn(function()
        while _G.InstantWin do
            task.wait(0.05)
            pcall(function()
                local player = game.Players.LocalPlayer
                local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if not hrp then return end

                -- البحث عن أبعد وأعلى منصة فوز (آخر مرحلة +150K Wins)
                local maxWinPad = nil
                local maxDist = -math.huge

                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and (obj.Name:lower():find("win") or obj.Name:lower():find("trophy") or obj.Name:lower():find("endpad")) then
                        -- اختيار أعلى منصة من حيث الارتفاع أو المسافة
                        local posVal = obj.Position.Z + obj.Position.Y
                        if posVal > maxDist then
                            maxDist = posVal
                            maxWinPad = obj
                        end
                    end
                end

                if maxWinPad then
                    hrp.CFrame = maxWinPad.CFrame + Vector3.new(0, 3, 0)
                    if firetouchinterest then
                        firetouchinterest(hrp, maxWinPad, 0)
                        task.wait(0.05)
                        firetouchinterest(hrp, maxWinPad, 1)
                    end
                    
                    task.wait(0.1)
                    local spawn = workspace:FindFirstChild("SpawnLocation", true)
                    if spawn then
                        hrp.CFrame = spawn.CFrame + Vector3.new(0, 3, 0)
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
Tabs.Gamepasses:AddSection("Treadmills Bypass & Boost")

local AutoDiamondTreadmill = Tabs.Gamepasses:AddToggle("AutoDiamond", { Title = "Auto Diamond Treadmill Speed (X150)", Default = false })
AutoDiamondTreadmill:OnChanged(function(Value)
    _G.AutoDiamond = Value
    task.spawn(function()
        while _G.AutoDiamond do
            task.wait(0.1)
            pcall(function()
                local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("BasePart") and (v.Name:find("Diamond") or (v.Parent and v.Parent.Name:find("Diamond"))) then
                        if firetouchinterest then
                            firetouchinterest(hrp, v, 0)
                            firetouchinterest(hrp, v, 1)
                        end
                    end
                end
            end)
        end
    end)
end)

local AutoGoldTreadmill = Tabs.Gamepasses:AddToggle("AutoGold", { Title = "Auto Gold Treadmill Speed (X50)", Default = false })
AutoGoldTreadmill:OnChanged(function(Value)
    _G.AutoGold = Value
    task.spawn(function()
        while _G.AutoGold do
            task.wait(0.1)
            pcall(function()
                local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("BasePart") and (v.Name:find("Gold") or (v.Parent and v.Parent.Name:find("Gold"))) then
                        if firetouchinterest then
                            firetouchinterest(hrp, v, 0)
                            firetouchinterest(hrp, v, 1)
                        end
                    end
                end
            end)
        end
    end)
end)

Window:SelectTab(1)
