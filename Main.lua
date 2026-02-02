-- Project P58 - Full LinoriaLib Conversion (All original features + Settings extras)
local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()
local Window = Library:CreateWindow({
    Title = 'Project P58',
    Center = true,
    AutoShow = true,
})
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
-- Tabs
local Tabs = {
    Main = Window:AddTab('Main'),
    Teleports = Window:AddTab('Teleports'),
    Misc = Window:AddTab('Misc'),
    Farms = Window:AddTab('Farms'),
    QuickBuy = Window:AddTab('Quick Buy'),
    Settings = Window:AddTab('Settings'),
}
-- Groupboxes
local MainExotic = Tabs.Main:AddLeftGroupbox('Exotic Shop')
local MainMoney = Tabs.Main:AddRightGroupbox('Money Dupe')
local MainGun = Tabs.Main:AddLeftGroupbox('Gun Dupe')
local TeleLocs = Tabs.Teleports:AddLeftGroupbox('Locations')
local MiscMods = Tabs.Misc:AddLeftGroupbox('Modifiers')
local MiscMove = Tabs.Misc:AddRightGroupbox('Movement')
local FarmsAuto = Tabs.Farms:AddLeftGroupbox('Auto Farms')
local QuickReg = Tabs.QuickBuy:AddLeftGroupbox('Regular Shop')
local QuickExo = Tabs.QuickBuy:AddRightGroupbox('Exotic Dealer')
local SettingsMenu = Tabs.Settings:AddLeftGroupbox('Menu Settings')
-- Services & Vars (identical)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local movementEnabled = false
local currentWalkSpeed = 16
local fastFallSpeed = -50
local moveConnection = nil
local ModFlags = {
    InfiniteHunger = false, InfiniteStamina = false, InfiniteSleep = false,
    DisableCameraBobbing = false, DisableBloodEffects = false,
    NoFallDamage = false, NoJumpCooldown = false, NoRentPay = false,
    DisableCameras = false, NoKnockback = false,
    RespawnWhereYouDied = false, InfiniteJump = false,
    InstantInteraction = false,
}
local running = false
local Character, Backpack
local DeathFrame = nil
local function updateCharacter()
    Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    Backpack = LocalPlayer:WaitForChild("Backpack")
end
updateCharacter()
LocalPlayer.CharacterAdded:Connect(updateCharacter)
-- ───────────────────────────────────────────────
-- All helper functions (exact copy)
-- ───────────────────────────────────────────────
local function getPing()
    local total = 0 local samples = 5
    for i = 1, samples do
        local t0 = tick()
        local temp = Instance.new("BoolValue") temp.Parent = ReplicatedStorage temp.Name = "PingTest_" .. math.random(10000,99999)
        task.wait(0.1)
        local t1 = tick() temp:Destroy()
        total += (t1 - t0) * 1000
    end
    return math.clamp(total / samples, 50, 300)
end
local function countGuns(toolName)
    local count = 0
    for _, item in Backpack:GetChildren() do if item.Name == toolName then count += 1 end end
    if Character then
        for _, item in Character:GetChildren() do
            if item:IsA("Tool") and item.Name == toolName then count += 1 end
        end
    end
    return count
end
local function dupeOne()
    local Tool = Character:FindFirstChildOfClass("Tool") or Backpack:FindFirstChildOfClass("Tool")
    if not Tool then Library:Notify("Equip a gun first!", 4) return false end
    Tool.Parent = Backpack
    task.wait(0.5)
    local ToolName = Tool.Name
    local ToolId
    local delay = 0.25 + ((math.clamp(getPing(),0,300) /300)*0.03)
    local conn; conn = ReplicatedStorage.MarketItems.ChildAdded:Connect(function(item)
        if item.Name == ToolName then
            local owner = item:WaitForChild("owner",2)
            if owner and owner.Value == LocalPlayer.Name then
                ToolId = item:GetAttribute("SpecialId")
            end
        end
    end)
    task.spawn(function() ReplicatedStorage.ListWeaponRemote:FireServer(ToolName,99999) end)
    task.wait(delay)
    task.spawn(function() ReplicatedStorage.BackpackRemote:InvokeServer("Store",ToolName) end)
    task.wait(3)
    if ToolId then
        task.spawn(function() ReplicatedStorage.BuyItemRemote:FireServer(ToolName,"Remove",ToolId) end)
    end
    task.spawn(function() ReplicatedStorage.BackpackRemote:InvokeServer("Grab",ToolName) end)
    conn:Disconnect()
    Library:Notify("Dupe attempted - check backpack", 3)
    return true
end
task.spawn(function()
    while true do
        if running then dupeOne() task.wait(1.5) else task.wait(0.1) end
    end
end)
local function teleportTo(cf)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    hum:ChangeState(0)
    repeat task.wait() until not LocalPlayer:GetAttribute("LastACPos")
    hrp.Anchored = true
    hrp.CFrame = cf
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    task.defer(function()
        hrp.Anchored = false
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        hum:ChangeState(2)
    end)
end
local function getHumanoid() return LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") end
local function isGrounded(hrp)
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {LocalPlayer.Character}
    params.FilterType = Enum.RaycastFilterType.Blacklist
    return Workspace:Raycast(hrp.Position, Vector3.new(0,-5,0), params) ~= nil
end
local function keepUpright()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + Vector3.new(hrp.CFrame.LookVector.X, 0, hrp.CFrame.LookVector.Z))
    end
end
local function teleportForward(distance)
    local char = LocalPlayer.Character if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = getHumanoid()
    if not hrp or not hum then return end
    hum:ChangeState(0) repeat task.wait() until not LocalPlayer:GetAttribute("LastACPos")
    local origin = hrp.Position
    local dir = hrp.CFrame.LookVector * distance
    local params = RaycastParams.new() params.FilterDescendantsInstances = {char} params.FilterType = Enum.RaycastFilterType.Blacklist
    local res = Workspace:Raycast(origin, dir, params)
    local pos = res and (res.Position - hrp.CFrame.LookVector * 2) or (origin + dir)
    if not isGrounded(hrp) then
        hrp.Velocity = Vector3.new(hrp.Velocity.X, fastFallSpeed, hrp.Velocity.Z)
    else
        hrp.Velocity = Vector3.zero
    end
    hrp.CFrame = CFrame.new(pos, pos + hrp.CFrame.LookVector)
    keepUpright()
end
local function startWalkLoop()
    if moveConnection then moveConnection:Disconnect() end
    moveConnection = RunService.Heartbeat:Connect(function(dt)
        if movementEnabled then
            local hum = getHumanoid()
            if hum then
                keepUpright()
                if hum.MoveDirection.Magnitude > 0 then
                    teleportForward(currentWalkSpeed * dt)
                else
                    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if hrp and not isGrounded(hrp) then
                        hrp.Velocity = Vector3.new(hrp.Velocity.X, fastFallSpeed, hrp.Velocity.Z)
                    end
                end
            end
        end
    end)
end
-- Noclip
local NoclipConnection local Clip = true
local function noclip()
    Clip = false
    local function Nocl()
        if not Clip and LocalPlayer.Character then
            for _, v in LocalPlayer.Character:GetDescendants() do
                if v:IsA("BasePart") and v.CanCollide then v.CanCollide = false end
            end
        end
    end
    if NoclipConnection then NoclipConnection:Disconnect() end
    NoclipConnection = RunService.Stepped:Connect(Nocl)
end
local function clip()
    if NoclipConnection then NoclipConnection:Disconnect() NoclipConnection = nil end
    Clip = true
end
-- ───────────────────────────────────────────────
-- UI Elements (all features)
-- ───────────────────────────────────────────────
MainExotic:AddButton('Buy All Ingredients', function()
    local r = ReplicatedStorage:WaitForChild("ExoticShopRemote")
    pcall(function()
        r:InvokeServer("Ice-Fruit Bag") r:InvokeServer("Ice-Fruit Cupz")
        r:InvokeServer("FijiWater") r:InvokeServer("FreshWater")
    end)
    Library:Notify("Bought all ingredients.", 3)
end)
MainExotic:AddButton('Teleport to Penthouse', function()
    teleportTo(CFrame.new(-181.86 + 2, 397.14, -587.99))
    Library:Notify("Moved to Penthouse", 2.5)
end)
MainExotic:AddButton('Teleport to Sell Juice', function()
    teleportTo(CFrame.new(-71.63, 287.06, -319.95))
    Library:Notify("Moved to Sell Juice", 2.5)
end)
MainMoney:AddButton('Dupe (Cupz Method - 5000 attempts)', function()
    local part = Workspace:FindFirstChild("IceFruit Sell")
    if not part then Library:Notify("IceFruit Sell not found.", 4) return end
    local prompt = part:FindFirstChildOfClass("ProximityPrompt")
    if not prompt then Library:Notify("Prompt not found.", 4) return end
    Library:Notify("Starting Cupz dupe (5000x)...", 5)
    for i = 1, 5000 do task.spawn(function() prompt:InputHoldBegin() prompt:InputHoldEnd() end) end
    Library:Notify("Cupz dupe finished - check cash", 4)
end)
MainGun:AddButton('Dupe Gun (Single)', function() dupeOne() end)
MainGun:AddToggle('Auto Dupe Gun', {Text = 'Auto Dupe Gun', Default = false, Callback = function(v) running = v Library:Notify(v and "Auto Dupe Started - equip gun" or "Auto Dupe Stopped", 3.5) end})
-- Teleports (all)
TeleLocs:AddButton('🏦 Bank', function() teleportTo(CFrame.new(-225.791, 283.810, -1215.357, -0.999,0,-0.048,0,1,0,0.048,0,-0.999)) Library:Notify("→ Bank", 2) end)
TeleLocs:AddButton('🚗Dealership', function() teleportTo(CFrame.new(-374.002, 253.280, -1233.570,0.089,0,0.996,0,1,0,-0.996,0,0.089)) Library:Notify("→ Dealership", 2) end)
TeleLocs:AddButton('💰Market', function() teleportTo(CFrame.new(-375.529, 334.314, -553.617,0.075,0,0.997,0,1,0,-0.997,0,0.075)) Library:Notify("→ Market", 2) end)
TeleLocs:AddButton('🏢Apartment', function() teleportTo(CFrame.new(-605.746, 356.494, -692.597,-0.160,0,-0.987,0,1,0,0.987,0,-0.160)) Library:Notify("→ Apartment", 2) end)
TeleLocs:AddButton('🔫Gunstore 1', function() teleportTo(CFrame.new(-1019.643, 253.815, -792.597,0.029,0,-1,0,1,0,1,0,0.029)) Library:Notify("→ Gunstore 1", 2) end)
TeleLocs:AddButton('🔫Gunstore 2', function() teleportTo(CFrame.new(-221.934, 283.803, -792.848,1,0,0.004,0,1,0,-0.004,0,1)) Library:Notify("→ Gunstore 2", 2) end)
TeleLocs:AddButton('🗝️Safe', function() teleportTo(CFrame.new(68516.609, 52941.688, -691.030,-1,0,-0.006,0,1,0,0.006,0,-1)) Library:Notify("→ Safe", 2) end)
-- Misc Mods
MiscMods:AddToggle('No Clip', {Text = 'No Clip', Default = false, Callback = function(v) if v then noclip() else clip() end end})
MiscMods:AddToggle('Infinite Stamina', {Text = 'Infinite Stamina', Default = false, Callback = function(v) ModFlags.InfiniteStamina = v end})
MiscMods:AddToggle('Infinite Hunger', {Text = 'Infinite Hunger', Default = false, Callback = function(v) ModFlags.InfiniteHunger = v end})
MiscMods:AddToggle('Infinite Sleep', {Text = 'Infinite Sleep', Default = false, Callback = function(v) ModFlags.InfiniteSleep = v end})
MiscMods:AddToggle('Instant Interaction',{Text = 'Instant Interaction',Default = false, Callback = function(v)
    ModFlags.InstantInteraction = v
    if v then
        for _, p in workspace:GetDescendants() do if p:IsA("ProximityPrompt") then p.HoldDuration = 0 end end
        workspace.DescendantAdded:Connect(function(p) if p:IsA("ProximityPrompt") then p.HoldDuration = 0 end end)
    end
end})
MiscMods:AddToggle('Disable Cam Bobbing', {Text = 'Disable Cam Bobbing', Default = false, Callback = function(v) ModFlags.DisableCameraBobbing = v end})
MiscMods:AddToggle('Disable Blood FX', {Text = 'Disable Blood FX', Default = false, Callback = function(v) ModFlags.DisableBloodEffects = v end})
MiscMods:AddToggle('No Fall Damage', {Text = 'No Fall Damage', Default = false, Callback = function(v) ModFlags.NoFallDamage = v end})
MiscMods:AddToggle('No Jump Cooldown', {Text = 'No Jump Cooldown', Default = false, Callback = function(v) ModFlags.NoJumpCooldown = v end})
MiscMods:AddToggle('No Rent Pay', {Text = 'No Rent Pay', Default = false, Callback = function(v) ModFlags.NoRentPay = v end})
MiscMods:AddToggle('Disable Cameras', {Text = 'Disable Cameras', Default = false, Callback = function(v) ModFlags.DisableCameras = v end})
MiscMods:AddToggle('No Knockback', {Text = 'No Knockback', Default = false, Callback = function(v) ModFlags.NoKnockback = v end})
MiscMods:AddToggle('Respawn Where Died', {Text = 'Respawn Where Died', Default = false, Callback = function(v) ModFlags.RespawnWhereYouDied = v end})
MiscMods:AddToggle('Infinite Jump', {Text = 'Infinite Jump', Default = false, Callback = function(v) ModFlags.InfiniteJump = v end})
-- Movement
MiscMove:AddSlider('Walk Speed', {Text = 'Walk Speed', Min = 16, Max = 500, Rounding = 0, Default = 16, Callback = function(v) currentWalkSpeed = v end})
MiscMove:AddToggle('Movement Speed (Teleport)', {Text = 'Movement Speed (Teleport)', Default = false, Callback = function(v)
    movementEnabled = v
    if v then startWalkLoop() else if moveConnection then moveConnection:Disconnect() moveConnection = nil end end
end})
-- Farms
FarmsAuto:AddButton('Studio Farm', function()
    Library:Notify("Starting Studio Farm...", 3)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")
    local hrp = char:WaitForChild("HumanoidRootPart")
    local function tp(cf) hrp.CFrame = cf end
    local function rob(pay)
        local path = workspace.StudioPay.Money:FindFirstChild(pay)
        if not path then return end
        local pPart = path:FindFirstChild("StudioMoney1")
        if not pPart then return end
        local prompt = pPart:FindFirstChildOfClass("ProximityPrompt")
        if prompt then
            tp(pPart.CFrame + Vector3.new(0,2,0))
            task.wait(0.1)
            prompt.HoldDuration = 0 prompt.RequiresLineOfSight = false
            pcall(fireproximityprompt, prompt)
        end
        task.wait(0.5)
        tp(hrp.CFrame)
    end
    hum:ChangeState(Enum.HumanoidStateType.FallingDown) task.wait(2)
    for _, p in {'StudioPay1','StudioPay2','StudioPay3'} do rob(p) end
    task.wait(1)
    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
    Library:Notify("Studio Farm done.", 3)
end)
-- Quick Buy
QuickReg:AddButton('Buy Shiesty', function() ReplicatedStorage.ShopRemote:InvokeServer('Shiesty') Library:Notify("Tried buying Shiesty", 2) end)
QuickReg:AddButton('Buy BluGloves', function() ReplicatedStorage.ShopRemote:InvokeServer('BluGloves') end)
QuickReg:AddButton('Buy WhiteGloves', function() ReplicatedStorage.ShopRemote:InvokeServer('WhiteGloves') end)
QuickReg:AddButton('Buy BlackGloves', function() ReplicatedStorage.ShopRemote:InvokeServer('BlackGloves') end)
QuickReg:AddButton('Buy Bandage', function() ReplicatedStorage.ShopRemote2:InvokeServer('Bandage') end)
QuickExo:AddButton('Buy Lemonade', function() ReplicatedStorage.ExoticShopRemote:InvokeServer('Lemonade') end)
-- ───────────────────────────────────────────────
-- Loops & Events (identical)
-- ───────────────────────────────────────────────
RunService.RenderStepped:Connect(function()
    local gui = LocalPlayer:FindFirstChild("PlayerGui")
    local char = LocalPlayer.Character
    if gui then
        local h = gui:FindFirstChild("Hunger", true) if h then local s = h:FindFirstChild("HungerBarScript", true) if s then s.Disabled = ModFlags.InfiniteHunger end end
        local r = gui:FindFirstChild("Run", true) if r then local s = r:FindFirstChild("StaminaBarScript", true) if s then s.Disabled = ModFlags.InfiniteStamina end end
        local sl = gui:FindFirstChild("SleepGui", true) if sl then local s = sl:FindFirstChild("sleepScript", true) if s then s.Disabled = ModFlags.InfiniteSleep end end
        local b = gui:FindFirstChild("BloodGui") if b then b.Enabled = not ModFlags.DisableBloodEffects end
        local j = gui:FindFirstChild("JumpDebounce") if j and j:FindFirstChild("LocalScript") then j.LocalScript.Disabled = ModFlags.NoJumpCooldown end
        local rt = gui:FindFirstChild("RentGui") if rt and rt:FindFirstChild("LocalScript") then rt.LocalScript.Disabled = ModFlags.NoRentPay end
        local ct = gui:FindFirstChild("CameraTexts") if ct then ct.Enabled = not ModFlags.DisableCameras if ct:FindFirstChild("LocalScript") then ct.LocalScript.Disabled = ModFlags.DisableCameras end end
    end
    if char then
        local cb = char:FindFirstChild("CameraBobbing") if cb then cb.Disabled = ModFlags.DisableCameraBobbing end
        local fd = char:FindFirstChild("FallDamageRagdoll") if fd then fd.Disabled = ModFlags.NoFallDamage end
    end
end)
UserInputService.InputBegan:Connect(function(input, gp)
    if gp or not ModFlags.InfiniteJump then return end
    if input.KeyCode == Enum.KeyCode.Space then
        local hum = getHumanoid()
        if hum and hum.Health > 0 then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)
local function SetupCharEvents(char)
    local hum = char:WaitForChild("Humanoid")
    local root = char:WaitForChild("HumanoidRootPart")
    hum.Died:Connect(function() DeathFrame = root.CFrame end)
    char.DescendantAdded:Connect(function(d)
        if (d:IsA("BodyVelocity") or d:IsA("LinearVelocity") or d:IsA("VectorForce")) and ModFlags.NoKnockback then task.wait() d:Destroy() end
    end)
    if ModFlags.RespawnWhereYouDied and DeathFrame then root.CFrame = DeathFrame end
end
if LocalPlayer.Character then SetupCharEvents(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(SetupCharEvents)
LocalPlayer.CharacterAdded:Connect(function()
    if ModFlags.DisableCameras and Lighting:FindFirstChild("Shiesty") then
        local rem = Lighting.Shiesty:FindFirstChildWhichIsA("RemoteEvent", true)
        if rem then rem:FireServer() end
    end
end)
-- ───────────────────────────────────────────────
-- Settings extras (fixed cursor toggle + OnClose cleanup)
-- ───────────────────────────────────────────────
SettingsMenu:AddLabel('Menu Keybind'):AddKeyPicker('MenuKeybind', {
    Default = 'RightShift',
    NoUI = true,
    Text = 'Toggle Menu',
})
Library.ToggleKeybind = Options.MenuKeybind -- this makes the key toggle the UI

SettingsMenu:AddToggle('CustomCursor', {
    Text = 'Enable Custom Cursor',
    Default = true,
    Callback = function(enabled)
        Library.ShowCustomCursor = enabled
        
        -- Fix disappearing cursor when disabling custom cursor
        if not enabled then
            task.delay(0.1, function()
                UserInputService.MouseIconEnabled = true
                UserInputService.MouseBehavior = Enum.MouseBehavior.Default
                pcall(function()
                    UserInputService.MouseIcon = ""
                end)
            end)
        end
    end
})

-- Final setup
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })
SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:ApplyToTab(Tabs.Settings)
Library:Notify('Project P58 - Linoria Loaded | Menu bind: RightShift (changeable) | Custom cursor toggle in Settings', 7)

-- Force cursor restore when UI is fully closed (prevents bug after disable + close)
Window:OnClose(function()
    task.delay(0.2, function()
        UserInputService.MouseIconEnabled = true
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        pcall(function()
            UserInputService.MouseIcon = ""
        end)
    end)
end)
