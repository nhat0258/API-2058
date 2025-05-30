local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Cam = workspace.CurrentCamera
local playerGui = LocalPlayer:WaitForChild("PlayerGui")

local fov = 136
local headWinRate = 50
local savedHeadWinRate = headWinRate
local isAiming = false
local isESPEnabled = false
local isESPLineEnabled = false
local isHeadShot100Enabled = false
local validPlayers = {}
local draggingSlider = false
local draggingHeadWinRateSlider = false
local ESPHandles = {}
local MAX_ESP_DISTANCE = 1000
local lastPlayerUpdate = 0
local currentTarget = nil
local aimAtHead = false
local lastVelocity = Vector3.zero
local espLineColor = Color3.fromRGB(255, 0, 0)
local espHighlightColor = Color3.fromRGB(255, 0, 0)
local fovColor = Color3.fromRGB(255, 0, 0)
local drawbarColor = Color3.fromRGB(255, 0, 0)
local isDraggingMenu = false
local isDraggingLogo = false
local dragStart = nil
local startPos = nil

-- Khởi tạo vòng FOV
local FOVring = Drawing.new("Circle")
FOVring.Visible = false
FOVring.Thickness = 2
FOVring.Color = fovColor
FOVring.Filled = false
FOVring.Radius = fov
FOVring.Position = Cam and Cam.ViewportSize / 2 or Vector2.new(0, 0)

-- Thiết lập ScreenGui với DisplayOrder cao để ở trên cùng
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomTeleportUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 2000000 -- Tăng lên mức cao hơn để thử vượt qua CoreGui
screenGui.IgnoreGuiInset = true
screenGui.Enabled = true
screenGui.Parent = game:GetService("CoreGui") -- Chuyển sang CoreGui nếu dùng exploit, nếu không giữ playerGui

-- Logo
local logo = Instance.new("TextButton")
logo.Size = UDim2.new(0, 51, 0, 51)
logo.Position = UDim2.new(0, 20, 0.5, -26)
logo.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
logo.Text = "N"
logo.TextColor3 = Color3.new(1, 1, 1)
logo.Font = Enum.Font.GothamBold
logo.TextScaled = true
logo.Active = true
logo.Selectable = true
logo.ZIndex = 110005
logo.Parent = screenGui
Instance.new("UICorner", logo).CornerRadius = UDim.new(0, 8)

-- Frame chính
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 320)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -160)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.BackgroundTransparency = 0.5
mainFrame.Visible = false
mainFrame.Active = true
mainFrame.ZIndex = 110000
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
local borderMain = Instance.new("UIStroke")
borderMain.Thickness = 3
borderMain.Color = Color3.fromRGB(0, 0, 0)
borderMain.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
borderMain.Parent = mainFrame

-- Thanh tiêu đề
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 32)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
titleBar.BackgroundTransparency = 0.2
titleBar.ZIndex = 110001
titleBar.Parent = mainFrame
titleBar.Active = true
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 6)
local titleBarStroke = Instance.new("UIStroke")
titleBarStroke.Thickness = 1
titleBarStroke.Color = Color3.fromRGB(0, 0, 0)
titleBarStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
titleBarStroke.Parent = titleBar

-- Nhãn tiêu đề
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0, 180, 1, 0)
titleLabel.Position = UDim2.new(0, 8, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Nexus Hub | V-5 True"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextScaled = true
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.ZIndex = 110002
titleLabel.Parent = titleBar

-- Nút thu nhỏ
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 16, 0, 16)
closeButton.Position = UDim2.new(1, -40, 0.5, -8)
closeButton.Text = "-"
closeButton.BackgroundTransparency = 1
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextScaled = true
closeButton.ZIndex = 110003
closeButton.Active = true
closeButton.Selectable = true
closeButton.Parent = titleBar

-- Nút thoát
local exitButton = Instance.new("TextButton")
exitButton.Size = UDim2.new(0, 16, 0, 16)
exitButton.Position = UDim2.new(1, -20, 0.5, -8)
exitButton.Text = "X"
exitButton.BackgroundTransparency = 1
exitButton.TextColor3 = Color3.new(1, 1, 1)
exitButton.Font = Enum.Font.GothamBold
exitButton.TextScaled = true
exitButton.ZIndex = 110003
exitButton.Active = true
exitButton.Selectable = true
exitButton.Parent = titleBar

-- Container cho các tab
local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(0, 56, 1, -48)
tabContainer.Position = UDim2.new(0, 8, 0, 40)
tabContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
tabContainer.BackgroundTransparency = 0.7
tabContainer.ZIndex = 110001
tabContainer.Parent = mainFrame
Instance.new("UICorner", tabContainer).CornerRadius = UDim.new(0, 6)

local tabPaddingTop = Instance.new("UIPadding")
tabPaddingTop.PaddingTop = UDim.new(0, 8)
tabPaddingTop.PaddingLeft = UDim.new(0, 4)
tabPaddingTop.PaddingRight = UDim.new(0, 4)
tabPaddingTop.Parent = tabContainer

local tabLayout = Instance.new("UIListLayout")
tabLayout.Padding = UDim.new(0, 4)
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabLayout.VerticalAlignment = Enum.VerticalAlignment.Top
tabLayout.Parent = tabContainer

-- Hàm tạo nút tab
local function createTabButton(name)
    local tab = Instance.new("TextButton")
    tab.Name = name
    tab.Text = name
    tab.Size = UDim2.new(1, 0, 0, 32)
    tab.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    tab.TextColor3 = Color3.new(1, 1, 1)
    tab.Font = Enum.Font.Gotham
    tab.TextScaled = true
    tab.BackgroundTransparency = 0.3
    tab.ZIndex = 110002
    tab.Active = true
    tab.Selectable = true
    tab.Parent = tabContainer
    Instance.new("UICorner", tab).CornerRadius = UDim.new(0, 5)
    local tabStroke = Instance.new("UIStroke")
    tabStroke.Thickness = 1
    tabStroke.Color = Color3.fromRGB(0, 0, 0)
    tabStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    tabStroke.Parent = tab
    return tab
end

local tab1Button = createTabButton("Main")
local tab2Button = createTabButton("Visual")
local tab3Button = createTabButton("Setting")

-- Hàm tạo khung tab
local function createTabFrame(name)
    local frame = Instance.new("Frame")
    frame.Name = name
    frame.Size = UDim2.new(1, -80, 1, -56)
    frame.Position = UDim2.new(0, 72, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.5
    frame.Visible = false
    frame.ZIndex = 110003
    frame.Parent = mainFrame
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
    return frame
end

local tab1Frame = createTabFrame("Tab1Frame")
local tab2Frame = createTabFrame("VisualFrame")

local tab3Frame = Instance.new("Frame")
tab3Frame.Name = "SettingFrame"
tab3Frame.Size = UDim2.new(1, -80, 1, -56)
tab3Frame.Position = UDim2.new(0, 72, 0, 40)
tab3Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
tab3Frame.BackgroundTransparency = 0.5
tab3Frame.Visible = false
tab3Frame.ZIndex = 110003
tab3Frame.Parent = mainFrame
Instance.new("UICorner", tab3Frame).CornerRadius = UDim.new(0, 8)

local tab3Layout = Instance.new("UIListLayout")
tab3Layout.Padding = UDim.new(0, 10)
tab3Layout.SortOrder = Enum.SortOrder.LayoutOrder
tab3Layout.Parent = tab3Frame

local tab3Padding = Instance.new("UIPadding")
tab3Padding.PaddingLeft = UDim.new(0, 10)
tab3Padding.PaddingTop = UDim.new(0, 10)
tab3Padding.Parent = tab3Frame

-- Nút bật/tắt Aimbot
local aimbotToggle = Instance.new("TextButton")
aimbotToggle.Size = UDim2.new(1, -20, 0, 30)
aimbotToggle.Position = UDim2.new(0, 10, 0, 10)
aimbotToggle.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
aimbotToggle.Text = "Aimbot: Off"
aimbotToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
aimbotToggle.TextScaled = true
aimbotToggle.TextXAlignment = Enum.TextXAlignment.Center
aimbotToggle.ZIndex = 110004
aimbotToggle.Parent = tab1Frame
Instance.new("UICorner", aimbotToggle).CornerRadius = UDim.new(0, 8)
local aimbotStroke = Instance.new("UIStroke")
aimbotStroke.Thickness = 1
aimbotStroke.Color = Color3.fromRGB(0, 0, 0)
aimbotStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
aimbotStroke.Parent = aimbotToggle

-- Nút FOV
local fovButton = Instance.new("TextButton")
fovButton.Size = UDim2.new(1, -20, 0, 30)
fovButton.Position = UDim2.new(0, 10, 0, 50)
fovButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
fovButton.Text = "FOV: " .. fov
fovButton.TextColor3 = Color3.fromRGB(255, 255, 255)
fovButton.TextScaled = true
fovButton.TextXAlignment = Enum.TextXAlignment.Center
fovButton.ZIndex = 110004
fovButton.Parent = tab1Frame
Instance.new("UICorner", fovButton).CornerRadius = UDim.new(0, 8)
local fovStroke = Instance.new("UIStroke")
fovStroke.Thickness = 1
fovStroke.Color = Color3.fromRGB(0, 0, 0)
fovStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
fovStroke.Parent = fovButton

-- Thanh trượt FOV
local sliderBackground = Instance.new("Frame")
sliderBackground.Size = UDim2.new(1, -20, 0, 10)
sliderBackground.Position = UDim2.new(0, 10, 0, 90)
sliderBackground.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
sliderBackground.ZIndex = 110004
sliderBackground.Parent = tab1Frame
Instance.new("UICorner", sliderBackground).CornerRadius = UDim.new(0, 8)

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(fov / 500, 0, 1, 0)
sliderFill.Position = UDim2.new(0, 0, 0, 0)
sliderFill.BackgroundColor3 = drawbarColor
sliderFill.ZIndex = 110005
sliderFill.Parent = sliderBackground
Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(0, 8)

-- Nút Headshot
local headWinRateButton = Instance.new("TextButton")
headWinRateButton.Size = UDim2.new(1, -20, 0, 30)
headWinRateButton.Position = UDim2.new(0, 10, 0, 110)
headWinRateButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
headWinRateButton.Text = "Headshot: " .. headWinRate
headWinRateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
headWinRateButton.TextScaled = true
headWinRateButton.TextXAlignment = Enum.TextXAlignment.Center
headWinRateButton.ZIndex = 110004
headWinRateButton.Parent = tab1Frame
Instance.new("UICorner", headWinRateButton).CornerRadius = UDim.new(0, 8)
local headWinRateStroke = Instance.new("UIStroke")
headWinRateStroke.Thickness = 1
headWinRateStroke.Color = Color3.fromRGB(0, 0, 0)
headWinRateStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
headWinRateStroke.Parent = headWinRateButton

-- Thanh trượt Headshot
local headWinRateSliderBackground = Instance.new("Frame")
headWinRateSliderBackground.Size = UDim2.new(1, -20, 0, 10)
headWinRateSliderBackground.Position = UDim2.new(0, 10, 0, 150)
headWinRateSliderBackground.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
headWinRateSliderBackground.ZIndex = 110004
headWinRateSliderBackground.Parent = tab1Frame
Instance.new("UICorner", headWinRateSliderBackground).CornerRadius = UDim.new(0, 8)

local headWinRateSliderFill = Instance.new("Frame")
headWinRateSliderFill.Size = UDim2.new(headWinRate / 90, 0, 1, 0)
headWinRateSliderFill.Position = UDim2.new(0, 0, 0, 0)
headWinRateSliderFill.BackgroundColor3 = drawbarColor
headWinRateSliderFill.ZIndex = 110005
headWinRateSliderFill.Parent = headWinRateSliderBackground
Instance.new("UICorner", headWinRateSliderFill).CornerRadius = UDim.new(0, 8)

-- Nút Headshot 100%
local headShot100Toggle = Instance.new("TextButton")
headShot100Toggle.Size = UDim2.new(1, -20, 0, 30)
headShot100Toggle.Position = UDim2.new(0, 10, 0, 170)
headShot100Toggle.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
headShot100Toggle.Text = "Head Shot 100%: Off"
headShot100Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
headShot100Toggle.TextScaled = true
headShot100Toggle.TextXAlignment = Enum.TextXAlignment.Center
headShot100Toggle.ZIndex = 110004
headShot100Toggle.Parent = tab1Frame
Instance.new("UICorner", headShot100Toggle).CornerRadius = UDim.new(0, 8)
local headShot100Stroke = Instance.new("UIStroke")
headShot100Stroke.Thickness = 1
headShot100Stroke.Color = Color3.fromRGB(0, 0, 0)
headShot100Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
headShot100Stroke.Parent = headShot100Toggle

-- Nút bật/tắt ESP Line
local espLineToggle = Instance.new("TextButton")
espLineToggle.Size = UDim2.new(1, -20, 0, 30)
espLineToggle.Position = UDim2.new(0, 10, 0, 10)
espLineToggle.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
espLineToggle.Text = "ESP Line: Off"
espLineToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
espLineToggle.TextScaled = true
espLineToggle.TextXAlignment = Enum.TextXAlignment.Center
espLineToggle.ZIndex = 110004
espLineToggle.Parent = tab2Frame
Instance.new("UICorner", espLineToggle).CornerRadius = UDim.new(0, 8)
local espLineStroke = Instance.new("UIStroke")
espLineStroke.Thickness = 1
espLineStroke.Color = Color3.fromRGB(0, 0, 0)
espLineStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
espLineStroke.Parent = espLineToggle

-- Nút bật/tắt ESP Highlight
local espToggle = Instance.new("TextButton")
espToggle.Size = UDim2.new(1, -20, 0, 30)
espToggle.Position = UDim2.new(0, 10, 0, 50)
espToggle.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
espToggle.Text = "ESP Highlight: Off"
espToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
espToggle.TextScaled = true
espToggle.TextXAlignment = Enum.TextXAlignment.Center
espToggle.ZIndex = 110004
espToggle.Parent = tab2Frame
Instance.new("UICorner", espToggle).CornerRadius = UDim.new(0, 8)
local espStroke = Instance.new("UIStroke")
espStroke.Thickness = 1
espStroke.Color = Color3.fromRGB(0, 0, 0)
espStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
espStroke.Parent = espToggle

local buttonHeight = 30
local pickerHeight = 70

-- Nút chọn màu ESP Line
local espLineColorButton = Instance.new("TextButton")
espLineColorButton.Size = UDim2.new(1, -20, 0, buttonHeight)
espLineColorButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
espLineColorButton.Text = "ESP Line Color: Red"
espLineColorButton.TextColor3 = Color3.fromRGB(255, 255, 255)
espLineColorButton.TextScaled = true
espLineColorButton.TextXAlignment = Enum.TextXAlignment.Center
espLineColorButton.ZIndex = 110004
espLineColorButton.LayoutOrder = 1
espLineColorButton.Parent = tab3Frame
Instance.new("UICorner", espLineColorButton).CornerRadius = UDim.new(0, 8)
local espLineColorStroke = Instance.new("UIStroke")
espLineColorStroke.Thickness = 1
espLineColorStroke.Color = Color3.fromRGB(0, 0, 0)
espLineColorStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
espLineColorStroke.Parent = espLineColorButton

-- Khung chọn màu ESP Line
local colorPickerFrame = Instance.new("Frame")
colorPickerFrame.Size = UDim2.new(0, 140, 0, pickerHeight)
colorPickerFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
colorPickerFrame.BackgroundTransparency = 0.5
colorPickerFrame.Visible = false
colorPickerFrame.ZIndex = 110005
colorPickerFrame.LayoutOrder = 2
colorPickerFrame.Parent = tab3Frame
Instance.new("UICorner", colorPickerFrame).CornerRadius = UDim.new(0, 8)
local colorPickerStroke = Instance.new("UIStroke")
colorPickerStroke.Thickness = 1
colorPickerStroke.Color = Color3.fromRGB(0, 0, 0)
colorPickerStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
colorPickerStroke.Parent = colorPickerFrame

local colorPickerGrid = Instance.new("UIGridLayout")
colorPickerGrid.CellSize = UDim2.new(0, 30, 0, 30)
colorPickerGrid.CellPadding = UDim2.new(0, 5, 0, 5)
colorPickerGrid.HorizontalAlignment = Enum.HorizontalAlignment.Center
colorPickerGrid.VerticalAlignment = Enum.VerticalAlignment.Center
colorPickerGrid.Parent = colorPickerFrame

-- Nút chọn màu ESP Highlight
local espHighlightColorButton = Instance.new("TextButton")
espHighlightColorButton.Size = UDim2.new(1, -20, 0, buttonHeight)
espHighlightColorButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
espHighlightColorButton.Text = "ESP Highlight Color: Red"
espHighlightColorButton.TextColor3 = Color3.fromRGB(255, 255, 255)
espHighlightColorButton.TextScaled = true
espHighlightColorButton.TextXAlignment = Enum.TextXAlignment.Center
espHighlightColorButton.ZIndex = 110004
espHighlightColorButton.LayoutOrder = 3
espHighlightColorButton.Parent = tab3Frame
Instance.new("UICorner", espHighlightColorButton).CornerRadius = UDim.new(0, 8)
local espHighlightColorStroke = Instance.new("UIStroke")
espHighlightColorStroke.Thickness = 1
espHighlightColorStroke.Color = Color3.fromRGB(0, 0, 0)
espHighlightColorStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
espHighlightColorStroke.Parent = espHighlightColorButton

-- Khung chọn màu ESP Highlight
local highlightColorPickerFrame = Instance.new("Frame")
highlightColorPickerFrame.Size = UDim2.new(0, 140, 0, pickerHeight)
highlightColorPickerFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
highlightColorPickerFrame.BackgroundTransparency = 0.5
highlightColorPickerFrame.Visible = false
highlightColorPickerFrame.ZIndex = 110005
highlightColorPickerFrame.LayoutOrder = 4
highlightColorPickerFrame.Parent = tab3Frame
Instance.new("UICorner", highlightColorPickerFrame).CornerRadius = UDim.new(0, 8)
local highlightColorPickerStroke = Instance.new("UIStroke")
highlightColorPickerStroke.Thickness = 1
highlightColorPickerStroke.Color = Color3.fromRGB(0, 0, 0)
highlightColorPickerStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
highlightColorPickerStroke.Parent = highlightColorPickerFrame

local highlightColorPickerGrid = Instance.new("UIGridLayout")
highlightColorPickerGrid.CellSize = UDim2.new(0, 30, 0, 30)
highlightColorPickerGrid.CellPadding = UDim2.new(0, 5, 0, 5)
highlightColorPickerGrid.HorizontalAlignment = Enum.HorizontalAlignment.Center
highlightColorPickerGrid.VerticalAlignment = Enum.VerticalAlignment.Center
highlightColorPickerGrid.Parent = highlightColorPickerFrame

-- Nút chọn màu FOV
local fovColorButton = Instance.new("TextButton")
fovColorButton.Size = UDim2.new(1, -20, 0, buttonHeight)
fovColorButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
fovColorButton.Text = "FOV Color: Red"
fovColorButton.TextColor3 = Color3.fromRGB(255, 255, 255)
fovColorButton.TextScaled = true
fovColorButton.TextXAlignment = Enum.TextXAlignment.Center
fovColorButton.ZIndex = 110004
fovColorButton.LayoutOrder = 5
fovColorButton.Parent = tab3Frame
Instance.new("UICorner", fovColorButton).CornerRadius = UDim.new(0, 8)
local fovColorStroke = Instance.new("UIStroke")
fovColorStroke.Thickness = 1
fovColorStroke.Color = Color3.fromRGB(0, 0, 0)
fovColorStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
fovColorStroke.Parent = fovColorButton

-- Khung chọn màu FOV
local fovColorPickerFrame = Instance.new("Frame")
fovColorPickerFrame.Size = UDim2.new(0, 140, 0, pickerHeight)
fovColorPickerFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
fovColorPickerFrame.BackgroundTransparency = 0.5
fovColorPickerFrame.Visible = false
fovColorPickerFrame.ZIndex = 110005
fovColorPickerFrame.LayoutOrder = 6
fovColorPickerFrame.Parent = tab3Frame
Instance.new("UICorner", fovColorPickerFrame).CornerRadius = UDim.new(0, 8)
local fovColorPickerStroke = Instance.new("UIStroke")
fovColorPickerStroke.Thickness = 1
fovColorPickerStroke.Color = Color3.fromRGB(0, 0, 0)
fovColorPickerStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
fovColorPickerStroke.Parent = fovColorPickerFrame

local fovColorPickerGrid = Instance.new("UIGridLayout")
fovColorPickerGrid.CellSize = UDim2.new(0, 30, 0, 30)
fovColorPickerGrid.CellPadding = UDim2.new(0, 5, 0, 5)
fovColorPickerGrid.HorizontalAlignment = Enum.HorizontalAlignment.Center
fovColorPickerGrid.VerticalAlignment = Enum.VerticalAlignment.Center
fovColorPickerGrid.Parent = fovColorPickerFrame

-- Nút chọn màu Slider
local drawbarColorButton = Instance.new("TextButton")
drawbarColorButton.Size = UDim2.new(1, -20, 0, buttonHeight)
drawbarColorButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
drawbarColorButton.Text = "Slider Color: Red"
drawbarColorButton.TextColor3 = Color3.fromRGB(255, 255, 255)
drawbarColorButton.TextScaled = true
drawbarColorButton.TextXAlignment = Enum.TextXAlignment.Center
drawbarColorButton.ZIndex = 110004
drawbarColorButton.LayoutOrder = 7
drawbarColorButton.Parent = tab3Frame
Instance.new("UICorner", drawbarColorButton).CornerRadius = UDim.new(0, 8)
local drawbarColorStroke = Instance.new("UIStroke")
drawbarColorStroke.Thickness = 1
drawbarColorStroke.Color = Color3.fromRGB(0, 0, 0)
drawbarColorStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
drawbarColorStroke.Parent = drawbarColorButton

-- Khung chọn màu Slider
local drawbarColorPickerFrame = Instance.new("Frame")
drawbarColorPickerFrame.Size = UDim2.new(0, 140, 0, pickerHeight)
drawbarColorPickerFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
drawbarColorPickerFrame.BackgroundTransparency = 0.5
drawbarColorPickerFrame.Visible = false
drawbarColorPickerFrame.ZIndex = 110005
drawbarColorPickerFrame.LayoutOrder = 8
drawbarColorPickerFrame.Parent = tab3Frame
Instance.new("UICorner", drawbarColorPickerFrame).CornerRadius = UDim.new(0, 8)
local drawbarColorPickerStroke = Instance.new("UIStroke")
drawbarColorPickerStroke.Thickness = 1
drawbarColorPickerStroke.Color = Color3.fromRGB(0, 0, 0)
drawbarColorPickerStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
drawbarColorPickerStroke.Parent = drawbarColorPickerFrame

local drawbarColorPickerGrid = Instance.new("UIGridLayout")
drawbarColorPickerGrid.CellSize = UDim2.new(0, 30, 0, 30)
drawbarColorPickerGrid.CellPadding = UDim2.new(0, 5, 0, 5)
drawbarColorPickerGrid.HorizontalAlignment = Enum.HorizontalAlignment.Center
drawbarColorPickerGrid.VerticalAlignment = Enum.VerticalAlignment.Center
drawbarColorPickerGrid.Parent = drawbarColorPickerFrame

-- Danh sách màu
local colors = {
    {Name = "Red", Color = Color3.fromRGB(255, 0, 0)},
    {Name = "Blue", Color = Color3.fromRGB(0, 0, 255)},
    {Name = "Pink", Color = Color3.fromRGB(255, 105, 180)},
    {Name = "Yellow", Color = Color3.fromRGB(255, 255, 0)},
    {Name = "Green", Color = Color3.fromRGB(0, 255, 0)},
    {Name = "White", Color = Color3.fromRGB(255, 255, 255)},
    {Name = "Brown", Color = Color3.fromRGB(139, 69, 19)},
    {Name = "Black", Color = Color3.fromRGB(0, 0, 0)}
}

for _, color in ipairs(colors) do
    local lineColorButton = Instance.new("TextButton")
    lineColorButton.Size = UDim2.new(0, 30, 0, 30)
    lineColorButton.BackgroundColor3 = color.Color
    lineColorButton.Text = ""
    lineColorButton.ZIndex = 110006
    lineColorButton.Parent = colorPickerFrame
    Instance.new("UICorner", lineColorButton).CornerRadius = UDim.new(0, 5)
    local lineColorButtonStroke = Instance.new("UIStroke")
    lineColorButtonStroke.Thickness = 1
    lineColorButtonStroke.Color = Color3.fromRGB(0, 0, 0)
    lineColorButtonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    lineColorButtonStroke.Parent = lineColorButton
    lineColorButton.MouseButton1Click:Connect(function()
        espLineColor = color.Color
        espLineColorButton.Text = "ESP Line Color: " .. color.Name
        colorPickerFrame.Visible = false
    end)

    local highlightColorButton = Instance.new("TextButton")
    highlightColorButton.Size = UDim2.new(0, 30, 0, 30)
    highlightColorButton.BackgroundColor3 = color.Color
    highlightColorButton.Text = ""
    highlightColorButton.ZIndex = 110006
    highlightColorButton.Parent = highlightColorPickerFrame
    Instance.new("UICorner", highlightColorButton).CornerRadius = UDim.new(0, 5)
    local highlightColorButtonStroke = Instance.new("UIStroke")
    highlightColorButtonStroke.Thickness = 1
    highlightColorButtonStroke.Color = Color3.fromRGB(0, 0, 0)
    highlightColorButtonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    highlightColorButtonStroke.Parent = highlightColorButton
    highlightColorButton.MouseButton1Click:Connect(function()
        espHighlightColor = color.Color
        espHighlightColorButton.Text = "ESP Highlight Color: " .. color.Name
        highlightColorPickerFrame.Visible = false
    end)

    local fovColorButton = Instance.new("TextButton")
    fovColorButton.Size = UDim2.new(0, 30, 0, 30)
    fovColorButton.BackgroundColor3 = color.Color
    fovColorButton.Text = ""
    fovColorButton.ZIndex = 110006
    fovColorButton.Parent = fovColorPickerFrame
    Instance.new("UICorner", fovColorButton).CornerRadius = UDim.new(0, 5)
    local fovColorButtonStroke = Instance.new("UIStroke")
    fovColorButtonStroke.Thickness = 1
    fovColorButtonStroke.Color = Color3.fromRGB(0, 0, 0)
    fovColorButtonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    fovColorButtonStroke.Parent = fovColorButton
    fovColorButton.MouseButton1Click:Connect(function()
        fovColor = color.Color
        fovColorButton.Text = "FOV Color: " .. color.Name
        FOVring.Color = fovColor
        fovColorPickerFrame.Visible = false
    end)

    local drawbarColorButton = Instance.new("TextButton")
    drawbarColorButton.Size = UDim2.new(0, 30, 0, 30)
    drawbarColorButton.BackgroundColor3 = color.Color
    drawbarColorButton.Text = ""
    drawbarColorButton.ZIndex = 110006
    drawbarColorButton.Parent = drawbarColorPickerFrame
    Instance.new("UICorner", drawbarColorButton).CornerRadius = UDim.new(0, 5)
    local drawbarColorButtonStroke = Instance.new("UIStroke")
    drawbarColorButtonStroke.Thickness = 1
    drawbarColorButtonStroke.Color = Color3.fromRGB(0, 0, 0)
    drawbarColorButtonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    drawbarColorButtonStroke.Parent = drawbarColorButton
    drawbarColorButton.MouseButton1Click:Connect(function()
        drawbarColor = color.Color
        drawbarColorButton.Text = "Slider Color: " .. color.Name
        if sliderFill then sliderFill.BackgroundColor3 = drawbarColor end
        if headWinRateSliderFill then headWinRateSliderFill.BackgroundColor3 = drawbarColor end
        drawbarColorPickerFrame.Visible = false
    end)
end

-- Kéo thả thanh tiêu đề
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDraggingMenu = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

titleBar.InputChanged:Connect(function(input)
    if isDraggingMenu and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- Kéo thả logo
logo.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDraggingLogo = true
        dragStart = input.Position
        startPos = logo.Position
    end
end)

logo.InputChanged:Connect(function(input)
    if isDraggingLogo and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        logo.Position = UDim2.new(
            0, startPos.X.Offset + delta.X,
            0, startPos.Y.Offset + delta.Y
        )
    end
end)

-- Kết thúc kéo thả
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDraggingMenu = false
        isDraggingLogo = false
        draggingSlider = false
        draggingHeadWinRateSlider = false
    end
end)

-- Thông báo hướng dẫn
StarterGui:SetCore("SendNotification", {
    Title = "Nexus Hub",
    Text = "Drag Title Bar or Logo To Move",
    Duration = 5
})

-- Kiểm tra team
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

-- Tạo ESP
local function CreateESP(playerChar)
    if not playerChar then return end
    local part = playerChar:FindFirstChild("HumanoidRootPart")
    local humanoid = playerChar:FindFirstChild("Humanoid")
    if not part or not humanoid or humanoid.Health <= 0 then return end

    if ESPHandles[playerChar] then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.Adornee = playerChar
    highlight.FillColor = espHighlightColor
    highlight.OutlineColor = espHighlightColor
    highlight.FillTransparency = 0.7
    highlight.OutlineTransparency = 0
    highlight.Parent = playerChar

    local line = Drawing.new("Line")
    line.Visible = false
    line.Color = espLineColor
    line.Thickness = 2
    line.Transparency = 1

    ESPHandles[playerChar] = {Highlight = highlight, Line = line}

    humanoid.Died:Connect(function()
        if ESPHandles[playerChar] then
            ESPHandles[playerChar].Highlight:Destroy()
            ESPHandles[playerChar].Line:Remove()
            ESPHandles[playerChar] = nil
        end
    end)

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

-- Xóa ESP
local function ClearESP()
    for obj, handles in pairs(ESPHandles) do
        if handles.Highlight then handles.Highlight:Destroy() end
        if handles.Line then handles.Line:Remove() end
    end
    ESPHandles = {}
end

-- Làm sạch ESP không hợp lệ
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

-- Kiểm tra người chơi hợp lệ
local function isPlayer(obj)
    return obj and obj:IsA("Model")
        and obj:FindFirstChild("Humanoid")
        and obj:FindFirstChild("Head")
        and obj:FindFirstChild("HumanoidRootPart")
        and obj:FindFirstChild("Humanoid").Health > 0
        and Players:GetPlayerFromCharacter(obj)
end

-- Cập nhật danh sách người chơi
local function updatePlayers()
    validPlayers = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and isPlayer(player.Character) then
            table.insert(validPlayers, player.Character)
        end
    end
end

-- Cập nhật vòng FOV và các bản vẽ
local function updateDrawings()
    if not Cam or Cam.ViewportSize.X <= 0 or Cam.ViewportSize.Y <= 0 then return end
    FOVring.Position = Cam.ViewportSize / 2
    FOVring.Radius = fov * (Cam.ViewportSize.Y / 1080)
    FOVring.Color = fovColor
end

-- Dự đoán vị trí mục tiêu
local function predictPos(target)
    if not target then return nil end
    local head = target:FindFirstChild("Head")
    local rootPart = target:FindFirstChild("HumanoidRootPart")
    if not head or not rootPart then return nil end
    local velocity = rootPart.Velocity or Vector3.zero
    velocity = lastVelocity:Lerp(velocity, 0.6)
    lastVelocity = velocity
    local predictionTime = 0.03
    local targetPart = aimAtHead and head or rootPart
    return targetPart.Position + velocity * predictionTime, velocity
end

-- Tìm mục tiêu
local function getTarget()
    local nearest = nil
    local minDistance = math.huge
    if not Cam then return nil end
    local viewportCenter = Cam.ViewportSize / 2
    local useTeams = hasTeams()
    for _, target in ipairs(validPlayers) do
        local targetPlayer = Players:GetPlayerFromCharacter(target)
        local humanoid = target:FindFirstChild("Humanoid")
        if targetPlayer and humanoid and humanoid.Health > 0 then
            if not useTeams or (useTeams and targetPlayer.Team ~= LocalPlayer.Team) then
                local predictedPos, velocity = predictPos(target)
                if predictedPos then
                    local screenPos, visible = Cam:WorldToViewportPoint(predictedPos)
                    if visible and screenPos.Z > 0 then
                        local distance = (Vector2.new(screenPos.X, screenPos.Y) - viewportCenter).Magnitude
                        local targetDirection = (predictedPos - Cam.CFrame.Position).Unit
                        local cameraLook = Cam.CFrame.LookVector
                        local angle = math.deg(math.acos(targetDirection:Dot(cameraLook)))
                        if distance < minDistance and distance < fov and angle < 90 then
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

-- Ngắm mục tiêu
local function aim(targetPosition, targetVelocity)
    if not targetPosition or not Cam then return end
    local currentCF = Cam.CFrame
    local targetDirection = (targetPosition - currentCF.Position).Unit
    if targetDirection.Magnitude > 0 then
        local baseSmoothFactor = 0.5
        local velocityMagnitude = targetVelocity.Magnitude
        local dynamicSmoothFactor = math.clamp(baseSmoothFactor + velocityMagnitude * 0.005, 0.5, 0.8)
        local newLookVector = currentCF.LookVector:Lerp(targetDirection, dynamicSmoothFactor)
        Cam.CFrame = CFrame.new(currentCF.Position, currentCF.Position + newLookVector)
    end
end

-- Sự kiện click logo
logo.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    if not mainFrame.Visible then
        colorPickerFrame.Visible = false
        highlightColorPickerFrame.Visible = false
        fovColorPickerFrame.Visible = false
        drawbarColorPickerFrame.Visible = false
    end
end)

-- Sự kiện click nút thu nhỏ
closeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    colorPickerFrame.Visible = false
    highlightColorPickerFrame.Visible = false
    fovColorPickerFrame.Visible = false
    drawbarColorPickerFrame.Visible = false
end)

-- Sự kiện click nút thoát
exitButton.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
    FOVring:Remove()
    ClearESP()
end)

-- Sự kiện click tab Main
tab1Button.MouseButton1Click:Connect(function()
    tab1Frame.Visible = true
    tab2Frame.Visible = false
    tab3Frame.Visible = false
    tab1Button.BackgroundTransparency = 0.3
    tab2Button.BackgroundTransparency = 0.7
    tab3Button.BackgroundTransparency = 0.7
    colorPickerFrame.Visible = false
    highlightColorPickerFrame.Visible = false
    fovColorPickerFrame.Visible = false
    drawbarColorPickerFrame.Visible = false
end)

-- Sự kiện click tab Visual
tab2Button.MouseButton1Click:Connect(function()
    tab1Frame.Visible = false
    tab2Frame.Visible = true
    tab3Frame.Visible = false
    tab1Button.BackgroundTransparency = 0.7
    tab2Button.BackgroundTransparency = 0.3
    tab3Button.BackgroundTransparency = 0.7
    colorPickerFrame.Visible = false
    highlightColorPickerFrame.Visible = false
    fovColorPickerFrame.Visible = false
    drawbarColorPickerFrame.Visible = false
end)

-- Sự kiện click tab Setting
tab3Button.MouseButton1Click:Connect(function()
    tab1Frame.Visible = false
    tab2Frame.Visible = false
    tab3Frame.Visible = true
    tab1Button.BackgroundTransparency = 0.7
    tab2Button.BackgroundTransparency = 0.7
    tab3Button.BackgroundTransparency = 0.3
    colorPickerFrame.Visible = false
    highlightColorPickerFrame.Visible = false
    fovColorPickerFrame.Visible = false
    drawbarColorPickerFrame.Visible = false
end)

-- Sự kiện bật/tắt Aimbot
aimbotToggle.MouseButton1Click:Connect(function()
    isAiming = not isAiming
    FOVring.Visible = isAiming
    aimbotToggle.Text = "Aimbot: " .. (isAiming and "On" or "Off")
    if not isAiming then
        currentTarget = nil
    end
end)

-- Sự kiện bật/tắt ESP Highlight
espToggle.MouseButton1Click:Connect(function()
    isESPEnabled = not isESPEnabled
    espToggle.Text = "ESP Highlight: " .. (isESPEnabled and "On" or "Off")
end)

-- Sự kiện bật/tắt ESP Line
espLineToggle.MouseButton1Click:Connect(function()
    isESPLineEnabled = not isESPLineEnabled
    espLineToggle.Text = "ESP Line: " .. (isESPLineEnabled and "On" or "Off")
end)

-- Sự kiện bật/tắt Headshot 100%
headShot100Toggle.MouseButton1Click:Connect(function()
    isHeadShot100Enabled = not isHeadShot100Enabled
    headShot100Toggle.Text = "Head Shot 100%: " .. (isHeadShot100Enabled and "On" or "Off")
    if isHeadShot100Enabled then
        savedHeadWinRate = headWinRate
        headWinRate = 100
        headWinRateButton.Text = "Headshot: 100"
        headWinRateSliderBackground.Visible = false
        headWinRateButton.Visible = false
        headWinRateSliderFill.Visible = false
    else
        headWinRate = savedHeadWinRate
        headWinRateButton.Text = "Headshot: " .. headWinRate
        headWinRateSliderBackground.Visible = true
        headWinRateButton.Visible = true
        headWinRateSliderFill.Visible = true
        headWinRateSliderFill.Size = UDim2.new(headWinRate / 90, 0, 1, 0)
    end
end)

-- Sự kiện click chọn màu ESP Line
espLineColorButton.MouseButton1Click:Connect(function()
    highlightColorPickerFrame.Visible = false
    fovColorPickerFrame.Visible = false
    drawbarColorPickerFrame.Visible = false
    colorPickerFrame.Visible = not colorPickerFrame.Visible
end)

-- Sự kiện click chọn màu ESP Highlight
espHighlightColorButton.MouseButton1Click:Connect(function()
    colorPickerFrame.Visible = false
    fovColorPickerFrame.Visible = false
    drawbarColorPickerFrame.Visible = false
    highlightColorPickerFrame.Visible = not highlightColorPickerFrame.Visible
end)

-- Sự kiện click chọn màu FOV
fovColorButton.MouseButton1Click:Connect(function()
    colorPickerFrame.Visible = false
    highlightColorPickerFrame.Visible = false
    drawbarColorPickerFrame.Visible = false
    fovColorPickerFrame.Visible = not fovColorPickerFrame.Visible
end)

-- Sự kiện click chọn màu Slider
drawbarColorButton.MouseButton1Click:Connect(function()
    colorPickerFrame.Visible = false
    highlightColorPickerFrame.Visible = false
    fovColorPickerFrame.Visible = false
    drawbarColorPickerFrame.Visible = not drawbarColorPickerFrame.Visible
end)

-- Kéo thanh trượt FOV
sliderBackground.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingSlider = true
    end
end)

-- Kéo thanh trượt Headshot
headWinRateSliderBackground.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingHeadWinRateSlider = true
    end
end)

-- Vòng lặp chính
RunService.RenderStepped:Connect(function()
    local success, err = pcall(function()
        if not Cam or not Cam.Parent then return end
        updateDrawings()

        if draggingSlider and sliderBackground and sliderBackground.Parent then
            local mousePosX = UserInputService:GetMouseLocation().X
            local start = sliderBackground.AbsolutePosition.X
            local width = sliderBackground.AbsoluteSize.X
            if width > 0 then
                local percent = math.clamp((mousePosX - start) / width, 0, 1)
                fov = math.floor(30 + percent * (500 - 30))
                fovButton.Text = "FOV: " .. fov
                sliderFill.Size = UDim2.new(percent, 0, 1, 0)
                FOVring.Radius = fov * (Cam.ViewportSize.Y / 1080)
            end
        end

        if draggingHeadWinRateSlider and not isHeadShot100Enabled and headWinRateSliderBackground and headWinRateSliderBackground.Parent then
            local mousePosX = UserInputService:GetMouseLocation().X
            local start = headWinRateSliderBackground.AbsolutePosition.X
            local width = headWinRateSliderBackground.AbsoluteSize.X
            if width > 0 then
                local percent = math.clamp((mousePosX - start) / width, 0, 1)
                headWinRate = math.floor(1 + percent * (90 - 1))
                headWinRateButton.Text = "Headshot: " .. headWinRate
                headWinRateSliderFill.Size = UDim2.new(headWinRate / 90, 0, 1, 0)
            end
        end

        if isAiming then
            local currentTime = tick()
            if currentTime - lastPlayerUpdate >= 0.5 then
                updatePlayers()
                lastPlayerUpdate = currentTime
            end
            local newTarget = getTarget()
            if newTarget ~= currentTarget then
                currentTarget = newTarget
                aimAtHead = currentTarget and (isHeadShot100Enabled or math.random(1, 100) <= headWinRate)
            end
            if currentTarget then
                local predictedPosition, targetVelocity = predictPos(currentTarget)
                if predictedPosition then
                    aim(predictedPosition, targetVelocity)
                end
            end
        end

        if isESPEnabled or isESPLineEnabled then
            updatePlayers()
            CleanInvalidESP()
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
                                    if handles then
                                        if isESPEnabled and handles.Highlight then
                                            handles.Highlight.Enabled = true
                                            handles.Highlight.FillColor = espHighlightColor
                                            handles.Highlight.OutlineColor = espHighlightColor
                                        elseif handles.Highlight then
                                            handles.Highlight.Enabled = false
                                        end
                                        if isESPLineEnabled and handles.Line then
                                            local screenPos, visible = Cam:WorldToViewportPoint(npcPos)
                                            handles.Line.Visible = visible
                                            handles.Line.From = viewportCenter
                                            handles.Line.To = Vector2.new(screenPos.X, screenPos.Y)
                                            handles.Line.Color = espLineColor
                                        elseif handles.Line then
                                            handles.Line.Visible = false
                                        end
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
        warn("Error RenderStepped: " .. tostring(err))
    end
end)

-- Xử lý sự kiện người chơi tham gia
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function(char)
            updatePlayers()
        end)
    end
    updatePlayers()
end)

-- Xử lý sự kiện người chơi rời đi
Players.PlayerRemoving:Connect(function(player)
    if player.Character and ESPHandles[player.Character] then
        ESPHandles[player.Character].Highlight:Destroy()
        ESPHandles[player.Character].Line:Remove()
        ESPHandles[player.Character] = nil
    end
    updatePlayers()
end)

-- Khởi tạo
updatePlayers()
tab1Frame.Visible = true
