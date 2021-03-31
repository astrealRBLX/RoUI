--[[

	Built-In GrowShrink Effect
	
	This effect will slightly grow an instance by a %
	of its current size then resize it down to 0.

]]

Settings = {
	SizeIncreasePercent = 10,
	InitialGrowSpeed = 0.5,
	GrowEasingStyle = Enum.EasingStyle.Back,
	GrowEasingDirection = Enum.EasingDirection.Out,
	FinalShrinkSpeed = 0.75,
	ShrinkEasingStyle = Enum.EasingStyle.Back,
	ShrinkEasingDirection = Enum.EasingDirection.InOut
}


return function(inst)
	local finalGoal = {};
	finalGoal.Size = UDim2.new(inst.Size.X.Scale, inst.Size.X.Offset * (1 + (Settings.SizeIncreasePercent / 100)), inst.Size.Y.Scale, inst.Size.Y.Offset * (1 + (Settings.SizeIncreasePercent)));

	local tween = game:GetService("TweenService"):Create(inst, TweenInfo.new(Settings.InitialGrowSpeed, Settings.GrowEasingStyle, Settings.GrowEasingDirection), finalGoal);
	tween:Play();
	
	tween.Completed:Wait();
	
	finalGoal = {};
	finalGoal.Size = UDim2.new(0, 0, 0, 0);

	tween = game:GetService("TweenService"):Create(inst, TweenInfo.new(Settings.FinalShrinkSpeed, Settings.ShrinkEasingStyle, Settings.ShrinkEasingDirection), finalGoal);
	tween:Play();

	return tween;
end
