/*   _                                
    ( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 

	DColorCircle
	
*/

local PANEL = {}

AccessorFunc( PANEL, "m_Hue", 				"Hue" )
AccessorFunc( PANEL, "m_BaseRGB", 				"BaseRGB" )
AccessorFunc( PANEL, "m_OutRGB", 				"RGB" )

/*---------------------------------------------------------
   Name: Init
---------------------------------------------------------*/
function PANEL:Init()

	self:SetImage( "vgui/minixhair" )
	self.Knob:NoClipping( false )
	
	self.BGSaturation = vgui.Create( "DImage", self )
	self.BGSaturation:SetImage( "vgui/gradient-r" )
	
	self.BGValue = vgui.Create( "DImage", self )
	self.BGValue:SetImage( "vgui/gradient-d" )
	self.BGValue:SetImageColor( Color( 0, 0, 0, 255 ) )
	
	self:SetBaseRGB( Color( 255, 255, 0 ) )
	self:SetRGB( Color( 0, 255, 0, 255 ) )
	self:SetColor( Color( 150, 200, 180, 255 ) )

end

/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:PerformLayout()

	DSlider.PerformLayout( self )
	
	self.BGSaturation:StretchToParent( 0,0,0,0 )
	self.BGSaturation:SetZPos( -9 )
	
	self.BGValue:StretchToParent( 0,0,0,0 )
	self.BGValue:SetZPos( -8 )

end

/*---------------------------------------------------------
   Name: Paint
---------------------------------------------------------*/
function PANEL:Paint()

	surface.SetDrawColor( self.m_BaseRGB.r, self.m_BaseRGB.g, self.m_BaseRGB.b, 255 )
	self:DrawFilledRect()

end

/*---------------------------------------------------------
   Name: Paint
---------------------------------------------------------*/
function PANEL:PaintOver()

	surface.SetDrawColor( 0, 0, 0, 250 )
	self:DrawOutlinedRect()

end

/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:TranslateValues( x, y )

	self:UpdateColor( x, y )
	self:OnUserChanged()
	
	return x, y

end

/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:UpdateColor( x, y )

	x = x or self:GetSlideX()
	y = y or self:GetSlideY()
	
	local value = 1 - y
	local saturation = 1 - x
	local h = ColorToHSV( self.m_BaseRGB )
	
	local color = HSVToColor( h, saturation, value )
	
	self:SetRGB( color )

end

/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:OnUserChanged()

	// Override me

end

/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:SetColor( color )

	local h, s, v = ColorToHSV( color )
	
	self:SetBaseRGB( HSVToColor( h, 1, 1 ) )
	
	self:SetSlideY( 1 - v )
	self:SetSlideX( 1 - s )

end

/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:SetBaseRGB( color )

	self.m_BaseRGB = color
	self:UpdateColor()

end


vgui.Register( "DColorCube", PANEL, "DSlider" )