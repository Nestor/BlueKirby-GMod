
PANEL = {}

local Distance 			= 256
local BlurSize			= 0.5
local Passes			= 16
local Steps				= 32
local Shape				= 0.5

local Window 			= nil
local Status 			= "Preview"


local sldDistance   	= nil
local lblDistance 		= nil
local lblSize 			= nil
local FocusGrabber  	= false
local ScreenshotTimer	= 0

local strTitle 		= Localize( "SuperDOF_WindowTitle", "Super DOF" )
local strBlurSize 	= Localize( "SuperDOF_BlurSize", "Blur Size:" )
local strDistance 	= Localize( "SuperDOF_Distance", "Focus Distance: (or click on scene)" )
local strRender 	= Localize( "SuperDOF_Render", "Render" )
local strScreenshot = Localize( "SuperDOF_Screenshot", "Take Screenshot" )
local strOpenWindow = Localize( "SuperDoF_Open", "Open Window" )
local strInformation =  Localize( "SuperDoF_Warning", "Warning: This is VERY experimental so it might not totally work on your graphics card. \n\nThis effect is not realtime. You render it and then save a screenshot of your render. Also, you will have low fps when previewing - that's normal.")


function PANEL:Init()

	self:SetTitle( strTitle )
	self:SetRenderInScreenshots( false )

	local Panel = vgui.Create( "DPanel", self )
	
	local lbl = Label( "Settings", Panel )
	lbl:SetContentAlignment( 8 )
	lbl:SetTextColor( Color( 255, 255, 255, 255 ) )
	lbl:Dock( TOP )
	
	self.BlurSize = vgui.Create( "DNumSlider", Panel )
		self.BlurSize:SetMin( 0 )
		self.BlurSize:SetMax( 10 )
		self.BlurSize:SetDecimals( 3 )
		self.BlurSize:SetText( strBlurSize )
		self.BlurSize:SetValue( BlurSize )
		function self.BlurSize:OnValueChanged( val ) BlurSize = val end
		self.BlurSize:Dock( TOP )
		self.BlurSize:DockMargin( 0, 0, 0, 16 )
	
	self.Distance = vgui.Create( "DNumSlider", Panel )
		self.Distance:SetMin( 0 )
		self.Distance:SetMax( 4096 )
		self.Distance:SetText( strDistance )
		self.Distance:SetValue( Distance )
		function self.Distance:OnValueChanged( val ) Distance = val end
		self.Distance:Dock( TOP )
			
	Panel:SetPos( 10, 30 )
	Panel:SetSize( 300, 90 )
	Panel:DockPadding( 8, 8, 8, 8 )
	Panel:DockMargin( 0, 0, 4, 0 )
	Panel:Dock( FILL )
	
	local Panel = vgui.Create( "DPanel", self )
	
	local lbl = Label( "Advanced", Panel )
	lbl:SetContentAlignment( 8 )
	lbl:SetTextColor( Color( 255, 255, 255, 255 ) )
	lbl:Dock( TOP )
	
	local PassesCtrl = vgui.Create( "DNumSlider", Panel )
		PassesCtrl:SetMin( 1 )
		PassesCtrl:SetMax( 64 )
		PassesCtrl:SetDecimals( 0 )
		PassesCtrl:SetText( Localize( "SuperDOF_Passes", "Passes:" ) )
		PassesCtrl:SetValue( Passes )
		function PassesCtrl:OnValueChanged( val ) Passes = val end
		PassesCtrl:Dock( TOP )
		PassesCtrl:DockMargin( 0, 0, 0, 4 )
	
	local RadialsCtrl = vgui.Create( "DNumSlider", Panel )
		RadialsCtrl:SetMin( 1 )
		RadialsCtrl:SetMax( 64 )
		RadialsCtrl:SetDecimals( 0 )
		RadialsCtrl:SetText( Localize( "SuperDOF_Radials", "Radials:" ) )
		RadialsCtrl:SetValue( Steps )
		function RadialsCtrl:OnValueChanged( val ) Steps = val end
		RadialsCtrl:Dock( TOP )
		RadialsCtrl:DockMargin( 0, 0, 0, 4 )
	
	local ShapeCtrl = vgui.Create( "DNumSlider", Panel )
		ShapeCtrl:SetMin( 0 )
		ShapeCtrl:SetMax( 1 )
		ShapeCtrl:SetDecimals( 3 )
		ShapeCtrl:SetText( Localize( "SuperDOF_Radials", "Shape:" ) )
		ShapeCtrl:SetValue( Shape )
		function ShapeCtrl:OnValueChanged( val ) Shape = val end
		ShapeCtrl:Dock( TOP )
		ShapeCtrl:DockMargin( 0, 0, 0, 4 )
		
	Panel:SetPos( 10, 30 )
	Panel:SetSize( 150, 100 )
	Panel:DockPadding( 8, 8, 8, 8 )
	Panel:Dock( RIGHT )
	
		

	local Panel = vgui.Create( "DPanel", self )
			
	self.Render = vgui.Create( "DButton", Panel )
		self.Render:SetText( strRender )
		function self.Render:DoClick() Status = "Render" end
		self.Render:Dock( RIGHT )		self.Render:SetSize( 70, 20 )
		
	self.Screenshot = vgui.Create( "DButton", Panel )
		self.Screenshot:SetText( strScreenshot )
		function self.Screenshot:DoClick() RunConsoleCommand( "jpeg" ) end
		self.Screenshot:Dock( RIGHT )
		self.Screenshot:SetSize( 120, 20 )
		self.Screenshot:DockMargin( 0, 0, 8, 0 )
		
	local Break = vgui.Create( "DButton", Panel )
		Break:SetText( "5" )
		local THIS = self
		function Break:DoClick() 
			THIS:SetVisible( false )
			timer.Simple( 5, function() THIS:SetVisible( true ) end )
		end
		Break:Dock( LEFT )
		Break:SetSize( 20, 20 )
		Break:SetTooltip( "Hide this window for 5 seconds\n(So you can move or take a picture with Steam)" )

	Panel:Dock( BOTTOM )
	Panel:DockPadding( 4, 4, 4, 4 )
	Panel:DockMargin( 0, 4, 0, 0 )
	Panel:SetTall( 28 );
	Panel:MoveToBack()
		
	self:SetSize( 450, 230 )
		
end

function PANEL:ChangeDistanceTo( dist )

	self.Distance:SetValue( dist )

end

local paneltypeSuperDOF = vgui.RegisterTable( PANEL, "DFrame" )


local texFSB = render.GetSuperFPTex()
local matFSB = Material( "pp/motionblur" )
local matFB	 = Material( "pp/fb" )

local function RenderDoF( vOrigin, vAngle, vFocus, fAngleSize, radial_steps, passes, bSpin )

	local OldRT 	= render.GetRenderTarget();
	local view 		= {  x = 0, y = 0, w = ScrW(), h = ScrH() }
	local fDistance = vOrigin:Distance( vFocus )
	
	fAngleSize = fAngleSize * math.Clamp( 256/fDistance, 0.1, 1 ) * 0.5
	
	view.origin = vOrigin
	view.angles = vAngle
	view.dopostprocess = true
	
	// Straight render (to act as a canvas)
	render.RenderView( view )
	render.UpdateScreenEffectTexture()
	
	render.SetRenderTarget( texFSB )
			matFB:SetMaterialFloat( "$alpha", 1  )
			render.SetMaterial( matFB )
			render.DrawScreenQuad()	
	
	local Radials = (math.pi*2) / radial_steps
	
	for mul=(1 / passes), 1, (1 / passes) do
	
		for i=0,(math.pi*2), Radials do
		
			local VA = vAngle * 1 // hack - this makes it copy the angles instead of the reference
			local VRot = vAngle * 1
			// Rotate around the focus point
			VA:RotateAroundAxis( VRot:Right(), 	math.sin( i + (mul) ) * fAngleSize * mul * (Shape) * 2 )
			VA:RotateAroundAxis( VRot:Up(), 	math.cos( i + (mul) ) * fAngleSize * mul * (1-Shape) * 2 )
			
			ViewOrigin = vFocus - VA:Forward() * fDistance
			
			view.origin = ViewOrigin
			view.angles = VA
			
			// Render to the front buffer
			render.SetRenderTarget( OldRT )
			render.Clear( 0, 0, 0, 255, true )
			render.RenderView( view )
			render.UpdateScreenEffectTexture()
			
			// Copy it to our floating point buffer at a reduced alpha
			render.SetRenderTarget( texFSB )
			local alpha = (Radials/(math.pi*2)) 		// Divide alpha by number of radials
			alpha = alpha * (1-mul)					// Reduce alpha the further away from center we are
			matFB:SetMaterialFloat( "$alpha", alpha  )
			
				render.SetMaterial( matFB )
				render.DrawScreenQuad()

			// We have to SPIN here to stop the Source engine running out of render queue space.
			if ( bSpin ) then
			
				// Restore RT
				render.SetRenderTarget( OldRT )
	
				// Render our result buffer to the screen
				matFSB:SetMaterialFloat( "$alpha", 1 )
				matFSB:SetMaterialTexture( "$basetexture", texFSB )
		
				render.SetMaterial( matFSB )
				render.DrawScreenQuad()
			
				render.Spin()
				
			end
		
		end
		
	end
	
	// Restore RT
	render.SetRenderTarget( OldRT )
	
	// Render our result buffer to the screen
	matFSB:SetMaterialFloat( "$alpha", 1 )
	matFSB:SetMaterialTexture( "$basetexture", texFSB )
		
	render.SetMaterial( matFSB )
	render.DrawScreenQuad()

end

function RenderSuperDoF( ViewOrigin, ViewAngles )

	if ( FocusGrabber ) then
	
		tr = util.TraceLine( util.GetPlayerTrace( LocalPlayer(), LocalPlayer():GetCursorAimVector() ) )
		Distance = tr.HitPos:Distance( ViewOrigin )
		Status = "Preview"
	
		SuperDOFWindow:ChangeDistanceTo( Distance )
	
	end

	local FocusPoint = ViewOrigin + ViewAngles:Forward() * Distance
	
	if ( Status == "Preview" ) then
		
		// A low quality, pretty quickly drawn rough outline
		RenderDoF( ViewOrigin, ViewAngles, FocusPoint, BlurSize, 2, 2, false )
		
	elseif ( Status == "Render" ) then
		
		// A great quality render..
		RenderDoF( ViewOrigin, ViewAngles, FocusPoint, BlurSize, Steps, Passes, true )
		Status = "ViewShot"
	
	elseif ( Status == "ViewShot" ) then
		
		matFSB:SetMaterialFloat( "$alpha", 1 )
		matFSB:SetMaterialTexture( "$basetexture", texFSB )
		render.SetMaterial( matFSB )
		render.DrawScreenQuad()
		
	end
	
end

local function RenderSceneHook( ViewOrigin, ViewAngles )

	if ( !ValidPanel( SuperDOFWindow ) ) then return end
	
	// Don't render it when the console is up
	if ( FrameTime() == 0 ) then return end
	
	RenderSuperDoF( ViewOrigin, ViewAngles );
	return true;

end


hook.Add( "RenderScene", "RenderSuperDoF", RenderSceneHook )


local function OpenWindow()

	Status = "Preview"
	
	if ( ValidPanel( SuperDOFWindow ) ) then
		SuperDOFWindow:Remove()
	end
	
	SuperDOFWindow = vgui.CreateFromTable( paneltypeSuperDOF )
	
	SuperDOFWindow:InvalidateLayout( true )
	SuperDOFWindow:MakePopup()
	SuperDOFWindow:AlignBottom( 50 )
	SuperDOFWindow:CenterHorizontal()
	SuperDOFWindow:SetKeyboardInputEnabled( false )

end

concommand.Add( "pp_superdof", OpenWindow )


/*---------------------------------------------------------
   Mouse button down
---------------------------------------------------------*/   
local function MouseDown( mouse )

	if ( !ValidPanel(SuperDOFWindow) ) then return end

	vgui.GetWorldPanel():MouseCapture( true )
	FocusGrabber = true

end


/*---------------------------------------------------------
   Mouse button released
---------------------------------------------------------*/   
local function MouseUp( mouse )

	if ( !ValidPanel(SuperDOFWindow) ) then return end
	
	vgui.GetWorldPanel():MouseCapture( false )
	FocusGrabber = false
	
end

hook.Add( "GUIMousePressed", "SuperDOFMouseDown", MouseDown )
hook.Add( "GUIMouseReleased", "SuperDOFMouseUp", MouseUp )


/*
// Control Panel
*/
local function BuildControlPanel( CPanel )

	CPanel:Help( strInformation )
	CPanel:Button( strOpenWindow, "pp_superdof" )
	
end

/*
// Tool Menu
*/
local function AddPostProcessMenu()

	spawnmenu.AddToolMenuOption( "PostProcessing", "PPShader", "SuperDoF", "#Super DoF", "", "", BuildControlPanel )

end

hook.Add( "PopulateToolMenu", "AddPostProcessMenu_SuperDoF", AddPostProcessMenu )
