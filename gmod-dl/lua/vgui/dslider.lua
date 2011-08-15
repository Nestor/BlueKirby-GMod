/*   _                                
    ( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 

	DSlider

*/
local PANEL = {}

AccessorFunc( PANEL, "NumSlider", 		"NumSlider" )

AccessorFunc( PANEL, "m_fSlideX", 		"SlideX" )
AccessorFunc( PANEL, "m_fSlideY", 		"SlideY" )

AccessorFunc( PANEL, "m_iLockX", 		"LockX" )
AccessorFunc( PANEL, "m_iLockY", 		"LockY" )

AccessorFunc( PANEL, "Dragging", 			"Dragging" )
AccessorFunc( PANEL, "m_bTrappedInside", 	"TrapInside" )


Derma_Hook( PANEL, "Paint", "Paint", "Slider" )
Derma_Hook( PANEL, "ApplySchemeSettings", "Scheme", "Slider" )
Derma_Hook( PANEL, "PerformLayout", "Layout", "Slider" )

/*---------------------------------------------------------
	
---------------------------------------------------------*/
function PANEL:Init()

	self:SetMouseInputEnabled( true )
	
	self:SetSlideX( 0.5 )
	self:SetSlideY( 0.5 )
	
	self.Knob = vgui.Create( "DImage", self )
	self:SetImage( "gui/silkicons/add" )
	self.Knob:NoClipping( true )

end

/*---------------------------------------------------------
	
---------------------------------------------------------*/
function PANEL:SetBackground( img )

	if ( !self.BGImage ) then
		self.BGImage = vgui.Create( "DImage", self )
	end
	
	self.BGImage:SetImage( img )
	self:InvalidateLayout()

end


/*---------------------------------------------------------
	
---------------------------------------------------------*/
function PANEL:SetImage( strImage )

	self.Knob:SetImage( strImage )
	self.Knob:SizeToContents()

end

/*---------------------------------------------------------
	
---------------------------------------------------------*/
function PANEL:SetImageColor( color )

	self.BGImage:SetImageColor( color )

end

/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:OnCursorMoved( x, y )

	if ( !self.Dragging ) then return end
	
	local w, h = self:GetSize()
	local iw, ih = self.Knob:GetSize()
	
	if ( self.m_bTrappedInside ) then
	
		w = w - iw
		h = h - ih
		
		x = x - iw * 0.5
		y = y - ih * 0.5
	
	end
	
	x = math.Clamp( x, 0, w ) / w
	y = math.Clamp( y, 0, h ) / h
	
	if ( self.m_iLockX ) then x = self.m_iLockX end
	if ( self.m_iLockY ) then y = self.m_iLockY end
	
	x, y = self:TranslateValues( x, y )
	
	self:SetSlideX( x )
	self:SetSlideY( y )
	
	self:InvalidateLayout()
	
end

/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:TranslateValues( x, y )

	// Give children the chance to manipulate the values..
	return x, y

end

/*---------------------------------------------------------
	
---------------------------------------------------------*/
function PANEL:OnMousePressed( mcode )

	self:SetDragging( true )
	self:MouseCapture( true )
	
	local x, y = self:CursorPos()
	self:OnCursorMoved( x, y )
	
end

/*---------------------------------------------------------
	
---------------------------------------------------------*/
function PANEL:OnMouseReleased( mcode )

	self:SetDragging( false )
	self:MouseCapture( false )

end

/*---------------------------------------------------------
	
---------------------------------------------------------*/
function PANEL:PerformLayout()

	local w, h = self:GetSize()
	local iw, ih = self.Knob:GetSize()
	
	if ( self.m_bTrappedInside ) then
	
		w = w - iw;
		h = h - ih;
		self.Knob:SetPos( (self.m_fSlideX or 0) * w, (self.m_fSlideY or 0) * h )
	
	else
	
		self.Knob:SetPos( (self.m_fSlideX or 0) * w - iw * 0.5, (self.m_fSlideY or 0) * h - ih * 0.5 )
	
	end
	
	if ( self.BGImage ) then
		self.BGImage:StretchToParent(0,0,0,0)
		self.BGImage:SetZPos( -10 )
	end

end

/*---------------------------------------------------------
	
---------------------------------------------------------*/
function PANEL:SetSlideX( i )
	self.m_fSlideX = i
	self:InvalidateLayout()
end

/*---------------------------------------------------------
	
---------------------------------------------------------*/
function PANEL:SetSlideY( i )
	self.m_fSlideY = i
	self:InvalidateLayout()
end


derma.DefineControl( "DSlider", "", PANEL, "Panel" )