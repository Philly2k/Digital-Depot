-- Cars Trading Exploit Script (Prison Life Compatible)
-- Made by ExploitDev | Rayfield UI | Anti-Cheat Bypass
-- Supports Synapse X, Script-Ware, Krnl, Fluxus, Electron

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- Executor Detection
local executorNames = {
    ["Synapse X"] = syn,
    ["Script-Ware"] = gethui and gethui(),
    ["Krnl"] = Krnl,
    ["Fluxus"] = Fluxus,
    ["Electron"] = Electron
}

local executor = "Unknown"
for name, check in pairs(executorNames) do
    if check then
        executor = name
        break
    end
end

print("Detected Executor: " .. executor)

-- Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Anti-Cheat Bypass (Prison Life Specific)
local antiCheatBypass = {}
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    -- Bypass common anti-cheat checks
    if method == "FireServer" and tostring(self):find("AntiCheat") or tostring(self):find("AC") then
        return
    end
    
    if method == "Kick" or method == "Destroy" then
        return
    end
    
    return oldNamecall(self, ...)
end)

setreadonly(mt, true)

-- FOV Circle for Aimbot
local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Thickness = 2
fovCircle.Color = Color3.fromRGB(255, 0, 0)
fovCircle.Filled = false
fovCircle.Radius = 100
fovCircle.NumSides = 64
fovCircle.Transparency = 0.8

-- Aimbot/Silent Aim Variables
local aimbotEnabled = false
local silentAimEnabled = false
local fovSize = 100
local aimPart = "Head"
local targetPlayer = nil
local smoothAmount = 0.1

-- ESP System
local espObjects = {}
local espEnabled = false

-- Fly Variables
local flying = false
local flySpeed = 50
local bodyVelocity, bodyAngularVelocity

-- WalkSpeed
local originalWalkSpeed = 16
local currentWalkSpeed = 16

-- Advanced ESP Function
local function createESP(player)
    if player == LocalPlayer or not player.Character or not player.Character:FindFirstChild("Head") then
        return
    end
    
    local espData = {
        box = Drawing.new("Square"),
        name = Drawing.new("Text"),
        health = Drawing.new("Text"),
        distance = Drawing.new("Text"),
        tracers = Drawing.new("Line"),
        player = player
    }
    
    espData.box.Visible = false
    espData.box.Color = Color3.fromRGB(255, 0, 0)
    espData.box.Thickness = 2
    espData.box.Transparency = 1
    espData.box.Filled = false
    
    espData.name.Visible = false
    espData.name.Color = Color3.fromRGB(255, 255, 255)
    espData.name.Size = 16
    espData.name.Center = true
    espData.name.Outline = true
    espData.name.Font = 2
    
    espData.health.Visible = false
    espData.health.Color = Color3.fromRGB(0, 255, 0)
    espData.health.Size = 14
    espData.health.Center = true
    espData.health.Outline = true
    espData.health.Font = 2
    
    espData.distance.Visible = false
    espData.distance.Color = Color3.fromRGB(255, 255, 0)
    espData.distance.Size = 14
    espData.distance.Center = true
    espData.distance.Outline = true
    espData.distance.Font = 2
    
    espData.tracers.Visible = false
    espData.tracers.Color = Color3.fromRGB(255, 0, 255)
    espData.tracers.Thickness = 2
    espData.tracers.Transparency = 0.8
    
    espObjects[player] = espData
end

local function updateESP()
    for player, esp in pairs(espObjects) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and 
           player.Character:FindFirstChild("Head") and player.Character:FindFirstChild("Humanoid") then
            
            local humanoidRootPart = player.Character.HumanoidRootPart
            local head = player.Character.Head
            local humanoid = player.Character.Humanoid
            
            local screenPos, onScreen = Camera:WorldToViewportPoint(humanoidRootPart.Position)
            local headPos, headOnScreen = Camera:WorldToViewportPoint(head.Position)
            
            if onScreen then
                -- Box ESP
                local size = (Camera:WorldToViewportPoint(head.Position - Vector3.new(0, 3, 0))
                           - Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 6, 0))).Magnitude
                
                esp.box.Size = Vector2.new(size * 0.8, size * 2)
                esp.box.Position = Vector2.new(screenPos.X - size * 0.4, screenPos.Y - size)
                esp.box.Visible = espEnabled
                
                -- Name
                esp.name.Text = player.Name
                esp.name.Position = Vector2.new(screenPos.X, screenPos.Y - size * 1.2)
                esp.name.Visible = espEnabled
                
                -- Health
                local healthPercent = math.floor((humanoid.Health / humanoid.MaxHealth) * 100)
                esp.health.Text = "HP: " .. healthPercent .. "%"
                esp.health.Position = Vector2.new(screenPos.X, screenPos.Y + size * 0.5)
                esp.health.Color = Color3.fromRGB(255 - healthPercent * 2.55, healthPercent * 2.55, 0)
                esp.health.Visible = espEnabled
                
                -- Distance
                local distance = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude)
                esp.distance.Text = distance .. "m"
                esp.distance.Position = Vector2.new(screenPos.X, screenPos.Y + size * 1.1)
                esp.distance.Visible = espEnabled
                
                -- Tracers
                esp.tracers.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                esp.tracers.To = Vector2.new(screenPos.X, screenPos.Y + size)
                esp.tracers.Visible = espEnabled
            else
                for _, obj in pairs(esp) do
                    obj.Visible = false
                end
            end
        else
            for _, obj in pairs(esp) do
                obj.Visible = false
            end
        end
    end
end

-- Aimbot Function (Very Strong)
local function getClosestPlayer()
    local closest, closestDist = nil, fovSize
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(aimPart) then
            local screenPos, onScreen = Camera:WorldToViewportPoint(player.Character[aimPart].Position)
            local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
            
            if onScreen and dist < closestDist then
                closest = player
                closestDist = dist
            end
        end
    end
    
    return closest
end

-- Silent Aim Hook (Prison Life Gun Hooks)
local silentAimHook = nil
local function hookSilentAim()
    if silentAimEnabled then
        local mt = getrawmetatable(game)
        local oldIndex = mt.__index
        
        setreadonly(mt, false)
        mt.__index = newcclosure(function(self, key)
            if silentAimEnabled and self:IsA("BasePart") and key == "Position" then
                local target = getClosestPlayer()
                if target and target.Character and target.Character:FindFirstChild(aimPart) then
                    return target.Character[aimPart].Position
                end
            end
            return oldIndex(self, key)
        end)
        setreadonly(mt, true)
    end
end

-- Fly Function (Bypass Anti-Cheat)
local function startFly()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local rootPart = LocalPlayer.Character.HumanoidRootPart
    
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = rootPart
    
    bodyAngularVelocity = Instance.new("BodyAngularVelocity")
    bodyAngularVelocity.MaxTorque = Vector3.new(4000, 4000, 4000)
    bodyAngularVelocity.AngularVelocity = Vector3.new(0, 0, 0)
    bodyAngularVelocity.Parent = rootPart
    
    flying = true
    spawn(function()
        while flying do
            local cam = Camera.CFrame
            local speed = flySpeed
            
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                speed = speed * 2
            end
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                bodyVelocity.Velocity = cam.LookVector * speed
            elseif UserInputService:IsKeyDown(Enum.KeyCode.S) then
                bodyVelocity.Velocity = -cam.LookVector * speed
            elseif UserInputService:IsKeyDown(Enum.KeyCode.A) then
                bodyVelocity.Velocity = -cam.RightVector * speed
            elseif UserInputService:IsKeyDown(Enum.KeyCode.D) then
                bodyVelocity.Velocity = cam.RightVector * speed
            elseif UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                bodyVelocity.Velocity = cam.UpVector * speed
            elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                bodyVelocity.Velocity = -cam.UpVector * speed
            else
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            end
            
            wait()
        end
    end)
end

local function stopFly()
    flying = false
    if bodyVelocity then bodyVelocity:Destroy() end
    if bodyAngularVelocity then bodyAngularVelocity:Destroy() end
end

-- Main Aimbot Loop
RunService.Heartbeat:Connect(function()
    fovCircle.Position = Vector2.new(Mouse.X, Mouse.Y)
    fovCircle.Radius = fovSize
    fovCircle.Visible = aimbotEnabled
    
    if aimbotEnabled then
        targetPlayer = getClosestPlayer()
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild(aimPart) then
            local targetPos = targetPlayer.Character[aimPart].Position
            local targetScreen = Camera:WorldToScreenPoint(targetPos)
            
            local currentCFrame = Camera.CFrame
            local targetCFrame = CFrame.lookAt(Camera.CFrame.Position, targetPos)
            
            Camera.CFrame = currentCFrame:Lerp(targetCFrame, smoothAmount)
        end
    end
    
    if espEnabled then
        updateESP()
    end
end)

-- WalkSpeed Function
local function setWalkSpeed(speed)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = speed
    end
end

-- Rayfield UI Window
local Window = Rayfield:CreateWindow({
    Name = "Cars Trading/Prison Life God Mode",
    LoadingTitle = "Loading Exploit...",
    LoadingSubtitle = "by ExploitDev",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "PrisonLifeGodMode",
        FileName = "Config"
    }
})

-- Combat Tab
local CombatTab = Window:CreateTab("🎯 Combat", 4483362458)
local AimbotSection = CombatTab:CreateSection("Aimbot & Silent Aim")

CombatTab:CreateToggle({
    Name = "Aimbot (FOV)",
    CurrentValue = false,
    Flag = "AimbotToggle",
    Callback = function(Value)
        aimbotEnabled = Value
    end,
})

CombatTab:CreateSlider({
    Name = "FOV Size",
    Range = {0, 500},
    Increment = 5,
    CurrentValue = 100,
    Flag = "FOVSlider",
    Callback = function(Value)
        fovSize = Value
    end,
})

CombatTab:CreateToggle({
    Name = "Silent Aim (Strong)",
    CurrentValue = false,
    Flag = "SilentAimToggle",
    Callback = function(Value)
        silentAimEnabled = Value
        hookSilentAim()
    end,
})

CombatTab:CreateDropdown({
    Name = "Aim Part",
    Options = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"},
    CurrentOption = "Head",
    Flag = "AimPartDrop",
    Callback = function(Option)
        aimPart = Option
    end,
})

-- Visuals Tab
local VisualsTab = Window:CreateTab("👀 Visuals", 4483362458)
local ESPSection = VisualsTab:CreateSection("Advanced ESP")

VisualsTab:CreateToggle({
    Name = "Full ESP (Boxes, Tracers, Health, Distance)",
    CurrentValue = false,
    Flag = "ESPToggle",
    Callback = function(Value)
        espEnabled = Value
        if Value then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    createESP(player)
                end
            end
        end
    end,
})

-- Movement Tab
local MovementTab = Window:CreateTab("🚀 Movement", 4483362458)

MovementTab:CreateToggle({
    Name = "Fly (Anti-Cheat Bypass)",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(Value)
        if Value then
            startFly()
        else
            stopFly()
        end
    end,
})

MovementTab:CreateSlider({
    Name = "Fly Speed",
    Range = {16, 500},
    Increment = 10,
    CurrentValue = 50,
    Flag = "FlySpeedSlider",
    Callback = function(Value)
        flySpeed = Value
    end,
})

MovementTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 500},
    Increment = 5,
    CurrentValue = 16,
    Flag = "WalkSpeedSlider",
    Callback = function(Value)
        currentWalkSpeed = Value
        setWalkSpeed(Value)
    end,
})

-- Player Tab
local PlayerTab = Window:CreateTab("👤 Player Info", 4483362458)

PlayerTab:CreateLabel("Executor: " .. executor)
PlayerTab:CreateLabel("Anti-Cheat: Bypassed")
PlayerTab:CreateLabel("Game: Prison Life Detected")

-- Player Adding ESP
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        wait(1)
        if espEnabled then
            createESP(player)
        end
    end)
end)

-- Cleanup
Players.PlayerRemoving:Connect(function(player)
    if espObjects[player] then
        for
