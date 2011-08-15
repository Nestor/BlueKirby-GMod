if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType			= "pistol"
	
end

if ( CLIENT ) then

	SWEP.PrintName			= "ZS Pistol"			-- The Name Of Your SWEP
	SWEP.Author				= "Gilman"			-- Who Made This SWEP
        SWEP.Instructions   = "Left Click to kill The undead.Right click to ironsight"				-- Doesn't Matter, Because It Doesn't Show Up
	SWEP.Slot				= 2			-- Where It Is Located In Inventory
	SWEP.SlotPos		 	= 2			-- Same Thing 
	SWEP.Category		= "ZS Weps"
	SWEP.DrawAmmo		= true
										-- **If You Dont Get It, Nevermind, It's Not Important, Just Leave It

	SWEP.IconLetter			= "c"			-- I Dont Know, Just Leave This, It Works Fine
	SWEP.ViewModelFOV      = 60				-- This Is Weird, AFTER You Make A SWEP And Test It, Experiment With This
	SWEP.Drawcrosshair		= true

			killicon.AddFont( "weapon_glock", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	
end


SWEP.Base				= "weapon_cs_base"		-- The Base File, Dont Touch This
SWEP.ViewModelFlip		= true				-- Which Side The Gun Is On, When Testing, Change If Necessary

SWEP.Spawnable			= true				-- Weather Everybody Can Spawn The Swep
SWEP.AdminSpawnable		= false				-- If ADMIN Can Spawn, <note> if you want a admin only, set {SWEP.Spawnable}
										-- to false, and admin to true

SWEP.ViewModel			= "models/weapons/v_pist_glock18.mdl"		-- what it looks like <refer to model names> READ THE NOTE AT THE TOP IT
SWEP.WorldModel			= "models/weapons/w_pist_glock18.mdl"  	-- what it looks like <refer to model names> READ THE NOTE AT THE TOP IT

SWEP.Weight				= 5				-- No Need To Change 
SWEP.AutoSwitchTo		= true				-- If When You Spawn, It Automaticly Switches To It
SWEP.AutoSwitchFrom		= true			-- Dont Know, Opposite Mayby

SWEP.ForceApply    = 10 							-- Amount of force to give to phys objects
SWEP.TracerFreq    = 1 							-- Show a tracer on every x bullets 

SWEP.Primary.Sound			= Sound( "Weapon_glock.Single" )	-- Sound Of The Swep <refer to model names>
SWEP.Primary.Recoil			= 0.6						-- Recoil, How Much It Pushes Back
SWEP.Primary.Damage			= 21						-- Damage Of Each Shot
SWEP.Primary.NumShots		= 1							-- How Many Bullets Come Out Of The Gun At Once, A Shotgun Is 5 Where A Normal Gun Is 1
SWEP.Primary.Cone			= 0.010						-- Spread, A Shotgun Is 0.1, A Normal Gun Is Around 0.03
SWEP.Primary.ClipSize		= 10							-- How Many Bullets In A Clip	
SWEP.Primary.Delay			= 0.30					-- Time Inbetween Each Bullet(s), In Seconds
SWEP.Primary.DefaultClip	= 10						-- Ammo You Got Left
SWEP.Primary.Automatic		= false						-- Auto Or Not
SWEP.Primary.Ammo			= "pistol"						-- Type Of Ammo,No Need To Change

SWEP.Secondary.ClipSize		= -1							-- Nevermind About Any Of This, With Iron Sights, It Doesn't Work
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= ""

SWEP.IronSightsPos = Vector (4.3484, -6.496, 2.9381)
SWEP.IronSightsAng = Vector (0, 0, 0)