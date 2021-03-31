--[[

	Built-In Shake Effect
	
	This effect will rotate an instance back and forth
	to create the appearance of it shaking.

]]

Settings = {
	AmountOfShakes = 4,
	RotationIncrement = 8,
	EasingStyle = Enum.EasingStyle.Sine,
	EasingDirection = Enum.EasingDirection.Out,
	ShakeSpeed = 0.25
}

return function(inst)
	local posRotate = false;
	local finalGoal = {};
	local originalRotation = inst.Rotation;
	
	for i = 1, Settings.AmountOfShakes - 1, 1 do
		finalGoal.Rotation = originalRotation + ((posRotate and Settings.RotationIncrement) or -(Settings.RotationIncrement));
		posRotate = not posRotate;
		
		local twn = game:GetService("TweenService"):Create(inst, TweenInfo.new(Settings.ShakeSpeed, Settings.EasingStyle, Settings.EasingDirection), finalGoal);
		twn:Play();
		twn.Completed:Wait();
	end
	
	finalGoal.Rotation = originalRotation;
	
	local twn = game:GetService("TweenService"):Create(inst, TweenInfo.new(Settings.ShakeSpeed, Settings.EasingStyle, Settings.EasingDirection), finalGoal);
	twn:Play();
	
	return twn;
end
