-- Executor Detection
local executor = identifyexecutor and identifyexecutor() or "Unknown"
if syn then executor = "Synapse X"
elseif fluxus then executor = "Fluxus"
elseif Krnl then executor = "Krnl"
elseif getgenv().ECLIPSE then executor = "Eclipse"
elseif getgenv().DELTA then executor = "Delta"
end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Tha Bronx 3 Max Money Exploit - " .. executor .. " - Rayfield UI (Fixed)",
   LoadingTitle = "Loading Fixed Exploit...",
   LoadingSubtitle = "by Grok",
   ConfigurationSaving = { Enabled = true, FolderName = nil, FileName = "ThaBronx3Fixed" },
   Discord = { Enabled = false, Invite = "noinv", RememberJoins = true },
   KeySystem = false
})

local ExploitsTab = Window:CreateTab("Exploits", 4483362458)
local TeleportsTab = Window:CreateTab("Teleports", 4483362458)
local PlayerTab = Window:CreateTab("Player", 4483362458)
local AutofarmTab = Window:CreateTab("Autofarm", 4483362458)

-- Services
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Globals
local AutoSellEnabled = false
local StudioFarmEnabled = false
local NoClipEnabled = false
local InfJumpEnabled = false
local InfJumpConnection = nil
local NoClipConnection = nil

-- Smooth TP with Anti-Cheat Bypass
local function smoothTP(targetCFrame, duration)
   duration = duration or 0.4
   local char = player.Character
   if char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
      local humanoid = char.Humanoid
      local hrp = char.HumanoidRootPart
      humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
      hrp.Velocity = Vector3.new(0, 0, 0)
      hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
      local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
      local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
      tween:Play()
      tween.Completed:Wait()
      humanoid:ChangeState(Enum.HumanoidStateType.Running)
   end
end

-- Global Instant Prompts (Sets HoldDuration=0 everywhere except MimicATM)
local InstantPromptsButton = ExploitsTab:CreateButton({
   Name = "Global Instant Prompts (No Hold E)",
   Callback = function()
      local function isMimicATM(obj)
         local parent = obj.Parent
         while parent do
            if parent.Name == "MimicATM" then return true end
            parent = parent.Parent
         end
         return false
      end
      local function setInstant(obj)
         if obj:IsA("ProximityPrompt") and not isMimicATM(obj) then
            obj.HoldDuration = 0
         end
      end
      for _, obj in pairs(workspace:GetDescendants()) do setInstant(obj) end
      workspace.DescendantAdded:Connect(function(obj)
         if obj:IsA("ProximityPrompt") then setInstant(obj) end
      end)
      Rayfield:Notify({Title = "Instant Prompts", Content = "All HoldDuration set to 0!", Duration = 4})
   end
})

-- Buy Specific Items (Ice Fruit Bag, Ice Fruit Cupz, Fiji Water, Fresh Water)
ExploitsTab:CreateButton({
   Name = "Buy Max Ice Fruit Items (Bag, Cupz, Fiji, Fresh Water)",
   Callback = function()
      spawn(function()
         Rayfield:Notify({Title = "Buying Ice Fruit Items...", Content = "Max stacks from dealer!", Duration = 4})
         local items = {"ice%-fruit bag", "ice%-fruit cupz", "fijiwater", "freshwater", "ice%s*fruit%s*bag", "ice%s*fruit%s*cup", "fiji%s*water", "fresh%s*water"}
         for i = 1, 15 do -- Reduced loops to avoid kick
            for _, obj in pairs(workspace:GetDescendants()) do
               if obj:IsA("ProximityPrompt") then
                  local text = string.lower(obj.ActionText or obj.ObjectText or "")
                  local match = false
                  for _, item in pairs(items) do
                     if text:find(item) then match = true; break end
                  end
                  if match then
                     pcall(function()
                        local char = player.Character
                        if char and char:FindFirstChild("HumanoidRootPart") and obj.Parent and obj.Parent:IsA("BasePart") then
                           smoothTP(obj.Parent.CFrame * CFrame.new(math.random(-2,2), 0, -4), 0.3)
                           task.wait(0.4)
                           obj.HoldDuration = 0
                           obj:InputHoldBegin()
                           task.wait(0.03)
                           obj:InputHoldEnd()
                        end
                     end)
                  end
               end
            end
            task.wait(0.8) -- Longer delay anti-kick
         end
      end)
   end
})

-- Infinite Money Toggle (Fixed Seller for Kool Aid)
local AutoSellToggle = ExploitsTab:CreateToggle({
   Name = "Infinite Money (Auto Sell Kool Aid)",
   CurrentValue = false,
   Flag = "AutoSellToggle",
   Callback = function(Value)
      AutoSellEnabled = Value
      if Value then
         spawn(function()
            while AutoSellEnabled do
               pcall(function()
                  local char = player.Character
                  local backpack = player.Backpack
                  -- Equip Ice Fruit Cups
                  local iceCup = backpack:FindFirstChild("Ice-Fruit Cupz") or backpack:FindFirstChild("Ice Fruit Cups") or char:FindFirstChild("Ice-Fruit Cupz")
                  if iceCup and iceCup:IsA("Tool") then
                     char.Humanoid:EquipTool(iceCup)
                     task.wait(0.5)
                  end
                  -- Find KOOL AID SELLER (improved filter)
                  local sellPrompt = nil
                  for _, obj in pairs(workspace:GetDescendants()) do
                     if obj:IsA("ProximityPrompt") then
                        local act = string.lower(obj.ActionText or "")
                        local objt = string.lower(obj.ObjectText or "")
                        local par = string.lower(obj.Parent.Name or "")
                        if (act:find("sell") or objt:find("sell")) and (act:find("kool") or act:find("aid") or act:find("drink") or par:find("kool") or par:find("vendor") or par:find("seller")) then
                           sellPrompt = obj
                           break
                        end
                     end
                  end
                  if sellPrompt and char:FindFirstChild("HumanoidRootPart") and sellPrompt.Parent and sellPrompt.Parent:IsA("BasePart") then
                     smoothTP(sellPrompt.Parent.CFrame * CFrame.new(0, 0, -4), 0.5)
                     task.wait(0.6)
                     sellPrompt.HoldDuration = 0
                     sellPrompt:InputHoldBegin()
                     task.wait(0.05)
                     sellPrompt:InputHoldEnd()
                  end
               end)
               task.wait(2) -- Slower loop
            end
         end)
      end
   end
})

-- Studio Autofarm Toggle
local StudioToggle = AutofarmTab:CreateToggle({
   Name = "Studio Autofarm (TP & Collect All Money)",
   CurrentValue = false,
   Flag = "StudioToggle",
   Callback = function(Value)
      StudioFarmEnabled = Value
      if Value then
         spawn(function()
            while StudioFarmEnabled do
               pcall(function()
                  -- Find Studio
                  local studio = nil
                  for _, model in pairs(workspace:GetChildren()) do
                     if string.lower(model.Name):find("studio") then
                        studio = model
                        break
                     end
                  end
                  if not studio then
                     for _, obj in pairs(workspace:GetDescendants()) do
                        if obj:IsA("BasePart") and string.lower(obj.Name):find("studio") then
                           studio = obj
                           break
                        end
                     end
                  end
                  local char = player.Character
                  if studio and char and char:FindFirstChild("HumanoidRootPart") then
                     local targetCF = studio:IsA("BasePart") and studio.CFrame or (studio.PrimaryPart and studio.PrimaryPart.CFrame) or studio:GetModelCFrame()
                     smoothTP(targetCF * CFrame.new(0, 5, 0), 0.6)
                     task.wait(0.8)
                     -- Collect all money/collect prompts (nearby or global with filter)
                     for _, obj in pairs(workspace:GetDescendants()) do
                        if obj:IsA("ProximityPrompt") then
                           local act = string.lower(obj.ActionText or "")
                           local par = string.lower(obj.Parent.Name or "")
                           if (act:find("collect") or act:find("money") or act:find("cash") or act:find("rob") or act:find("take") or act:find("grab") or par:find("money") or par:find("cash")) then
                              local dist = (obj.Parent.Position - char.HumanoidRootPart.Position).Magnitude
                              if dist < 50 then -- Nearby only
                                 smoothTP(obj.Parent.CFrame * CFrame.new(0,0,-3), 0.3)
                                 task.wait(0.3)
                                 obj.HoldDuration = 0
                                 obj:InputHoldBegin()
                                 task.wait(0.03)
                                 obj:InputHoldEnd()
                              end
                           end
                        end
                     end
                  end
               end)
               task.wait(1.5)
            end
         end)
      end
   end
})

-- Teleports (Fixed Seller, Pot perfect)
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
         local char = player.Character
         if char and char:FindFirstChild("HumanoidRootPart") then
            smoothTP(pot.CFrame + Vector3.new(0, 5, 0), 0.5)
         end
      end
   end
})

local TpSellerButton = TeleportsTab:CreateButton({
   Name = "Teleport to Kool Aid Seller",
   Callback = function()
      local sellPrompt = nil
      for _, obj in pairs(workspace:GetDescendants()) do
         if obj:IsA("ProximityPrompt") then
            local act = string.lower(obj.ActionText or "")
            local objt = string.lower(obj.ObjectText or "")
            local par = string.lower(obj.Parent.Name or "")
            if (act:find("sell") or objt:find("sell")) and (act:find("kool") or act:find("aid") or act:find("drink") or par:find("kool") or par:find("vendor") or par:find("seller")) then
               sellPrompt = obj
               break
            end
         end
      end
      if sellPrompt and sellPrompt.Parent and sellPrompt.Parent:IsA("BasePart") then
         local char = player.Character
         if char and char:FindFirstChild("HumanoidRootPart") then
            smoothTP(sellPrompt.Parent.CFrame * CFrame.new(0, 0, -5), 0.5)
         end
      end
   end
})

-- Player Mods
PlayerTab:CreateSlider({Name = "WalkSpeed", Range = {16, 500}, Increment = 1, CurrentValue = 16, Flag = "WalkSpeed", Callback = function(v) local char = player.Character; if char then char.Humanoid.WalkSpeed = v end end})
PlayerTab:CreateSlider({Name = "Jump Power", Range = {50, 400}, Increment = 1, CurrentValue = 50, Flag = "JumpPower", Callback = function(v) local char = player.Character; if char then char.Humanoid.JumpPower = v end end})

-- Fixed Infinite Jump Toggle
local InfJumpToggle = PlayerTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Callback = function(Value)
      InfJumpEnabled = Value
      if Value then
         InfJumpConnection = UserInputService.JumpRequest:Connect(function()
            if InfJumpEnabled then
               local char = player.Character
               if char then
                  local hum = char:FindFirstChildOfClass("Humanoid")
                  if hum then hum:ChangeState("Jumping") end
               end
            end
         end)
      else
         if InfJumpConnection then InfJumpConnection:Disconnect() end
      end
   end
})

-- Fixed NoClip Toggle
local NoClipToggle = PlayerTab:CreateToggle({
   Name = "NoClip",
   CurrentValue = false,
   Callback = function(Value)
      NoClipEnabled = Value
      if Value then
         local function startNoClip(char)
            NoClipConnection = RunService.Heartbeat:Connect(function()
               if NoClipEnabled then
                  for _, part in pairs(char:GetDescendants()) do
                     if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                     end
                  end
               end
            end)
         end
         if player.Character then startNoClip(player.Character) end
         player.CharacterAdded:Connect(startNoClip)
      else
         if NoClipConnection then NoClipConnection:Disconnect() end
      end
   end
})

-- Anti-Cheat Hooks
local oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
   local method = getnamecallmethod()
   local args = {...}
   if method == "Kick" or method:lower() == "kick" then return task.wait(math.huge) end
   if method == "FireServer" and tostring(self):find("Anti") or tostring(self):find("Cheat") then return end
   return oldNamecall(self, ...)
end)

-- CharacterAdded for mods
player.CharacterAdded:Connect(function()
   task.wait(1)
   -- Reapply WS/JP if sliders changed
end)

Rayfield:Notify({
   Title = "Loaded Fixed Version!",
   Content = "Buy Ice Items Fixed | Studio Autofarm | NoClip/Jump Fixed | Anti-Kick TP | Kool Aid Seller",
   Duration = 8,
   Image = 4483362458
})
