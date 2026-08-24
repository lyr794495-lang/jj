-- إشعار التحديث
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Clover Hub",
    Text = "تم تفعيل المشي التلقائي و Godmode بنجاح!",
    Duration = 4
})

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local AutoWalkBtn = Instance.new("TextButton")
local UICorner2 = Instance.new("UICorner")
local GodModeBtn = Instance.new("TextButton")
local UICorner3 = Instance.new("UICorner")
local FlyBtn = Instance.new("TextButton")
local UICorner4 = Instance.new("UICorner")

ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "CloverHubGUI"

MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Position = UDim2.new(0.5, -130, 0.4, -120)
MainFrame.Size = UDim2.new(0, 260, 0, 270)
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

-- [ 1. زر المشي التلقائي السريع نحو خط النهاية ]
AutoWalkBtn.Parent = MainFrame
AutoWalkBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 127)
AutoWalkBtn.Position = UDim2.new(0.08, 0, 0.2, 0)
AutoWalkBtn.Size = UDim2.new(0.84, 0, 0, 45)
AutoWalkBtn.Font = Enum.Font.GothamBold
AutoWalkBtn.Text = "مشي تلقائي سريع للكأس (OFF)"
AutoWalkBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoWalkBtn.TextSize = 12
UICorner2.Parent = AutoWalkBtn

local autoWalkActive = false
AutoWalkBtn.MouseButton1Click:Connect(function()
    autoWalkActive = not autoWalkActive
    if autoWalkActive then
        AutoWalkBtn.Text = "إيقاف المشي التلقائي (ON)"
        AutoWalkBtn.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
    else
        AutoWalkBtn.Text = "مشي تلقائي سريع للكأس (OFF)"
        AutoWalkBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 127)
    end

    task.spawn(function()
        local TweenService = game:GetService("TweenService")
        while autoWalkActive do
            task.wait(0.1)
            pcall(function()
                local char = game.Players.LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    -- البحث عن منصة Win أو الكأس المحددة
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if not autoWalkActive then break end
                        if obj:IsA("BasePart") and (obj.Name == "Win" or obj.Name == "WinPad" or obj.Name:lower():find("win")) then
                            local targetCFrame = obj.CFrame + Vector3.new(0, 3, 0)
                            local distance = (hrp.Position - targetCFrame.Position).Magnitude
                            
                            -- التحرك السريع المباشر (Tween) إلى خط النهاية بدون تنقل عشوائي
                            local speed = 150 -- سرعة التحرك
                            local tweenInfo = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)
                            local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
                            tween:Play()
                            tween.Completed:Wait()
                            task.wait(0.2)
                        end
                    end
                end
            end)
        end
    end)
end)

-- [ 2. ميزة عدم الموت Godmode ]
GodModeBtn.Parent = MainFrame
GodModeBtn.BackgroundColor3 = Color3.fromRGB(170, 85, 255)
GodModeBtn.Position = UDim2.new(0.08, 0, 0.45, 0)
GodModeBtn.Size = UDim2.new(0.84, 0, 0, 45)
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
            task.wait(0.2)
            pcall(function()
                local char = game.Players.LocalPlayer.Character
                if char and char:FindFirstChild("Humanoid") then
                    -- إلغاء حالات الموت والضرر
                    char.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                    if char.Humanoid.Health < char.Humanoid.MaxHealth then
                        char.Humanoid.Health = char.Humanoid.MaxHealth
                    end
                end
                -- إزالة مناطق القتل في الماب تلقائياً
                for _, part in pairs(workspace:GetDescendants()) do
                    if part:IsA("BasePart") and (part.Name:lower():find("kill") or part.Name:lower():find("lava") or part.Name:lower():find("void")) then
                        part.CanTouch = false
                    end
                end
            end)
        end
    end)
end)

-- [ 3. زر الطيران السريع ]
FlyBtn.Parent = MainFrame
FlyBtn.BackgroundColor3 = Color3.fromRGB(85, 170, 255)
FlyBtn.Position = UDim2.new(0.08, 0, 0.7, 0)
FlyBtn.Size = UDim2.new(0.84, 0, 0, 45)
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
