Vec3 = {}
Vec3.__index = Vec3

function Vec3.New(X, Y, Z)
	local self = setmetatable({}, Vec3)
	if type(X) == "table" then
		self.X = X[1]
		self.Y = X[2]
		self.Z = X[3]
	else
		self.X = X or 0.0
		self.Y = Y or 0.0
		self.Z = Z or 0.0
	end
	return self
end

function Vec3.__eq(A, B)
	return A.X == B.X and A.Y == B.Y and A.Z == B.Z
end

function Vec3.__add(A, B)
	return Vec3.New(A.X + B.X, A.Y + B.Y, A.Z + B.Z)
end

function Vec3.__sub(A, B)
	return Vec3.New(A.X - B.X, A.Y - B.Y, A.Z - B.Z)
end

function Vec3.__mul(A, B) -- maybe wrong
	return Vec3.New(A.X * B.X, A.Y * B.Y, A.Z * B.Z)
end

function Vec3.__div(A, B)
	return Vec3.New(A.X / B.X, A.Y / B.Y, A.Z / B.Z)
end

function Vec3.__unm(A)
	return Vec3.New(-A.X, -A.Y, -A.Z)
end

function Vec3.__tostring(A)
	return("X: " .. A.X .. ", Y: " .. A.Y .. ", Z: " .. A.Z)
end

--[[function Vec3.__index(I)
	return self[I]
end]]

function Vec3:DotProduct(A)
	return ((self.X * A.X) + (self.Y * A.Y) + (self.Z * A.Z))
end

function Vec3:GetLength()
	return math.sqrt(self:DotProduct(self))
end

function Vec3:GetDistance(A)
	return math.abs((A - self):GetLength())
end