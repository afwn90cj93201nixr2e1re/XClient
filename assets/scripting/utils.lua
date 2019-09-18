require "vec3"

function VectorAngles(Forward)
	if Forward.X == 0 and Forward.Y == 0 then
		if Forward.Z > 0 then
			return Vec3.New(90, 0, 0)
		else
			return Vec3.New(270, 0, 0)
		end
	else
		local yaw = math.deg(math.atan(Forward.Y, Forward.X))

		if yaw < 0 then
			yaw = yaw + 360.0
		end

		local tmp = math.sqrt((Forward.X ^ 2) + (Forward.Y ^ 2))
		local pitch = math.deg(math.atan(Forward.Z, tmp))

		if pitch < 0 then
			pitch = pitch + 360.0
		end

		return Vec3.New(pitch, yaw, 0)
	end
end

function GetDistance(Target)
	local origin = Vec3.New(Client.GetOrigin())
	return origin:GetDistance(Target)
end

function IsVisible(Target, Origin)
	local o = Origin

	if o == nil then
		o = Vec3.New(Client.GetOrigin())
	end

	local trace = Client.TraceLine(o, Target)

	return trace.Fraction >= 1.0;
end