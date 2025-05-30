local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Parent = Lighting

local blurTweenIn = TweenService:Create(blur, TweenInfo.new(0.5, Enum.EasingStyle.Sine), { Size = 24 })
local blurTweenOut = TweenService:Create(blur, TweenInfo.new(0.5, Enum.EasingStyle.Sine), { Size = 0 })

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IntroUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local TextLabel = Instance.new("TextLabel")
TextLabel.Parent = ScreenGui
TextLabel.Size = UDim2.new(1, 0, 1, 0)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "Nexus Hub V5 [ Mr.N ]"
TextLabel.TextColor3 = Color3.new(1, 1, 1)
TextLabel.TextScaled = true
TextLabel.Font = Enum.Font.GothamBold
TextLabel.TextTransparency = 1

local textTweenIn = TweenService:Create(TextLabel, TweenInfo.new(0.5, Enum.EasingStyle.Sine), { TextTransparency = 0 })
local textTweenOut = TweenService:Create(TextLabel, TweenInfo.new(0.5, Enum.EasingStyle.Sine), { TextTransparency = 1 })

blurTweenIn:Play()
textTweenIn:Play()
wait(2)
textTweenOut:Play()
blurTweenOut:Play()

task.delay(3, function()
	ScreenGui:Destroy()
	blur:Destroy()
end)

local placeId = game.PlaceId
local universeId = tostring(game.GameId)

local placeScripts = {
    [12688469563] = "https://raw.githubusercontent.com/nhat0258/Testing/main/Grow-A-Graden-Tool",
    [14202073004] = "https://raw.githubusercontent.com/nhat0258/API-2058/refs/heads/main/Unnamed-Shooter-Game-V5.lua"
}

local universeScripts = {
    ["7436755782"] = "https://raw.githubusercontent.com/nhat0258/Testing/main/Grow-A-Graden-Tool",
    ["4914269443"] = "https://raw.githubusercontent.com/nhat0258/API-2058/refs/heads/main/Unnamed-Shooter-Game-V5.lua"
}

local url

if placeScripts[placeId] then
    if placeId == 12688469563 then
        print("Nexus Hub V5 -- Universal")
    elseif placeId == 14202073004 then
        print("Nexus Hub V5 -- Unnamed Shooter")
    end
    url = placeScripts[placeId]
elseif universeScripts[universeId] then
    url = universeScripts[universeId]
end

if url then
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)

    if success and response then
        local loadSuccess, loadErr = pcall(function()
            loadstring(response)()
        end)
        if not loadSuccess then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Mr.N",
                Text = "Error running script : "..tostring(loadErr),
                Duration = 8
            })
        end
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "N-Hub",
            Text = "Cannot Load Script From Url !",
            Duration = 6
        })
    end
else
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Mr.N",
        Text = "Nexus-Hub Not Support This Game!",
        Duration = 6
    })
end
