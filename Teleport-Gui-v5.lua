-- Made By NhatNguyenQuang
print("MR.N -- Devemenlopver")

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomTeleportUI"
screenGui.Parent = playerGui

local savedPosition = nil

local logo = Instance.new("TextButton")
logo.Size = UDim2.new(0, 50, 0, 50)
logo.Position = UDim2.new(0, 20, 0.5, -25)
logo.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
logo.Text = "N"
logo.TextColor3 = Color3.new(1, 1, 1)
logo.Font = Enum.Font.GothamBold
logo.TextScaled = true
logo.Draggable = true
logo.Active = true
logo.Parent = screenGui
Instance.new("UICorner", logo).CornerRadius = UDim.new(0, 10)

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 395)
mainFrame.Position = UDim2.new(0.5, -100, 0.5, -197.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BackgroundTransparency = 0.25
mainFrame.Visible = false
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)
local borderMain = Instance.new("UIStroke")
borderMain.Thickness = 5
borderMain.Color = Color3.fromRGB(0, 0, 0)
borderMain.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
borderMain.Parent = mainFrame

local tabButtonsFrame = Instance.new("Frame")
tabButtonsFrame.Size = UDim2.new(1, 0, 0, 35)
tabButtonsFrame.Position = UDim2.new(0, 0, 1, -35)
tabButtonsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
tabButtonsFrame.BackgroundTransparency = 0.25
tabButtonsFrame.Parent = mainFrame
local borderTabs = Instance.new("UIStroke")
borderTabs.Thickness = 5
borderTabs.Color = Color3.fromRGB(0, 0, 0)
borderTabs.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
borderTabs.Parent = tabButtonsFrame

local function createTabButton(name, position)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.5, -2, 1, -2)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.Text = name
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.Gotham
    button.TextSize = 16
    button.TextScaled = false
    button.Parent = tabButtonsFrame
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)
    local border = Instance.new("UIStroke")
    border.Color = Color3.new(1, 1, 1)
    border.Thickness = 1.5
    border.Parent = button
    return button
end

local projectTabButton = createTabButton("Project", UDim2.new(0, 1, 0, 1))
local villageTabButton = createTabButton("Village", UDim2.new(0.5, 1, 0, 1))

local projectTab = Instance.new("ScrollingFrame")
projectTab.Size = UDim2.new(1, 0, 1, -35)
projectTab.Position = UDim2.new(0, 0, 0, 0)
projectTab.BackgroundTransparency = 1
projectTab.Visible = true
projectTab.ScrollingDirection = Enum.ScrollingDirection.Y
projectTab.CanvasSize = UDim2.new(0, 0, 0, 550) -- Tăng CanvasSize để chứa thêm nút
projectTab.ScrollBarThickness = 5
projectTab.Parent = mainFrame

local projectLayout = Instance.new("UIListLayout")
projectLayout.Padding = UDim.new(0, 10)
projectLayout.SortOrder = Enum.SortOrder.LayoutOrder
projectLayout.Parent = projectTab

local villageTab = Instance.new("Frame")
villageTab.Size = UDim2.new(1, 0, 1, -35)
villageTab.Position = UDim2.new(0, 0, 0, 0)
villageTab.BackgroundTransparency = 1
villageTab.Visible = false
villageTab.Parent = mainFrame

local villageLayout = Instance.new("UIListLayout")
villageLayout.Padding = UDim.new(0, 6)
villageLayout.SortOrder = Enum.SortOrder.LayoutOrder
villageLayout.Parent = villageTab

local customTimeoutInput = Instance.new("TextBox")
customTimeoutInput.Size = UDim2.new(1, -20, 0, 45)
customTimeoutInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
customTimeoutInput.TextColor3 = Color3.new(1, 1, 1)
customTimeoutInput.Text = "Timeout (giây): 3.5"
customTimeoutInput.ClearTextOnFocus = false
customTimeoutInput.Font = Enum.Font.Gotham
customTimeoutInput.TextSize = 16
customTimeoutInput.TextScaled = false
customTimeoutInput.TextXAlignment = Enum.TextXAlignment.Left
customTimeoutInput.Parent = projectTab
Instance.new("UICorner", customTimeoutInput).CornerRadius = UDim.new(0, 8)

local countdownLabel = Instance.new("TextLabel")
countdownLabel.Size = UDim2.new(1, -20, 0, 45)
countdownLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
countdownLabel.TextColor3 = Color3.new(1, 1, 1)
countdownLabel.Text = "Thời gian còn lại: -"
countdownLabel.Font = Enum.Font.Gotham
countdownLabel.TextSize = 16
countdownLabel.TextScaled = false
countdownLabel.TextXAlignment = Enum.TextXAlignment.Left
countdownLabel.Parent = projectTab
Instance.new("UICorner", countdownLabel).CornerRadius = UDim.new(0, 8)

local function getCharacter()
    return player.Character or player.CharacterAdded:Wait()
end

local function getClosestSeat()
    local character = getCharacter()
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local closest, minDist = nil, math.huge
    for _, seat in ipairs(workspace:GetDescendants()) do
        if (seat:IsA("Seat") or seat:IsA("VehicleSeat")) and not seat.Occupant then
            local dist = (seat.Position - root.Position).Magnitude
            if dist < minDist then
                minDist = dist
                closest = seat
            end
        end
    end
    return closest
end

local function teleportToSeat(seat)
    local character = getCharacter()
    local root = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildWhichIsA("Humanoid")
    if seat and root and humanoid then
        character:SetPrimaryPartCFrame(CFrame.new(seat.Position + Vector3.new(0, 1.5, 0)))
        seat:Sit(humanoid)
    end
end

local function createTeleportButton(index, position, tab)
    local button = Instance.new("TextButton")
    button.Size = tab == villageTab and UDim2.new(1, -10, 0, 35) or UDim2.new(1, -20, 0, 45)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Text = index
    button.Font = Enum.Font.GothamBold
    button.TextSize = 16
    button.TextScaled = false
    button.Parent = tab
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)

    button.MouseButton1Click:Connect(function()
        local character = getCharacter()
        local root = character:FindFirstChild("HumanoidRootPart")
        if not root then
            print("Không tìm thấy nhân vật!")
            return
        end

        local timeout = tonumber(customTimeoutInput.Text:match("Timeout%s*%([^)]*%)%s*:%s*([%d%.]+)")) or 3.5

        local startTime = tick()
        local initialDuration = 2
        while tick() - startTime < initialDuration do
            character:SetPrimaryPartCFrame(CFrame.new(position + Vector3.new(0, 3, 0)))
            print("Đang dịch chuyển đến " .. index .. "...")
            task.wait(0.1)
        end

        local totalStartTime = tick()
        local seated = false

        while tick() - totalStartTime < timeout do
            local remainingTime = math.max(0, timeout - (tick() - totalStartTime))
            countdownLabel.Text = string.format("Thời gian còn lại: %.1f", remainingTime)
            local seat = getClosestSeat()
            if seat and not seat.Occupant then
                teleportToSeat(seat)
                if seat.Occupant then
                    seated = true
                    print("Đã ngồi vào ghế!")
                    countdownLabel.Text = "Đã ngồi vào ghế!"
                    break
                end
            end
            character:SetPrimaryPartCFrame(CFrame.new(position + Vector3.new(0, 3, 0)))
            task.wait(0.1)
        end

        if not seated then
            print("Không tìm thấy ghế trống trong " .. timeout .. " giây!")
            countdownLabel.Text = "Không tìm thấy ghế trống!"
        end

        task.wait(1)
        countdownLabel.Text = "Thời gian còn lại: -"
    end)
end

-- Hàm tạo nút Sit Nearest Seat
local function createSitNearestSeatButton(tab)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 45)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Text = "Sit Nearest Seat"
    button.Font = Enum.Font.GothamBold
    button.TextSize = 16
    button.TextScaled = false
    button.Parent = tab
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)

    button.MouseButton1Click:Connect(function()
        local seat = getClosestSeat()
        if seat then
            teleportToSeat(seat)
            if seat.Occupant then
                print("Đã ngồi vào ghế gần nhất!")
                countdownLabel.Text = "Đã ngồi vào ghế gần nhất!"
            else
                print("Không thể ngồi vào ghế!")
                countdownLabel.Text = "Không thể ngồi vào ghế!"
            end
        else
            print("Không tìm thấy ghế trống gần đây!")
            countdownLabel.Text = "Không tìm thấy ghế trống!"
        end
        task.wait(1)
        countdownLabel.Text = "Thời gian còn lại: -"
    end)
end

local villagePositions = {
    [1] = Vector3.new(-781.9, 43.8, 21918.8),
    [2] = Vector3.new(-637.0, 38.8, 14085.6),
    [3] = Vector3.new(-299.1, 38.7, 6452.0),
    [4] = Vector3.new(-11.4, 38.2, -1815.9),
    [5] = Vector3.new(-298.4, 40.8, 6427.9),
    [6] = Vector3.new(-1259.8, 41.5, -1887.2),
    [7] = Vector3.new(-945.2, 43.1, -41654.6)
}

for i, pos in ipairs(villagePositions) do
    createTeleportButton("Làng " .. i, pos, villageTab)
end

local positionInput = Instance.new("TextBox")
positionInput.Size = UDim2.new(1, -20, 0, 45)
positionInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
positionInput.TextColor3 = Color3.new(1, 1, 1)
positionInput.Text = "Tọa độ lưu: Chưa có"
positionInput.ClearTextOnFocus = false
positionInput.Font = Enum.Font.Gotham
positionInput.TextSize = 16
positionInput.TextScaled = false
positionInput.TextXAlignment = Enum.TextXAlignment.Left
positionInput.Parent = projectTab
Instance.new("UICorner", positionInput).CornerRadius = UDim.new(0, 8)

local saveButton = Instance.new("TextButton")
saveButton.Size = UDim2.new(1, -20, 0, 45)
saveButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
saveButton.TextColor3 = Color3.new(1, 1, 1)
saveButton.Text = "Lưu Tọa Độ"
saveButton.Font = Enum.Font.GothamBold
saveButton.TextSize = 16
saveButton.TextScaled = false
saveButton.Parent = projectTab
Instance.new("UICorner", saveButton).CornerRadius = UDim.new(0, 8)

local teleportToSavedButton = Instance.new("TextButton")
teleportToSavedButton.Size = UDim2.new(1, -20, 0, 45)
teleportToSavedButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
teleportToSavedButton.TextColor3 = Color3.new(1, 1, 1)
teleportToSavedButton.Text = "Chuyển Đến Tọa Độ"
teleportToSavedButton.Font = Enum.Font.GothamBold
teleportToSavedButton.TextSize = 16
teleportToSavedButton.TextScaled = false
teleportToSavedButton.Parent = projectTab
Instance.new("UICorner", teleportToSavedButton).CornerRadius = UDim.new(0, 8)

createTeleportButton("Teleport To End", Vector3.new(-424.4, 28.1, -49040.7), projectTab)
createTeleportButton("Teleport To Castle", Vector3.new(181.0, 19.2, -9204.2), projectTab)
createTeleportButton("Teleport To Starting Point", Vector3.new(59.7, 12.0, 29876.9), projectTab)

-- Thêm nút Sit Nearest Seat vào projectTab
createSitNearestSeatButton(projectTab)

saveButton.MouseButton1Click:Connect(function()
    local character = getCharacter()
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if root then
        savedPosition = root.Position
        positionInput.Text = string.format("Tọa độ: %.1f, %.1f, %.1f", savedPosition.X, savedPosition.Y, savedPosition.Z)
    else
        positionInput.Text = "Không tìm thấy nhân vật!"
        task.wait(1)
        positionInput.Text = "Tọa độ lưu: Chưa có"
    end
end)

teleportToSavedButton.MouseButton1Click:Connect(function()
    local character = getCharacter()
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then
        positionInput.Text = "Không tìm thấy nhân vật!"
        task.wait(1)
        positionInput.Text = savedPosition and string.format("Tọa độ: %.1f, %.1f, %.1f", savedPosition.X, savedPosition.Y, savedPosition.Z) or "Tọa độ lưu: Chưa có"
        return
    end

    local x, y, z = positionInput.Text:match("([%d%-%.]+)%s*,%s*([%d%-%.]+)%s*,%s*([%d%-%.]+)")
    if x and y and z then
        savedPosition = Vector3.new(tonumber(x), tonumber(y), tonumber(z))
    elseif not savedPosition then
        positionInput.Text = "Chưa có tọa độ lưu!"
        task.wait(1)
        positionInput.Text = "Tọa độ lưu: Chưa có"
        return
    end

    local timeout = tonumber(customTimeoutInput.Text:match("Timeout%s*%([^)]*%)%s*:%s*([%d%.]+)")) or 3.5

    local startTime = tick()
    local initialDuration = 2
    while tick() - startTime < initialDuration do
        character:SetPrimaryPartCFrame(CFrame.new(savedPosition + Vector3.new(0, 3, 0)))
        print("Đang dịch chuyển đến tọa độ đã lưu...")
        task.wait(0.1)
    end

    local totalStartTime = tick()
    local seated = false

    while tick() - totalStartTime < timeout do
        local remainingTime = math.max(0, timeout - (tick() - totalStartTime))
        countdownLabel.Text = string.format("Thời gian còn lại: %.1f", remainingTime)
        local seat = getClosestSeat()
        if seat and not seat.Occupant then
            teleportToSeat(seat)
            if seat.Occupant then
                seated = true
                print("Đã ngồi vào ghế!")
                positionInput.Text = "Đã ngồi vào ghế gần tọa độ!"
                break
            end
        end
        character:SetPrimaryPartCFrame(CFrame.new(savedPosition + Vector3.new(0, 3, 0)))
        task.wait(0.1)
    end

    if not seated then
        print("Không tìm thấy ghế trống trong " .. timeout .. " giây!")
        positionInput.Text = "Không tìm thấy ghế trống!"
    end

    task.wait(1)
    positionInput.Text = savedPosition and string.format("Tọa độ: %.1f, %.1f, %.1f", savedPosition.X, savedPosition.Y, savedPosition.Z) or "Tọa độ lưu: Chưa có"
    countdownLabel.Text = "Thời gian còn lại: -"
end)

-- Thêm nút kéo thả ở góc phải trên cùng
local dragButton = Instance.new("TextButton")
dragButton.Size = UDim2.new(0, 50, 0, 50)
dragButton.Position = UDim2.new(1, -70, 0, 0)
dragButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
dragButton.BackgroundTransparency = 0.5
dragButton.Text = "+"
dragButton.TextColor3 = Color3.new(1, 1, 1)
dragButton.Font = Enum.Font.GothamBold
dragButton.TextScaled = true
dragButton.Parent = mainFrame
Instance.new("UICorner", dragButton).CornerRadius = UDim.new(0, 10)
local borderDrag = Instance.new("UIStroke")
borderDrag.Thickness = 2
borderDrag.Color = Color3.fromRGB(255, 255, 255)
borderDrag.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
borderDrag.Parent = dragButton
dragButton.Draggable = true

-- Sự kiện cho nút kéo thả để chạy script tạo party
dragButton.MouseButton1Click:Connect(function()
    local Players = game:GetService("Players")
    local localPlayer = Players.LocalPlayer
    local playerGui = localPlayer:WaitForChild("PlayerGui")

    -- Đảm bảo nhân vật và HumanoidRootPart đã tải
    local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    -- Các vị trí có thể dùng để tạo party
    local partyPositions = {
        Vector3.new(44.5, 7.8, 100.8),
        Vector3.new(44.5, 7.6, 115.8),
        Vector3.new(44.5, 7.6, 130.8),
        Vector3.new(44.5, 7.6, 145.8),
    }

    local safeDistance = 7 -- khoảng cách tối thiểu từ người khác
    local maxWaitTime = 5 -- thời gian tối đa chờ giao diện xuất hiện

    -- Kiểm tra có người khác gần vị trí không
    local function isOccupied(pos)
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (player.Character.HumanoidRootPart.Position - pos).Magnitude
                if dist < safeDistance then
                    return true
                end
            end
        end
        return false
    end

    -- Tìm vị trí trống
    local function findSafePartyPosition()
        for _, pos in ipairs(partyPositions) do
            if not isOccupied(pos) then
                return pos
            end
        end
        return nil
    end

    -- Tìm giao diện "Tạo Nhóm" và nút có chứa chữ "Tạo"
    local function findCreateButton()
        local startTime = tick()
        while (tick() - startTime) < maxWaitTime do
            for _, gui in ipairs(playerGui:GetDescendants()) do
                if gui:IsA("TextLabel") and gui.Text == "Tạo Nhóm" then
                    for _, child in ipairs(gui.Parent:GetDescendants()) do
                        if child:IsA("TextButton") and child.Text and string.find(child.Text:lower(), "tạo") then
                            return child
                        end
                    end
                end
            end
            task.wait(0.1)
        end
        return nil
    end

    -- Chọn chế độ (Bình thường hoặc Khó) dựa trên tên nút
    local function selectMode(mode)
        local startTime = tick()
        while (tick() - startTime) < maxWaitTime do
            for _, gui in ipairs(playerGui:GetDescendants()) do
                if gui:IsA("TextLabel") and gui.Text == "Tạo Nhóm" then
                    for _, child in ipairs(gui.Parent:GetDescendants()) do
                        if child:IsA("TextButton") and child.Text == mode then
                            pcall(function()
                                child:Activate()
                                print("Đã chọn chế độ:", mode)
                            end)
                            return true
                        end
                    end
                end
            end
            task.wait(0.1)
        end
        warn("Không tìm thấy nút chế độ:", mode)
        return false
    end

    -- Thực hiện toàn bộ quá trình tạo party
    local function autoCreateParty()
        local pos = findSafePartyPosition()
        if not pos then
            warn("Không có vị trí party trống.")
            return
        end

        humanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
        print("Đã di chuyển đến vị trí:", pos)

        task.wait(1)

        if not selectMode("Bình thường") then
            warn("Không thể chọn chế độ Bình thường.")
            return
        end

        local createButton = findCreateButton()
        if createButton then
            pcall(function()
                createButton:Activate()
                print("Đã bấm nút Tạo.")
            end)
        else
            warn("Không tìm thấy nút Tạo sau", maxWaitTime, "giây.")
            return
        end

        task.wait(1)
        for _, gui in ipairs(playerGui:GetDescendants()) do
            if gui:IsA("TextLabel") and string.find(gui.Text, "Trốn thoát sang Mexico!") then
                print("Party đã được tạo thành công!")
                break
            end
        end
    end

    autoCreateParty()
end)

logo.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

projectTabButton.MouseButton1Click:Connect(function()
    projectTab.Visible = true
    villageTab.Visible = false
end)

villageTabButton.MouseButton1Click:Connect(function()
    projectTab.Visible = false
    villageTab.Visible = true
end)
