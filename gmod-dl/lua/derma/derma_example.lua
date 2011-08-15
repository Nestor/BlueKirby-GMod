/*   _                                
    ( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 

*/

local PANEL = {}

function PANEL:Init()

	self:SetTitle( "Derma Initiative Control Test" )
	self.ContentPanel = vgui.Create( "DPropertySheet", self )
	
	self:InvalidateLayout( true )
	local w, h = self:GetSize()
	
	local Controls = table.Copy( derma.GetControlList() )
		
	for id, ctrl in pairs( Controls ) do
	
		local Ctrls = _G[ ctrl.ClassName ]
		if ( Ctrls && Ctrls.GenerateExample ) then
		
			Ctrls:GenerateExample( ctrl.ClassName, self.ContentPanel, w, h )
		
		end
	
	end
	

end


function PANEL:PerformLayout()

	self:SetSize( 600, 450 )
	
	self.ContentPanel:StretchToParent( 4, 24, 4, 4 )
	
	DFrame.PerformLayout( self )

end


local vguiExampleWindow = vgui.RegisterTable( PANEL, "DFrame" )





//
// This is all to open the actual window via concommand
//
local DermaExample = nil

local function OpenTestWindow()

	if ( DermaExample && DermaExample:IsValid() ) then return end
	
	DermaExample = vgui.CreateFromTable( vguiExampleWindow )
	DermaExample:MakePopup()
	DermaExample:Center()

end

concommand.Add( "derma_controls", OpenTestWindow )

