if SERVER then
	return
end


local ply = LocalPlayer()

function ShowNPCHealth()
	local target = ply:GetEyeTrace().Entity
	if !target:IsWorld() and target:IsNPC() then
		print(Target:Health())
	end
end

hook.Add( "Think", "ShowNPCHealthQueer", ShowNPCHealth)