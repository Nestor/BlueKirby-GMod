local BUTTON = {};
local STATE_NONE = 0;
local STATE_HOVER = 1;
local STATE_DOWN = 2;


function BUTTON:Init()
	self.State = STATE_NONE;
	self.Color = Color( 50, 50, 50, 255 );
	self.TextColor = Color( 255, 255, 255, 255 );
	self.Text = "";
	self.Font = "HordeFont14";
end

function BUTTON:SetColor( color )
	self.Color = color;
end

function BUTTON:SetText( text )
	self.Text = text;
end

function BUTTON:GetColor()
	return self.Color;
end

function BUTTON:GetText( )
	return self.Text;
end

function BUTTON:SetTextColor( color )
	self.TextColor = color;
end

function BUTTON:GetTextColor()
	return self.TextColor;
end

function BUTTON:SetFont( font )
	self.Font = font;
end

function BUTTON:GetFont()
	return self.Font;
end

function BUTTON:Paint( w, h )
	local color = table.Copy( self.Color ); --Have to do this because of utter fucking bullshit
	
	if (self.State == STATE_NONE) then
		draw.RoundedBox( 4, 0, 0, w, h, color );
	elseif (self.State == STATE_HOVER) then
		draw.RoundedBox( 4, 0, 0, w, h, util.AddToColor( color, Color( 15, 15, 15, 0 ) ) );
	elseif (self.State == STATE_DOWN) then
		draw.RoundedBox( 4, 0, 0, w, h, util.SubFromColor( color, Color( 5, 5, 5, 0 ) ) );
	end
	
	local white = Color( 255, 255, 255, 1 );
	local black = Color( 0, 0, 0, 1 );
	
	draw.RoundedBox( 4, 0, 0, w, math.max( h/10, 8 ), (self.State == STATE_DOWN and black or white) );
	draw.RoundedBox( 4, 0, h-math.max( h/10, 8 ), w, math.max( h/10, 8 ), (self.State == STATE_DOWN and white or black) );
	
	for i = 0, math.max( h/10, 8 ) do
		white = Color( 255, 255, 255, math.max( h/10, 8 ) - i);
		black = Color( 0, 0, 0, 50 - i*4);
		
		surface.SetDrawColor( (self.State == STATE_DOWN and black or white) );
		surface.DrawLine( 0, i, w, i );
		surface.SetDrawColor( (self.State == STATE_DOWN and white or black) );
		surface.DrawLine( 0, h-i-1, w, h-i-1 );
	end
	
	color = table.Copy( self.TextColor );
	
	draw.DrawText( self.Text or "", self.Font, w/2+1, h/2-6+(self.State == STATE_DOWN and 1 or 0), Color( 0, 0, 0, 150 ), 1 );
	draw.DrawText( self.Text or "", self.Font, w/2, h/2-7+(self.State == STATE_DOWN and 1 or 0), color, 1 );
	
	return true;
end

function BUTTON:OnCursorEntered()
	self.State = STATE_HOVER;
end

function BUTTON:OnCursorExited()
	self.State = STATE_NONE;
end

function BUTTON:OnMouseReleased()
	if (self.State == STATE_DOWN and self.DoClick) then
		timer.Simple( 0.05, self.DoClick );
	end
	
	self.State = STATE_HOVER;
end
 
function BUTTON:OnMousePressed()
	self.State = STATE_DOWN;
end
 
vgui.Register( "HButton3D", BUTTON );

---------------
--FLAT BUTTON--
---------------

local BUTTON = {};

function BUTTON:Init()
	self.State = STATE_NONE;
	self.Color = Color( 50, 50, 50, 255 );
	self.OriginalColor = table.Copy( self.Color );
	self.WantedColor = table.Copy( self.Color );
	self.TextColor = Color( 255, 255, 255, 255 );
	self.HoverColor = util.AddToColor( table.Copy( self.Color ), Color( 15, 15, 15, 0 ) );
	self.DownColor = util.SubFromColor( table.Copy( self.Color ), Color( 5, 5, 5, 0 ) );
	self.Text = "";
	self.TextColorOffset = 105;
	self.Font = "HordeHUDFont26";
	self.AlignX = true;
	self.TextOffset = 5;
	self.Selected = false;
	self.Enabled = true;
end

function BUTTON:SetAlignX( align )
	self.AlignX = align;
end

function BUTTON:SetColor( color )
	self.Color = color;
	self.OriginalColor = table.Copy( color );
	self.WantedColor = table.Copy( color );
	self.HoverColor = util.AddToColor( table.Copy( color ), Color( 15, 15, 15, 0 ) );
	self.DownColor = util.SubFromColor( table.Copy( color ), Color( 5, 5, 5, 0 ) );
end

function BUTTON:SetWantedColor( color )
	self.WantedColor = color;
end

function BUTTON:SetOriginalColor( color )
	self.OriginalColor = color;
end

function BUTTON:SetHoverColor( color )
	self.HoverColor = table.Copy( color );
end

function BUTTON:SetDownColor( color )
	self.DownColor = table.Copy( color );
end

function BUTTON:SetText( text )
	self.Text = text;
end

function BUTTON:GetColor()
	return self.Color;
end

function BUTTON:GetText( )
	return self.Text;
end

function BUTTON:SetTextColor( color )
	self.TextColor = color;
end

function BUTTON:GetTextColor()
	return self.TextColor;
end

function BUTTON:SetFont( font )
	self.Font = font;
end

function BUTTON:GetFont()
	return self.Font;
end

function BUTTON:Paint( w, h )
	local color = table.Copy( self.TextColor );
	
	if (self.Color != self.WantedColor) then
		if (self.Color.r > self.WantedColor.r) then
			self.Color.r = math.Approach( self.Color.r, self.WantedColor.r, math.Clamp( math.abs( self.Color.r - self.WantedColor.r ) * 16, 200, 500 ) * RealFrameTime() );
		else
			self.Color.r = math.Approach( self.Color.r, self.WantedColor.r, math.Clamp( -math.abs( self.Color.r - self.WantedColor.r ) * 8, 125, 500 ) * RealFrameTime() );
		end
		
		if (self.Color.g > self.WantedColor.g) then
			self.Color.g = math.Approach( self.Color.g, self.WantedColor.g, math.Clamp( math.abs( self.Color.g - self.WantedColor.g ) * 16, 200, 500 ) * RealFrameTime() );
		else
			self.Color.g = math.Approach( self.Color.g, self.WantedColor.g, math.Clamp( -math.abs( self.Color.g - self.WantedColor.g ) * 8, 125, 500 ) * RealFrameTime() );
		end
		
		if (self.Color.b > self.WantedColor.b) then
			self.Color.b = math.Approach( self.Color.b, self.WantedColor.b, math.Clamp( math.abs( self.Color.b - self.WantedColor.b ) * 16, 200, 500 ) * RealFrameTime() );
		else
			self.Color.b = math.Approach( self.Color.b, self.WantedColor.b, math.Clamp( -math.abs( self.Color.b - self.WantedColor.b ) * 8, 125, 500 ) * RealFrameTime() );
		end
	end
	
	surface.SetDrawColor( self.Color );
	surface.DrawRect( 0, 0, w, h );
	
	surface.SetFont( self.Font );
	local width, height = surface.GetTextSize( self.Text );
	
	if (self.AlignX == true) then
		draw.DrawText( self.Text or "", self.Font, w/2, h/2-height/2+(self.State == STATE_DOWN and 1 or 0)-2, color, 1 );
	else
		draw.DrawText( self.Text or "", self.Font, self.TextOffset, h/2-height/2+(self.State == STATE_DOWN and 1 or 0)-2, util.SubFromColor( table.Copy( color ), Color( self.TextColorOffset, self.TextColorOffset, self.TextColorOffset, 0 ) ), 0 );
		
		if (self.State == STATE_NONE and self.Selected == false) then
			self.TextOffset =  math.Approach( self.TextOffset, 5, math.Clamp( math.abs( self.TextOffset - 6 ) * 4, 10, 200 ) * RealFrameTime() );
			self.TextColorOffset = math.Approach( self.TextColorOffset, 105, math.Clamp( math.abs( self.TextColorOffset - 105 ) * 4, 10, 200 ) * RealFrameTime() );
		else
			self.TextOffset =  math.Approach( self.TextOffset, (60-width/2), math.Clamp( math.abs( self.TextOffset - (60-width/2) ) * 4, 10, 200 ) * RealFrameTime() );
			self.TextColorOffset = math.Approach( self.TextColorOffset, 0, math.Clamp( math.abs( self.TextColorOffset ) * 4, 10, 200 ) * RealFrameTime() );
		end
	end
	
	return true;
end

function BUTTON:SetEnabled( enabled )
	if (enabled == false) then self.WantedColor = table.Copy( self.OriginalColor ); end
	
	self.Enabled = enabled;
end

function BUTTON:OnCursorEntered()
	if (self.Enabled == false) then return; end
	
	self.State = STATE_HOVER;
	self.WantedColor = table.Copy( self.HoverColor );
end

function BUTTON:OnCursorExited()
	if (self.Enabled == false) then return; end
	
	local color = table.Copy( self.Color );
	self.State = STATE_NONE;
	self.WantedColor = self.OriginalColor;
end

function BUTTON:OnMouseReleased( mouse_in )
	if (mouse_in != MOUSE_LEFT or self.Enabled == false) then return; end
	
	if (self.State == STATE_DOWN and self.DoClick) then
		timer.Simple( 0.05, self.DoClick );
	end
	
	self.State = STATE_HOVER;
	self.WantedColor = table.Copy( self.HoverColor );
end
 
function BUTTON:OnMousePressed( mouse_in )
	if (mouse_in != MOUSE_LEFT or self.Enabled == false) then return; end
	
	self.State = STATE_DOWN;
	self.WantedColor = table.Copy( self.DownColor );
end
 
vgui.Register( "HButton", BUTTON );

---------------
--FLAT BUTTON--
---------------

local PANEL = {};

function PANEL:Init()
	self.State = STATE_NONE;
	self.Color = Color( 10, 10, 10, 255 );
	self.TextColor = Color( 255, 255, 255, 255 );
	self.Text = "";
	self.Font = "HordeHUDFont26";
	self.Offset = 0;
	self.Height = 0;
	self.IsDragging = false;
	self.DragOffset = {["Mouse"] = {},["Panel"] = {}};
	self.Closing = false;
	self.Notifications = {};
	self.DrawBottom = true;
	
	self.CloseButton = vgui.Create( "HButton", self );
	self.CloseButton:SetText( "X" );
	self.CloseButton:SetSize( 40, 40 );
	self.CloseButton:SetPos( self:GetWide() - 40, 0 );
	self.CloseButton:SetColor( Color( 40, 40, 40, 255 ) );
	self.CloseButton:SetHoverColor( Color( 150, 40, 40, 255 ) );
	self.CloseButton:SetDownColor( Color( 60, 40, 40, 255 ) );
	self.CloseButton.DoClick = function()
		self.Closing = true;
		gui.EnableScreenClicker( false );
	end
end

function PANEL:Ease()
	self.CloseButton:SetPos( self:GetWide() - 40, 0 );
	self.Height = self:GetTall();
	self.Offset = self.Height;
	self:SetSize( self:GetWide(), 1 );
end

function PANEL:OnMousePressed( mouse_in )
	if (mouse_in != MOUSE_LEFT) then return; end
	
	local mousex, mousey = gui.MousePos();
	local panelx, panely = self:GetPos();
	
	if (mousey - panely < 40) then
		self.IsDragging = true;
		self.DragOffset.Mouse = Vector( mousex, mousey );
		self.DragOffset.Panel = Vector( panelx, panely );
	end
end

function PANEL:OnMouseReleased( mouse_in )
	if (mouse_in != MOUSE_LEFT) then return; end
	
	self.IsDragging = false;
end

function PANEL:SetColor( color )
	self.Color = color;
	self.CloseButton:SetColor( util.AddToColor( table.Copy( color ), Color( 30, 30, 30 ) ) );
	self.CloseButton:SetHoverColor( util.AddToColor( table.Copy( color ), Color( 80, 0, 0, 0 ) ) );
	self.CloseButton:SetDownColor( util.AddToColor( table.Copy( color ), Color( 40, 0, 0, 0 ) ) );
end

function PANEL:GetColor()
	return self.Color;
end

function PANEL:SetWindowTitle( title )
	self.Text = title;
end

function PANEL:GetTitle( )
	return self.Text;
end

function PANEL:SetTextColor( color )
	self.TextColor = color;
end

function PANEL:GetTextColor()
	return self.TextColor;
end

function PANEL:Notification( text, color )
	if (!color) then color = Color( 255, 255, 255 ); end
	
	local x = self:GetWide();
	
	for _, notification in pairs( self.Notifications ) do
		if (notification.x + 100 >= x) then
			x = notification.x + notification.width + 100;
		end
	end
	
	surface.SetFont( "HordeHUDFont18" );
	local width, _ = surface.GetTextSize( text );
	
	table.insert( self.Notifications, { ["text"] = text, ["color"] = color,	["x"] = x, ["width"] = width } );
end

function PANEL:Paint( w, h )
	local color = table.Copy( self.Color );
	
	if (self.IsDragging and (gui.MouseX() != self.DragOffset.Mouse.x or gui.MouseY() != self.DragOffset.Mouse.y)) then
		self:SetPos( math.Clamp( self.DragOffset.Panel.x - (self.DragOffset.Mouse.x - gui.MouseX()), -self:GetWide() + 40, ScrW() - 40 ), math.Clamp( self.DragOffset.Panel.y - (self.DragOffset.Mouse.y - gui.MouseY()), -self:GetTall() + 40, ScrH() - 40 ) );
	end
	
	surface.SetDrawColor( color );
	surface.DrawRect( 0, 0, w, h );
	surface.SetDrawColor( util.AddToColor( table.Copy( color ), Color( 30, 30, 30, 0 ) ) );
	surface.DrawRect( 0, 0, w, 40 );
	if (self.DrawBottom == true) then
		surface.SetDrawColor( util.AddToColor( table.Copy( color ), Color( 20, 20, 20, 0 ) ) );
		surface.DrawRect( 0, h-40, w, h );
	end
	draw.DrawText( self.Text or "", self.Font, 10, 5, self.TextColor, 0 );
	
	for index, notification in pairs( self.Notifications ) do
		if (notification.x < self:GetWide() ) then
			draw.DrawText( notification.text, "HordeHUDFont18", notification.x, self:GetTall() - (30 - (self.Offset/10)), notification.color, 0 );
		end
		
		notification.x = notification.x - 100 * RealFrameTime();
		
		if (notification.x < -notification.width) then
			notification = table.remove( notification, index );
		end
	end
	
	if (self.Closing == true) then
		self.Offset = math.Approach( self.Offset, self.Height, -math.Clamp( self:GetTall() * 8, 20, 1000 ) * RealFrameTime() );
		self:SetSize( self:GetWide(), self.Height - self.Offset );
		
		if (self.Offset >= self.Height - 1) then
			self:Close();
		end
	end
	
	if (self.Offset and self.Closing == false) then
		self.Offset = math.Approach( self.Offset, 0, math.Clamp( self.Offset * 8, 20, 1000 ) * RealFrameTime() );
		self:SetSize( self:GetWide(), self.Height - self.Offset );
	end
	
	return true;
end
 
vgui.Register( "HFrame", PANEL, "DFrame" );

---------------
--MODEL PANEL--
---------------

PANEL = {};

function PANEL:Init()
	self.Color = Color( 0, 0, 0, 255 );
	self.State = STATE_NONE;
end

function PANEL:SetColor( color )
	self.Color = color;
end

function PANEL:GetColor()
	return self.Color;
end

function PANEL:OnCursorEntered()
	self.State = STATE_HOVER;
end

function PANEL:OnCursorExited()
	self.State = STATE_NONE;
end
 
vgui.Register( "HModelPanel", PANEL, "DModelPanel" );

---------------
--MODEL PANEL--
---------------

PANEL = {};

function PANEL:Init()
	self.Easing = false;
	self.Offset = 0;
end

function PANEL:StopEasing() end

function PANEL:Ease()
	if (self.Easing) then return; end
	
	local paint = self.Paint;
	local x, y = self:GetPos();
	local width = self:GetWide();
	local height = self:GetTall();
	
	self.Easing = true;
	
	self.StopEasing = function()
		self.Offset = 0;
		self:SetVisible( false );
		self.Paint = paint;
		self:SetSize( width, height );
		self:SetPos( x, y );
		self:MoveToBack();
		self.Easing = false;
		
		self.StopEasing = function() end
	end
	
	self.Paint = function( self, w, h )
		self.Offset = math.Approach( self.Offset, width, math.Clamp( (width - self.Offset) * 8, 20, 1000 ) * RealFrameTime() );
		
		self:SetSize( width - self.Offset, height );
		self:SetPos( x + self.Offset + 1, y );
		
		if (self.Offset+2 >= width) then
			self:StopEasing();
		end
		
		paint( self, w, h );
	end
end
 
vgui.Register( "HPanel", PANEL, "DPanel" );

//Fonts

surface.CreateFont( "HordeHUDFont10", { font = "Everson Mono", size = 10, antialias = true, weight = 0, scalieness = 100, outline = false } );
surface.CreateFont( "HordeHUDFont14", { font = "Everson Mono", size = 14, antialias = true, weight = 0, scalieness = 100, outline = false } );
surface.CreateFont( "HordeHUDFont18", { font = "Robotic", size = 18, antialias = true, weight = 0, scalieness = 100, outline = false } );
surface.CreateFont( "HordeHUDFont22", { font = "Roboto", size = 22, antialias = true, weight = 0, scalieness = 100, outline = false } );
surface.CreateFont( "HordeHUDFont26", { font = "Roboto", size = 26, antialias = true, weight = 500, scalieness = 100, outline = false} );
surface.CreateFont( "HordeHUDFont30", { font = "Roboto", size = 30, antialias = true, weight = 0, scalieness = 100, outline = false } );
surface.CreateFont( "HordeHUDFont", { font = "Impact", size = 20, antialias = true, outline = false } );
surface.CreateFont( "HordeMessageFont", { font = "Trebuchet", size = 14, weight = 1000, antialias = true, outline = false } );
surface.CreateFont( "HordeFont14", { font = "Trebuchet", size = 14, weight = 1000, antialias = true, outline = false } );
surface.CreateFont( "HordeFont18", { font = "Trebuchet", size = 18, weight = 1000, antialias = true, outline = false } );
surface.CreateFont( "HordeFont24", { font = "Trebuchet", size = 24, weight = 1000, antialias = true, outline = false } );
surface.CreateFont( "HordeFont28", { font = "Trebuchet", size = 28, weight = 1000, antialias = true, outline = false } );
surface.CreateFont( "HordeFont32", { font = "Trebuchet", size = 32, weight = 1000, antialias = true, outline = false } );

//Utils

function util.AddToColor( color, add )
	color.r = math.min( color.r + add.r, 255 );
	color.g = math.min( color.g + add.g, 255 );
	color.b = math.min( color.b + add.b, 255 );
	color.a = math.min( color.a + add.a, 255 );
	
	return color;
end

function util.SubFromColor( color, sub )
	color.r = math.max( color.r - sub.r, 0 );
	color.g = math.max( color.g - sub.g, 0 );
	color.b = math.max( color.b - sub.b, 0 );
	color.a = math.max( color.a - sub.a, 0 );
	
	return color;
end

util.SubtractFromColor = util.SubFromColor;