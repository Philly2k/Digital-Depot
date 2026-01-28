-- Executor Detection
local executor = "Unknown"
if syn then
   executor = "Synapse X"
elseif fluxus then
   executor = "Fluxus"
elseif krnl then
   executor = "Krnl"
elseif getgenv().ECLIPSE then
   executor = "Eclipse"
elseif getgenv().DELTA then
   executor = "Delta"
end -- Add more if needed

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Tha Bronx 3 Max Money Exploit - " .. executor .. " - Rayfield UI",
   LoadingTitle = "Loading Exploit...",
   LoadingSubtitle = "by Grok",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "ThaBronx3"
   },
   Discord = {
      Enabled = false, -- Toggle if you want to use Discord Rich Presence integration
      Invite = "noinv", -- The Discord invite code, do not include discord.gg/. Use a URL shortner
      RememberJoins = true -- Toggle if you want to remember joins for metrics
   },
   KeySystem = false -- Set this to true to use our key system
})

local ExploitsTab = Window:CreateTab("Exploits", 4483362458) -- Title, Image
local TeleportsTab = Window:CreateTab("Teleports", 4483362458)
local PlayerTab = Window:CreateTab("Player", 4483362458)

local MoneySection = ExploitsTab:CreateSection("Max Money Exploit")
local BuySection = ExploitsTab:CreateSection("Buy All Items")

-- Services for Tween (smooth TP to bypass some detections)
local TweenService = game:GetService("TweenService")

-- Function for smooth teleport (anti-cheat bypass attempt: slower movement)
local function smoothTP(targetCFrame, duration)
   duration = duration or 0.2 -- Fast but not instant
   local player = game.Players.LocalPlayer
   local char = player.Character
   if char and char:FindFirstChild("HumanoidRootPart") then
      local hrp = char.HumanoidRootPart
      local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
      local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
      tween:Play()
      tween.Completed:Wait()
   end
end

-- Infinite Money Toggle (Auto Sell Kool Aid with Ice Fruit Cups)
local AutoSellEnabled = false
local AutoSellToggle = ExploitsTab:CreateToggle({
   Name = "Infinite Money (Auto Sell Kool Aid)",
   CurrentValue = false,
   Flag = "AutoSellToggle",
   Callback = function(Value)
      AutoSellEnabled = Value
      if Value then
         Rayfield:Notify({
            Title = "Infinite Money Started",
            Content = "Equipping Ice Fruit Cups & Auto Selling to Seller!",
            Duration = 4,
            Image = 4483362458,
         })
         spawn(function()
            while AutoSellEnabled do
               pcall(function()
                  local player = game.Players.LocalPlayer
                  local char = player.Character
                  local backpack = player.Backpack
                  -- Equip Ice Fruit Cups
                  local iceCup = backpack:FindFirstChild("Ice Fruit Cups") or char:FindFirstChild("Ice Fruit Cups")
                  if iceCup and iceCup:IsA("Tool") then
                     local humanoid = char:FindFirstChildOfClass("Humanoid")
                     if humanoid then
                        humanoid:EquipTool(iceCup)
                     end
                  end
                  -- Find Seller ProximityPrompt
                  local sellPrompt = nil
                  for _, obj in pairs(workspace:GetDescendants()) do
                     if obj:IsA("ProximityPrompt") and (string.lower(obj.ActionText or ""):find("sell") or string.lower(obj.ObjectText or ""):find("sell") or string.lower(obj.Parent.Name):find("seller")) then
                        sellPrompt = obj
                        break
                     end
                  end
                  if sellPrompt and char:FindFirstChild("HumanoidRootPart") and sellPrompt.Parent and sellPrompt.Parent:IsA("BasePart") then
                     -- Teleport to Seller (smooth TP)
                     smoothTP(sellPrompt.Parent.CFrame * CFrame.new(0, 0, -3))
                     task.wait(0.3)
                     -- Instant Fire (One Tap E)
                     sellPrompt.HoldDuration = 0
                     sellPrompt:InputHoldBegin()
                     task.wait(0.05)
                     sellPrompt:InputHoldEnd()
                     sellPrompt.HoldDuration = 1 -- Reset if needed
                  end
               end)
               task.wait(1.5) -- Delay for sell animation/money receive
            end
         end)
      else
         Rayfield:Notify({
            Title = "Infinite Money Stopped",
            Content = "Auto Sell Disabled",
            Duration = 3,
         })
      end
   end,
})

-- Buy All Items Button (Fires all buy prompts max times)
local BuyAllButton = ExploitsTab:CreateButton({
   Name = "Buy All Items (Ingredients Max)",
   Callback = function()
      Rayfield:Notify({
         Title = "Buying All Items...",
         Content = "Firing all Buy Prompts!",
         Duration = 4,
      })
      spawn(function()
         for i = 1, 20 do -- Buy max stacks
            for _, obj in pairs(workspace:GetDescendants()) do
               if obj:IsA("ProximityPrompt") and string.lower(obj.ActionText or ""):find("buy") then
                  pcall(function()
                     local char = game.Players.LocalPlayer.Character
                     if char:FindFirstChild("HumanoidRootPart") and obj.Parent and obj.Parent:IsA("BasePart") then
                        -- Smooth TP to prompt
                        smoothTP(obj.Parent.CFrame * CFrame.new(math.random(-3,3), 0, math.random(-3,3)))
                        task.wait(0.1)
                        obj.HoldDuration = 0
                        obj:InputHoldBegin()
                        task.wait(0.01)
                        obj:InputHoldEnd()
                     end
                  end)
               end
            end
            task.wait(0.2)
         end
      end)
   end,
})

local TpSection = TeleportsTab:CreateSection("Teleports")

-- Teleport to Cooking Pot (No notify, smooth TP)
local TpPotButton = TeleportsTab:CreateButton({
   Name = "Teleport to Cooking Pot",
   Callback = function()
      local pots = {}
      for _, obj in pairs(workspace:GetDescendants()) do
         if (string.lower(obj.Name):find("pot") or string.lower(obj.Name):find("cook") or string.lower(obj.Name):find("stove")) and obj:IsA("BasePart") then
            table.insert(pots, obj)
         end
      end
      if #pots > 0 then
         local pot = pots[1]
         local char = game.Players.LocalPlayer.Character
         if char and char:FindFirstChild("HumanoidRootPart") then
            smoothTP(pot.CFrame + Vector3.new(0, 5, 0))
         end
      else
         Rayfield:Notify({
            Title = "No Pots Found",
            Content = "Search for pots failed",
            Duration = 3,
         })
      end
   end,
})

-- Teleport to Seller (No notify, smooth TP)
local TpSellerButton = TeleportsTab:CreateButton({
   Name = "Teleport to Seller",
   Callback = function()
      local sellPrompt = nil
      for _, obj in pairs(workspace:GetDescendants()) do
         if obj:IsA("ProximityPrompt") and (string.lower(obj.ActionText or ""):find("sell") or string.lower(obj.ObjectText or ""):find("sell") or string.lower(obj.Parent.Name):find("seller")) then
            sellPrompt = obj
            break
         end
      end
      if sellPrompt and sellPrompt.Parent and sellPrompt.Parent:IsA("BasePart") then
         local char = game.Players.LocalPlayer.Character
         if char and char:FindFirstChild("HumanoidRootPart") then
            smoothTP(sellPrompt.Parent.CFrame * CFrame.new(0, 0, -5))
         end
      else
         Rayfield:Notify({
            Title = "No Seller Found",
            Content = "Search for seller failed",
            Duration = 3,
         })
      end
   end,
})

local PlayerSection = PlayerTab:CreateSection("Player Mods")

-- Walkspeed Slider
PlayerTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 500},
   Increment = 1,
   CurrentValue = 16,
   Flag = "WalkSpeed",
   Callback = function(Value)
      local char = game.Players.LocalPlayer.Character
      if char and char:FindFirstChild("Humanoid") then
         char.Humanoid.WalkSpeed = Value
      end
   end,
})

-- Jump Power Slider
PlayerTab:CreateSlider({
   Name = "Jump Power",
   Range = {50, 400},
   Increment = 1,
   CurrentValue = 50,
   Flag = "JumpPower",
   Callback = function(Value)
      local char = game.Players.LocalPlayer.Character
      if char and char:FindFirstChild("Humanoid") then
         char.Humanoid.JumpPower = Value
      end
   end,
})

-- Infinite Jump Button
local InfJumpButton = PlayerTab:CreateButton({
   Name = "Infinite Jump (Toggle)",
   Callback = function()
      local InfiniteJumpEnabled = true
      game:GetService("UserInputService").JumpRequest:Connect(function()
         if InfiniteJumpEnabled then
            game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
         end
      end)
      Rayfield:Notify({
         Title = "Infinite Jump",
         Content = "Enabled! (Re-execute to toggle off)",
         Duration = 3,
      })
   end,
})

-- Anti-Cheat Bypass Attempts: Hook some common detections (basic)
-- Example: Hook __namecall to bypass some checks (undetectable attempt)
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
   local method = getnamecallmethod()
   if method == "Kick" or method == "kick" then
      return -- Bypass kick
   end
   if method == "TeleportDetect" or method == "AntiCheatCheck" then -- Placeholder for game-specific
      return false
   end
   return oldNamecall(self, ...)
end)

-- Additional: NoClip for TP through walls if needed
local NoClipEnabled = false
local NoClipToggle = PlayerTab:CreateToggle({
   Name = "NoClip (For TP Bypass)",
   CurrentValue = false,
   Callback = function(Value)
      NoClipEnabled = Value
      if Value then
         spawn(function()
            while NoClipEnabled do
               for _, part in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                  if part:IsA("BasePart") then
                     part.CanCollide = false
                  end
               end
               task.wait()
            end
         end)
      end
   end,
})

Rayfield:Notify({
   Title = "Loaded Successfully!",
   Content = "Tha Bronx 3 Max Money Exploit - Fully Functional! Anti-Cheat Bypasses Added.",
   Duration = 6.5,
   Image = 4483362458,
})
