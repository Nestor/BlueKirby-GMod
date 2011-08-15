include('shared.lua')

function SWEP:DrawHUD()

	if(ScopeLevel > 0) then
			local ScW, ScH, ScopeId
	
			ScW = surface.ScreenWidth()
			ScH = surface.ScreenHeight()
			
	
			ScopeId = surface.GetTextureID("weapons/scopes/scope2")
			surface.SetTexture(ScopeId)
		
			QuadTable = {}
			
			QuadTable.texture 	= ScopeId
			QuadTable.color		= Color( 0, 0, 0, 0 )
			
			QuadTable.x = 0
			QuadTable.y = 0
			QuadTable.w = ScW
			QuadTable.h = ScH	
			draw.TexturedQuad( QuadTable )
	end
		
end