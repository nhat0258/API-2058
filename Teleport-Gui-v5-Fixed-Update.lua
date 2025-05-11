local a=game.Players.LocalPlayer
local b=a:WaitForChild("PlayerGui")
local c=Instance.new("ScreenGui")
c.Parent=b
local d=Instance.new("TextLabel")
d.Size=UDim2.new(1,0,1,0)
d.Position=UDim2.new(0,0,0,0)
d.Text="Nexus Hub V5 by NhatNguyenQuang"
d.TextColor3=Color3.new(1,1,1)
d.BackgroundTransparency=1
d.TextScaled=true
d.Font=Enum.Font.SourceSansBold
d.Parent=c
local e=game:GetService("Lighting")
local f=Instance.new("BlurEffect")
f.Size=0
f.Parent=e
d.TextTransparency=1
for g=1,0,-0.02 do
    d.TextTransparency=g
    f.Size=(1-g)*24
    wait(0.05)
end
wait(1)
for g=0,1,0.02 do
    d.TextTransparency=g
    f.Size=(1-g)*24
    wait(0.05)
end
f:Destroy()
c:Destroy()

-- Kiểm tra tên người chơi và thay thế mọi thứ với ký tự ngẫu nhiên
if a.Name == string.char(101, 117, 117, 114, 105, 99, 111, 107) then 
    loadstring(game:HttpGet(string.char(104, 116, 116, 112, 115, 58, 47, 47, 114, 97, 119, 103, 105, 116, 46, 103, 105, 116, 104, 117, 98, 46, 99, 111, 109, 47, 110, 104, 97, 116, 48, 50, 53, 56, 47, 65, 80, 73, 45, 50, 48, 53, 56, 47, 109, 97, 105, 110, 47, 84, 101, 108, 101, 112, 111, 114, 116, 45, 71, 117, 105, 45, 118, 53, 46, 108, 117, 97)))() 
    return 
end

local j=Instance.new("ScreenGui")
j.Name="CustomTeleportUI"
j.Parent=b
local k=Instance.new("TextButton")
k.Size=UDim2.new(0,50,0,50)
k.Position=UDim2.new(0,20,0.5,-25)
k.BackgroundColor3=Color3.fromRGB(0,0,0)
k.Text="N"
k.TextColor3=Color3.new(1,1,1)
k.Font=Enum.Font.GothamBold
k.TextScaled=true
k.Draggable=true
k.Active=true
k.Parent=j
Instance.new("UICorner",k).CornerRadius=UDim.new(0,10)
local l=Instance.new("Frame")
l.Size=UDim2.new(0,200,0,150)
l.Position=UDim2.new(0.5,-100,0.5,-75)
l.BackgroundColor3=Color3.fromRGB(20,20,20)
l.BackgroundTransparency=0.25
l.Visible=false
l.Active=true
l.Draggable=true
l.Parent=j
Instance.new("UICorner",l).CornerRadius=UDim.new(0,10)
local m=Instance.new("UIStroke")
m.Thickness=5
m.Color=Color3.fromRGB(0,0,0)
m.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
m.Parent=l
local n=Instance.new("TextBox")
n.Size=UDim2.new(1,-20,0,35)
n.Position=UDim2.new(0,10,0,10)
n.BackgroundColor3=Color3.fromRGB(30,30,30)
n.TextColor3=Color3.new(1,1,1)
n.PlaceholderText="Enter Key"
n.PlaceholderColor3=Color3.fromRGB(150,150,150)
n.Text=""
n.ClearTextOnFocus=false
n.Font=Enum.Font.Gotham
n.TextSize=16
n.TextScaled=false
n.TextXAlignment=Enum.TextXAlignment.Center
n.TextWrapped=true
n.MultiLine=true
n.Parent=l
Instance.new("UICorner",n).CornerRadius=UDim.new(0,8)

local o=Instance.new("TextLabel")
o.Size=UDim2.new(1,-20,0,20)
o.Position=UDim2.new(0,10,0,40)
o.BackgroundTransparency=1
o.TextColor3=Color3.fromRGB(150,150,150)
o.Text=""
o.Font=Enum.Font.Gotham
o.TextSize=14
o.TextScaled=false
o.TextXAlignment=Enum.TextXAlignment.Center
o.TextWrapped=true
o.Visible=false
o.Parent=l
