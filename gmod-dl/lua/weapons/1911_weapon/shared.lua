
if ( CLIENT ) then
	SWEP.Author				= "-[SB]- Spy, MaKc"
	SWEP.Contact			= "No contacts for you :P."
	SWEP.Purpose			= ""
	SWEP.Instructions		= ""
	SWEP.PrintName			= "1911 Limited Edition"
	SWEP.Instructions		= ""
	SWEP.Slot				= 1
	SWEP.SlotPos			= 0
	SWEP.IconLetter			= "f"
	
	killicon.AddFont("cse_deagle","CSKillIcons",SWEP.IconLetter,Color(255,80,0,255))
end

if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end


SWEP.Base				= "1911_base1"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_1911_custom.mdl"
SWEP.WorldModel			= "models/weapons/w_1911_custom.mdl"
SWEP.HoldType = "pistol"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("colt_fire.wav")
SWEP.Primary.Recoil			= 3
SWEP.Primary.Unrecoil		= 5
SWEP.Primary.Damage			= 45
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0
SWEP.Primary.ClipSize		= 8
SWEP.Primary.Delay			= 0.06 //Don't use this, use the tables below!
SWEP.Primary.DefaultClip	= 35 //Always set this 1 higher than what you want.
SWEP.Primary.Automatic		= true //Don't use this, use the tables below!
SWEP.Primary.Ammo			= "pistol"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

//Firemode configuration

SWEP.IronSightsPos = Vector (2.5441, -2.3226, 1.7263)
SWEP.IronSightsAng = Vector (0.1136, 0.0292, 0)

SWEP.data = {}
SWEP.mode = "semi" //The starting firemode
SWEP.data.newclip = false //Do not change this



SWEP.data.semi = {}
SWEP.data.semi.Delay = .25
SWEP.data.semi.Cone = 0.01
SWEP.data.semi.ConeZoom = 0.008

//End of configuration
