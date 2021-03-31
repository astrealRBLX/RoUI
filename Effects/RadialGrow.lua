--[[

	Built-In RadialGrow Effect
	
	This effect will create a circle as
	a descendant of an object and
	infinitely grow it until a certain point.
	
]]

Settings = {
	CircleColor = Color3.fromRGB(255, 255, 255),
	CircleTrans = 0.5,
	CircleSpeed = 0.5,
	CircleEasingStyle = Enum.EasingStyle.Sine,
	CircleEasingDirection = Enum.EasingDirection.Out
}

return function(inst)
	local circle = Instance.new("Frame");
	Instance.new("UICorner", circle);
	circle.UICorner.CornerRadius = UDim.new(1, 0);
	circle.AnchorPoint = Vector2.new(0.5, 0.5);
	circle.BackgroundColor3 = Settings.CircleColor;
	inst.ClipsDescendants = true;
	circle.Parent = inst;
	circle.Position = UDim2.new(0, game.Players.LocalPlayer:GetMouse().X - inst.AbsolutePosition.X, 0, game.Players.LocalPlayer:GetMouse().Y - inst.AbsolutePosition.Y);
	circle.Size = UDim2.new(0, 1, 0, 1);
	circle.Transparency = Settings.CircleTrans;

	local finalGoal = {};
	finalGoal.Size = UDim2.new(0, (inst.AbsoluteSize.X), 0, (inst.AbsoluteSize.X));
	finalGoal.Transparency = 1;

	local tween = game:GetService("TweenService"):Create(circle, TweenInfo.new(Settings.CircleSpeed, Settings.CircleEasingStyle, Settings.CircleEasingDirection), finalGoal);
	tween:Play();
	
	return tween;
end
