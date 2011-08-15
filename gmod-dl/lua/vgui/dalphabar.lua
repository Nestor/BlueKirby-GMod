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
AccessorFunc( PANEL, "m_RGB", 				"RGB" )

/*---------------------------------------------------------
   Name: Init
---------------------------------------------------------*/
function PANEL:Init()

	self:SetBackground( "vgui/gradient-u" )
	self:SetImage( "vgui/v-indicator" )
	
	self.imgBackground = vgui.Create( "DImage", self )
	self.imgBackground:SetImage( "vgui/bg-lines" )
	
	self:SetRGB( Color( 0, 255, 0, 255 ) )
	self:SetColor( Color( 0, 0, 255, 255 ) )
	self:SetLockX( 0.5 )
	self.Knob:NoClipping( false )

end

/*---------------------------------------------------------
	
---------------------------------------------------------*/
function PANEL:SetImageColor( color )

	local color = table.Copy( color )
	color.a = 255
	DSlider.SetImageColor( self, color )

end

/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:PerformLayout()

	DSlider.PerformLayout( self )
	
	self.imgBackground:SetZPos( -15 )
	self.imgBackground:SizeToContents()
	self.imgBackground:Center()

end

/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:TranslateValues( x, y )

	self:OnChange( 255 - (y * 255) )

	return x, y

end

/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:SetColor( color )

	local h, s, v = ColorToHSV( color )
	
	self:SetHue( h )
	self:SetRGB( HSVToColor( self:GetHue(), 1, 1 ) )
	
	self:SetSlideY( h / 360 )

end

/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:OnChange( alpha )

	// Override me

end

/*---------------------------------------------------------
   Name: Paint
---------------------------------------------------------*/
function PANEL:PaintOver()

	surface.SetDrawColor( 0, 0, 0, 250 )
	self:DrawOutlinedRect()

end

vgui.Register( "DAlphaBar", PANEL, "DSlider" )
