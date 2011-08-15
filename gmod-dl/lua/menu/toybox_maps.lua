/*__                                       _     
 / _| __ _  ___ ___ _ __  _   _ _ __   ___| |__  
| |_ / _` |/ __/ _ \ '_ \| | | | '_ \ / __| '_ \ 
|  _| (_| | (_|  __/ |_) | |_| | | | | (__| | | |
|_|  \__,_|\___\___| .__/ \__,_|_| |_|\___|_| |_|
                   |_| 2010 */

local PANEL = {}


function PANEL:Init()

	self.HTMLControls = vgui.Create( "DHTMLControls", self );
	self.HTMLControls:Dock( TOP )
	
end

function PANEL:Paint()

	if ( !self.Started ) then
		
		self.Started = true;
		
		self.HTML = vgui.Create( "HTML", self )
		self.HTML:Dock( FILL )
		self.HTML:OpenURL( "http://toybox.garrysmod.com/IG/maps/" );
		
		self.HTMLControls:SetHTML( self.HTML )
		
		self:InvalidateLayout()
		
	end

end

vgui.Register( "ToyboxMap", PANEL, "DPanel" )
