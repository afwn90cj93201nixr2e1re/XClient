require "utils"

function FindPlayer()
	for I = 0, Client.GetEntitiesCount() - 1 do
		if (I ~= Client.GetIndex() + 1) then
			if Client.IsEntityActive(I) then
				if Client.IsPlayerIndex(I) then
					return Client.GetEntity(I)
				end
			end
		end
	end
	return nil
end

function Move()
	local player = FindPlayer()
	
	if player ~= nil then
		local origin = Vec3.New(player.origin)
		
		LookAt(origin)

		local distance = GetDistance(origin)

		if distance > 200 then
			MoveTo(origin)
		else 
			if distance < 150 then
				MoveFrom(origin)
			end
		end
	end
end