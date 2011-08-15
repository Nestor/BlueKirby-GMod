/*   _                                
    ( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 

	DImage

*/

PANEL = {}

AccessorFunc( PANEL, "m_Material", 				"Material" )
AccessorFunc( PANEL, "m_Color", 				"ImageColor" )
AccessorFunc( PANEL, "m_bKeepAspect", 			"KeepAspect" )
AccessorFunc( PANEL, "m_strMatName", 			"MatName" )
AccessorFunc( PANEL, "m_strMatNameFailsafe", 	"FailsafeMatName" )

/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:Init()

	self:SetImageColor( Color( 255, 255, 255, 255 ) )
	self:SetMouseInputEnabled( false )
	self:SetKeyboardInputEnabled( false )
	
	self:SetKeepAspect( false )
	
	self.ImageName = ""
	
end

/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:SetOnViewMaterial( MatName, MatNameBackup )

	self:SetMatName( MatName )
	self:SetFailsafeMatName( MatNameBackup )

end


/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:Unloaded()
	return self.m_strMatName != nil
end

local g_ImageLoadTime = 0

/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:LoadMaterial()

	if ( !self:Unloaded() ) then return end
	if ( g_ImageLoadTime > SysTime() ) then return end
	
	local mat, loadtime = Material( self:GetMatName() )
	self:SetMaterial( mat )
	self:SetMatName( nil )
	
	// This crude shit is trying to work out whether the material was loaded
	// from disk or whether it was already loaded and we just got a pointer to it..
	// Because we don't want to space the frames out if we just got a pointer
	if ( loadtime < 0.01 ) then loadtime = 0 end
	g_ImageLoadTime = SysTime() + loadtime * 0.1
	
	if ( self.m_Material:IsError() && self:GetFailsafeMatName()  ) then
		self:SetMaterial( Material( self:GetFailsafeMatName() ) )
	end
	
	self:FixVertexLitMaterial()

end


/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:SetMaterial( Mat )

	// Everybody makes mistakes, 
	// that's why they put erasers on pencils.
	if ( type( Mat ) == "string" ) then
		self:SetImage( Mat )
	return end

	self.m_Material = Mat
	
	if (!self.m_Material) then return end
	
	local Texture = self.m_Material:GetMaterialTexture( "$basetexture" )
	if ( Texture ) then
		self.ActualWidth = Texture:GetActualWidth()
		self.ActualHeight = Texture:GetActualHeight()
	else
		self.ActualWidth = 32
		self.ActualHeight = 32
	end

end


/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:SetImage( strImage, strBackup )

	if ( strBackup && !file.Exists( "materials/"..strImage..".vmt", true ) ) then
		strImage = strBackup
	end

	self.ImageName = strImage

	local Mat = Material( strImage )
	self:SetMaterial( Mat )
	self:FixVertexLitMaterial()
	
end

function PANEL:FixVertexLitMaterial()
	
	//
	// If it's a vertexlitgeneric material we need to change it to be
	// UnlitGeneric so it doesn't go dark when we enter a dark room
	// and flicker all about
	//
	
	local Mat = self:GetMaterial()
	local strImage = Mat:GetName()
	
	if ( string.find( Mat:GetShader(), "VertexLitGeneric" ) || string.find( Mat:GetShader(), "Cable" ) ) then
	
		local t = Mat:GetMaterialString( "$basetexture" )
		
		if ( t ) then
		
			local params = {}
			params[ "$basetexture" ] = t
			params[ "$vertexcolor" ] = 1
			params[ "$vertexalpha" ] = 1
			
			Mat = CreateMaterial( strImage .. "_DImage", "UnlitGeneric", params )
		
		end
		
	end
	
	self:SetMaterial( Mat )
	
end


/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:GetImage()

	return self.ImageName
	
end

/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:SizeToContents( strImage )

	self:SetSize( self.ActualWidth, self.ActualHeight )

end


/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:Paint()

	self:LoadMaterial()

	local Mat = self:GetMaterial()
	if (!Mat) then return true end

	surface.SetMaterial( Mat )
	surface.SetDrawColor( self.m_Color.r, self.m_Color.g, self.m_Color.b, self.m_Color.a )
	
	if ( self:GetKeepAspect() ) then
	
		local w = self.ActualWidth
		local h = self.ActualHeight
		
		// Image is bigger than panel, shrink to suitable size
		if ( w > self:GetWide() && h > self:GetTall() ) then
		
			if ( w > self:GetWide() ) then
			
				local diff = self:GetWide() / w
				w = w * diff
				h = h * diff
			
			end
			
			if ( h > self:GetTall() ) then
			
				local diff = self:GetTall() / h
				w = w * diff
				h = h * diff
			
			end

		end
		
		if ( w < self:GetWide() ) then
		
			local diff = self:GetWide() / w
			w = w * diff
			h = h * diff
		
		end
		
		if ( h < self:GetTall() ) then
		
			local diff = self:GetTall() / h
			w = w * diff
			h = h * diff
		
		end
		

		
		local OffX = (self:GetWide() - w) * 0.5
		local OffY = (self:GetTall() - h) * 0.5
		

	
		surface.DrawTexturedRect( OffX, OffY, w, h )
	
		return true
	
	end
	
	
	surface.DrawTexturedRect( 0, 0, self:GetSize() )
	return true

end

/*---------------------------------------------------------
   Name: GenerateExample
---------------------------------------------------------*/
function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )

	local ctrl = vgui.Create( ClassName )
		ctrl:SetImage( "brick/brick_model" )
		ctrl:SetSize( 200, 200 )
		
	PropertySheet:AddSheet( ClassName, ctrl, nil, true, true )

end

derma.DefineControl( "DImage", "A simple image", PANEL, "DPanel" )
