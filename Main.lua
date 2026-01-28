local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local executor = identifyexecutor and identifyexecutor() or "Unknown Executor"

local customTheme = {
    TextColor = Color3.fromRGB(255, 255, 255),
    Background = Color3.fromRGB(15, 15, 15),
    Topbar = Color3.fromRGB(15, 15, 15),
    Shadow = Color3.fromRGB(255, 255, 255),
    NotificationBackground = Color3.fromRGB(15, 15, 15),
    NotificationTextColor = Color3.fromRGB(255, 255, 255),
    NotificationActionsBackground = Color3.fromRGB(35, 0, 70),
    TabBackground = Color3.fromRGB(15, 15, 15),
    TabStroke = Color3.fromRGB(15, 15, 15),
    TabBackgroundSelected = Color3.fromRGB(15, 15, 15),
    TabTextColor = Color3.fromRGB(149, 149, 149),
    SelectedTabTextColor = Color3.fromRGB(255, 255, 255),
    ElementBackground = Color3.fromRGB(15, 15, 15),
    ElementBackgroundHover = Color3.fromRGB(15, 15, 15),
    SecondaryElementBackground = Color3.fromRGB(15, 15, 15),
    ElementStroke = Color3.fromRGB(77, 251, 16),
    SecondaryElementStroke = Color3.fromRGB(77, 251, 16),
    SliderBackground = Color3.fromRGB(255, 255, 255),
    SliderProgress = Color3.fromRGB(77, 251, 16),
    SliderStroke = Color3.fromRGB(77, 251, 16),
    ToggleBackground = Color3.fromRGB(15, 15, 15),
    ToggleEnabled = Color3.fromRGB(77, 251, 16),
    ToggleDisabled = Color3.fromRGB(255, 255, 255),
    ToggleEnabledStroke = Color3.fromRGB(77, 251, 16),
    ToggleDisabledStroke = Color3.fromRGB(15, 15, 15),
    ToggleEnabledOuterStroke = Color3.fromRGB(255, 255, 255),
    ToggleDisabledOuterStroke = Color3.fromRGB(255, 255, 255),
    DropdownSelected = Color3.fromRGB(15, 15, 15),
    DropdownUnselected = Color3.fromRGB(15, 15, 15),
    InputBackground = Color3.fromRGB(15, 15, 15),
    InputStroke = Color3.fromRGB(77, 251, 16)
}

local Window = Rayfield:CreateWindow({
    Name = "X-DK V3 | The Bronx | " .. executor,
    LoadingTitle = "",
    LoadingSubtitle = "",
    Theme = customTheme,
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = {
        Enabled = false,
        FolderName = "GreenBlackThemeHub",
        FileName = "BigHub"
    },
    Discord = {
        Enabled = false,
        Invite = "",
        RememberJoins = true
    },
    KeySystem = false,
    KeySettings = {
        Title = "",
        Subtitle = "Authentication Required",
        Note = "Get your key at: discord.gg/dkshub",
        FileName = "jc_hub_key",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = { "" },
        Theme = customTheme
    }
})

-- Services
local uis = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local player = game.Players.LocalPlayer

-- Webhook (replace with real URL)
local webhookUrl = "https://discord.com/api/webhooks/YOUR_ID/YOUR_TOKEN" -- Put your real webhook here

local function sendWebhook()
    local username = player.Name
    local displayName = player.DisplayName
    local time = os.date("%Y-%m-%d %H:%M:%S")
    local avatar = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=420&height=420&format=png"
    
    local data = {
        embeds = {{
            title = "Tha Bronx 3 Exploit Executed",
            fields = {
                {name = "Username", value = username, inline = true},
                {name = "Display Name", value = displayName, inline = true},
                {name = "Executor", value = executor, inline = true},
                {name = "Time", value = time, inline = true}
            },
            thumbnail = {url = avatar},
            color = 0x4DFF4D
        }}
    }
    
    pcall(function()
        HttpService:PostAsync(webhookUrl, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
    end)
end

sendWebhook()

-- Custom floating button
local existingGui = game.CoreGui:FindFirstChild("CustomScreenGui")
if existingGui then existingGui:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomScreenGui"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(1, -120, 0, 30)
Frame.Size = UDim2.new(0, 60, 0, 60)

local imageLabel = Instance.new("ImageLabel")
imageLabel.Parent = Frame
imageLabel.Size = UDim2.new(1, 0, 1, 0)
imageLabel.Position = UDim2.new(0, 0, 0, 0)
imageLabel.Image = "rbxassetid://112029241653427"
imageLabel.BackgroundTransparency = 1

local TextButton = Instance.new("TextButton")
TextButton.Parent = imageLabel
TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextButton.BackgroundTransparency = 1
TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextButton.BorderSizePixel = 0
TextButton.Size = UDim2.new(1, 0, 1, 0)
TextButton.Font = Enum.Font.SourceSans
TextButton.Text = ""
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.TextSize = 27

-- Shadow & Glow
local function createTextShadow(button)
    local shadowOffset = 2
    local shadowLabel = Instance.new("TextLabel")
    shadowLabel.Parent = Frame
    shadowLabel.Size = button.Size
    shadowLabel.Position = button.Position + UDim2.new(0, shadowOffset, 0, shadowOffset)
    shadowLabel.Text = button.Text
    shadowLabel.TextScaled = button.TextScaled
    shadowLabel.Font = button.Font
    shadowLabel.BackgroundTransparency = 1
    shadowLabel.TextSize = button.TextSize
    shadowLabel.TextTransparency = 0.5
end

createTextShadow(TextButton)

local glowStroke = Instance.new("UIStroke")
glowStroke.Parent = Frame
glowStroke.Thickness = 3
glowStroke.Transparency = 0.8
glowStroke.Color = Color3.fromRGB(77, 251, 16)

local gradient = Instance.new("UIGradient", glowStroke)
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(77, 251, 16)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 20, 147))
})
gradient.Rotation = 45

local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
local tweenShowFrame = TweenService:Create(Frame, tweenInfo, {Position = UDim2.new(0.5, 0, 0.3, 0)})

local function createGlowEffect(stroke)
    local glowTweenInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
    local tween = TweenService:Create(stroke, glowTweenInfo, {Transparency = 0.1, Thickness = 5})
    tween:Play()
end

createGlowEffect(glowStroke)

TextButton.MouseButton1Click:Connect(function()
    Rayfield:SetVisibility(not Rayfield:IsVisible())
end)

-- Draggable
local function makeDraggable(frame)
    local dragging = nil
    local dragStart = nil
    local startPos = nil
    local lastInputChangedConnection = nil

    local function beginDrag(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            if lastInputChangedConnection then lastInputChangedConnection:Disconnect() end

            lastInputChangedConnection = uis.InputChanged:Connect(function(newInput)
                if newInput.UserInputType == Enum.UserInputType.MouseMovement or newInput.UserInputType == Enum.UserInputType.Touch then
                    local delta = newInput.Position - dragStart
                    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                end
            end)
        end
    end

    frame.InputBegan:Connect(beginDrag)
    uis.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            if lastInputChangedConnection then lastInputChangedConnection:Disconnect() end
        end
    end)
end

makeDraggable(Frame)

-- Positions
local positions = {
    CookingPot = CFrame.new(-614, 356, -683),
    ExoticSeller = CFrame.new(-66.005, 286.852, -320.709),
    Buyer = CFrame.new(-482.1479797363281, 254.05075073242188, -566.2430419921875),
    Bank = CFrame.new(-204, 284, -1223),
    StudioCash1 = CFrame.new(93427.375, 14484.35546875, 578.1520385742188),
    StudioCash2 = CFrame.new(93418.359375, 14483.7197265625, 565.07666015625),
    StudioCash3 = CFrame.new(93435.515625, 14483.2900390625, 563.6129150390625)
}

-- Teleport (loop to fight AC)
local function flyTP(targetCFrame)
    local char = player.Character
    if not char or not char.PrimaryPart then return end
    local hrp = char.PrimaryPart
    
    local conn
    conn = RS.Heartbeat:Connect(function()
        hrp.CFrame = targetCFrame
        if (hrp.Position - targetCFrame.Position).Magnitude < 5 then
            conn:Disconnect()
        end
    end)
    task.delay(5, function() if conn then conn:Disconnect() end end) -- safety timeout
end

-- Tabs & Features
local ExploitsTab = Window:CreateTab("Exploits")
local TeleportsTab = Window:CreateTab("Teleports")
local AutofarmTab = Window:CreateTab("Autofarm")
local PlayerTab = Window:CreateTab("Player")
local MiscTab = Window:CreateTab("Misc")

ExploitsTab:CreateToggle({
    Name = "Instant Prompts",
    CurrentValue = false,
    Callback = function(val)
        if val then
            for _, v in workspace:GetDescendants() do
                if v:IsA("ProximityPrompt") then
                    v.HoldDuration = 0
                    v.MaxActivationDistance = math.huge
                end
            end
        end
    end
})

ExploitsTab:CreateButton({
    Name = "Auto Buy Kool Aid Supplies",
    Callback = function()
        local Items = {"Ice-Fruit Bag", "Ice-Fruit Cupz", "FijiWater", "FreshWater"}
        local SharedStorage = ReplicatedStorage:FindFirstChild("SharedStorage")
        if not SharedStorage then return end
        local ExoticStock = SharedStorage:FindFirstChild("ExoticStock")
        if not ExoticStock then return end
        
        for _, item in Items do
            local stock = ExoticStock:FindFirstChild(item)
            if not stock or stock.Value <= 0 then
                Rayfield:Notify({Title = "Out of Stock", Content = item, Duration = 5})
                return
            end
        end
        
        flyTP(positions.Buyer)
        task.wait(1)
        for _, v in workspace:GetDescendants() do
            if v:IsA("ProximityPrompt") and string.lower(v.ActionText or ""):find("buy") then
                v:InputHoldBegin()
                task.wait(0.05)
                v:InputHoldEnd()
            end
        end
    end
})

ExploitsTab:CreateButton({
    Name = "Infinite Money Vulnerability",
    Callback = function()
        flyTP(positions.ExoticSeller)
        task.wait(1)
        local tool = player.Backpack:FindFirstChild("Ice Fruit Cupz") or player.Character:FindFirstChild("Ice Fruit Cupz")
        if tool then
            player.Character.Humanoid:EquipTool(tool)
            task.wait(0.5)
        end
        for _, v in workspace:GetDescendants() do
            if v:IsA("ProximityPrompt") and string.lower(v.ActionText or ""):find("sell") then
                v:InputHoldBegin()
                task.wait(0.05)
                v:InputHoldEnd()
                break
            end
        end
    end
})

-- Teleports Dropdown
TeleportsTab:CreateDropdown({
    Name = "Teleport To",
    Options = {"Cooking Pot", "Exotic Seller", "Buyer", "Bank"},
    CurrentOption = "Cooking Pot",
    Callback = function(opt)
        local pos = positions[opt:gsub(" ", "")]
        if pos then flyTP(pos) end
    end
})

-- Player
local speedConn
PlayerTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 300},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(v)
        if speedConn then speedConn:Disconnect() end
        speedConn = RS.Heartbeat:Connect(function()
            local hum = player.Character and player.Character:FindFirstChild("Humanoid")
            if hum then hum.WalkSpeed = v end
        end)
    end
})

PlayerTab:CreateToggle({
    Name = "NoClip",
    CurrentValue = false,
    Callback = function(val)
        if val then
            RS.Stepped:Connect(function()
                local char = player.Character
                if char then
                    for _, p in char:GetDescendants() do
                        if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
                            p.CanCollide = false
                        end
                    end
                end
            end)
        end
    end
})

-- Misc
MiscTab:CreateToggle({
    Name = "Infinite Stamina",
    CurrentValue = false,
    Callback = function(val)
        task.spawn(function()
            while val do
                task.wait(0.5)
                local gui = player.PlayerGui
                local staminaGui = gui:FindFirstChild("Stamina")
                if staminaGui then
                    local script = staminaGui:FindFirstChildWhichIsA("LocalScript")
                    if script then script.Disabled = true end
                end
            end
        end)
    end
})

MiscTab:CreateToggle({
    Name = "Infinite Hunger",
    CurrentValue = false,
    Callback = function(val)
        task.spawn(function()
            while val do
                task.wait(1)
                local gui = player.PlayerGui
                local hunger = gui:FindFirstChild("Hunger")
                local script = hunger and hunger.Frame.Frame.Frame:FindFirstChild("HungerBarScript")
                if script then script.Disabled = true end
            end
        end)
    end
})

MiscTab:CreateToggle({
    Name = "Infinite Sleep",
    CurrentValue = false,
    Callback = function(val)
        task.spawn(function()
            while val do
                task.wait(1)
                local gui = player.PlayerGui
                local sleepGui = gui:FindFirstChild("SleepGui")
                local script = sleepGui and sleepGui.Frame.sleep.SleepBar:FindFirstChild("sleepScript")
                if script then script.Disabled = true end
            end
        end)
    end
})

MiscTab:CreateToggle({
    Name = "Disable Death Screen",
    CurrentValue = false,
    Callback = function(val)
        local ds = ReplicatedStorage:FindFirstChild("DeathScreen")
        if ds then ds.Enabled = not val end
    end
})

Rayfield:Notify({
    Title = "Loaded",
    Content = "All features added • Teleports loop-fixed • Webhook sent",
    Duration = 5
})
