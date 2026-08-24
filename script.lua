-- إشعار التحديث
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Clover Hub",
    Text = "تم تحديث المراحل والـ Godmode ضد الوحوش بنجاح!",
    Duration = 4
})

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")

local Farm1CupBtn = Instance.new("TextButton")
local UICorner1 = Instance.new("UICorner")

local Farm3CupsBtn = Instance.new("TextButton")
local UICorner2 = Instance.new("UICorner")

local GodModeBtn = Instance.new("TextButton")
local UICorner3 = Instance.new("UICorner")

local FlyBtn = Instance.new("TextButton")
local UICorner4 = Instance.new("UICorner")

ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "CloverHubGUI"

MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Position = UDim2.new(0.5, -130, 0.35, -130)
MainFrame.Size = UDim2.new(0, 260, 0, 320)
MainFrame.Active = true
MainFrame.Draggable = true
UICorner.Parent = MainFrame

Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.GothamBold
Title.Text = "Speed Keyboard Escape"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13

-- [ 1. تفريم مرحلة 1 كأس ]
Farm1CupBtn.Parent = MainFrame
Farm1CupBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 127)
Farm1CupBtn.Position = UDim2.new(0.08, 0, 0.16, 0)
Farm1CupBtn.Size = UDim2.new(0.84, 0, 0, 40)
Farm1CupBtn.Font = Enum.Font.GothamBold
Farm1CupBtn.Text = "تفريم 1 كأس (OFF)"
Farm1CupBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Farm1CupBtn.TextSize = 12
UICorner1.Parent = Farm1CupBtn

-- [ 2. تفريم مرحلة 3 كؤوس ]
Farm3CupsBtn.Parent = MainFrame
Farm3CupsBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
Farm3CupsBtn.Position = UDim2.new(0.08, 0, 0.31, 0)
Farm3CupsBtn.Size = UDim2.new(0.84, 0, 0, 40)
Farm3CupsBtn.Font = Enum.Font.GothamBold
Farm3CupsBtn.Text = "تفريم 3 كؤوس (OFF)"
Farm3CupsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Farm3CupsBtn.TextSize = 12
UICorner2.Parent = Farm3CupsBtn

-- دوال التفريم والمشي المضبوط
local farm1Active = false
local farm3Active = false

local function startSmoothFarm(targetType)
    local TweenService = game:GetService("TweenService")
    task.spawn(function()
        while (targetType == 1 and farm1Active) or (targetType == 3 and farm3Active) do
            task.wait(0.1)
            pcall(function()
                local char = game.Players.LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if (targetType == 1 and not farm1Active) or (targetType == 3 and not farm3Active) then break end
                        
                        -- التمييز بين خط البداية ومنصات الفوز/الكؤوس
                        if obj:IsA("BasePart") and (obj.Name:lower():find("win") or obj.Name:lower():find("trophy") or obj.Name:lower():find("cup")) then
                            local isMatch = false
                            if targetType == 1 and (obj.Name:find("1") or not obj.Name:find("3")) then
                                isMatch = true
                            elseif targetType == 3 and (obj.Name:find("3") or obj.Parent.Name:find("3")) then
                                isMatch = true
                            end
                            
                            if isMatch then
                                local targetCFrame = obj.CFrame + Vector3.new(0, 3, 0)
                                local distance = (hrp.Position - targetCFrame.Position).Magnitude
                                local tweenInfo = TweenInfo.new(distance / 160, Enum.EasingStyle.Linear)
                                local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
                                tween:Play()
                                tween.Completed:Wait()
                                task.wait(0.2)
                            end
                        end
                    end
                end
            end)
        end
    end)
end

Farm1CupBtn.MouseButton1Click:Connect(function()
    farm1Active = not farm1Active
    farm3Active = false
    Farm3CupsBtn.Text = "تفريم 3 كؤوس (OFF)"
    Farm3CupsBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)

    if farm1Active then
        Farm1CupBtn.Text = "إيقاف 1 كأس (ON)"
        Farm1CupBtn.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
        startSmoothFarm(1)
    else
        Farm1CupBtn.Text = "تفريم 1 كأس (OFF)"
        Farm1CupBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 127)
    end
end)

Farm3CupsBtn.MouseButton1Click:Connect(function()
    farm3Active = not farm3Active
    farm1Active = false
    Farm1CupBtn.Text = "تفريم 1 كأس (OFF)"
    Farm1CupBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 127)

    if farm3Active then
        Farm3CupsBtn.Text = "إيقاف 3 كؤوس (ON)"
        Farm3CupsBtn.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
        startSmoothFarm(3)
    else
        Farm3CupsBtn.Text = "تفريم 3 كؤوس (OFF)"
        Farm3CupsBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
    end
end)

-- [ 3. ميزة عدم الموت المتقدمة ضد الوحوش واللمس ]
GodModeBtn.Parent = MainFrame
GodModeBtn.BackgroundColor3 = Color3.fromRGB(170, 85, 255)
GodModeBtn.Position = UDim2.new(0.08, 0, 0.46, 0)
GodModeBtn.Size = UDim2.new(0.84, 0, 0, 40)
GodModeBtn.Font = Enum.Font.GothamBold
GodModeBtn.Text = "تفعيل عدم الموت (Godmode)"
GodModeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
GodModeBtn.TextSize = 12
UICorner3.Parent = GodModeBtn

local godModeActive = false
GodModeBtn.MouseButton1Click:Connect(function()
    godModeActive = not godModeActive
    if godModeActive then
        GodModeBtn.Text = "إيقاف عدم الموت (ON)"
        GodModeBtn.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
    else
        GodModeBtn.Text = "تفعيل عدم الموت (Godmode)"
        GodModeBtn.BackgroundColor3 = Color3.fromRGB(170, 85, 255)
    end

    task.spawn(function()
        while godModeActive do
            task.wait(0.15)
            pcall(function()
                local char = game.Players.LocalPlayer.Character
                if char then
                    if char:FindFirstChild("Humanoid") then
                        char.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                        char.Humanoid.Health = char.Humanoid.MaxHealth
                    end
                    -- إيقاف الاصطدام مع الوحوش والمجسمات القاتلة
                    for _, part in pairs(workspace:GetDescendants()) do
                        if part:IsA("BasePart") then
                            if part.Name:lower():find("kill") or part.Name:lower():find("monster") or part.Name:lower():find("npc") or part.Name:lower():find("lava") or part.Name:lower():find("cup") then
                                part.CanTouch = false
                            end
                        end
                    end
                end
            end)
        end
    end)
end)

-- [ 4. زر الطيران السريع ]
FlyBtn.Parent = MainFrame
FlyBtn.BackgroundColor3 = Color3.fromRGB(85, 170, 255)
FlyBtn.Position = UDim2.new(0.08, 0, 0.61, 0)
FlyBtn.Size = UDim2.new(0.84, 0, 0, 40)
FlyBtn.Font = Enum.Font.GothamBold
FlyBtn.Text = "تشغيل الطيران (OFF)"
FlyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyBtn.TextSize = 12
UICorner4.Parent = FlyBtn

local flying = false
local bg, bv

FlyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    local char = game.Players.LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart

    if flying then
        FlyBtn.Text = "إيقاف الطيران (ON)"
        FlyBtn.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
        
        bv = Instance.new("BodyVelocity")
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Parent = hrp

        bg = Instance.new("BodyGyro")
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.CFrame = hrp.CFrame
        bg.Parent = hrp

        task.spawn(function()
            while flying and task.wait() do
                local cam = workspace.CurrentCamera
                local moveDir = char.Humanoid.MoveDirection
                bv.Velocity = (cam.CFrame.LookVector * (moveDir.Z * 80)) + (cam.CFrame.RightVector * (moveDir.X * 80))
                bg.CFrame = cam.CFrame
            end
        end)
    else
        FlyBtn.Text = "تشغيل الطيران (OFF)"
        FlyBtn.BackgroundColor3 = Color3.fromRGB(85, 170, 255)
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
    end
end)
