
/*__                                       _     
 / _| __ _  ___ ___ _ __  _   _ _ __   ___| |__  
| |_ / _` |/ __/ _ \ '_ \| | | | '_ \ / __| '_ \ 
|  _| (_| | (_|  __/ |_) | |_| | | | | (__| | | |
|_|  \__,_|\___\___| .__/ \__,_|_| |_|\___|_| |_|
                   |_| 2010 */
				   
include( "content_vgui.lua" )
include( "content_main.lua" )

Downloads = {}
local Main = nil

function UpdatePackageDownloadStatus( id, name, f, status, size )

	if ( !Main ) then
		Main = vgui.Create( "DContentMain", GetOverlayPanel() )
	end

	local dl = Downloads[ id ]
	
	if ( dl == nil ) then
	
		dl = vgui.Create( "DContentDownload", Main )
		dl.Velocity = Vector( 0, 0, 0 );
		dl:SetAlpha( 10 )
		Downloads[ id ] 	= dl
		Main:Add( dl )
		
	end
	
	dl:Update( f, status, name, size );
	
	if ( status == "success" ) then
		
		dl:Bounce()
		Downloads[ id ] = nil
		surface.PlaySound( "garrysmod/content_downloaded.wav" ) 
		
		timer.Simple( 2, function() 
								dl:Remove() 
						end )
	end
	
	if ( status == "failed" ) then
		
		dl:Failed()
		Downloads[ id ] = nil
		surface.PlaySound( "garrysmod/content_downloaded.wav" ) 
		
		timer.Simple( 2, function() 
								dl:Remove() 
						end )
	end
	
	Main:OnActivity( Downloads )

end