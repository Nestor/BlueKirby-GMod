

if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType			= "weapon_colt"
	
end

if ( CLIENT ) then

	SWEP.PrintName			= "Colt M1911A1"			
	SWEP.Author				= "Valve"
	SWEP.ViewModelFOV      = 60
	SWEP.Slot				= 1
	SWEP.SlotPos			= 1
	SWEP.IconLetter			= "b"
	SWEP.DrawCrosshair		= true
	
	killicon.AddFont( "weapon_fiveseven", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	
end

SWEP.Category				= "Day of Defeat"
SWEP.Base				= "rg_base"
SWEP.ViewModelFlip		= false

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_colt.mdl"
SWEP.WorldModel			= "models/weapons/w_colt.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= true
SWEP.AutoSwitchFrom		= true

SWEP.Primary.Sound			= Sound( "Weapon_colt.shoot" )
SWEP.Primary.Recoil			= .5
SWEP.Primary.Damage			= 15
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.02
SWEP.Primary.ClipSize		= 7
SWEP.Primary.Delay			= 0.11
SWEP.Primary.DefaultClip	= 301
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.MuzzleEffect			= "rg_muzzle_pistol"
SWEP.ShellEffect			= "rg_shelleject"

SWEP.SemiRPM				= 550

SWEP.MinRecoil		= 0.5
SWEP.MaxRecoil		= 5
SWEP.DeltaRecoil		= 0.15

SWEP.MinSpread		= 0.05
SWEP.MaxSpread		= 0.5
SWEP.DeltaSpread		= 0.05

SWEP.MuzzleVelocity			= 650

SWEP.AvailableFireModes		= {"Semi","Semi","Semi","Semi","Semi","Semi"}

SWEP.IronSightsPos = Vector (-3.8509, -7.593, 3.638)
SWEP.IronSightsAng = Vector (0.4573, 0.1018, 0)


