
if SERVER then
	return
end

local text1 = "Health: "
local alpha = 0
local ply = LocalPlayer()

function ShowNPCHealth( )
	local Target = LocalPlayer():GetEyeTrace().Entity
	if LocalPlayer():Alive() and LocalPlayer():GetActiveWeapon():IsValid() and Target != nil and Target:IsNPC() then
		text1 = ("Health: ")
		alpha = 255
	else
		alpha = 0
	end
end

hook.Add( "Think", "ShowNPCHealthQueer", ShowNPCHealth)
hook.Add( "HUDPaint", "ShowNPCHealthQueer2", function()
	draw.DrawText( text1, "MenuLarge", (ScrW() / 2), (ScrH() - (ScrH() / 10)), Color( 255, 255, 255, alpha1 ), 1 )
	draw.DrawText( tostring(WarmUpTimeA), "MenuLarge", (ScrW() / 2), (ScrH() / 2 - (ScrH() / 2)), Color( 255, 255, 255, 255 ), 1	)
end )


local function ColoredPeePee( )
	if 90 <= render.GetDXLevel() then
		RunConsoleCommand("pp_colormod", 1)
		RunConsoleCommand("pp_colormod_brightness", -0.19)
		RunConsoleCommand("pp_colormod_contrast", 1.58)
		RunConsoleCommand("pp_colormod_addr", 1)
		RunConsoleCommand("pp_colormod_addg", 3)
		RunConsoleCommand("pp_colormod_addb", 3)
		RunConsoleCommand("pp_colormod_mulr", 0)
		RunConsoleCommand("pp_colormod_mulg", 1)
		RunConsoleCommand("pp_colormod_mulb", 4)
	else
		RunConsoleCommand("pp_colormod", 0)
	end
end
hook.Add( "RenderScreenspaceEffects", "BetterColorPeePee", ColoredPeePee )