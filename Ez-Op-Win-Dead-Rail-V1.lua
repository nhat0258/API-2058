local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
player.CameraMode = Enum.CameraMode.Classic

-- Thông báo khi bắt đầu script
StarterGui:SetCore("SendNotification", {
    Title = "Enhanced NPC Lock GUI",
    Text = "By NhatNguyenQuang",
    Duration = 3
})

-- Tạo ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Enhanced_NPC_Lock_GUI"
screenGui.Parent = game:GetService("CoreGui")
screenGui.ResetOnSpawn = false

-- Tạo khung chính
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 210)
mainFrame.Position = UDim2.new(0.5, -100, 0.5, -105)
mainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui
mainFrame.Visible = false

local uicorner = Instance.new("UICorner")
uicorner.CornerRadius = UDim.new(0, 12)
uicorner.Parent = mainFrame

-- Nút logo (ngoài khung chính)
local logoButton = Instance.new("TextButton")
logoButton.Size = UDim2.new(0, 50, 0, 50)
logoButton.Position = UDim2.new(0.5, -25, 0.5, -25)
logoButton.BackgroundColor3 = Color3.new(0, 0, 0)
logoButton.TextColor3 = Color3.new(1, 1, 1)
logoButton.Text = "N"
logoButton.Font = Enum.Font.Fantasy
logoButton.TextScaled = true
logoButton.Parent = screenGui

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(0, 12)
logoCorner.Parent = logoButton

-- Hiển thị thời gian (ngoài khung chính, dưới logo)
local startTime = os.time()
local timeLabel = Instance.new("TextLabel")
timeLabel.Size = UDim2.new(0, 100, 0, 30)
timeLabel.Position = UDim2.new(0.5, -50, 0.5, 35)
timeLabel.BackgroundTransparency = 1
timeLabel.TextColor3 = Color3.new(1, 1, 1)
timeLabel.Text = "Time: 0:00"
timeLabel.Font = Enum.Font.Fantasy
timeLabel.TextScaled = true
timeLabel.Parent = screenGui

-- Cấu hình các nút
local buttons = {
    {
        Name = "NPCLockButton",
        Text = "NPC Lock: OFF",
        Position = UDim2.new(0, 10, 0, 10),
        Func = function() end -- Định nghĩa sau
    },
    {
        Name = "NoclipButton",
        Text = "Noclip: OFF",
        Position = UDim2.new(0, 10, 0, 50),
        Func = function() end -- Định nghĩa sau
    },
    {
        Name = "TeleportButton",
        Text = "Teleport To End",
        Position = UDim2.new(0, 10, 0, 90),
        Func = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/ringtaa/newpacifisct/refs/heads/main/newpacifisct.lua"))()
        end
    },
    {
        Name = "HideTimeButton",
        Text = "Hide Time Left",
        Position = UDim2.new(0, 10, 0, 130),
        Func = function()
            timeVisible = not timeVisible
            timeLabel.Visible = timeVisible
            -- Không thay đổi văn bản nút, giữ nguyên "Hide Time Left"
        end
    }
}

-- Tạo các nút
for _, btn in ipairs(buttons) do
    local button = Instance.new("TextButton")
    button.Name = btn.Name
    button.Size = btn.Size or UDim2.new(0, 180, 0, 30)
    button.Position = btn.Position
    button.BackgroundColor3 = btn.BackgroundColor3 or Color3.new(0.2, 0.2, 0.2)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Text = btn.Text
    button.Font = Enum.Font.Fantasy
    button.TextScaled = true
    button.Parent = mainFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button

    button.MouseButton1Click:Connect(btn.Func)
end

local hideTimeButton = mainFrame.HideTimeButton
local noclipButton = mainFrame.NoclipButton

-- Chức năng kéo thả cho khung chính
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        update(input)
    end
end)

-- Chức năng kéo thả cho nút logo
local logoDragging, logoDragInput, logoDragStart, logoStartPos
local function updateLogo(input)
    local delta = input.Position - logoDragStart
    logoButton.Position = UDim2.new(logoStartPos.X.Scale, logoStartPos.X.Offset + delta.X, logoStartPos.Y.Scale, logoStartPos.Y.Offset + delta.Y)
    timeLabel.Position = UDim2.new(logoStartPos.X.Scale, logoStartPos.X.Offset + delta.X - 50, logoStartPos.Y.Scale, logoStartPos.Y.Offset + delta.Y + 60)
end

logoButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        logoDragging = true
        logoDragStart = input.Position
        logoStartPos = logoButton.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                logoDragging = false
            end
        end)
    end
end)

logoButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        logoDragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if logoDragging and input == logoDragInput then
        updateLogo(input)
    end
end)

-- Bật/tắt hiển thị GUI
local guiVisible = false
logoButton.MouseButton1Click:Connect(function()
    guiVisible = not guiVisible
    mainFrame.Visible = guiVisible
end)

-- Bộ đếm thời gian
RunService.RenderStepped:Connect(function()
    local elapsed = os.time() - startTime
    local minutes = math.floor(elapsed / 60)
    local seconds = elapsed % 60
    timeLabel.Text = string.format("Time: %d:%02d", minutes, seconds)
    if elapsed >= 600 then
        timeLabel.TextColor3 = Color3.new(1, 0, 0)
    end
end)

-- Hiển thị thời gian
local timeVisible = true

-- Chức năng Full Bright (ẩn)
local function enableFullBright()
    Lighting.Ambient = Color3.new(1, 1, 1)
    Lighting.Brightness = 2
    Lighting.GlobalShadows = false
end
enableFullBright()

-- Chức năng Instant Interact (ẩn)
local instantInteractConnection
local function enableInstantInteract()
    instantInteractConnection = RunService.Heartbeat:Connect(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and (obj:FindFirstChild("TouchInterest") or obj.Name:lower():match("interact")) then
                    local distance = (obj.Position - player.Character.HumanoidRootPart.Position).Magnitude
                    if distance < 10 then
                        firetouchinterest(player.Character.HumanoidRootPart, obj, 0)
                        firetouchinterest(player.Character.HumanoidRootPart, obj, 1)
                    end
                end
            end
        end
    end)
end
enableInstantInteract()

-- Chức năng NPC Lock
local npcLock = false
local lastTarget = nil
local toggleLoop

local function addPlayerHighlight()
    if player.Character then
        local highlight = player.Character:FindFirstChild("PlayerHighlightESP")
        if not highlight then
            highlight = Instance.new("Highlight")
            highlight.Name = "PlayerHighlightESP"
            highlight.FillColor = Color3.new(1, 1, 1)
            highlight.OutlineColor = Color3.new(1, 1, 1)
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0
            highlight.Parent = player.Character
        end
    end
end

local function removePlayerHighlight()
    if player.Character and player.Character:FindFirstChild("PlayerHighlightESP") then
        player.Character.PlayerHighlightESP:Destroy()
    end
end

local function getClosestNPC()
    local closestNPC = nil
    local closestDistance = math.huge

    for _, object in ipairs(workspace:GetDescendants()) do
        if object:IsA("Model") then
            local humanoid = object:FindFirstChild("Humanoid") or object:FindFirstChildWhichIsA("Humanoid")
            local hrp = object:FindFirstChild("HumanoidRootPart") or object.PrimaryPart
            if humanoid and hrp and humanoid.Health > 0 and object.Name ~= "Horse" then
                local isPlayer = false
                for _, pl in ipairs(Players:GetPlayers()) do
                    if pl.Character == object then
                        isPlayer = true
                        break
                    end
                end
                if not isPlayer then
                    local distance = (hrp.Position - player.Character.HumanoidRootPart.Position).Magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        closestNPC = object
                    end
                end
            end
        end
    end

    return closestNPC
end

local npcLockButton = mainFrame.NPCLockButton
npcLockButton.MouseButton1Click:Connect(function()
    npcLock = not npcLock
    npcLockButton.Text = "NPC Lock: " .. (npcLock and "ON" or "OFF")
    StarterGui:SetCore("SendNotification", {
        Title = "NPC Lock",
        Text = npcLock and "Đã kích hoạt" or "Đã tắt",
        Duration = 2
    })
    if npcLock then
        toggleLoop = RunService.RenderStepped:Connect(function()
            local npc = getClosestNPC()
            if npc and npc:FindFirstChild("Humanoid") then
                local npcHumanoid = npc:FindFirstChild("Humanoid")
                if npcHumanoid.Health > 0 then
                    camera.CameraSubject = npcHumanoid
                    lastTarget = npc
                    addPlayerHighlight()
                else
                    StarterGui:SetCore("SendNotification", {
                        Title = "Đã tiêu diệt NPC",
                        Text = npc.Name,
                        Duration = 0.4
                    })
                    lastTarget = nil
                    removePlayerHighlight()
                    if player.Character and player.Character:FindFirstChild("Humanoid") then
                        camera.CameraSubject = player.Character:FindFirstChild("Humanoid")
                    end
                end
            else
                if player.Character and player.Character:FindFirstChild("Humanoid") then
                    camera.CameraSubject = player.Character:FindFirstChild("Humanoid")
                end
                lastTarget = nil
                removePlayerHighlight()
            end
        end)
    else
        if toggleLoop then
            toggleLoop:Disconnect()
            toggleLoop = nil
        end
        removePlayerHighlight()
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            camera.CameraSubject = player.Character:FindFirstChild("Humanoid")
        end
    end
end)

-- Chức năng Noclip
local noclip = false
local noclipConnection
noclipButton.MouseButton1Click:Connect(function()
    noclip = not noclip
    noclipButton.Text = "Noclip: " .. (noclip and "ON" or "OFF")
    StarterGui:SetCore("SendNotification", {
        Title = "Noclip",
        Text = noclip and "Đã kích hoạt" or "Đã tắt",
        Duration = 2
    })
    if noclip then
        noclipConnection = RunService.Stepped:Connect(function()
            if player.Character then
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            -- Tìm bề mặt bên dưới bằng Raycast
            local humanoidRootPart = player.Character.HumanoidRootPart
            local rayOrigin = humanoidRootPart.Position
            local rayDirection = Vector3.new(0, -1000, 0) -- Tìm xuống dưới 1000 stud
            local raycastParams = RaycastParams.new()
            raycastParams.FilterDescendantsInstances = {player.Character}
            raycastParams.FilterType = Enum.RaycastFilterType.Exclude
            local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
            
            if raycastResult then
                -- Di chuyển nhân vật đến bề mặt tìm được (cộng thêm 3 unit để đứng trên sàn)
                local newPosition = raycastResult.Position + Vector3.new(0, 3, 0)
                humanoidRootPart.CFrame = CFrame.new(newPosition)
            else
                -- Nếu không tìm thấy bề mặt, giữ nhân vật ở vị trí hiện tại
                StarterGui:SetCore("SendNotification", {
                    Title = "Noclip",
                    Text = "Không tìm thấy bề mặt bên dưới!",
                    Duration = 2
                })
            end
            
            -- Bật lại CanCollide
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end)

-- Chức năng Quick Lever Interaction (Interact Intense)
local function quickLeverInteract()
    RunService.Heartbeat:Connect(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            for _, lever in pairs(workspace:GetDescendants()) do
                if lever:IsA("BasePart") and lever.Name:lower():match("lever") then
                    local distance = (lever.Position - player.Character.HumanoidRootPart.Position).Magnitude
                    if distance < 5 then
                        firetouchinterest(player.Character.HumanoidRootPart, lever, 0)
                        firetouchinterest(player.Character.HumanoidRootPart, lever, 1)
                    end
                end
            end
        end
    end)
end
quickLeverInteract()
