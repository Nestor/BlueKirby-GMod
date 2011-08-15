//=============================================================================//
//  ___  ___   _   _   _    __   _   ___ ___ __ __
// |_ _|| __| / \ | \_/ |  / _| / \ | o \ o \\ V /
//  | | | _| | o || \_/ | ( |_n| o ||   /   / \ / 
//  |_| |___||_n_||_| |_|  \__/|_n_||_|\\_|\\ |_|  2010
//										 
//=============================================================================//


local PANEL = {}

/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:Init()

end

function PANEL:ShowURL( url )

	if ( url == "" ) then return end
	if ( self.LoadedURL == url ) then return end
	if ( IsValid( self.HTML ) ) then self.HTML:Remove() end

	self.HTML = vgui.Create( "HTML", self )
	self.HTML:Dock( FILL )
	self.HTML:OpenURL( url )
	
	self:InvalidateLayout()
	
	self.LoadedURL = url

end

/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:PerformLayout()

	self:SetSize( ScrW() + 24, ScrH() )
	
end


/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:Paint()

	surface.SetDrawColor( 230, 230, 230, 255 )
	surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )
	
end


/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:StatusChanged( strStatus )

	if ( string.find( strStatus, "Downloading " ) ) then
	
		local Filename = string.gsub( strStatus, "Downloading ", "" )
		Filename = string.gsub( Filename, "'", "\'" )
		self.HTML:RunJavascript( "DownloadingFile( '" .. Filename .. "' )" );
	
	return end
	
	strStatus = string.gsub( strStatus, "'", "\'" )
	self.HTML:RunJavascript( "SetStatusChanged( '" .. strStatus .. "' )" );
	
end

/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:CheckForStatusChanges()

	local str = GetLoadStatus()
	if ( !str ) then return end
	
	str = string.Trim( str )
	str = string.Trim( str, "\n" )
	str = string.Trim( str, "\t" )
	
	str = string.gsub( str, ".bz2", "" )
	str = string.gsub( str, ".ztmp", "" )
	str = string.gsub( str, "\\", "/" )
	
	if ( self.OldStatus && self.OldStatus == str ) then return end
	
	self.OldStatus = str
	self:StatusChanged( str )

end


/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:OnActivate()

	self.NumDownloadables = 0;
	
end

/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:OnDeactivate()

	// We wipe it here incase the HTML panel is playing music.. 
	// It would be nice to keep it open so we don't have to continually refresh
	// but that ain't happening.

	if ( IsValid( self.HTML ) ) then self.HTML:Remove() end
	self.LoadedURL = nil
	self.NumDownloadables = 0;
	
end

/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:Think()

	self:ShowURL( GetLoadingURL() )
	
	self:CheckForStatusChanges()
	self:CheckDownloadTables()
	
end

/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:RefreshDownloadables()

	self.Downloadables = GetDownloadables()
	if ( !self.Downloadables ) then return end
	
	local iDownloading = 0
	local iFileCount = 0
	for k, v in pairs( self.Downloadables ) do
	
		v = string.gsub( v, ".bz2", "" )
		v = string.gsub( v, ".ztmp", "" )
		v = string.gsub( v, "\\", "/" )
	
		iDownloading = iDownloading + self:FileNeedsDownload( v )
		iFileCount = iFileCount + 1

	end
	
	if ( iDownloading == 0 ) then return end
	
	self.HTML:RunJavascript( "SetFilesNeeded( " .. iDownloading .. ")" );
	self.HTML:RunJavascript( "SetFilesTotal( " .. iFileCount .. ")" );

end

function PANEL:FileNeedsDownload( filename )

	local iReturn = 0
	local bExists = file.Exists( filename, true )
	if ( bExists ) then	return 0 end
	
	return 1
	
end

/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:CheckDownloadTables()

	local NumDownloadables = NumDownloadables()
	if ( !NumDownloadables ) then return end
	
	if ( self.NumDownloadables && NumDownloadables == self.NumDownloadables ) then return end
		
	self.NumDownloadables = NumDownloadables
	self:RefreshDownloadables()
	
end

local PanelType_Loading = vgui.RegisterTable( PANEL, "EditablePanel" )

local pnlLoading = nil

function GetLoadPanel()

	if ( !pnlLoading ) then
		pnlLoading = vgui.CreateFromTable( PanelType_Loading )
	end

	return pnlLoading
	
end



