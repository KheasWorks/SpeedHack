local player = game:GetService("Players").LocalPlayer
local mouse = player:GetMouse()
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local origSpeed = hum.WalkSpeed

-- Main GUI
local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
gui.Name = "KheasHubGUI"
gui.ResetOnSpawn = false

-- Rainbow stroke function
local function addRainbowStroke(obj)
	local stroke = Instance.new("UIStroke", obj)
	stroke.Thickness = 2
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	local h = 0
	game:GetService("RunService").RenderStepped:Connect(function()
		h = (h + 0.005) % 1
		stroke.Color = Color3.fromHSV(h, 1, 1)
	end)
end

-- Draggable function (supports PC & Mobile)
local function makeDraggable(frame)
	local dragging = false
	local dragInput, dragStart, startPos

	local function update(input)
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			math.clamp(startPos.X.Scale, 0, 1),
			math.clamp(startPos.X.Offset + delta.X, 0, workspace.CurrentCamera.ViewportSize.X - frame.AbsoluteSize.X),
			math.clamp(startPos.Y.Scale, 0, 1),
			math.clamp(startPos.Y.Offset + delta.Y, 0, workspace.CurrentCamera.ViewportSize.Y - frame.AbsoluteSize.Y)
		)
	end

	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	frame.InputChanged:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then
			update(input)
		end
	end)
end

-- Main Window
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.3, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.Active = true
frame.Draggable = false -- custom drag used
makeDraggable(frame)
addRainbowStroke(frame)

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 12)

-- Title
local title = Instance.new("TextLabel", frame)
title.Text = "KheasHub"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 22
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, 0, 0, 40)

-- Hide Button
local hideBtn = Instance.new("TextButton", frame)
hideBtn.Text = "-"
hideBtn.Font = Enum.Font.SourceSansBold
hideBtn.TextSize = 22
hideBtn.Size = UDim2.new(0, 30, 0, 30)
hideBtn.Position = UDim2.new(1, -35, 0, 5)
hideBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
hideBtn.TextColor3 = Color3.new(1, 1, 1)

-- SpeedHack Button
local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.new(0.6, 0, 0, 40)
btn.Position = UDim2.new(0.2, 0, 0.4, 0)
btn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
btn.Text = "S P E E D"
btn.Font = Enum.Font.SourceSansBold
btn.TextSize = 20
btn.TextColor3 = Color3.new(1, 1, 1)

local btnCorner = Instance.new("UICorner", btn)
btnCorner.CornerRadius = UDim.new(0, 8)

-- Button border (UIStroke) kept on button itself
local btnStroke = Instance.new("UIStroke", btn)
btnStroke.Color = Color3.new(1, 1, 1)
btnStroke.Thickness = 2

-- NO UITextStroke on text here (so no text border)

-- Status Label
local status = Instance.new("TextLabel", frame)
status.Position = UDim2.new(0.2, 0, 0.7, 0)
status.Size = UDim2.new(0.6, 0, 0, 30)
status.Text = ""
status.BackgroundTransparency = 1
status.TextSize = 18
status.Font = Enum.Font.SourceSansBold
status.TextColor3 = Color3.new(0, 1, 0)

-- Mini Icon (K circle)
local mini = Instance.new("TextButton", gui)
mini.Size = UDim2.new(0, 50, 0, 50)
mini.Position = UDim2.new(0, 20, 0.8, 0)
mini.BackgroundColor3 = Color3.new(0, 0, 0)
mini.Text = "K"
mini.Font = Enum.Font.SourceSansBold
mini.TextSize = 24
mini.TextColor3 = Color3.new(1, 1, 1)
mini.Visible = false
mini.AutoButtonColor = true

local miniCorner = Instance.new("UICorner", mini)
miniCorner.CornerRadius = UDim.new(1, 0)
addRainbowStroke(mini)

-- Make mini draggable (PC & Mobile)
makeDraggable(mini)

-- Hide / Show logic
hideBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	mini.Visible = true
end)

mini.MouseButton1Click:Connect(function()
	frame.Visible = true
	mini.Visible = false
end)

-- Speed toggle and button animation
local toggled = false
btn.MouseButton1Click:Connect(function()
	-- Animation (button press effect)
	btn:TweenSize(UDim2.new(0.55, 0, 0, 36), "Out", "Quad", 0.08, true, function()
		btn:TweenSize(UDim2.new(0.6, 0, 0, 40), "Out", "Back", 0.15, true)
	end)

	toggled = not toggled
	if toggled then
		hum.WalkSpeed = 120
		status.Text = "SUCCESFULLY LOADED"
		status.TextColor3 = Color3.fromRGB(0, 255, 0)
	else
		hum.WalkSpeed = origSpeed
		status.Text = "SUCCESFULLY DEACTIVATED"
		status.TextColor3 = Color3.fromRGB(255, 0, 0)
	end
end)
