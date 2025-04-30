print("MR.N -- Developer")
--// Services
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Cam = workspace.CurrentCamera

--// Variables
local fov = 136
local isAiming = false
local isESPEnabled = false
local validPlayers = {}
local draggingSlider = false
local ESPHandles = {} -- Lưu trữ các Highlight và Line
local MAX_ESP_DISTANCE = 1000 -- Khoảng cách tối đa để hiển thị ESP (studs)
local isMenuVisible = true

--// Create Drawing
local FOVring = Drawing.new("Circle")
FOVring.Visible = false
FOVring.Thickness = 2
FOVring.Color = Color3.fromRGB(128, 0, 128)
FOVring.Filled = false
FOVring.Radius = fov
FOVring.Position = Cam.ViewportSize / 2

--// GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "AimbotGUI"

-- Logo mới (Chữ "N", nền đen, kéo thả, ẩn/hiện menu, gấp 1,5 kích thước ban đầu)
local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.new(0, 45, 0, 45) -- Tăng từ 30x30 thành 45x45 (30*1.5)
Logo.Position = UDim2.new(0, 20, 0, 20)
Logo.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Logo.Text = "N"
Logo.TextColor3 = Color3.fromRGB(255, 255, 255)
Logo.TextScaled = true
Logo.Parent = ScreenGui
Logo.Active = true
local UICornerLogo = Instance.new("UICorner", Logo)
UICornerLogo.CornerRadius = UDim.new(0, 8)

-- Main Frame (Khôi phục kích thước ban đầu)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 230)
MainFrame.Position = UDim2.new(0, 20, 0, 60)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Parent = ScreenGui
MainFrame.Active = true
local UICornerFrame = Instance.new("UICorner", MainFrame)
UICornerFrame.CornerRadius = UDim.new(0, 8)

-- Tiêu đề "Nexus | True v2"
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -20, 0, 30)
TitleLabel.Position = UDim2.new(0, 10, 0, 10)
TitleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TitleLabel.Text = "Nexus | True v2"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextScaled = true
TitleLabel.Parent = MainFrame
local UICornerTitle = Instance.new("UICorner", TitleLabel)
UICornerTitle.CornerRadius = UDim.new(0, 8)

-- Close Button (Nút tắt ở góc trên bên phải)
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -40, 0, 10)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextScaled = true
CloseButton.Parent = MainFrame
local UICornerClose = Instance.new("UICorner", CloseButton)
UICornerClose.CornerRadius = UDim.new(0, 8)

-- Toggle Button (Aimbot)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(1, -20, 0, 30)
ToggleButton.Position = UDim2.new(0, 10, 0, 50)
ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ToggleButton.Text = "Bật Aimbot"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextScaled = true
ToggleButton.Parent = MainFrame
local UICornerToggle = Instance.new("UICorner", ToggleButton)
UICornerToggle.CornerRadius = UDim.new(0, 8)

-- ESP Toggle Button
local ESPButton = Instance.new("TextButton")
ESPButton.Size = UDim2.new(1, -20, 0, 30)
ESPButton.Position = UDim2.new(0, 10, 0, 90)
ESPButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ESPButton.Text = "Bật ESP"
ESPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPButton.TextScaled = true
ESPButton.Parent = MainFrame
local UICornerESP = Instance.new("UICorner", ESPButton)
UICornerESP.CornerRadius = UDim.new(0, 8)

-- FOV Label
local FOVLabel = Instance.new("TextLabel")
FOVLabel.Size = UDim2.new(1, -20, 0, 20)
FOVLabel.Position = UDim2.new(0, 10, 0, 130)
FOVLabel.BackgroundTransparency = 1
FOVLabel.Text = "FOV: "..fov
FOVLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FOVLabel.TextScaled = true
FOVLabel.Parent = MainFrame

-- FOV Slider Background
local SliderBackground = Instance.new("Frame")
SliderBackground.Size = UDim2.new(1, -20, 0, 10)
SliderBackground.Position = UDim2.new(0, 10, 0, 160)
SliderBackground.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SliderBackground.Parent = MainFrame
local UICornerSliderBG = Instance.new("UICorner", SliderBackground)
UICornerSliderBG.CornerRadius = UDim.new(0, 8)

-- FOV Slider Fill
local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new(fov/500, 0, 1, 0)
SliderFill.Position = UDim2.new(0, 0, 0, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(128, 0, 128)
SliderFill.Parent = SliderBackground
local UICornerSliderFill = Instance.new("UICorner", SliderFill)
UICornerSliderFill.CornerRadius = UDim.new(0, 8)

--// Dragging Function (Ngăn kéo MainFrame khi kéo Slider)
local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                   startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if not draggingSlider then -- Chỉ kéo nếu không kéo Slider
                dragging = true
                dragStart = input.Position
                startPos = frame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging and not draggingSlider then -- Ngăn kéo khi kéo Slider
            update(input)
        end
    end)
end

makeDraggable(MainFrame)
makeDraggable(Logo)

--// Menu Toggle Function
local function toggleMenu()
    isMenuVisible = not isMenuVisible
    MainFrame.Visible = isMenuVisible
end

--// Logo Click to Toggle Menu
Logo.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        toggleMenu()
    end
end)

--// Close Button Click
CloseButton.MouseButton1Click:Connect(function()
    -- Xóa GUI
    ScreenGui:Destroy()
    -- Xóa FOVring
    FOVring:Remove()
    -- Xóa tất cả ESP
    for obj, handles in pairs(ESPHandles) do
        if handles.Highlight then handles.Highlight:Destroy() end
        if handles.Line then handles.Line:Remove() end
    end
    ESPHandles = {}
end)

--// Hàm kiểm tra xem game có đội hay không
local function hasTeams()
    if LocalPlayer.Team ~= nil then
        return true
    end
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Team ~= nil then
            return true
        end
    end
    return false
end

--// ESP Functions
local function CreateESP(playerChar)
    local part = playerChar:FindFirstChild("HumanoidRootPart")
    local humanoid = playerChar:FindFirstChild("Humanoid")
    if not playerChar or not part or not humanoid or humanoid.Health <= 0 then return end

    if ESPHandles[playerChar] then return end

    -- Tạo Highlight
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.Adornee = playerChar
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
    highlight.FillTransparency = 0.7
    highlight.OutlineTransparency = 0
    highlight.Parent = playerChar

    -- Tạo Line
    local line = Drawing.new("Line")
    line.Visible = false -- Mặc định ẩn, chỉ hiển thị khi cần
    line.Color = Color3.fromRGB(255, 0, 0) -- Màu đỏ cho tất cả
    line.Thickness = 2
    line.Transparency = 1

    ESPHandles[playerChar] = {Highlight = highlight, Line = line}

    -- Lắng nghe sự kiện nhân vật chết
    humanoid.Died:Connect(function()
        if ESPHandles[playerChar] then
            ESPHandles[playerChar].Highlight:Destroy()
            ESPHandles[playerChar].Line:Remove()
            ESPHandles[playerChar] = nil
        end
    end)

    -- Lắng nghe khi Character bị thay đổi (tái sinh)
    local player = Players:GetPlayerFromCharacter(playerChar)
    if player then
        player.CharacterAppearanceLoaded:Connect(function(newChar)
            if ESPHandles[playerChar] then
                ESPHandles[playerChar].Highlight:Destroy()
                ESPHandles[playerChar].Line:Remove()
                ESPHandles[playerChar] = nil
            end
        end)
    end
end

local function ClearESP()
    for obj, handles in pairs(ESPHandles) do
        if handles.Highlight then handles.Highlight:Destroy() end
        if handles.Line then handles.Line:Remove() end
    end
    ESPHandles = {}
end

--// Hàm dọn dẹp ESP không hợp lệ
local function CleanInvalidESP()
    for char, handles in pairs(ESPHandles) do
        local humanoid = char:FindFirstChild("Humanoid")
        local rootPart = char:FindFirstChild("HumanoidRootPart")
        if not char.Parent or not humanoid or not rootPart or humanoid.Health <= 0 then
            if handles.Highlight then handles.Highlight:Destroy() end
            if handles.Line then handles.Line:Remove() end
            ESPHandles[char] = nil
        end
    end
end

--// Aimbot Logic
local function isPlayer(obj)
    return obj:IsA("Model")
        and obj:FindFirstChild("Humanoid")
        and obj:FindFirstChild("Head")
        and obj:FindFirstChild("HumanoidRootPart")
        and obj:FindFirstChild("Humanoid").Health > 0 -- Đảm bảo người chơi còn sống
        and Players:GetPlayerFromCharacter(obj)
end

local function updatePlayers()
    validPlayers = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and isPlayer(player.Character) then
            table.insert(validPlayers, player.Character)
        end
    end
end

local function updateDrawings()
    if Cam.ViewportSize.X > 0 and Cam.ViewportSize.Y > 0 then
        FOVring.Position = Cam.ViewportSize / 2
        FOVring.Radius = fov * (Cam.ViewportSize.Y / 1080)
    end
end

local function predictPos(target)
    local head = target:FindFirstChild("Head")
    local rootPart = target:FindFirstChild("HumanoidRootPart")
    if not head or not rootPart then return nil end
    local velocity = rootPart.Velocity or Vector3.zero
    local predictionTime = 0.02
    return head.Position + velocity * predictionTime
end

local function getTarget()
    local nearest = nil
    local minDistance = math.huge
    local viewportCenter = Cam.ViewportSize / 2
    local useTeams = hasTeams() -- Kiểm tra xem game có đội hay không
    for _, target in ipairs(validPlayers) do
        local targetPlayer = Players:GetPlayerFromCharacter(target)
        local humanoid = target:FindFirstChild("Humanoid")
        if targetPlayer and humanoid and humanoid.Health > 0 then -- Thêm kiểm tra Health trong getTarget
            if not useTeams or (useTeams and targetPlayer.Team ~= LocalPlayer.Team) then
                local predictedPos = predictPos(target)
                if predictedPos then
                    local screenPos, visible = Cam:WorldToViewportPoint(predictedPos)
                    if visible and screenPos.Z > 0 then
                        local distance = (Vector2.new(screenPos.X, screenPos.Y) - viewportCenter).Magnitude
                        if distance < minDistance and distance < fov then
                            minDistance = distance
                            nearest = target
                        end
                    end
                end
            end
        end
    end
    return nearest
end

local function aim(targetPosition)
    if not targetPosition then return end
    local currentCF = Cam.CFrame
    local targetDirection = (targetPosition - currentCF.Position).Unit
    if targetDirection.Magnitude > 0 then
        local smoothFactor = 0.581
        local newLookVector = currentCF.LookVector:Lerp(targetDirection, smoothFactor)
        Cam.CFrame = CFrame.new(currentCF.Position, currentCF.Position + newLookVector)
    end
end

--// Main Update
RunService.RenderStepped:Connect(function()
    local success, err = pcall(function()
        updateDrawings()

        if draggingSlider then
            local mousePosX = UserInputService:GetMouseLocation().X
            local start = SliderBackground.AbsolutePosition.X
            local width = SliderBackground.AbsoluteSize.X
            if width > 0 then
                local percent = math.clamp((mousePosX - start) / width, 0, 1)
                fov = math.floor(30 + percent * (500 - 30))
                FOVLabel.Text = "FOV: "..fov
                SliderFill.Size = UDim2.new(percent, 0, 1, 0)
            end
        end

        if isAiming then
            updatePlayers()
            local target = getTarget()
            if target then
                local predictedPosition = predictPos(target)
                if predictedPosition then
                    aim(predictedPosition)
                end
            end
        end

        -- ESP Logic
        if isESPEnabled then
            updatePlayers()
            CleanInvalidESP() -- Dọn dẹp ESP không hợp lệ
            local localRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local viewportCenter = Cam.ViewportSize / 2
            if localRoot then
                local playerPos = localRoot.Position
                local useTeams = hasTeams()
                for _, playerChar in ipairs(validPlayers) do
                    local targetPlayer = Players:GetPlayerFromCharacter(playerChar)
                    if targetPlayer then
                        local npcRoot = playerChar:FindFirstChild("HumanoidRootPart")
                        local humanoid = playerChar:FindFirstChild("Humanoid")
                        if npcRoot and humanoid and humanoid.Health > 0 then
                            local npcPos = npcRoot.Position
                            local distance = (npcPos - playerPos).Magnitude
                            if distance <= MAX_ESP_DISTANCE then
                                if not useTeams or (useTeams and targetPlayer.Team ~= LocalPlayer.Team) then
                                    if not ESPHandles[playerChar] then
                                        CreateESP(playerChar)
                                    end
                                    local handles = ESPHandles[playerChar]
                                    if handles and handles.Line then
                                        local screenPos, visible = Cam:WorldToViewportPoint(npcPos)
                                        handles.Line.Visible = true
                                        handles.Line.From = viewportCenter
                                        handles.Line.To = Vector2.new(screenPos.X, screenPos.Y)
                                        handles.Line.Color = Color3.fromRGB(255, 0, 0) -- Màu đỏ cho cả phía trước và phía sau
                                    end
                                end
                            elseif ESPHandles[playerChar] then
                                ESPHandles[playerChar].Highlight:Destroy()
                                ESPHandles[playerChar].Line:Remove()
                                ESPHandles[playerChar] = nil
                            end
                        elseif ESPHandles[playerChar] then
                            ESPHandles[playerChar].Highlight:Destroy()
                            ESPHandles[playerChar].Line:Remove()
                            ESPHandles[playerChar] = nil
                        end
                    end
                end
            end
        else
            ClearESP()
        end
    end)
    if not success then
        warn("Error in RenderStepped: " .. err)
    end
end)

--// Inputs
ToggleButton.MouseButton1Click:Connect(function()
    isAiming = not isAiming
    FOVring.Visible = isAiming
    ToggleButton.Text = isAiming and "Tắt Aimbot" or "Bật Aimbot"
end)

ESPButton.MouseButton1Click:Connect(function()
    isESPEnabled = not isESPEnabled
    ESPButton.Text = isESPEnabled and "Tắt ESP" or "Bật ESP"
end)

SliderBackground.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingSlider = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingSlider = false
    end
end)

-- Optimize player list updates
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function(char)
            updatePlayers()
        end)
    end
    updatePlayers()
end)

Players.PlayerRemoving:Connect(function(player)
    if player.Character and ESPHandles[player.Character] then
        ESPHandles[player.Character].Highlight:Destroy()
        ESPHandles[player.Character].Line:Remove()
        ESPHandles[player.Character] = nil
    end
    updatePlayers()
end)

updatePlayers()
