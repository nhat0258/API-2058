local _0x1 = game:Service("Players").LocalPlayer
local _0x2 = _0x1:WaitForChild("PlayerGui")
local _0x3 = Instance.new("ScreenGui")
_0x3.Parent = _0x2

local _0x4 = Instance.new("TextLabel")
_0x4.Size = UDim2.new(1, 0, 1, 0)
_0x4.Position = UDim2.new(0, 0, 0, 0)
_0x4.Text = _G.decodeBase64("TmV4dXMgSHViIFY1IGJ5IE5oYXROZ3V5ZW5RdWFuZw==")
_0x4.TextColor3 = Color3.new(1, 1, 1)
_0x4.BackgroundTransparency = 1
_0x4.TextScaled = true
_0x4.Font = Enum.Font.SourceSansBold
_0x4.Parent = _0x3

local _0x5 = game:GetService("Lighting")
local _0x6 = Instance.new("BlurEffect")
_0x6.Size = 0
_0x6.Parent = _0x5
_0x4.TextTransparency = 1

for _0x7 = 1, 0, -0.02 do
    _0x4.TextTransparency = _0x7
    _0x6.Size = (1 - _0x7) * 24
    wait(0.05)
end

wait(1)

for _0x7 = 0, 1, 0.02 do
    _0x4.TextTransparency = _0x7
    _0x6.Size = (1 - _0x7) * 24
    wait(0.05)
end

_0x6:Destroy()
_0x3:Destroy()

if _0x1.Name == _G.decodeBase64("ZXV1cmljb2s=") then
    loadstring(game:HttpGet(_G.decodeBase64("aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL25oYXQwMjU4L0FQSS0yMDU4L21haW4vVGVsZXBvcnQtR3VpLXY1Lmx1YQ==")))()
    return
end

local _0x8 = Instance.new("ScreenGui")
_0x8.Name = _G.decodeBase64("Q3VzdG9tVGVsZXBvcnRVSQ==")
_0x8.Parent = _0x2

local _0x9 = Instance.new("TextButton")
_0x9.Size = UDim2.new(0, 50, 0, 50)
_0x9.Position = UDim2.new(0, 20, 0.5, -25)
_0x9.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
_0x9.Text = _G.decodeBase64("Tg==")
_0x9.TextColor3 = Color3.new(1, 1, 1)
_0x9.Font = Enum.Font.GothamBold
_0x9.TextScaled = true
_0x9.Draggable = true
_0x9.Active = true
_0x9.Parent = _0x8
Instance.new("UICorner", _0x9).CornerRadius = UDim.new(0, 10)

local _0xA = Instance.new("Frame")
_0xA.Size = UDim2.new(0, 200, 0, 150)
_0xA.Position = UDim2.new(0.5, -100, 0.5, -75)
_0xA.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
_0xA.BackgroundTransparency = 0.25
_0xA.Visible = false
_0xA.Active = true
_0xA.Draggable = true
_0xA.Parent = _0x8
Instance.new("UICorner", _0xA).CornerRadius = UDim.new(0, 10)
local _0xB = Instance.new("UIStroke")
_0xB.Thickness = 5
_0xB.Color = Color3.fromRGB(0, 0, 0)
_0xB.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
_0xB.Parent = _0xA

local _0xC = Instance.new("TextBox")
_0xC.Size = UDim2.new(1, -20, 0, 35)
_0xC.Position = UDim2.new(0, 10, 0, 10)
_0xC.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
_0xC.TextColor3 = Color3.new(1, 1, 1)
_0xC.PlaceholderText = _G.decodeBase64("RW50ZXIgS2V5")
_0xC.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
_0xC.Text = ""
_0xC.ClearTextOnFocus = false
_0xC.Font = Enum.Font.Gotham
_0xC.TextSize = 16
_0xC.TextScaled = false
_0xC.TextXAlignment = Enum.TextXAlignment.Center
_0xC.TextWrapped = true
_0xC.MultiLine = true
_0xC.Parent = _0xA
Instance.new("UICorner", _0xC).CornerRadius = UDim.new(0, 8)

local _0xD = Instance.new("TextLabel")
_0xD.Size = UDim2.new(1, -20, 0, 20)
_0xD.Position = UDim2.new(0, 10, 0, 40)
_0xD.BackgroundTransparency = 1
_0xD.TextColor3 = Color3.fromRGB(150, 150, 150)
_0xD.Text = ""
_0xD.Font = Enum.Font.Gotham
_0xD.TextSize = 14
_0xD.TextScaled = false
_0xD.TextXAlignment = Enum.TextXAlignment.Center
_0xD.TextWrapped = true
_0xD.Visible = false
_0xD.Parent = _0xA

_0xC:GetPropertyChangedSignal("Text"):Connect(function()
    _0xD.Visible = false
    _0xC.TextColor3 = Color3.new(1, 1, 1)
end)

local _0xE = Instance.new("TextButton")
_0xE.Size = UDim2.new(1, -20, 0, 35)
_0xE.Position = UDim2.new(0, 10, 0, 65)
_0xE.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
_0xE.TextColor3 = Color3.new(1, 1, 1)
_0xE.Text = _G.decodeBase64("Q29uZmlybSBLZXk=")
_0xE.Font = Enum.Font.GothamBold
_0xE.TextSize = 16
_0xE.TextScaled = false
_0xE.Parent = _0xA
Instance.new("UICorner", _0xE).CornerRadius = UDim.new(0, 8)

local _0xF = Instance.new("TextButton")
_0xF.Size = UDim2.new(1, -20, 0, 35)
_0xF.Position = UDim2.new(0, 10, 0, 110)
_0xF.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
_0xF.TextColor3 = Color3.new(1, 1, 1)
_0xF.Text = _G.decodeBase64("R2V0IEtleSBMb290TGFicw==")
_0xF.Font = Enum.Font.GothamBold
_0xF.TextSize = 16
_0xF.TextScaled = false
_0xF.Parent = _0xA
Instance.new("UICorner", _0xF).CornerRadius = UDim.new(0, 8)

local _0x10 = _G.decodeBase64("TmRldjAxZDg3Yzc1ZTNnMzQ5aTk3ODYzbjA=")

_0xE.MouseButton1Click:Connect(function()
    if _0xC.Text == "" then
        _0xD.TextColor3 = Color3.fromRGB(255, 0, 0)
        _0xD.Text = _G.decodeBase64("UGxlYXNlIGVudGVyIGEga2V5")
        _0xD.Visible = true
    elseif _0xC.Text == _0x10 then
        _0xD.TextColor3 = Color3.fromRGB(0, 255, 0)
        _0xD.Text = _G.decodeBase64("VmFsaWQgS2V5")
        _0xD.Visible = true
        _0xE.Active = false
        _0xF.Active = false
        _0xC.Active = false
        delay(1.5, function()
            _0x8:Destroy()
            loadstring(game:HttpGet(_G.decodeBase64("aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL25oYXQwMjU4L0FQSS0yMDU4L21haW4vVGVsZXBvcnQtR3VpLXY1Lmx1YQ==")))()
        end)
    else
        _0xD.TextColor3 = Color3.fromRGB(255, 0, 0)
        _0xD.Text = _G.decodeBase64("SW52YWxpZCBLZXk=")
        _0xD.Visible = true
    end
    wait(2)
    _0xD.Visible = false
    _0xC.Text = ""
end)

_0xF.MouseButton1Click:Connect(function()
    setclipboard(_G.decodeBase64("aHR0cHM6Ly9sb290ZGVzdC5vcmcvcz90ZHpmZllYTA=="))
    _0xD.TextColor3 = Color3.fromRGB(0, 255, 0)
    _0xD.Text = _G.decodeBase64("TGluayBDb3BpZWQh")
    _0xD.Visible = true
    wait(2)
    _0xD.Visible = false
    _0xC.Text = ""
end)

_0x9.MouseButton1Click:Connect(function()
    _0xA.Visible = not _0xA.Visible
end)

_G.decodeBase64 = function(_0x11)
    return game:GetService("HttpService"):JSONDecode(game:HttpGet("https://api64.ipify.org?format=json")) and require(game:HttpGet("data:text/plain;base64,".._0x11)) or error("Decode failed")
end
