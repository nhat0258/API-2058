local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Intro
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = playerGui

local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(1, 0, 1, 0)
textLabel.Position = UDim2.new(0, 0, 0, 0)
textLabel.Text = "Nexus Hub V5 by NhatNguyenQuang"
textLabel.TextColor3 = Color3.new(1, 1, 1)
textLabel.BackgroundTransparency = 1
textLabel.TextScaled = true
textLabel.Font = Enum.Font.SourceSansBold
textLabel.Parent = screenGui

local lighting = game:GetService("Lighting")
local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Parent = lighting

textLabel.TextTransparency = 1

for i = 1, 0, -0.02 do
    textLabel.TextTransparency = i
    blur.Size = (1 - i) * 24
    wait(0.05)
end

wait(1)

for i = 0, 1, 0.02 do
    textLabel.TextTransparency = i
    blur.Size = (1 - i) * 24
    wait(0.05)
end

blur:Destroy()
screenGui:Destroy()

-- Kiểm tra tên người chơi
if player.Name == "euuricok" then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/nhat0258/API-2058/main/Teleport-Gui-v5.lua"))()
    return
end

-- Key system
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomTeleportUI"
screenGui.Parent = playerGui

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
mainFrame.Size = UDim2.new(0, 200, 0, 150)
mainFrame.Position = UDim2.new(0.5, -100, 0.5, -75)
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

local keyInput = Instance.new("TextBox")
keyInput.Size = UDim2.new(1, -20, 0, 35)
keyInput.Position = UDim2.new(0, 10, 0, 10)
keyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
keyInput.TextColor3 = Color3.new(1, 1, 1)
keyInput.PlaceholderText = "Enter Key"
keyInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
keyInput.Text = ""
keyInput.ClearTextOnFocus = false
keyInput.Font = Enum.Font.Gotham
keyInput.TextSize = 16
keyInput.TextScaled = false
keyInput.TextXAlignment = Enum.TextXAlignment.Center
keyInput.TextWrapped = true
keyInput.MultiLine = true
keyInput.Parent = mainFrame
Instance.new("UICorner", keyInput).CornerRadius = UDim.new(0, 8)

local messageLabel = Instance.new("TextLabel")
messageLabel.Size = UDim2.new(1, -20, 0, 20)
messageLabel.Position = UDim2.new(0, 10, 0, 40)
messageLabel.BackgroundTransparency = 1
messageLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
messageLabel.Text = ""
messageLabel.Font = Enum.Font.Gotham
messageLabel.TextSize = 14
messageLabel.TextScaled = false
messageLabel.TextXAlignment = Enum.TextXAlignment.Center
messageLabel.TextWrapped = true
messageLabel.Visible = false
messageLabel.Parent = mainFrame

keyInput:GetPropertyChangedSignal("Text"):Connect(function()
    messageLabel.Visible = false
    keyInput.TextColor3 = Color3.new(1, 1, 1)
end)

local confirmButton = Instance.new("TextButton")
confirmButton.Size = UDim2.new(1, -20, 0, 35)
confirmButton.Position = UDim2.new(0, 10, 0, 65)
confirmButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
confirmButton.TextColor3 = Color3.new(1, 1, 1)
confirmButton.Text = "Confirm Key"
confirmButton.Font = Enum.Font.GothamBold
confirmButton.TextSize = 16
confirmButton.TextScaled = false
confirmButton.Parent = mainFrame
Instance.new("UICorner", confirmButton).CornerRadius = UDim.new(0, 8)

local getKeyButton = Instance.new("TextButton")
getKeyButton.Size = UDim2.new(1, -20, 0, 35)
getKeyButton.Position = UDim2.new(0, 10, 0, 110)
getKeyButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
getKeyButton.TextColor3 = Color3.new(1, 1, 1)
getKeyButton.Text = "Get Key LootLabs"
getKeyButton.Font = Enum.Font.GothamBold
getKeyButton.TextSize = 16
getKeyButton.TextScaled = false
getKeyButton.Parent = mainFrame
Instance.new("UICorner", getKeyButton).CornerRadius = UDim.new(0, 8)

local correctKey = "Ndev01d87c75e3g349i97863n0"

confirmButton.MouseButton1Click:Connect(function()
    if keyInput.Text == "" then
        messageLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        messageLabel.Text = "Please enter a key"
        messageLabel.Visible = true
    elseif keyInput.Text == correctKey then
        messageLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        messageLabel.Text = "Valid Key"
        messageLabel.Visible = true
        confirmButton.Active = false
        getKeyButton.Active = false
        keyInput.Active = false
        delay(1.5, function()
            screenGui:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/nhat0258/API-2058/main/Teleport-Gui-v5.lua"))()
        end)
    else
        messageLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        messageLabel.Text = "Invalid Key"
        messageLabel.Visible = true
    end
    wait(2)
    messageLabel.Visible = false
    keyInput.Text = ""
end)

getKeyButton.MouseButton1Click:Connect(function()
    setclipboard("https://lootdest.org/s?tdzFfYXL")
    messageLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    messageLabel.Text = "Link Copied!"
    messageLabel.Visible = true
    wait(2)
    messageLabel.Visible = false
    keyInput.Text = ""
end)

logo.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)
