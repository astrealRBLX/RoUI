--[[

	Built-In 360 Effect
	
	This effect will rotate an instance 360 degrees
	smoothly.

]]

Settings = {
	RotationDirection = "Left",
	RotationSpeed = 2,
	RotationEaseStyle = Enum.EasingStyle.Sine,
	RotationEaseDir = Enum.EasingDirection.InOut
}

return function(inst)
	local finalGoal = {};
	local originalRotation = inst.Rotation;
	
	if Settings.RotationDirection == "Right" then
		finalGoal.Rotation = originalRotation + 360;
	elseif Settings.RotationDirection == "Left" then
		finalGoal.Rotation = originalRotation - 360;
	end
	
	local twn = game:GetService("TweenService"):Create(inst, TweenInfo.new(Settings.RotationSpeed, Settings.RotationEaseStyle, Settings.RotationEaseDir), finalGoal);
	twn:Play();
	twn.Completed:Wait();
	finalGoal.Rotation = originalRotation;
	
	return twn;
end
