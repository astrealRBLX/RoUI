--[[

	RoUI by AstrealDev
	
	Create UI effects simply and efficiently.
	GitHub: https://github.com/impRBLX/RoUI
	v1.2

]]

-----// Private Variables //-----
local RoUI = {};
local RoUIClass = {};
local RoUIObjectClass = {};
local RoUIBuiltInEffects = {};

-----// Private Functions //-----
local function CreateUIObjectInstance(obj)
	if not obj:IsA("GuiObject") then return end

	local meta = {};
	meta.__index = meta;

	for key, value in pairs(RoUIObjectClass) do
		meta[key] = value;
	end

	local this = setmetatable({}, meta);

	this.Type = "UIObject";
	this.Instance = obj;
	this.EventConnections = {};

	if obj:IsA("GuiButton") then
		this.Type = "UIButton";
	end
	
	return this;
end

local function CreateUIEffect(effectName, func)
	local meta = {};
	meta.__index = meta;
	meta.__call = function(_, ...)
		coroutine.wrap(func)(...);
	end
	
	local this = setmetatable({}, meta);
	
	this.Name = effectName;
	this.Type = "UIEffect";
	this.Function = func;
	
	return this;
end

-----// RoUI Metamethods //-----
RoUI.__index = RoUI;
function RoUI.__call(self, ...)
	return RoUI.new(...);
end

-----// RoUI Constructor //-----
function RoUI.new(graphicalObjects)
	
	local meta = {};
	meta.__index = meta;
	
	for key, value in pairs(RoUIClass) do
		meta[key] = value;
	end
	
	local self = setmetatable({}, meta);
	
	self.UIObjects = {};
	self.UIEffects = {};
	
	for _, obj in pairs(graphicalObjects) do
		if obj:IsA("GuiObject") then
			local this = CreateUIObjectInstance(obj);
			table.insert(self.UIObjects, this);
			this.Instance.AncestryChanged:Connect(function()
				if not this.Instance:IsDescendantOf(game) then
					table.remove(self.UIObjects, table.find(self.UIObjects, this));
				end
			end)
		end
	end
	
	for effName, effObj in pairs(RoUIBuiltInEffects) do
		self.UIEffects[effName] = effObj;
	end
	
	return self, unpack(self.UIObjects);
end

-----// Accessible RoUI Methods //-----
function RoUIClass.InsertObject(self, obj)
	local this = CreateUIObjectInstance(obj);
	table.insert(self.UIObjects, this);
	this.Instance.AncestryChanged:Connect(function()
		if not this.Instance:IsDescendantOf(game) then
			table.remove(self.UIObjects, table.find(self.UIObjects, this));
		end
	end)
end

function RoUIClass.RemoveObject(self, obj)
	for index, inst in pairs(self.UIObjects) do
		if inst.Instance == obj then
			table.remove(self.UIObjects, index);
			break;
		end
	end
end

function RoUIClass.GetUIObjectFromInstance(self, inst)
	for key, value in pairs(self.UIObjects) do
		if value.Instance == inst then
			return value;
		end
	end
	
	return nil;
end

function RoUIClass.Show(self)
	for _, value in pairs(self.UIObjects) do
		value.Instance.Visible = true;
	end
end

function RoUIClass.Hide(self)
	for _, value in pairs(self.UIObjects) do
		value.Instance.Visible = false;
	end
end

function RoUIClass.Visibility(self, bool)
	for _, value in pairs(self.UIObjects) do
		value.Instance.Visible = bool or (not value.Instance.Visible);
	end
end

function RoUIClass.CreateEffect(self, effName, handlerFunc)
	self.UIEffects[effName] = CreateUIEffect(effName, handlerFunc);
	return self.UIEffects[effName];
end

function RoUIClass.GetEffect(self, effName)
	return self.UIEffects[effName];
end

function RoUIClass.BindEffectToButtons(self, effect, event, callback)
	local allBindedConnections = {};
	for _, obj in pairs(self.UIObjects) do
		if obj.Type ~= "UIButton" then continue end
		local _con = obj.Instance[event]:Connect(function(...)
			effect(obj.Instance);
			if callback then coroutine.wrap(callback)(obj.Instance, ...) end;
		end)
		obj.EventConnections[event] = _con;
		table.insert(allBindedConnections, _con);
	end
	return allBindedConnections;
end

function RoUIClass.BindEffect(self, objectAffected, eventObject, effect, event, callback)
	local _con = eventObject[event]:Connect(function(...)
		effect(objectAffected.Instance);
		if callback then coroutine.wrap(callback)(objectAffected.Instance, ...) end;
	end)
	objectAffected.EventConnections[event] = _con;
	return _con;
end

function RoUIClass.UnbindEffectFromButtons(self, event)
	for _, obj in pairs(self.UIObjects) do
		if obj.Type ~= "UIButton" then continue end
		for evName, evVal in pairs(obj.EventConnections) do
			if evName == event then
				evVal:Disconnect();
				evVal = nil;
			end
		end
	end
end

function RoUIClass.UnbindEffect(self, objectAffected, event)
	for evName, evVal in pairs(objectAffected.EventConnections) do
		if evName == event then
			evVal:Disconnect();
			evVal = nil;
		end
	end
end

-----// Acessible RoUI Object Methods //-----
function RoUIObjectClass.Show(self)
	self.Instance.Visible = true;
end

function RoUIObjectClass.Hide(self)
	self.Instance.Visible = false;
end

function RoUIObjectClass.Visibility(self, bool)
	self.Instance.Visible = bool or (not self.Instance.Visible);
end

function RoUIObjectClass.PlayEffect(self, effect)
	effect(self.Instance);
end

-----// Load Built-In Effects //-----
if script:FindFirstChild("Built-In Effects") then
	for _, source in pairs(script:FindFirstChild("Built-In Effects"):GetChildren()) do
		if not source:IsA("ModuleScript") then continue end
		
		local newSource = require(source);
		RoUIBuiltInEffects["!" .. source.Name] = CreateUIEffect("RadialGrow", newSource);
	end
end

return setmetatable({}, RoUI);
