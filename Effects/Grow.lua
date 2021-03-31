--[[

	Built-In Grow Effect
	
	This effect will smoothly grow an
	instance a certain %.

]]

Settings = {
	GrowPercent = 10,
	GrowSpeed = 0.5,
	EasingStyle = Enum.EasingStyle.Back,
	EasingDir = Enum.EasingDirection.Out
}

return function(inst)
	local finalGoal = {};
	
	finalGoal.Size = UDim2.new(inst.Size.X.Scale, inst.Size.X.Offset + (inst.AbsoluteSize.X * (Settings.GrowPercent / 100)), inst.Size.Y.Scale, inst.Size.Y.Offset + (inst.AbsoluteSize.Y * (Settings.GrowPercent / 100)));
	
	local twn = game:GetService("TweenService"):Create(inst, TweenInfo.new(Settings.GrowSpeed, Settings.EasingStyle, Settings.EasingDir), finalGoal);
	twn:Play();
	
	return twn;
end
