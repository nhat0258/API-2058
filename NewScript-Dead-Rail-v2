print("MR.N -- Developer")

-- Dịch vụ cần thiết
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local LocalizationService = game:GetService("LocalizationService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Biến lưu trữ countryCode để tránh gọi API nhiều lần
local cachedCountryCode = nil

-- Biến trạng thái
local isAiming = false
local isNoClip = false
local isESPEnabledMobs = false
local isESPEnabledItems = false
local MAX_ESP_DISTANCE = 100
local validNPCs = {}
local ESPHandles = {}
local fov = 136
local FOVring = Drawing.new("Circle")
FOVring.Visible = false
FOVring.Thickness = 2
FOVring.Color = Color3.fromRGB(255, 0, 0) -- Đỏ
FOVring.Filled = false
FOVring.Radius = fov

local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

-- Lưu trạng thái cho Noclip
local originalCollideStates = {}

-- Hàm lấy quốc gia của người chơi
local function getPlayerCountry()
    if cachedCountryCode then
        return cachedCountryCode
    end

    local function tryApi(url, field)
        local success, result = pcall(function()
            local response
            local co = coroutine.create(function()
                response = HttpService:GetAsync(url)
            end)
            coroutine.resume(co)
            local elapsed = 0
            local timeout = 3
            while coroutine.status(co) ~= "dead" and elapsed < timeout do
                task.wait(0.1)
                elapsed += 0.1
            end
            if coroutine.status(co) ~= "dead" then
                return nil
            end
            local data = HttpService:JSONDecode(response)
            return data[field]
        end)
        return success and result or nil
    end

    local countryCode = tryApi("http://ip-api.com/json", "countryCode")
    if countryCode then
        cachedCountryCode = countryCode
        return countryCode
    end

    countryCode = tryApi("https://ipinfo.io/json", "country")
    if countryCode then
        cachedCountryCode = countryCode
        return countryCode
    end

    local success, locale = pcall(function()
        return LocalizationService:GetCountryRegionForPlayerAsync(LocalPlayer)
    end)
    if success and locale == "VN" then
        cachedCountryCode = "VN"
        return "VN"
    end

    warn("Không thể lấy thông tin quốc gia")
    cachedCountryCode = "Unknown"
    return nil
end

-- Hàm tìm ghế điều khiển trên tàu
local function findConductorSeat()
    local train = workspace:FindFirstChild("Train")
    if not train then
        return nil, "Không tìm thấy Train trong workspace", "Train not found in workspace"
    end

    local trainControls = train:FindFirstChild("TrainControls")
    if not trainControls then
        return nil, "Không tìm thấy TrainControls trong Train", "TrainControls not found in Train"
    end

    local conductorSeat = trainControls:FindFirstChild("ConductorSeat")
    if not conductorSeat then
        return nil, "Không tìm thấy ConductorSeat trong TrainControls", "ConductorSeat not found in TrainControls"
    end

    local vehicleSeat = conductorSeat:FindFirstChild("VehicleSeat")
    if not vehicleSeat then
        return nil, "Không tìm thấy VehicleSeat trong ConductorSeat", "VehicleSeat not found in ConductorSeat"
    end

    return vehicleSeat, nil, nil
end

-- Hàm khiến nhân vật ngồi vào ghế
local function sitInConductorSeat(isVietnamese)
    local character = LocalPlayer.Character
    if not character then
        return false, "Không tìm thấy nhân vật của người chơi", "Player character not found"
    end

    local hrp = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")
    if not hrp or not humanoid then
        return false, "Không tìm thấy HumanoidRootPart hoặc Humanoid", "HumanoidRootPart or Humanoid not found"
    end

    local trainSeat, errorVN, errorEN = findConductorSeat()
    if not trainSeat then
        return false, errorVN, errorEN
    end

    hrp.CFrame = trainSeat.CFrame + Vector3.new(0, 3, 0)
    task.wait(0.1)
    trainSeat:Sit(humanoid)
    return true, "Đã ngồi vào ghế điều khiển thành công!", "Successfully sat in conductor seat!"
end

-- Hàm thực thi script dịch chuyển
local function teleportToCastle()
    local success, result = pcall(function()
        local scriptContent = game:HttpGet("https://raw.githubusercontent.com/ringtaa/castletpfast.github.io/refs/heads/main/FASTCASTLE.lua")
        local func = loadstring(scriptContent)
        if func then
            func()
            return true, "Đã dịch chuyển đến lâu đài thành công!", "Successfully teleported to castle!"
        else
            return false, "Không thể thực thi script dịch chuyển đến lâu đài", "Failed to execute castle teleport script"
        end
    end)
    if not success then
        return false, "Lỗi khi tải script lâu đài: " .. tostring(result), "Error loading castle script: " .. tostring(result)
    end
    return result
end

local function teleportToTeslaLab()
    local success, result = pcall(function()
        local scriptContent = game:HttpGet("https://raw.githubusercontent.com/ringtaa/tptotesla.github.io/refs/heads/main/Tptotesla.lua")
        local func = loadstring(scriptContent)
        if func then
            func()
            return true, "Đã dịch chuyển đến phòng thí nghiệm Tesla thành công!", "Successfully teleported to Tesla lab!"
        else
            return false, "Không thể thực thi script dịch chuyển đến Tesla", "Failed to execute Tesla teleport script"
        end
    end)
    if not success then
        return false, "Lỗi khi tải script Tesla: " .. tostring(result), "Error loading Tesla script: " .. tostring(result)
    end
    return result
end

local function teleportToFort()
    local success, result = pcall(function()
        local scriptContent = game:HttpGet("https://raw.githubusercontent.com/ringtaa/Tpfort.github.io/refs/heads/main/Tpfort.lua")
        local func = loadstring(scriptContent)
        if func then
            func()
            return true, "Đã dịch chuyển đến Fort thành công!", "Successfully teleported to Fort!"
        else
            return false, "Không thể thực thi script dịch chuyển đến Fort", "Failed to execute Fort teleport script"
        end
    end)
    if not success then
        return false, "Lỗi khi tải script Fort: " .. tostring(result), "Error loading Fort script: " .. tostring(result)
    end
    return result
end

local function teleportToSterlingTown()
    local success, result = pcall(function()
        local scriptContent = game:HttpGet("https://raw.githubusercontent.com/ringtaa/sterlingnotifcation.github.io/refs/heads/main/Sterling.lua")
        local func = loadstring(scriptContent)
        if func then
            func()
            return true, "Đã dịch chuyển đến Sterling Town thành công!", "Successfully teleported to Sterling Town!"
        else
            return false, "Không thể thực thi script dịch chuyển đến Sterling Town", "Failed to execute Sterling Town teleport script"
        end
    end)
    if not success then
        return false, "Lỗi khi tải script Sterling Town: " .. tostring(result), "Error loading Sterling Town script: " .. tostring(result)
    end
    return result
end

local function teleportToEnd()
    local success, result = pcall(function()
        local scriptContent = game:HttpGet("https://raw.githubusercontent.com/ringtaa/newpacifisct/refs/heads/main/newpacifisct.lua")
        local func = loadstring(scriptContent)
        if func then
            func()
            return true, "Đã dịch chuyển đến End thành công!", "Successfully teleported to End!"
        else
            return false, "Không thể thực thi script dịch chuyển đến End", "Failed to execute End teleport script"
        end
    end)
    if not success then
        return false, "Lỗi khi tải script End: " .. tostring(result), "Error loading End script: " .. tostring(result)
    end
    return result
end

local function teleportToFarm()
    local success, result = pcall(function()
        local scriptContent = game:HttpGet("https://raw.githubusercontent.com/ringtaa/tpfarm.github.io/refs/heads/main/tptofarm.lua")
        local func = loadstring(scriptContent)
        if func then
            func()
            return true, "Đã dịch chuyển đến Farm thành công!", "Successfully teleported to Farm!"
        else
            return false, "Không thể thực thi script dịch chuyển đến Farm", "Failed to execute Farm teleport script"
        end
    end)
    if not success then
        return false, "Lỗi khi tải script Farm: " .. tostring(result), "Error loading Farm script: " .. tostring(result)
    end
    return result
end

local function teleportToBank()
    local success, result = pcall(function()
        local scriptContent = game:HttpGet("https://raw.githubusercontent.com/ringtaa/Tptobank.github.io/refs/heads/main/Banktp.lua")
        local func = loadstring(scriptContent)
        if func then
            func()
            return true, "Đã dịch chuyển đến Bank thành công!", "Successfully teleported to Bank!"
        else
            return false, "Không thể thực thi script dịch chuyển đến Bank", "Failed to execute Bank teleport script"
        end
    end)
    if not success then
        return false, "Lỗi khi tải script Bank: " .. tostring(result), "Error loading Bank script: " .. tostring(result)
    end
    return result
end

-- Hàm mở khóa lớp Horse
local function unlockHorseClass()
    local success, result = pcall(function()
        local args = { [1] = "Horse" }
        local remote = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("RemotePromise"):WaitForChild("Remotes"):WaitForChild("C_BuyClass")
        remote:FireServer(unpack(args))
        return true, "Đã mở khóa lớp Ngựa thành công!", "Successfully unlocked Horse class!"
    end)
    if not success then
        return false, "Lỗi khi mở khóa lớp Ngựa: " .. tostring(result), "Error unlocking Horse class: " .. tostring(result)
    end
    return result
end

-- Hàm NPC Lock
local npcLock = false
local lastTarget = nil
local toggleLoop = nil
local function addPlayerHighlight()
    if LocalPlayer.Character then
        local highlight = LocalPlayer.Character:FindFirstChild("PlayerHighlightESP")
        if not highlight then
            highlight = Instance.new("Highlight")
            highlight.Name = "PlayerHighlightESP"
            highlight.FillColor = Color3.new(1, 1, 1)
            highlight.OutlineColor = Color3.new(1, 1, 1)
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0
            highlight.Parent = LocalPlayer.Character
        end
    end
end

local function removePlayerHighlight()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("PlayerHighlightESP") then
        LocalPlayer.Character.PlayerHighlightESP:Destroy()
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
                    local distance = (hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        closestNPC = object
                    end
                end
            end
        end
    end
    return closestNPC, closestDistance
end

local function toggleNPCLock(npcLockButton, statusLabel, isVietnamese)
    npcLock = not npcLock
    npcLockButton.Text = isVietnamese and ("Khóa NPC: " .. (npcLock and "BẬT" or "TẮT")) or ("NPC Lock: " .. (npcLock and "ON" or "OFF"))
    
    if npcLock then
        local npc, distance = getClosestNPC()
        if npc and distance < 100 then
            local npcHumanoid = npc:FindFirstChild("Humanoid")
            if npcHumanoid and npcHumanoid.Health > 0 then
                Camera.CameraSubject = npcHumanoid
                lastTarget = npc
                addPlayerHighlight()
                statusLabel.Text = isVietnamese and ("Đã khóa NPC: " .. npc.Name) or ("Locked NPC: " .. npc.Name)
                statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                
                toggleLoop = RunService.RenderStepped:Connect(function()
                    if not npcLock then
                        toggleLoop:Disconnect()
                        toggleLoop = nil
                        return
                    end
                    if lastTarget and lastTarget:FindFirstChild("Humanoid") and lastTarget.Humanoid.Health > 0 then
                        Camera.CameraSubject = lastTarget.Humanoid
                    else
                        statusLabel.Text = isVietnamese and ("NPC " .. (lastTarget and lastTarget.Name or "") .. " đã bị giết!") or ("NPC " .. (lastTarget and lastTarget.Name or "") .. " killed!")
                        statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                        lastTarget = nil
                        removePlayerHighlight()
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                            Camera.CameraSubject = LocalPlayer.Character.Humanoid
                        end
                        npcLock = false
                        npcLockButton.Text = isVietnamese and "Khóa NPC: TẮT" or "NPC Lock: OFF"
                        toggleLoop:Disconnect()
                        toggleLoop = nil
                    end
                end)
            else
                npcLock = false
                npcLockButton.Text = isVietnamese and "Khóa NPC: TẮT" or "NPC Lock: OFF"
                statusLabel.Text = isVietnamese and "Không tìm thấy NPC để khóa!" or "No NPC found to lock!"
                statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
            end
        else
            npcLock = false
            npcLockButton.Text = isVietnamese and "Khóa NPC: TẮT" or "NPC Lock: OFF"
            statusLabel.Text = isVietnamese and "Không tìm thấy NPC để khóa!" or "No NPC found to lock!"
            statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        end
    else
        if toggleLoop then
            toggleLoop:Disconnect()
            toggleLoop = nil
        end
        removePlayerHighlight()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            Camera.CameraSubject = LocalPlayer.Character.Humanoid
        end
        statusLabel.Text = isVietnamese and "Nhấn nút để thực hiện hành động!" or "Click a button to perform an action!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end

-- Hàm Aimbot
local function isNPC(obj)
    return obj:IsA("Model") 
        and obj:FindFirstChild("Humanoid")
        and obj.Humanoid.Health > 0
        and obj:FindFirstChild("Head")
        and obj:FindFirstChild("HumanoidRootPart")
        and not Players:GetPlayerFromCharacter(obj)
end

local function updateNPCs()
    local tempTable = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if isNPC(obj) then
            tempTable[obj] = true
        end
    end
    for i = #validNPCs, 1, -1 do
        if not tempTable[validNPCs[i]] then
            table.remove(validNPCs, i)
        end
    end
    for obj in pairs(tempTable) do
        if not table.find(validNPCs, obj) then
            table.insert(validNPCs, obj)
        end
    end
end

local function handleDescendant(descendant)
    if isNPC(descendant) then
        table.insert(validNPCs, descendant)
        local humanoid = descendant:WaitForChild("Humanoid")
        humanoid.Destroying:Connect(function()
            for i = #validNPCs, 1, -1 do
                if validNPCs[i] == descendant then
                    table.remove(validNPCs, i)
                    break
                end
            end
        end)
    end
end

workspace.DescendantAdded:Connect(handleDescendant)

local function updateDrawings()
    FOVring.Position = Camera.ViewportSize / 2
    FOVring.Radius = fov * (Camera.ViewportSize.Y / 1080)
end

local function predictPos(target)
    local rootPart = target:FindFirstChild("HumanoidRootPart")
    local head = target:FindFirstChild("Head")
    if not rootPart or not head then
        return head and head.Position or rootPart and rootPart.Position
    end
    local velocity = rootPart.Velocity
    local predictionTime = 0.02
    return rootPart.Position + velocity * predictionTime + (head.Position - rootPart.Position)
end

local function getTarget()
    local nearest = nil
    local minDistance = math.huge
    local viewportCenter = Camera.ViewportSize / 2
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
    for _, npc in ipairs(validNPCs) do
        local predictedPos = predictPos(npc)
        if predictedPos then
            local screenPos, visible = Camera:WorldToViewportPoint(predictedPos)
            if visible and screenPos.Z > 0 then
                local ray = workspace:Raycast(
                    Camera.CFrame.Position,
                    (predictedPos - Camera.CFrame.Position).Unit * 1000,
                    raycastParams
                )
                if ray and ray.Instance:IsDescendantOf(npc) then
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - viewportCenter).Magnitude
                    if distance < minDistance and distance < fov then
                        minDistance = distance
                        nearest = npc
                    end
                end
            end
        end
    end
    return nearest
end

local function aim(targetPosition)
    local currentCF = Camera.CFrame
    local targetDirection = (targetPosition - currentCF.Position).Unit
    local smoothFactor = 0.581
    local newLookVector = currentCF.LookVector:Lerp(targetDirection, smoothFactor)
    Camera.CFrame = CFrame.new(currentCF.Position, currentCF.Position + newLookVector)
end

local lastUpdate = 0
local UPDATE_INTERVAL = 0.4

local aimbotConnection
local function toggleAimbot(aimbotButton, statusLabel, isVietnamese)
    isAiming = not isAiming
    FOVring.Visible = isAiming
    aimbotButton.Text = isVietnamese and (isAiming and "Tắt Ngắm Tự Động" or "Bật Ngắm Tự Động") or (isAiming and "Tắt Aimbot" or "Bật Aimbot")
    statusLabel.Text = isVietnamese and (isAiming and "Ngắm tự động đã bật!" or "Ngắm tự động đã tắt!") or (isAiming and "Aimbot enabled!" or "Aimbot disabled!")
    statusLabel.TextColor3 = isAiming and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
    
    if isAiming then
        aimbotConnection = RunService.Heartbeat:Connect(function(dt)
            updateDrawings()
            lastUpdate = lastUpdate + dt
            if lastUpdate >= UPDATE_INTERVAL then
                updateNPCs()
                lastUpdate = 0
            end
            if isAiming then
                local target = getTarget()
                if target then
                    local predictedPosition = predictPos(target)
                    if predictedPosition then
                        aim(predictedPosition)
                    end
                end
            end
        end)
    else
        if aimbotConnection then
            aimbotConnection:Disconnect()
            aimbotConnection = nil
        end
    end
end

-- Hàm Noclip với Anti-Avoid
local noclipConnection
local antiAvoidConnection
local function toggleNoclip(noclipButton, statusLabel, isVietnamese)
    isNoClip = not isNoClip
    noclipButton.Text = isVietnamese and (isNoClip and "Tắt Xuyên Tường" or "Bật Xuyên Tường") or (isNoClip and "Tắt Noclip" or "Bật Noclip")
    statusLabel.Text = isVietnamese and (isNoClip and "Xuyên tường đã bật!" or "Xuyên tường đã tắt!") or (isNoClip and "Noclip enabled!" or "Noclip disabled!")
    statusLabel.TextColor3 = isNoClip and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
    
    if isNoClip then
        if LocalPlayer.Character then
            originalCollideStates = {}
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    originalCollideStates[part] = part.CanCollide
                    part.CanCollide = false
                end
            end
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.PlatformStand = false
                humanoid.Jump = false
            end
        end
        noclipConnection = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
        antiAvoidConnection = RunService.Heartbeat:Connect(function(dt)
            if not LocalPlayer.Character then return end
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            
            local position = hrp.CFrame.Position
            local cameraCFrame = Camera.CFrame
            local _, _, yaw = cameraCFrame:ToEulerAnglesYXZ()
            local uprightCFrame = CFrame.new(position) * CFrame.Angles(0, yaw, 0)
            hrp.CFrame = hrp.CFrame:Lerp(uprightCFrame, 0.5)
        end)
    else
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        if antiAvoidConnection then
            antiAvoidConnection:Disconnect()
            antiAvoidConnection = nil
        end
        if LocalPlayer.Character then
            for part, canCollide in pairs(originalCollideStates) do
                if part and part:IsDescendantOf(LocalPlayer.Character) then
                    part.CanCollide = canCollide
                end
            end
            originalCollideStates = {}
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if hrp then
                hrp.Velocity = Vector3.new(0, 0, 0)
                hrp.CFrame = hrp.CFrame + Vector3.new(0, 1, 0)
            end
            if humanoid then
                humanoid.PlatformStand = false
                humanoid.Jump = false
                humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end
        end
    end
end

-- Hàm ESP
local function CreateESP(object, color, partName)
    local part = object:FindFirstChild(partName) or object.PrimaryPart
    if not object or not part then return end

    if ESPHandles[object] then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.Adornee = object
    highlight.FillColor = color
    highlight.OutlineColor = color
    highlight.Parent = object

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_Billboard"
    billboard.Adornee = part
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = object

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.TextColor3 = color
    textLabel.BackgroundTransparency = 1
    textLabel.TextSize = 7
    textLabel.Parent = billboard

    ESPHandles[object] = {Highlight = highlight, Billboard = billboard, TextLabel = textLabel}
end

local function ClearESP()
    for obj, handles in pairs(ESPHandles) do
        if handles.Highlight then handles.Highlight:Destroy() end
        if handles.Billboard then handles.Billboard:Destroy() end
    end
    ESPHandles = {}
end

local espConnection
local function toggleESPMobs(espMobsButton, statusLabel, isVietnamese)
    isESPEnabledMobs = not isESPEnabledMobs
    espMobsButton.Text = isVietnamese and (isESPEnabledMobs and "Tắt ESP Quái" or "Bật ESP Quái") or (isESPEnabledMobs and "Tắt ESP Mobs" or "Bật ESP Mobs")
    statusLabel.Text = isVietnamese and (isESPEnabledMobs and "ESP quái đã bật!" or "ESP quái đã tắt!") or (isESPEnabledMobs and "ESP mobs enabled!" or "ESP mobs disabled!")
    statusLabel.TextColor3 = isESPEnabledMobs and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
    
    if not isESPEnabledMobs and not isESPEnabledItems then
        ClearESP()
    end
end

local function toggleESPItems(espItemsButton, statusLabel, isVietnamese)
    isESPEnabledItems = not isESPEnabledItems
    espItemsButton.Text = isVietnamese and (isESPEnabledItems and "Tắt ESP Vật Phẩm" or "Bật ESP Vật Phẩm") or (isESPEnabledItems and "Tắt ESP Items" or "Bật ESP Items")
    statusLabel.Text = isVietnamese and (isESPEnabledItems and "ESP vật phẩm đã bật!" or "ESP vật phẩm đã tắt!") or (isESPEnabledItems and "ESP items enabled!" or "ESP items disabled!")
    statusLabel.TextColor3 = isESPEnabledItems and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
    
    if not isESPEnabledMobs and not isESPEnabledItems then
        ClearESP()
    end
end

local function updateESP()
    if not isESPEnabledMobs and not isESPEnabledItems then
        ClearESP()
        return
    end

    local character = LocalPlayer.Character
    if not character then return end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    local playerPos = rootPart.Position

    if isESPEnabledMobs then
        for _, npc in ipairs(validNPCs) do
            local npcPos = npc:FindFirstChild("HumanoidRootPart") and npc.HumanoidRootPart.Position
            if npcPos and (npcPos - playerPos).Magnitude <= MAX_ESP_DISTANCE then
                if not ESPHandles[npc] then
                    CreateESP(npc, Color3.fromRGB(255, 0, 0), "HumanoidRootPart")
                end
                local handles = ESPHandles[npc]
                if handles and handles.TextLabel then
                    local distance = (playerPos - npcPos).Magnitude
                    handles.TextLabel.Text = npc.Name .. "\n" .. math.floor(distance) .. " studs"
                end
            elseif ESPHandles[npc] then
                ESPHandles[npc].Highlight:Destroy()
                ESPHandles[npc].Billboard:Destroy()
                ESPHandles[npc] = nil
            end
        end
    end

    if isESPEnabledItems then
        local runtimeItems = workspace:FindFirstChild("RuntimeItems")
        if runtimeItems then
            for _, item in ipairs(runtimeItems:GetDescendants()) do
                if item:IsA("Model") and item.PrimaryPart then
                    local itemPos = item.PrimaryPart.Position
                    if (itemPos - playerPos).Magnitude <= MAX_ESP_DISTANCE then
                        if not ESPHandles[item] then
                            CreateESP(item, Color3.fromRGB(0, 0, 255), "PrimaryPart")
                        end
                        local handles = ESPHandles[item]
                        if handles and handles.TextLabel then
                            local distance = (playerPos - itemPos).Magnitude
                            handles.TextLabel.Text = item.Name .. "\n" .. math.floor(distance) .. " studs"
                        end
                    elseif ESPHandles[item] then
                        ESPHandles[item].Highlight:Destroy()
                        ESPHandles[item].Billboard:Destroy()
                        ESPHandles[item] = nil
                    end
                end
            end
        end
    end
end

-- Tạo UI
local function createUI()
    local isVietnamese = (getPlayerCountry() == "VN")

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "TrainControlUI"
    screenGui.Parent = LocalPlayer.PlayerGui
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.DisplayOrder = 1000000

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 430)
    frame.Position = UDim2.new(0.5, -100, 0.5, -215)
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    frame.BorderSizePixel = 0
    frame.Visible = false
    frame.ZIndex = 1000000
    frame.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame

    local tab1Content = Instance.new("Frame")
    tab1Content.Size = UDim2.new(1, 0, 1, -100)
    tab1Content.Position = UDim2.new(0, 0, 0, 0)
    tab1Content.BackgroundTransparency = 1
    tab1Content.ZIndex = 1000000
    tab1Content.Parent = frame
    tab1Content.Visible = true

    local tab2Content = Instance.new("Frame")
    tab2Content.Size = UDim2.new(1, 0, 1, -100)
    tab2Content.Position = UDim2.new(0, 0, 0, 0)
    tab2Content.BackgroundTransparency = 1
    tab2Content.ZIndex = 1000000
    tab2Content.Parent = frame
    tab2Content.Visible = false

    local tab3Content = Instance.new("ScrollingFrame")
    tab3Content.Size = UDim2.new(1, 0, 1, -100)
    tab3Content.Position = UDim2.new(0, 0, 0, 0)
    tab3Content.BackgroundTransparency = 1
    tab3Content.ZIndex = 1000000
    tab3Content.CanvasSize = UDim2.new(0, 0, 0, 300)
    tab3Content.ScrollBarThickness = 5
    tab3Content.CanvasPosition = Vector2.new(0, 0)
    tab3Content.Parent = frame
    tab3Content.Visible = false

    local tab3ListLayout = Instance.new("UIListLayout")
    tab3ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tab3ListLayout.Padding = UDim.new(0, 10)
    tab3ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tab3ListLayout.Parent = tab3Content

    local tab3Padding = Instance.new("UIPadding")
    tab3Padding.PaddingLeft = UDim.new(0, 10)
    tab3Padding.PaddingRight = UDim.new(0, 10)
    tab3Padding.PaddingTop = UDim.new(0, 10)
    tab3Padding.PaddingBottom = UDim.new(0, 10)
    tab3Padding.Parent = tab3Content

    local tab4Content = Instance.new("Frame")
    tab4Content.Size = UDim2.new(1, 0, 1, -100)
    tab4Content.Position = UDim2.new(0, 0, 0, 0)
    tab4Content.BackgroundTransparency = 1
    tab4Content.ZIndex = 1000000
    tab4Content.Parent = frame
    tab4Content.Visible = false

    local tab1Button = Instance.new("TextButton")
    tab1Button.Size = UDim2.new(0, 47.5, 0, 30)
    tab1Button.Position = UDim2.new(0, 5, 0, 310)
    tab1Button.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    tab1Button.Text = isVietnamese and "Công Trình" or "Projects"
    tab1Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    tab1Button.TextScaled = true
    tab1Button.ZIndex = 1000001
    tab1Button.BorderSizePixel = 2
    tab1Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
    tab1Button.Parent = frame
    local tab1Corner = Instance.new("UICorner")
    tab1Corner.CornerRadius = UDim.new(0, 8)
    tab1Corner.Parent = tab1Button

    local tab2Button = Instance.new("TextButton")
    tab2Button.Size = UDim2.new(0, 47.5, 0, 30)
    tab2Button.Position = UDim2.new(0, 52.5, 0, 310)
    tab2Button.BackgroundColor3 = Color3.fromRGB(200, 200, 50)
    tab2Button.Text = isVietnamese and "Khác" or "Other"
    tab2Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    tab2Button.TextScaled = true
    tab2Button.ZIndex = 1000001
    tab2Button.BorderSizePixel = 0
    tab2Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
    tab2Button.Parent = frame
    local tab2Corner = Instance.new("UICorner")
    tab2Corner.CornerRadius = UDim.new(0, 8)
    tab2Corner.Parent = tab2Button

    local tab3Button = Instance.new("TextButton")
    tab3Button.Size = UDim2.new(0, 47.5, 0, 30)
    tab3Button.Position = UDim2.new(0, 100, 0, 310)
    tab3Button.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    tab3Button.Text = isVietnamese and "Công Cụ" or "Tool"
    tab3Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    tab3Button.TextScaled = true
    tab3Button.ZIndex = 1000001
    tab3Button.BorderSizePixel = 0
    tab3Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
    tab3Button.Parent = frame
    local tab3Corner = Instance.new("UICorner")
    tab3Corner.CornerRadius = UDim.new(0, 8)
    tab3Corner.Parent = tab3Button

    local tab4Button = Instance.new("TextButton")
    tab4Button.Size = UDim2.new(0, 47.5, 0, 30)
    tab4Button.Position = UDim2.new(0, 147.5, 0, 310)
    tab4Button.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    tab4Button.Text = isVietnamese and "Lớp Đặc Biệt" or "Special Class"
    tab4Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    tab4Button.TextScaled = true
    tab4Button.ZIndex = 1000001
    tab4Button.BorderSizePixel = 0
    tab4Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
    tab4Button.Parent = frame
    local tab4Corner = Instance.new("UICorner")
    tab4Corner.CornerRadius = UDim.new(0, 8)
    tab4Corner.Parent = tab4Button

    local sitButton = Instance.new("TextButton")
    sitButton.Size = UDim2.new(0, 180, 0, 50)
    sitButton.Position = UDim2.new(0.5, -90, 0, 10)
    sitButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    sitButton.Text = isVietnamese and "Ngồi vào ghế điều khiển" or "Sit in Conductor Seat"
    sitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    sitButton.TextScaled = true
    sitButton.ZIndex = 1000001
    sitButton.Parent = tab1Content
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = sitButton

    local castleButton = Instance.new("TextButton")
    castleButton.Size = UDim2.new(0, 180, 0, 50)
    castleButton.Position = UDim2.new(0.5, -90, 0, 70)
    castleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    castleButton.Text = isVietnamese and "Dịch Chuyển Đến Lâu Đài" or "Teleport to Castle"
    castleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    castleButton.TextScaled = true
    castleButton.ZIndex = 1000001
    castleButton.Parent = tab1Content
    local castleButtonCorner = Instance.new("UICorner")
    castleButtonCorner.CornerRadius = UDim.new(0, 8)
    castleButtonCorner.Parent = castleButton

    local teslaButton = Instance.new("TextButton")
    teslaButton.Size = UDim2.new(0, 180, 0, 50)
    teslaButton.Position = UDim2.new(0.5, -90, 0, 130)
    teslaButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    teslaButton.Text = isVietnamese and "Dịch Chuyển Đến Tesla Lab" or "Teleport to Tesla Lab"
    teslaButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    teslaButton.TextScaled = true
    teslaButton.ZIndex = 1000001
    teslaButton.Parent = tab1Content
    local teslaButtonCorner = Instance.new("UICorner")
    teslaButtonCorner.CornerRadius = UDim.new(0, 8)
    teslaButtonCorner.Parent = teslaButton

    local fortButton = Instance.new("TextButton")
    fortButton.Size = UDim2.new(0, 180, 0, 50)
    fortButton.Position = UDim2.new(0.5, -90, 0, 190)
    fortButton.BackgroundColor3 = Color3.fromRGB(200, 200, 50)
    fortButton.Text = isVietnamese and "Dịch Chuyển Đến Fort" or "Teleport to Fort"
    fortButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    fortButton.TextScaled = true
    fortButton.ZIndex = 1000001
    fortButton.Parent = tab1Content
    local fortButtonCorner = Instance.new("UICorner")
    fortButtonCorner.CornerRadius = UDim.new(0, 8)
    fortButtonCorner.Parent = fortButton

    local sterlingButton = Instance.new("TextButton")
    sterlingButton.Size = UDim2.new(0, 180, 0, 50)
    sterlingButton.Position = UDim2.new(0, 10, 0, 250)
    sterlingButton.BackgroundColor3 = Color3.fromRGB(150, 50, 200)
    sterlingButton.Text = isVietnamese and "Dịch Chuyển Đến Sterling Town" or "Teleport to Sterling Town"
    sterlingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    sterlingButton.TextScaled = true
    sterlingButton.ZIndex = 1000001
    sterlingButton.Parent = tab1Content
    local sterlingButtonCorner = Instance.new("UICorner")
    sterlingButtonCorner.CornerRadius = UDim.new(0, 8)
    sterlingButtonCorner.Parent = sterlingButton

    local endButton = Instance.new("TextButton")
    endButton.Size = UDim2.new(0, 180, 0, 50)
    endButton.Position = UDim2.new(0.5, -90, 0, 10)
    endButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    endButton.Text = isVietnamese and "Dịch Chuyển Đến End" or "Teleport to End"
    endButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    endButton.TextScaled = true
    endButton.ZIndex = 1000001
    endButton.Parent = tab2Content
    local endButtonCorner = Instance.new("UICorner")
    endButtonCorner.CornerRadius = UDim.new(0, 8)
    endButtonCorner.Parent = endButton

    local farmButton = Instance.new("TextButton")
    farmButton.Size = UDim2.new(0, 180, 0, 50)
    farmButton.Position = UDim2.new(0.5, -90, 0, 70)
    farmButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    farmButton.Text = isVietnamese and "Dịch Chuyển Đến Farm" or "Teleport to Farm"
    farmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    farmButton.TextScaled = true
    farmButton.ZIndex = 1000001
    farmButton.Parent = tab2Content
    local farmButtonCorner = Instance.new("UICorner")
    farmButtonCorner.CornerRadius = UDim.new(0, 8)
    farmButtonCorner.Parent = farmButton

    local bankButton = Instance.new("TextButton")
    bankButton.Size = UDim2.new(0, 180, 0, 50)
    bankButton.Position = UDim2.new(0.5, -90, 0, 130)
    bankButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    bankButton.Text = isVietnamese and "Dịch Chuyển Đến Bank" or "Teleport to Bank"
    bankButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    bankButton.TextScaled = true
    bankButton.ZIndex = 1000001
    bankButton.Parent = tab2Content
    local bankButtonCorner = Instance.new("UICorner")
    bankButtonCorner.CornerRadius = UDim.new(0, 8)
    bankButtonCorner.Parent = bankButton

    local npcLockButton = Instance.new("TextButton")
    npcLockButton.Size = UDim2.new(0, 180, 0, 50)
    npcLockButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    npcLockButton.Text = isVietnamese and "Khóa NPC: TẮT" or "NPC Lock: OFF"
    npcLockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    npcLockButton.TextScaled = true
    npcLockButton.ZIndex = 1000001
    npcLockButton.LayoutOrder = 1
    npcLockButton.Parent = tab3Content
    local npcLockButtonCorner = Instance.new("UICorner")
    npcLockButtonCorner.CornerRadius = UDim.new(0, 8)
    npcLockButtonCorner.Parent = npcLockButton

    local aimbotButton = Instance.new("TextButton")
    aimbotButton.Size = UDim2.new(0, 180, 0, 50)
    aimbotButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    aimbotButton.Text = isVietnamese and "Bật Ngắm Tự Động" or "Bật Aimbot"
    aimbotButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    aimbotButton.TextScaled = true
    aimbotButton.ZIndex = 1000001
    aimbotButton.LayoutOrder = 2
    aimbotButton.Parent = tab3Content
    local aimbotButtonCorner = Instance.new("UICorner")
    aimbotButtonCorner.CornerRadius = UDim.new(0, 8)
    aimbotButtonCorner.Parent = aimbotButton

    local noclipButton = Instance.new("TextButton")
    noclipButton.Size = UDim2.new(0, 180, 0, 50)
    noclipButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    noclipButton.Text = isVietnamese and "Bật Xuyên Tường" or "Bật Noclip"
    noclipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    noclipButton.TextScaled = true
    noclipButton.ZIndex = 1000001
    noclipButton.LayoutOrder = 3
    noclipButton.Parent = tab3Content
    local noclipButtonCorner = Instance.new("UICorner")
    noclipButtonCorner.CornerRadius = UDim.new(0, 8)
    noclipButtonCorner.Parent = noclipButton

    local espMobsButton = Instance.new("TextButton")
    espMobsButton.Size = UDim2.new(0, 180, 0, 50)
    espMobsButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    espMobsButton.Text = isVietnamese and "Bật ESP Quái" or "Bật ESP Mobs"
    espMobsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    espMobsButton.TextScaled = true
    espMobsButton.ZIndex = 1000001
    espMobsButton.LayoutOrder = 4
    espMobsButton.Parent = tab3Content
    local espMobsButtonCorner = Instance.new("UICorner")
    espMobsButtonCorner.CornerRadius = UDim.new(0, 8)
    espMobsButtonCorner.Parent = espMobsButton

    local espItemsButton = Instance.new("TextButton")
    espItemsButton.Size = UDim2.new(0, 180, 0, 50)
    espItemsButton.BackgroundColor3 = Color3.fromRGB(128, 0, 128)
    espItemsButton.Text = isVietnamese and "Bật ESP Vật Phẩm" or "Bật ESP Items"
    espItemsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    espItemsButton.TextScaled = true
    espItemsButton.ZIndex = 1000001
    espItemsButton.LayoutOrder = 5
    espItemsButton.Parent = tab3Content
    local espItemsButtonCorner = Instance.new("UICorner")
    espItemsButtonCorner.CornerRadius = UDim.new(0, 8)
    espItemsButtonCorner.Parent = espItemsButton

    local horseClassButton = Instance.new("TextButton")
    horseClassButton.Size = UDim2.new(0, 180, 0, 50)
    horseClassButton.Position = UDim2.new(0.5, -90, 0, 10)
    horseClassButton.BackgroundColor3 = Color3.fromRGB(150, 50, 200)
    horseClassButton.Text = isVietnamese and "Mở Khóa Lớp Ngựa" or "Unlock Horse Class"
    horseClassButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    horseClassButton.TextScaled = true
    horseClassButton.ZIndex = 1000001
    horseClassButton.Parent = tab4Content
    local horseClassButtonCorner = Instance.new("UICorner")
    horseClassButtonCorner.CornerRadius = UDim.new(0, 8)
    horseClassButtonCorner.Parent = horseClassButton

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(0, 180, 0, 50)
    statusLabel.Position = UDim2.new(0.5, -90, 0, 360)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = isVietnamese and "Nhấn nút để thực hiện hành động!" or "Click a button to perform an action!"
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    statusLabel.TextScaled = true
    statusLabel.TextWrapped = true
    statusLabel.ZIndex = 1000001
    statusLabel.Parent = frame

    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -40, 0, 10)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextScaled = true
    closeButton.ZIndex = 1000001
    closeButton.Parent = frame
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeButton

    local logoButton = Instance.new("TextButton")
    logoButton.Size = UDim2.new(0, 50, 0, 50)
    logoButton.Position = UDim2.new(0, 10, 0, 10)
    logoButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    logoButton.Text = "N"
    logoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    logoButton.TextScaled = false
    logoButton.TextSize = 24
    logoButton.ZIndex = 1000000
    logoButton.Parent = screenGui
    local logoCorner = Instance.new("UICorner")
    logoCorner.CornerRadius = UDim.new(0, 8)
    logoCorner.Parent = logoButton

    -- Thêm sự kiện nhấn phím G để hiển thị/ẩn menu
    UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        if not gameProcessedEvent and input.KeyCode == Enum.KeyCode.G and not UserInputService:GetFocusedTextBox() then
            frame.Visible = not frame.Visible
        end
    end)

    tab1Button.MouseButton1Click:Connect(function()
        tab1Content.Visible = true
        tab2Content.Visible = false
        tab3Content.Visible = false
        tab4Content.Visible = false
        tab1Button.BorderSizePixel = 2
        tab2Button.BorderSizePixel = 0
        tab3Button.BorderSizePixel = 0
        tab4Button.BorderSizePixel = 0
    end)

    tab2Button.MouseButton1Click:Connect(function()
        tab1Content.Visible = false
        tab2Content.Visible = true
        tab3Content.Visible = false
        tab4Content.Visible = false
        tab1Button.BorderSizePixel = 0
        tab2Button.BorderSizePixel = 2
        tab3Button.BorderSizePixel = 0
        tab4Button.BorderSizePixel = 0
    end)

    tab3Button.MouseButton1Click:Connect(function()
        tab1Content.Visible = false
        tab2Content.Visible = false
        tab3Content.Visible = true
        tab4Content.Visible = false
        tab1Button.BorderSizePixel = 0
        tab2Button.BorderSizePixel = 0
        tab3Button.BorderSizePixel = 2
        tab4Button.BorderSizePixel = 0
    end)

    tab4Button.MouseButton1Click:Connect(function()
        tab1Content.Visible = false
        tab2Content.Visible = false
        tab3Content.Visible = false
        tab4Content.Visible = true
        tab1Button.BorderSizePixel = 0
        tab2Button.BorderSizePixel = 0
        tab3Button.BorderSizePixel = 0
        tab4Button.BorderSizePixel = 2
    end)

    sitButton.MouseButton1Click:Connect(function()
        local success, messageVN, messageEN = sitInConductorSeat(isVietnamese)
        statusLabel.Text = isVietnamese and messageVN or messageEN
        statusLabel.TextColor3 = success and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    end)

    castleButton.MouseButton1Click:Connect(function()
        local success, messageVN, messageEN = teleportToCastle()
        statusLabel.Text = isVietnamese and messageVN or messageEN
        statusLabel.TextColor3 = success and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    end)

    teslaButton.MouseButton1Click:Connect(function()
        local success, messageVN, messageEN = teleportToTeslaLab()
        statusLabel.Text = isVietnamese and messageVN or messageEN
        statusLabel.TextColor3 = success and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    end)

    fortButton.MouseButton1Click:Connect(function()
        local success, messageVN, messageEN = teleportToFort()
        statusLabel.Text = isVietnamese and messageVN or messageEN
        statusLabel.TextColor3 = success and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    end)

    sterlingButton.MouseButton1Click:Connect(function()
        local success, messageVN, messageEN = teleportToSterlingTown()
        statusLabel.Text = isVietnamese and messageVN or messageEN
        statusLabel.TextColor3 = success and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    end)

    endButton.MouseButton1Click:Connect(function()
        local success, messageVN, messageEN = teleportToEnd()
        statusLabel.Text = isVietnamese and messageVN or messageEN
        statusLabel.TextColor3 = success and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    end)

    farmButton.MouseButton1Click:Connect(function()
        local success, messageVN, messageEN = teleportToFarm()
        statusLabel.Text = isVietnamese and messageVN or messageEN
        statusLabel.TextColor3 = success and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    end)

    bankButton.MouseButton1Click:Connect(function()
        local success, messageVN, messageEN = teleportToBank()
        statusLabel.Text = isVietnamese and messageVN or messageEN
        statusLabel.TextColor3 = success and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    end)

    npcLockButton.MouseButton1Click:Connect(function()
        toggleNPCLock(npcLockButton, statusLabel, isVietnamese)
    end)

    aimbotButton.MouseButton1Click:Connect(function()
        toggleAimbot(aimbotButton, statusLabel, isVietnamese)
    end)

    noclipButton.MouseButton1Click:Connect(function()
        toggleNoclip(noclipButton, statusLabel, isVietnamese)
    end)

    espMobsButton.MouseButton1Click:Connect(function()
        toggleESPMobs(espMobsButton, statusLabel, isVietnamese)
    end)

    espItemsButton.MouseButton1Click:Connect(function()
        toggleESPItems(espItemsButton, statusLabel, isVietnamese)
    end)

    horseClassButton.MouseButton1Click:Connect(function()
        local success, messageVN, messageEN = unlockHorseClass()
        statusLabel.Text = isVietnamese and messageVN or messageEN
        statusLabel.TextColor3 = success and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    end)

    closeButton.MouseButton1Click:Connect(function()
        if toggleLoop then
            toggleLoop:Disconnect()
            toggleLoop = nil
        end
        if aimbotConnection then
            aimbotConnection:Disconnect()
            aimbotConnection = nil
        end
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        if antiAvoidConnection then
            antiAvoidConnection:Disconnect()
            antiAvoidConnection = nil
        end
        if espConnection then
            espConnection:Disconnect()
            espConnection = nil
        end
        isAiming = false
        isNoClip = false
        isESPEnabledMobs = false
        isESPEnabledItems = false
        FOVring.Visible = false
        ClearESP()
        removePlayerHighlight()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            Camera.CameraSubject = LocalPlayer.Character.Humanoid
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = originalCollideStates[part] or true
                end
            end
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if hrp then
                hrp.Velocity = Vector3.new(0, 0, 0)
                hrp.CFrame = hrp.CFrame + Vector3.new(0, 1, 0)
            end
            if humanoid then
                humanoid.PlatformStand = false
                humanoid.Jump = false
                humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end
        end
        screenGui:Destroy()
    end)

    logoButton.MouseButton1Click:Connect(function()
        frame.Visible = not frame.Visible
    end)

    espConnection = RunService.RenderStepped:Connect(updateESP)
end

-- Khởi tạo UI
createUI()
