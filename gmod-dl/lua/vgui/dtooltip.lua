/*   _                                
    ( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 

*/

//
// The delay before a tooltip appears
//
local tooltip_delay = CreateClientConVar( "tooltip_delay", "0", true, false ) 

PANEL = {}


/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:Init()

	self:SetDrawOnTop( true )
	self.DeleteContentsOnClose = false

end

/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:SetContents( panel, bDelete )

	panel:SetParent( self )

	self.Contents = panel
	self.DeleteContentsOnClose = bDelete or false
	
	if ( self.Contents.SetTextColor ) then
		self.Contents:SetTextColor( Color( 0, 0, 0, 240 ) )
		self.Contents:SetFont( "DefaultSmall" )
	end
	
	self.Contents:SizeToContents()
	self:InvalidateLayout( true )
	
	
	self.Contents:SetVisible( false )

end

/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:PerformLayout()

	if ( self.Contents ) then
		self:SetWide( self.Contents:GetWide() + 8 )
		self:SetTall( self.Contents:GetTall() + 8 )
		
		self.Contents:SetPos( 4, 4 )
	end

end

local Mat = Material( "vgui/arrow" )

/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:DrawArrow( x, y )

	if ( self.StartShowingAt && SysTime() < self.StartShowingAt ) then return end

	self.Contents:SetVisible( true )
	
	surface.SetMaterial( Mat )	
	surface.DrawTexturedRect( self.ArrowPosX+x, self.ArrowPosY+y, self.ArrowWide, self.ArrowTall )

end

/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:Paint()

	if ( self.StartShowingAt && SysTime() < self.StartShowingAt ) then return false end

	derma.SkinHook( "Paint", "Tooltip", self )
	return true

end

/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:OpenForPanel( panel )

	local x, y = panel:LocalToScreen( 0, 0 )
	local w, h = panel:GetSize()
	
	self.ArrowTall = 8
	self.ArrowWide = 16
	
	self.Rot = 0

	local ty = y - self:GetTall() - 16
	self.ArrowPosY = self:GetTall()
	if ( ty < 0 ) then
	
		ty = y + h + 16
		self.ArrowPosY = 0
		self.ArrowTall = self.ArrowTall * -1
	
	end
	
	local tx = x + panel:GetWide() * 0.5
	self.ArrowPosX = panel:GetWide() * 0.1
	if ( tx + self:GetWide() > ScrW() ) then
	
		tx = x + panel:GetWide() * 0.5 - self:GetWide()
		self.ArrowPosX = self:GetWide() * 0.9
		self.ArrowWide = self.ArrowWide * -1
	
	end
	
	self:SetPos( tx, ty )
	
	self.StartShowingAt = SysTime() + tooltip_delay:GetFloat()

end

/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:Close()

	if ( !self.DeleteContentsOnClose && self.Contents ) then
	
		self.Contents:SetVisible( false )
		self.Contents:SetParent( nil )
	
	end
	
	self:Remove()

end


derma.DefineControl( "DTooltip", "", PANEL, "Panel" )