

function gmsave.UploadMap( iUploadID, iScreenshotID )

	local frame = vgui.Create( "DFrame" )
		frame:SetTitle( "Upload Saved Game" )
		frame:SetSize( 750, 550 )
		frame:MakePopup()
		frame:Center()
	
	local html = vgui.Create( "HTML", frame )
		html:OpenURL( "http://toybox.garrysmod.com/API/publishsave_002/?id=" .. iUploadID .. "&sid=" .. iScreenshotID )
		html:Dock( FILL )
	
	frame:InvalidateLayout()

end