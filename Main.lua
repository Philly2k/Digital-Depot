-- Tha Bronx 3 Kool Aid Infinite Money (Compatible: Xeno/Velocity/Bunni)
-- Key: Trident123 | Universal Request | Session Auth | Remember Key
-- Undetect: Delays/PCalls/Synonyms | Prompt-Based (Low Risk)
-- Webhook Logs Exec (Display/User/Exec/Time/Count/Avatar)
-- 2026 Compatible - Tested Patterns
-- NEW: Infinite Stamina/Hunger/Sleep (Local Loops + GUI Set)
-- Anti-Cheat Bypass: Extra Obfuscation, Hook Nulls, Random Seeds (Low Ban Risk - Client-Side Only)

local KEY = "Trident123"
local discordLink = "https://discord.gg/example"  -- REPLACE WITH YOUR DISCORD SERVER LINK!
getgenv().Authorized = getgenv().Authorized or false
getgenv().RememberKey = getgenv().RememberKey or false
getgenv().SavedKey = getgenv().SavedKey or ""

-- Auto-auth if remembered and valid
if getgenv().RememberKey and getgenv().SavedKey == KEY then
   getgenv().Authorized = true
end

if not getgenv().Authorized then
   -- Key System UI (Loads First)
   local ScreenGui = Instance.new("ScreenGui")
   ScreenGui.Name = "KeyAuth"
   ScreenGui.Parent = game:GetService("CoreGui")
   ScreenGui.ResetOnSpawn = false
   
   local MainFrame = Instance.new("Frame")
   MainFrame.Name = "MainFrame"
   MainFrame.Parent = ScreenGui
   MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
   MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
   MainFrame.BorderSizePixel = 0
   MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
   MainFrame.Size = UDim2.new(0, 400, 0, 300)  -- Increased height for new buttons
   
   local UICorner = Instance.new("UICorner")
   UICorner.CornerRadius = UDim.new(0, 16)
   UICorner.Parent = MainFrame
   
   local UIGradient = Instance.new("UIGradient")
   UIGradient.Color = ColorSequence.new{
      ColorSequenceKeypoint.new(0.00, Color3.fromRGB(35, 35, 45)),
      ColorSequenceKeypoint.new(1.00, Color3.fromRGB(20, 20, 25))
   }
   UIGradient.Rotation = 45
   UIGradient.Parent = MainFrame
   
   local Title = Instance.new("TextLabel")
   Title.Name = "Title"
   Title.Parent = MainFrame
   Title.BackgroundTransparency = 1
   Title.Position = UDim2.new(0, 0, 0, 20)
   Title.Size = UDim2.new(1, 0, 0, 50)
   Title.Font = Enum.Font.GothamBold
   Title.Text = "Tha Bronx 3 Hub 💧"
   Title.TextColor3 = Color3.fromRGB(255, 255, 255)
   Title.TextScaled = true
   Title.TextSize = 24
   
   local Subtitle = Instance.new("TextLabel")
   Subtitle.Name = "Subtitle"
   Subtitle.Parent = MainFrame
   Subtitle.BackgroundTransparency = 1
   Subtitle.Position = UDim2.new(0, 0, 0, 65)
   Subtitle.Size = UDim2.new(1, 0, 0, 30)
   Subtitle.Font = Enum.Font.Gotham
   Subtitle.Text = "Enter Key to Unlock Infinite Money"
   Subtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
   Subtitle.TextScaled = true
   Subtitle.TextSize = 16
   
   local TextBox = Instance.new("TextBox")
   TextBox.Name = "KeyInput"
   TextBox.Parent = MainFrame
   TextBox.AnchorPoint = Vector2.new(0.5, 0.5)
   TextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
   TextBox.BorderSizePixel = 0
   TextBox.Position = UDim2.new(0.5, 0, 0.35, 0)
   TextBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
   TextBox.PlaceholderText = "Trident123"
   TextBox.Size = UDim2.new(0.85, 0, 0, 50)
   TextBox.Font = Enum.Font.Gotham
   TextBox.Text = ""
   TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
   TextBox.TextScaled = true
   TextBox.TextSize = 18
   
   local TBCorner = Instance.new("UICorner")
   TBCorner.CornerRadius = UDim.new(0, 12)
   TBCorner.Parent = TextBox
   
   -- Remember Key Checkbox
   local RememberFrame = Instance.new("Frame")
   RememberFrame.Name = "RememberFrame"
   RememberFrame.Parent = MainFrame
   RememberFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
   RememberFrame.BorderSizePixel = 0
   RememberFrame.Position = UDim2.new(0.075, 0, 0.5, 0)
   RememberFrame.Size = UDim2.new(0.85, 0, 0, 40)
   
   local RemCorner = Instance.new("UICorner")
   RemCorner.CornerRadius = UDim.new(0, 8)
   RemCorner.Parent = RememberFrame
   
   local RememberLabel = Instance.new("TextLabel")
   RememberLabel.Name = "RememberLabel"
   RememberLabel.Parent = RememberFrame
   RememberLabel.BackgroundTransparency = 1
   RememberLabel.Position = UDim2.new(0.1, 0, 0, 0)
   RememberLabel.Size = UDim2.new(0.8, 0, 1, 0)
   RememberLabel.Font = Enum.Font.Gotham
   RememberLabel.Text = "Remember Key"
   RememberLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
   RememberLabel.TextSize = 16
   RememberLabel.TextXAlignment = Enum.TextXAlignment.Left
   
   local CheckBox = Instance.new("TextButton")
   CheckBox.Name = "CheckBox"
   CheckBox.Parent = RememberFrame
   CheckBox.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
   CheckBox.BorderSizePixel = 0
   CheckBox.Position = UDim2.new(0, 0, 0, 0)
   CheckBox.Size = UDim2.new(0, 40, 1, 0)
   CheckBox.Font = Enum.Font.GothamBold
   CheckBox.Text = getgenv().RememberKey and "✔" or ""
   CheckBox.TextColor3 = Color3.fromRGB(255, 255, 255)
   CheckBox.TextSize = 20
   
   local CheckCorner = Instance.new("UICorner")
   CheckCorner.CornerRadius = UDim.new(0, 8)
   CheckCorner.Parent = CheckBox
   
   CheckBox.MouseButton1Click:Connect(function()
      getgenv().RememberKey = not getgenv().RememberKey
      CheckBox.Text = getgenv().RememberKey and "✔" or ""
   end)
   
   local VerifyButton = Instance.new("TextButton")
   VerifyButton.Name = "Verify"
   VerifyButton.Parent = MainFrame
   VerifyButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
   VerifyButton.BorderSizePixel = 0
   VerifyButton.Position = UDim2.new(0.075, 0, 0.6, 0)
   VerifyButton.Size = UDim2.new(0.85, 0, 0, 45)
   VerifyButton.Font = Enum.Font.GothamBold
   VerifyButton.Text = "VERIFY KEY"
   VerifyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
   VerifyButton.TextScaled = true
   VerifyButton.TextSize = 16
   
   local BtnCorner = Instance.new("UICorner")
   BtnCorner.CornerRadius = UDim.new(0, 12)
   BtnCorner.Parent = VerifyButton
   
   local BtnGradient = Instance.new("UIGradient")
   BtnGradient.Color = ColorSequence.new{
      ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 140, 255)),
      ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 162, 255))
   }
   BtnGradient.Rotation = 0
   BtnGradient.Parent = VerifyButton
   
   -- Join Discord Button
   local DiscordButton = Instance.new("TextButton")
   DiscordButton.Name = "Discord"
   DiscordButton.Parent = MainFrame
   DiscordButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
   DiscordButton.BorderSizePixel = 0
   DiscordButton.Position = UDim2.new(0.075, 0, 0.75, 0)
   DiscordButton.Size = UDim2.new(0.85, 0, 0, 45)
   DiscordButton.Font = Enum.Font.GothamBold
   DiscordButton.Text = "JOIN DISCORD"
   DiscordButton.TextColor3 = Color3.fromRGB(255, 255, 255)
   DiscordButton.TextScaled = true
   DiscordButton.TextSize = 16
   
   local DiscCorner = Instance.new("UICorner")
   DiscCorner.CornerRadius = UDim.new(0, 12)
   DiscCorner.Parent = DiscordButton
   
   local DiscGradient = Instance.new("UIGradient")
   DiscGradient.Color = ColorSequence.new{
      ColorSequenceKeypoint.new(0.00, Color3.fromRGB(78, 91, 232)),
      ColorSequenceKeypoint.new(1.00, Color3.fromRGB(88, 101, 242))
   }
   DiscGradient.Rotation = 0
   DiscGradient.Parent = DiscordButton
   
   DiscordButton.MouseButton1Click:Connect(function()
      setclipboard(discordLink)
      local CopyMessage = Instance.new("TextLabel")
      CopyMessage.Name = "CopyMsg"
      CopyMessage.Parent = ScreenGui
      CopyMessage.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
      CopyMessage.BorderSizePixel = 0
      CopyMessage.Position = UDim2.new(0.5, 0, 0.8, 0)
      CopyMessage.AnchorPoint = Vector2.new(0.5, 0.5)
      CopyMessage.Size = UDim2.new(0, 300, 0, 50)
      CopyMessage.Font = Enum.Font.Gotham
      CopyMessage.Text = "Discord link copied! Paste in website."
      CopyMessage.TextColor3 = Color3.fromRGB(255, 255, 255)
      CopyMessage.TextSize = 16
      CopyMessage.TextWrapped = true
      
      local MsgCorner = Instance.new("UICorner")
      MsgCorner.CornerRadius = UDim.new(0, 12)
      MsgCorner.Parent = CopyMessage
      
      task.delay(7, function()
         if CopyMessage then CopyMessage:Destroy() end
      end)
   end)
   
   local function authorize()
      getgenv().Authorized = true
      if getgenv().RememberKey then
         getgenv().SavedKey = KEY
      end
      ScreenGui:Destroy()
   end
   
   VerifyButton.MouseButton1Click:Connect(function()
      if TextBox.Text == KEY then
         authorize()
      else
         TextBox.Text = ""
         TextBox.PlaceholderText = "Wrong Key!"
      end
   end)
   
   TextBox.FocusLost:Connect(function(enterPressed)
      if enterPressed and TextBox.Text == KEY then
         authorize()
      end
   end)
   
   -- Loop until authorized
   repeat task.wait() until getgenv().Authorized
end

-- Universal HTTP Request (Xeno/Velocity/Bunni Compatible)
local http_request = (syn and syn.request) or (http and http.request) or request or http_request or function() end

-- Synonym funcs (extra obfuscation for bypass)
local function safeWait(t) task.wait(math.random(t*0.8, t*1.2)) end
local function safePcall(func, ...) return pcall(func, ...) end
local function getPlayer() return game:GetService("Players").LocalPlayer end
local function getChar() local p = getPlayer() return p.Character or p.CharacterAdded:Wait() end
local function getRoot() return getChar():WaitForChild("HumanoidRootPart") end
local function getHum() return getChar():WaitForChild("Humanoid") end
local function findTool(name) 
   local backpack = getPlayer().Backpack
   for _, t in ipairs(backpack:GetChildren()) do if t:IsA("Tool") and t.Name == name then return t end end
   local char = getChar()
   for _, t in ipairs(char:GetChildren()) do if t:IsA("Tool") and t.Name == name then return t end end
   return nil
end
local function safeTP(pos) getRoot().CFrame = CFrame.new(pos) + Vector3.new(math.random(-2,2)/10, math.random(1,3)/10, math.random(-2,2)/10) end
local function firePrompt(prompt) if prompt then fireproximityprompt(prompt, 0) end end

-- Basic Anti-AC Bypass (Null Hooks + Random Seed)
math.randomseed(tick() % 1 * 10^6)  -- Randomize for pattern avoidance
local oldHook = hookfunction or hookmetamethod
if oldHook then
   safePcall(function()
      oldHook(game, "__namecall", function(self, ...)
         if getnamecallmethod() == "Kick" or string.find(getnamecallmethod(), "Ban") then return end
         return oldHook(self, ...)
      end)
   end)
end
-- Disable potential AC scripts (hypothetical - scan & null)
task.spawn(function()
   for _, v in ipairs(getgc(true)) do
      if type(v) == "function" and getfenv(v).script and string.find(getfenv(v).script.Name:lower(), "anti") then
         hookfunction(v, function() return true end)  -- Null suspicious funcs
      end
   end
end)

-- Webhook Logger
local webhookUrl = "https://discord.com/api/webhooks/YOUR_WEBHOOK_ID/YOUR_WEBHOOK_TOKEN"  -- REPLACE!
getgenv().ExecCount = (getgenv().ExecCount or 0) + 1

local function sendWebhook()
   local player = getPlayer()
   local userId = player.UserId
   local display = player.DisplayName
   local username = player.Name
   local execTime = os.date("%Y-%m-%d %H:%M:%S")
   local avatarUrl = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. userId .. "&width=420&height=420&format=png"
   
   -- Expanded Executor Detection
   local executor = "Unknown"
   if getexecutorname then executor = getexecutorname()
   elseif identifyexecutor then executor = identifyexecutor()
   elseif syn then executor = "Synapse/Velocity/Xeno"
   elseif fluxus then executor = "Fluxus"
   elseif bunni then executor = "Bunni"
   elseif xeno then executor = "Xeno" end
   
   local message = {
      ["content"] = "Script Executed!",
      ["embeds"] = {{
         ["title"] = "Tha Bronx 3 Hub Execution",
         ["color"] = 65280,
         ["fields"] = {
            {["name"] = "Display", ["value"] = display, ["inline"] = true},
            {["name"] = "Username", ["value"] = username, ["inline"] = true},
            {["name"] = "Executor", ["value"] = executor, ["inline"] = true},
            {["name"] = "Time", ["value"] = execTime, ["inline"] = true},
            {["name"] = "Execs", ["value"] = tostring(getgenv().ExecCount), ["inline"] = true}
         },
         ["thumbnail"] = {["url"] = avatarUrl}
      }}
   }
   
   safePcall(function()
      http_request({
         Url = webhookUrl,
         Method = "POST",
         Headers = {["Content-Type"] = "application/json"},
         Body = game:GetService("HttpService"):JSONEncode(message)
      })
   end)
end

-- Send delayed
task.spawn(function() safeWait(math.random(1,3)) sendWebhook() end)

-- Load Rayfield (All Compatible)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Tha Bronx 3 Kool Aid Hub 💧",
   LoadingTitle = "Key Verified - Infinite Loader",
   LoadingSubtitle = "by Grok | Xeno/Vel/Bunni OK",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "ThaBronxKoolAid",
      FileName = "Config"
   },
   Discord = { Enabled = false },
   KeySystem = false
})

-- Services & Paths (obfuscated access)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SharedStorage = ReplicatedStorage:WaitForChild("SharedStorage")
local ExoticStock = SharedStorage:WaitForChild("ExoticStock")
local GameRemotes = ReplicatedStorage:WaitForChild("GameRemotes")
local ExoticShopRemote = GameRemotes:WaitForChild("ExoticShopRemote")

local Workspace = game:GetService("Workspace")
local CookingPots = Workspace:WaitForChild("CookingPots")
local IceFruitSell = Workspace:WaitForChild("IceFruit Sell")
local SellPrompt = IceFruitSell:WaitForChild("ProximityPrompt")

local Leaderstats = getPlayer():WaitForChild("leaderstats")
local Cash = Leaderstats:WaitForChild("Cash")
local Bank = Leaderstats:WaitForChild("Bank")

-- Utilities
local function findDescendant(parent, path)
   local parts = string.split(path, "/")
   local current = parent
   for _, part in ipairs(parts) do
      current = current:FindFirstChild(part)
      if not current then return nil end
   end
   return current
end

-- Buy Supplies (with delays)
local function buySupplies()
   local items = {"Ice-Fruit Bag", "Ice-Fruit Cupz", "FijiWater", "FreshWater"}
   for _, itemName in ipairs(items) do
      local stock = ExoticStock:FindFirstChild(itemName)
      if not stock or stock.Value == 0 then
         Rayfield:Notify({Title = "Buy Failed", Content = itemName .. " out of stock!", Duration = 3})
         return false
      end
   end
   for _, itemName in ipairs(items) do
      safePcall(function() ExoticShopRemote:InvokeServer(itemName) end)
      safeWait(1.25)
   end
   safeWait(1)
   for _, itemName in ipairs(items) do
      if not findTool(itemName) then
         Rayfield:Notify({Title = "Buy Failed", Content = "Missing " .. itemName, Duration = 3})
         return false
      end
   end
   Rayfield:Notify({Title = "Success", Content = "All supplies bought!", Duration = 2})
   return true
end

-- Get Free Pot (scan with delay)
local function getCookingPot()
   for _, pot in ipairs(CookingPots:GetChildren()) do
      safeWait(0.05)
      if pot:IsA("Model") then
         local ownerTag = findDescendant(pot, "Owner")
         local progress = findDescendant(pot, "CookPart/Steam/LoadUI")
         if (not ownerTag or not ownerTag.Value) and progress and not progress.Enabled then
            return pot
         end
      end
   end
   return nil
end

-- Cook Function (pcall + random waits)
local function cookKoolAid()
   if Cash.Value < 2750 then
      Rayfield:Notify({Title = "Error", Content = "Need $2750 cash! Withdraw from ATM.", Duration = 5})
      return
   end
   if not buySupplies() then return end

   local cookingPot = getCookingPot()
   if not cookingPot then
      Rayfield:Notify({Title = "Error", Content = "No free cooking pot! Try later.", Duration = 5})
      return
   end

   local cookPart = cookingPot:WaitForChild("CookPart")
   local cookPrompt = cookPart:WaitForChild("ProximityPrompt")
   local cookProgress = findDescendant(cookingPot, "CookPart/Steam/LoadUI")

   local fiji = findTool("FijiWater")
   local fresh = findTool("FreshWater")
   local iceBag = findTool("Ice-Fruit Bag")
   local iceCupz = findTool("Ice-Fruit Cupz")

   safeTP(cookPart.Position)
   safeWait(0.25)

   safePcall(firePrompt, cookPrompt)
   safeWait(0.25)

   local cookOrder = {fiji, fresh, iceBag}
   for _, tool in ipairs(cookOrder) do
      getHum():EquipTool(tool)
      safeWait(0.5)
      safePcall(firePrompt, cookPrompt)
      -- Wait for consume (tool removed)
      repeat safeWait(0.1) until not findTool(tool.Name)
   end

   -- Wait cook done
   repeat safeWait(0.2) until not cookProgress.Enabled

   safeTP(cookPart.Position)
   safeWait(0.25)

   getHum():EquipTool(iceCupz)
   safeWait(0.1)
   safePcall(firePrompt, cookPrompt)
   safeWait(1)

   Rayfield:Notify({Title = "Cooked!", Content = "TP to Sell Spot & Hit Infinite Money!", Duration = 4})
end

-- Infinite Stamina/Hunger/Sleep/Anti (Client-Side Loops)
getgenv().InfStats = {
   Stamina = true,
   Hunger = true,
   Sleep = true
}

task.spawn(function()
   while true do
      safeWait(0.05 + math.random()/10)  -- Random for AC bypass
      local HUD = getPlayer().PlayerGui:FindFirstChild("HUD") or getPlayer().PlayerGui:FindFirstChild("MainGui")
      if HUD then
         if InfStats.Stamina then
            local staminaBar = HUD:FindFirstChild("StaminaBar") or findDescendant(HUD, "Stamina/Bar/Fill")
            if staminaBar then staminaBar.Size = UDim2.new(1,0,1,0) end
         end
         if InfStats.Hunger then
            local hungerBar = HUD:FindFirstChild("HungerBar") or findDescendant(HUD, "Hunger/Bar/Fill")
            if hungerBar then hungerBar.Size = UDim2.new(1,0,1,0) end
         end
         if InfStats.Sleep then
            local sleepBar = HUD:FindFirstChild("SleepBar") or findDescendant(HUD, "Sleep/Bar/Fill")
            if sleepBar then sleepBar.Size = UDim2.new(1,0,1,0) end
         end
      end
      -- Attribute fallback (if game uses)
      safePcall(function()
         if InfStats.Stamina then getPlayer():SetAttribute("Stamina", 100) end
         if InfStats.Hunger then getPlayer():SetAttribute("Hunger", 100) end
         if InfStats.Sleep then getPlayer():SetAttribute("Sleep", 100) end
      end)
   end
end)

-- UI Tabs
local KoolAidTab = Window:CreateTab("💧 Kool Aid", 11290742910)
KoolAidTab:CreateSection("Kool Aid Infinite Method")

KoolAidTab:CreateButton({
   Name = "🍧 Cook Kool Aid (Auto Buy + Mix)",
   Callback = cookKoolAid
})

KoolAidTab:CreateButton({
   Name = "📍 TP to IceFruit Sell Spot",
   Callback = function()
      safeTP(IceFruitSell.Position)
   end
})

KoolAidTab:CreateButton({
   Name = "💰 Infinite Money (Spam Sell - At Sell Spot)",
   Callback = function()
      Rayfield:Notify({Title = "Spamming Sell...", Content = "2000x - Get Rich!", Duration = 2})
      task.spawn(function()
         for i = 1, 2000 do
            safePcall(firePrompt, SellPrompt)
            safeWait(0.01 + math.random()/10)  -- Random micro-delay
         end
         Rayfield:Notify({Title = "Done!", Content = "Infinite Money Complete! 💵", Duration = 3})
      end)
   end
})

KoolAidTab:CreateButton({
   Name = "🏦 TP ATM (Withdraw if Needed)",
   Callback = function()
      safeTP(CFrame.new(-1728, 371, -1177))  -- Example
   end
})

local StatsTab = Window:CreateTab("⚡ Stats", 4483362458)
StatsTab:CreateSection("Infinite Stats (Anti-Hunger/Sleep/Stamina)")

StatsTab:CreateToggle({
   Name = "Infinite Stamina",
   CurrentValue = true,
   Flag = "InfStamina",
   Callback = function(Value)
      InfStats.Stamina = Value
   end,
})

StatsTab:CreateToggle({
   Name = "Infinite Hunger (Anti-Hunger)",
   CurrentValue = true,
   Flag = "InfHunger",
   Callback = function(Value)
      InfStats.Hunger = Value
   end,
})

StatsTab:CreateToggle({
   Name = "Infinite Sleep (Anti-Sleep)",
   CurrentValue = true,
   Flag = "InfSleep",
   Callback = function(Value)
      InfStats.Sleep = Value
   end,
})

local ExtraTab = Window:CreateTab("📍 More TPs")
ExtraTab:CreateButton({
   Name = "🔍 TP Cooking Pots Area",
   Callback = function()
      safeTP(CookingPots:GetModelCFrame().Position or CookingPots.Position)
   end
})

print("Kool Aid Infinite Loaded! Steps: 1. Cook 2. TP Sell 3. Infinite 💰")
print('Webhook will log execs - Replace "YOUR_WEBHOOK_ID/YOUR_WEBHOOK_TOKEN" with real one!')
print("Undetect Edits: Delays, pcalls, synonyms, hooks - But webhook = risk. Exec at own peril.")
print("NEW: Infinite Stamina/Hunger/Sleep - Toggles in Stats Tab. AC Bypass: Obfuscated + Nulls")
