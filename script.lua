-- إشعار بداية التشغيل
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Clover Hub",
    Text = "تم تحديث السكربت بنجاح!",
    Duration = 5
})

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local AutoWinBtn = Instance.new("TextButton")
local UICorner2 = Instance.new("UICorner")
local FlyBtn = Instance.new("TextButton")
local UICorner3 = Instance.new("UICorner")

ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "CloverHubGUI"

MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -100)
MainFrame.Size = UDim2.new(0, 250, 0, 220)
MainFrame.Active = true
MainFrame.Draggable = true

UICorner.Parent = MainFrame

Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.GothamBold
Title.Text = "Speed Keyboard Escape"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14

-- زر التفريم المحدث للمنصة المحددة (+1 Win)
AutoWinBtn.Parent = MainFrame
AutoWinBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 127)
AutoWinBtn.Position = UDim2.new(0.1, 0, 0.3, 0)
AutoWinBtn.Size = UDim2.new(0.8, 0, 0, 45)
AutoWinBtn.Font = Enum.Font.GothamBold
AutoWinBtn.Text = "تجميع الكؤوس وفوز تلقائي (OFF)"
AutoWinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoWinBtn.TextSize = 12
UICorner2.Parent = AutoWinBtn

local autoWinActive = false
AutoWinBtn.MouseButton1Click:Connect(function()
    autoWinActive = not autoWinActive
    if autoWinActive then
        AutoWinBtn.Text = "إيقاف تجميع الكؤوس (ON)"
        AutoWinBtn.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
    else
        AutoWinBtn.Text = "تجميع الكؤوس وفوز تلقائي (OFF)"
        AutoWinBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 127)
    end
    
    task.spawn(function()
        while autoWinActive do
            task.wait(0.15)
            pcall(function()
                local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if not autoWinActive then break end
                        -- استهداف منصات الفوز والكؤوس بدقة بناءً على الماب
                        if obj:IsA("BasePart") and (obj.Name:lower():find("win") or obj.Name:lower():find("trophy") or obj.Name:lower():find("cup") or obj.Name:lower():find("pad")) then
                            -- التحقق من أن حجم المنصة مناسب لمنصة الفوز لتجنب الأماكن العشوائية
                            if obj.Size.Y < 10 then
                                hrp.CFrame = obj.CFrame + Vector3.new(0, 3, 0)
                                task.wait(0.3)
                            end
                        end
                    end
                end
            end)
        end
    end)
end)

-- زر الطيران المحدث (مصحح الاتجاه والسرعة)
FlyBtn.Parent = MainFrame
FlyBtn.BackgroundColor3 = Color3.fromRGB(85, 170, 255)
FlyBtn.Position = UDim2.new(0.1, 0, 0.65, 0)
FlyBtn.Size = UDim2.new(0.8, 0, 0, 45)
FlyBtn.Font = Enum.Font.GothamBold
FlyBtn.Text = "تشغيل الطيران السريع (OFF)"
FlyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyBtn.TextSize = 13
UICorner3.Parent = FlyBtn

local flying = false
local bg, bv
local flySpeed = 70 -- سرعة الطيران السريعة

FlyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    local char = game.Players.LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart

    if flying then
        FlyBtn.Text = "إيقاف الطيران السريع (ON)"
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
                -- تم ضبط اتجاه الحركة ليتبع العصا للأمام بشكل صحيح وبسرعة عالية
                bv.Velocity = (cam.CFrame.LookVector * (moveDir.Z * flySpeed)) + (cam.CFrame.RightVector * (moveDir.X * flySpeed)) + Vector3.new(0, moveDir.Y * flySpeed, 0)
                bg.CFrame = cam.CFrame
            end
        end)
    else
        FlyBtn.Text = "تشغيل الطيران السريع (OFF)"
        FlyBtn.BackgroundColor3 = Color3.fromRGB(85, 170, 255)
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
    end
end)
