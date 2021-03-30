--[[

	RoUI by AstrealDev
	
	A simple & clean ROBLOX UI effects library.
	
	GitHub: https://github.com/impRBLX/RoUI
	v1.0

]]


-----// Private Variables //-----
local RoUI = {};
local RoUIInstance = {};

-----// Private Functions //-----
local function getVisbilityProperty(inst)
	if inst:IsA("LayerCollector") then
		return "Enabled";
	end
	return "Visible";
end

local function getUDimFromDir(inst, dir)
	if dir == RoUI.DIRECTIONS.LEFT or dir == RoUI.DIRECTIONS.RIGHT then
		return UDim2.new(dir.X, 0, inst.Position.Y.Scale, inst.Position.Y.Offset);
	elseif dir == RoUI.DIRECTIONS.UP or dir == RoUI.DIRECTIONS.DOWN then
		return UDim2.new(inst.Position.X.Scale, inst.Position.X.Offset, dir.Y, 0);
	end
	return inst.Position;
end

-----// RoUI Metamethods //-----
RoUI.__index = RoUI;
function RoUI.__call(self, ...)
	return RoUI.new(...);
end

-----// RoUI Constructor //-----
function RoUI.new(graphicalObj)
	
	local finalMT = {};
	finalMT.__index = finalMT;
	
	for key, value in pairs(RoUIInstance) do
		finalMT[key] = value;
	end
	
	local self = setmetatable({}, finalMT);
	
	self.instance = graphicalObj;
	
	return self;
	
end

-----// RoUI Instance Methods //-----
function RoUIInstance.Show(self)
	assert(self, "No RoUI Instance provided.");
	
	self.instance[getVisbilityProperty(self.instance)] = true;
end

function RoUIInstance.Hide(self)
	assert(self, "No RoUI Instance provided.");
	
	self.instance[getVisbilityProperty(self.instance)] = false;
end

function RoUIInstance.Visibility(self, value)
	assert(self and value, "Must provide RoUI Instance and boolean value.");
	assert(typeof(value) == "boolean", "Value provided must be of type boolean.");
	
	self.instance[getVisbilityProperty(self.instance)] = value;
end

function RoUIInstance.TweenPos(self, dir, speed, cb, easeDir, easeStyle)
	assert(self and dir and speed, "Must provide RoUI Instance, Vector2, and number.");
	assert(typeof(dir) == "Vector2", "Direction must be of type Vector2.");
	assert(typeof(speed) == "number", "Time must be of type number.");
	assert(self.instance:IsA("GuiObject"), "RoUI Instance must be of type GuiObject.");
	
	self.instance:TweenPosition(
		getUDimFromDir(self.instance, dir),
		easeDir or RoUI.Settings.Defaults.EasingDirection,
		easeStyle or RoUI.Settings.Defaults.EasingStyle,
		speed,
		true,
		cb
	);
end

function RoUIInstance.BindClickEffect(self, effect, mouse)
	assert(self and effect and mouse, "Must provide RoUI Instance, effect, and mouse.");
	assert(typeof(effect) == "number", "Effect must be of type number.");
	assert(self.instance:IsA("GuiButton"), "RoUI Instance must be of type GuiButton.");
	
	if self.BindedEffect then
		self.BindedEffect:Disconnect();
		if self.BindedEffectInstance then
			self.BindedEffectInstance:Destroy();
		end
	end
	
	if effect == RoUI.CLICK_EFFECTS.RADIAL.GROW or effect == RoUI.CLICK_EFFECTS.RADIAL.SHRINK then
		self.BindedEffectInstance = Instance.new("Frame");
		Instance.new("UICorner", self.BindedEffectInstance);
		self.BindedEffectInstance.UICorner.CornerRadius = UDim.new(1, 0);
		self.BindedEffectInstance.AnchorPoint = Vector2.new(0.5, 0.5);
		self.BindedEffectInstance.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		self.instance.ClipsDescendants = true;
		
		if effect == RoUI.CLICK_EFFECTS.RADIAL.GROW then
			self.BindedEffect = self.instance.MouseButton1Click:Connect(function()
				coroutine.wrap(function()
					self.BindedEffectInstance.Parent = self.instance;
					self.BindedEffectInstance.Position = UDim2.new(0, mouse.X - self.instance.AbsolutePosition.X, 0, mouse.Y - self.instance.AbsolutePosition.Y);
					self.BindedEffectInstance.Size = UDim2.new(0, 1, 0, 1);
					self.BindedEffectInstance.Transparency = RoUI.Settings.Defaults.EffectTransparency or 0.5;
					
					local finalGoal = {};
					finalGoal.Size = UDim2.new(0, (self.instance.AbsoluteSize.X), 0, (self.instance.AbsoluteSize.X));
					finalGoal.Transparency = 1;
					
					local tween = game:GetService("TweenService"):Create(self.BindedEffectInstance, TweenInfo.new(RoUI.Settings.Defaults.ClickEffectSpeed or 1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), finalGoal);
					tween:Play();
				end)();
			end)
		elseif effect == RoUI.CLICK_EFFECTS.RADIAL.SHRINK then
			self.BindedEffect = self.instance.MouseButton1Click:Connect(function()
				coroutine.wrap(function()
					self.BindedEffectInstance.Parent = self.instance;
					self.BindedEffectInstance.Position = UDim2.new(0, mouse.X - self.instance.AbsolutePosition.X, 0, mouse.Y - self.instance.AbsolutePosition.Y);
					self.BindedEffectInstance.Size = UDim2.new(0, (self.instance.AbsoluteSize.X), 0, (self.instance.AbsoluteSize.X));
					self.BindedEffectInstance.Transparency = RoUI.Settings.Defaults.EffectTransparency or 0.5;

					local finalGoal = {};
					finalGoal.Size = UDim2.new(0, 1, 0, 1);
					finalGoal.Transparency = 1;

					local tween = game:GetService("TweenService"):Create(self.BindedEffectInstance, TweenInfo.new(RoUI.Settings.Defaults.ClickEffectSpeed or 1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), finalGoal);
					tween:Play();
				end)();
			end)
		end
	end
end

function RoUIInstance.SetHoverColor(self, color)
	assert(self and color, "Must provide RoUI Instance and Color3.");
	assert(self.instance:IsA("GuiButton"), "RoUI Instance must be of type GuiButton.");
	
	self.instance.AutoButtonColor = false;
	local originalColor = self.instance.BackgroundColor3;
	
	if self.MouseEnterEvent then
		self.MouseEnterEvent:Disconnect();
	end
	
	if self.MouseLeaveEvent then
		self.MouseLeaveEvent:Disconnect();
	end
	
	self.MouseEnterEvent = self.instance.MouseEnter:Connect(function()
		self.instance.BackgroundColor3 = color;
	end)
	self.MouseLeaveEvent = self.instance.MouseLeave:Connect(function()
		self.instance.BackgroundColor3 = originalColor;
	end)
end

function RoUIInstance.SetPressedColor(self, color)
	assert(self and color, "Must provide RoUI Instance and Color3.");
	assert(self.instance:IsA("GuiButton"), "RoUI Instance must be of type GuiButton.");
	
	self.instance.AutoButtonColor = false;
	local originalColor = self.instance.BackgroundColor3;
	
	if self.MouseDownEvent then
		self.MouseDownEvent:Disconnect();
	end
	
	if self.MouseUpEvent then
		self.MouseUpEvent:Disconnect();
	end
	
	self.MouseDownEvent = self.instance.MouseButton1Down:Connect(function()
		self.instance.BackgroundColor3 = color;
	end)
	self.MouseUpEvent = self.instance.MouseButton1Up:Connect(function()
		self.instance.BackgroundColor3 = originalColor;
	end)
end

function RoUIInstance.PlayEffect(self, effect)
	assert(self and effect, "Must provide RoUI Instance and effect.");
	assert(typeof(effect) == "number", "Effect must be of type number.");
	assert(self.instance:IsA("GuiObject"), "RoUI Instance must be of type GuiObject.");
	
	if effect == RoUI.GENERAL_EFFECTS.GROW_SHRINK then
		coroutine.wrap(function()
			local finalGoal = {};
			finalGoal.Size = UDim2.new(self.instance.Size.X.Scale, self.instance.Size.X.Offset * 1.10, self.instance.Size.Y.Scale, self.instance.Size.Y.Offset * 1.10);
			
			local tween = game:GetService("TweenService"):Create(self.instance, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), finalGoal);
			tween:Play();
			tween.Completed:Connect(function()
				finalGoal = {};
				finalGoal.Size = UDim2.new(0, 0, 0, 0);

				tween = game:GetService("TweenService"):Create(self.instance, TweenInfo.new(0.75, Enum.EasingStyle.Back, Enum.EasingDirection.InOut), finalGoal);
				tween:Play();
			end)
			
		end)();
	end
end

function RoUIInstance.TweenTrans(self, endT, speed)
	assert(self, "Must provide RoUI Instance.");
	assert(self.instance:IsA("GuiObject"), "RoUI Instance must be of type GuiObject.");
	
	local finalGoal = {};
	if not endT then
		if self.instance.Transparency >= 0.6 then
			finalGoal.Transparency = 0;
		else
			finalGoal.Transparency = 1;
		end
	else
		finalGoal.Transparency = endT;
	end
	
	local tween = game:GetService("TweenService"):Create(self.instance, TweenInfo.new(speed or RoUI.Settings.Defaults.TweenTransparencySpeed, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), finalGoal);
	tween:Play();
end

-----// RoUI Properties //------
RoUI.DIRECTIONS = {
	LEFT = Vector2.new(-1, 0);
	UP = Vector2.new(0, 1);
	RIGHT = Vector2.new(1, 0);
	DOWN = Vector2.new(0, -1);
}

RoUI.CLICK_EFFECTS = {
	RADIAL = {
		GROW = 0;
		SHRINK = 1;
	}
}

RoUI.GENERAL_EFFECTS = {
	GROW_SHRINK = 0;
}

RoUI.Settings = {
	Defaults = {
		EasingDirection = Enum.EasingDirection.InOut;
		EasingStyle = Enum.EasingStyle.Quad;
		ClickEffectSpeed = 0.5;
		ClickEffectTransparency = 0.25;
		TweenTransparencySpeed = 0.5;
	}
}

return setmetatable({}, RoUI);
