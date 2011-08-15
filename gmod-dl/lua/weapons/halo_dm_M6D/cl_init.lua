include('shared.lua')

function SWEP:DrawHUD()
	surface.SetTexture(surface.GetTextureID("VGUI/halohud/crosshair_m6d"))
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( ScrW()/2 - 50, ScrH()/2 - 50, 100, 100 )
end