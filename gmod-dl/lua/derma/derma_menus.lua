/*   _                                
    ( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 

*/

local tblOpenMenus = {}

function RegisterDermaMenuForClose( menu )

	table.insert( tblOpenMenus, menu )

end


function DermaMenu( parentmenu )

	if (!parentmenu) then CloseDermaMenus() end
	
	local menu = vgui.Create( "DMenu" )
	
	return menu

end


function CloseDermaMenus()

	for k, menu in pairs( tblOpenMenus ) do
	
		menu:Remove()
	
	end	
	
	tblOpenMenus = {}

end

//
// Here we detect when the mouse is pressed on another panel
// This allows us to close the menus.
//
local function DermaDetectMenuFocus( panel, mousecode )

	if ( IsValid( panel ) ) then
	
		// Clicking onto a menu shouldn't close all menus..
		if ( panel.ClassName && panel.ClassName == "DMenu" ) then return end

		// Is the parent a menu?
		return DermaDetectMenuFocus( panel:GetParent(), mousecode )
		
	end
	
	CloseDermaMenus()

end



hook.Add( "VGUIMousePressed", "DermaDetectMenuFocus", DermaDetectMenuFocus )
