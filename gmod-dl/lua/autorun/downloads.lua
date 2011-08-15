if SERVER then
	AddCSLuaFile("autorun/client/npc_health.lua")
	AddCSLuaFile("autorun/client/cc.lua")
	resource.AddFile("sound/bwmusic/the_suns_gone_dim.mp3")
	resource.AddFile("sound/bwmusic/vs_marx.mp3")
	else
	include("autorun/client/npc_health.lua")
end