local function PlayClientSound(ply, args)
	RunConsoleCommand("stopsound")
	surface.PlaySound(args[1])
end


concommand.Add("playsound", PlayClientSound)