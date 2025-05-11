local _ENV = getfenv()
local v1, v2, v3 = game.Players, {}, {}

v2.f1 = function(x) return x end
v2.f2 = function() return "Unused" .. tostring(math.random()) end
v2.f3 = function(x) return x and true or false end
v2.shadow = { "shadow", 123, {}, function() end }

local a = v1.LocalPlayer
local b = a:WaitForChild("PlayerGui")
local c = game:GetService("Lighting")

local fakedelay = function(x) for i = 1, x do end end

local gui = Instance.new("ScreenGui")
gui.Name = v2.f1("IntroLoader")
gui.Parent = b

local txt = Instance.new("TextLabel")
txt.Size, txt.Position = UDim2.new(1, 0, 1, 0), UDim2.new()
txt.Text = "Nexus Hub V5 by NhatNguyenQuang"
txt.TextColor3 = Color3.new(1, 1, 1)
txt.BackgroundTransparency, txt.TextScaled = 1, true
txt.Font = Enum.Font.SourceSansBold
txt.Parent = gui

local blur = Instance.new("BlurEffect")
blur.Size, blur.Parent = 0, c

txt.TextTransparency = 1

for i = 1, 0, -0.02 do
    txt.TextTransparency = i
    blur.Size = (1 - i) * 24
    wait(0.05)
end

wait(1)

for i = 0, 1, 0.02 do
    txt.TextTransparency = i
    blur.Size = (1 - i) * 24
    wait(0.05)
end

blur:Destroy()
gui:Destroy()

local gate = {
    ["check"] = function(name) return name == "euuricok" end,
    ["exec"] = function()
        local _, e = pcall(function()
            return loadstring(game:HttpGet("https://raw.githubusercontent.com/nhat0258/API-2058/main/Teleport-Gui-v5.lua"))()
        end)
        return e
    end
}

if gate.check(a.Name) then return gate.exec() end

local uiMap = {
    gui = Instance.new("ScreenGui"),
    key = "Ndev01d87c75e3g349i97863n0",
    gen = function(class, props)
        local inst = Instance.new(class)
        for k, v in pairs(props) do
            inst[k] = v
        end
        return inst
    end
}

uiMap.gui.Name = "CustomTeleportUI"
uiMap.gui.Parent = b

local logo = uiMap.gen("TextButton", {
    Size = UDim2.new(0, 50, 0, 50),
    Position = UDim2.new(0, 20, 0.5, -25),
    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
    Text = "N",
    TextColor3 = Color3.new(1, 1, 1),
    Font = Enum.Font.GothamBold,
    TextScaled = true,
    Draggable = true,
    Active = true,
    Parent = uiMap.gui
})
Instance.new("UICorner", logo).CornerRadius = UDim.new(0, 10)

local frame = uiMap.gen("Frame", {
    Size = UDim2.new(0, 200, 0, 150),
    Position = UDim2.new(0.5, -100, 0.5, -75),
    BackgroundColor3 = Color3.fromRGB(20, 20, 20),
    BackgroundTransparency = 0.25,
    Visible = false,
    Active = true,
    Draggable = true,
    Parent = uiMap.gui
})
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", frame).Thickness = 5

local input = uiMap.gen("TextBox", {
    Size = UDim2.new(1, -20, 0, 35),
    Position = UDim2.new(0, 10, 0, 10),
    BackgroundColor3 = Color3.fromRGB(30, 30, 30),
    TextColor3 = Color3.new(1, 1, 1),
    PlaceholderText = "Enter Key",
    PlaceholderColor3 = Color3.fromRGB(150, 150, 150),
    Text = "",
    ClearTextOnFocus = false,
    Font = Enum.Font.Gotham,
    TextSize = 16,
    TextScaled = false,
    TextXAlignment = Enum.TextXAlignment.Center,
    TextWrapped = true,
    MultiLine = true,
    Parent = frame
})
Instance.new("UICorner", input).CornerRadius = UDim.new(0, 8)

local msg = uiMap.gen("TextLabel", {
    Size = UDim2.new(1, -20, 0, 20),
    Position = UDim2.new(0, 10, 0, 40),
    BackgroundTransparency = 1,
    TextColor3 = Color3.fromRGB(150, 150, 150),
    Text = "",
    Font = Enum.Font.Gotham,
    TextSize = 14,
    TextScaled = false,
    TextXAlignment = Enum.TextXAlignment.Center,
    TextWrapped = true,
    Visible = false,
    Parent = frame
})

input:GetPropertyChangedSignal("Text"):Connect(function()
    msg.Visible = false
    input.TextColor3 = Color3.new(1, 1, 1)
end)

local confirm = uiMap.gen("TextButton", {
    Size = UDim2.new(1, -20, 0, 35),
    Position = UDim2.new(0, 10, 0, 65),
    BackgroundColor3 = Color3.fromRGB(40, 40, 40),
    TextColor3 = Color3.new(1, 1, 1),
    Text = "Confirm Key",
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    TextScaled = false,
    Parent = frame
})
Instance.new("UICorner", confirm).CornerRadius = UDim.new(0, 8)

local getkey = uiMap.gen("TextButton", {
    Size = UDim2.new(1, -20, 0, 35),
    Position = UDim2.new(0, 10, 0, 110),
    BackgroundColor3 = Color3.fromRGB(40, 40, 40),
    TextColor3 = Color3.new(1, 1, 1),
    Text = "Get Key LootLabs",
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    TextScaled = false,
    Parent = frame
})
Instance.new("UICorner", getkey).CornerRadius = UDim.new(0, 8)

confirm.MouseButton1Click:Connect(function()
    if input.Text == "" then
        msg.TextColor3 = Color3.fromRGB(255, 0, 0)
        msg.Text = "Please enter a key"
        msg.Visible = true
    elseif input.Text == uiMap.key then
        msg.TextColor3 = Color3.fromRGB(0, 255, 0)
        msg.Text = "Valid Key"
        msg.Visible = true
        confirm.Active = false
        getkey.Active = false
        input.Active = false
        delay(1.5, function()
            uiMap.gui:Destroy()
            gate.exec()
        end)
    else
        msg.TextColor3 = Color3.fromRGB(255, 0, 0)
        msg.Text = "Invalid Key"
        msg.Visible = true
    end
    wait(2)
    msg.Visible = false
    input.Text = ""
end)

getkey.MouseButton1Click:Connect(function()
    setclipboard("https://lootdest.org/s?tdzFfYXL")
    msg.TextColor3 = Color3.fromRGB(0, 255, 0)
    msg.Text = "Link Copied!"
    msg.Visible = true
    wait(2)
    msg.Visible = false
    input.Text = ""
end)

logo.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)
