local main = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local up = Instance.new("TextButton")
local down = Instance.new("TextButton")
local onof = Instance.new("TextButton")


main.Name = "CementHUB"
main.Parent = game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

Frame.Parent = main
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Position = UDim2.new(0.1, 0, 0.1, 0)
Frame.Size = UDim2.new(0, 150, 0, 200)

onof.Parent = Frame
onof.Size = UDim2.new(1, 0, 0.3, 0)
onof.Text = "Fly: OFF"
onof.BackgroundColor3 = Color3.fromRGB(200, 50, 50)

up.Parent = Frame
up.Position = UDim2.new(0, 0, 0.35, 0)
up.Size = UDim2.new(1, 0, 0.3, 0)
up.Text = "Fly Up"

down.Parent = Frame
down.Position = UDim2.new(0, 0, 0.7, 0)
down.Size = UDim2.new(1, 0, 0.3, 0)
down.Text = "Fly Down"

local speaker = game:GetService("Players").LocalPlayer
local flying = false
local speed = 50
local maxspeed = 200
local ctrl = {f = 0, b = 0, l = 0, r = 0}
local lastctrl = {f = 0, b = 0, l = 0, r = 0}

local function getTorso()
    local chr = speaker.Character
    return chr and (chr:FindFirstChild("Torso") or chr:FindFirstChild("UpperTorso"))
end

local function Fly()
    local torso = getTorso()
    if not torso then return end
    
    flying = true
    onof.Text = "Fly: ON"
    onof.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    
    local bg = Instance.new("BodyGyro", torso)
    bg.P = 9e4
    bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    bg.cframe = torso.CFrame
    
    local bv = Instance.new("BodyVelocity", torso)
    bv.velocity = Vector3.new(0, 0.1, 0)
    bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
    
    
    task.spawn(function()
        local mouse = speaker:GetMouse()
        while flying and task.wait() do
            local chr = speaker.Character
            if chr and chr:FindFirstChildWhichIsA("Humanoid") then
                chr.Humanoid.PlatformStand = true
            end
            
            
            if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
                speed = math.min(speed + 0.5 + (speed / maxspeed), maxspeed)
            else
                speed = 0
            end
            
            if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
                bv.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f + ctrl.b)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l + ctrl.r, (ctrl.f + ctrl.b) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * speed
                lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
            else
                bv.velocity = Vector3.new(0, 0.1, 0)
            end
            bg.cframe = workspace.CurrentCamera.CoordinateFrame
        end
        
        
        bg:Destroy()
        bv:Destroy()
        local chr = speaker.Character
        if chr and chr:FindFirstChildWhichIsA("Humanoid") then
            chr.Humanoid.PlatformStand = false
        end
    end)
end

local function StopFly()
    flying = false
    onof.Text = "Fly: OFF"
    onof.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
end


onof.MouseButton1Down:Connect(function()
    if flying then StopFly() else Fly() end
end)


up.MouseButton1Down:Connect(function() ctrl.f = 1 end)
up.MouseButton1Up:Connect(function() ctrl.f = 0 end)
down.MouseButton1Down:Connect(function() ctrl.b = -1 end)
down.MouseButton1Up:Connect(function() ctrl.b = 0 end)


game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "AAO Fly",
    Text = "Скрипт успешно переведен в открытый код!",
    Duration = 5
})