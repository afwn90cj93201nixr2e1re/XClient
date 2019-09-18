require "utils"

function FindPlayerEntity(Expression) -- Expression(I) -> bool
	for I = 0, Client.GetEntitiesCount() - 1 do
		if (I ~= Client.GetIndex() + 1) then
			if Client.IsEntityActive(I) then
				if Client.IsPlayerIndex(I) then
					if not Expression then
						return Client.GetEntity(I)
					elseif Expression(I) then
						return Client.GetEntity(I)
					end
				end
			end
		end
	end
	return nil
end

function Move()
	local player = FindPlayerEntity()
	
	if player == nil then
		return
	end
	
	local origin = Vec3.New(player.origin)

	LookAt(origin)

	if IsVisible(origin) then
		print("visible")
	else
		print("not visible")
	end
	
	local distance = GetDistance(origin)

	if distance > 200 then
		MoveTo(origin)
	elseif distance < 150 then
		MoveFrom(origin)
	end
end