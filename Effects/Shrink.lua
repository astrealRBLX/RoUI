--[[

	Built-In Shtink Effect
	
	This effect will smoothly shrink an
	instance a certain %.

]]

Settings = {
	ShrinkPercent = 10,
	ShrinkSpeed = 0.5,
	EasingStyle = Enum.EasingStyle.Back,
	EasingDir = Enum.EasingDirection.Out
}

return function(inst)
	local finalGoal = {};
	
	finalGoal.Size = UDim2.new(inst.Size.X.Scale, inst.Size.X.Offset - (inst.AbsoluteSize.X * (Settings.ShrinkPercent / 100)), inst.Size.Y.Scale, inst.Size.Y.Offset - (inst.AbsoluteSize.Y * (Settings.ShrinkPercent / 100)));
	
	local twn = game:GetService("TweenService"):Create(inst, TweenInfo.new(Settings.ShrinkSpeed, Settings.EasingStyle, Settings.EasingDir), finalGoal);
	twn:Play();
	
	return twn;
end
