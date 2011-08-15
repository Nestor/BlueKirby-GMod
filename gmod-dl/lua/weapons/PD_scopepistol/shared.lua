

if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType			= "ar2"
	
end

if ( CLIENT ) then

	SWEP.PrintName			= "Perfect dark scoped pistol"			
	SWEP.Author				= "Lune66/Crazzyperson"
	SWEP.Slot				= 1
	SWEP.SlotPos			= 1
	SWEP.IconLetter			= "n"
	
	killicon.AddFont( "weapon_pistol", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	
end

SWEP.Base				= "weapon_cs_base"

SWEP.DrawCrosshair = true
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_falcon2scope.mdl"
SWEP.WorldModel			= "models/weapons/w_pistol.mdl"
SWEP.ViewModelFlip		= false

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "weapons/falcon2/Falcon2_fire.wav" )
SWEP.Primary.Recoil			= 0.3
SWEP.Primary.Damage			= 21
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.005
SWEP.Primary.ClipSize		= 8
SWEP.Primary.Delay			= 0.1
SWEP.Primary.DefaultClip	= 9
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

function SWEP:Initialize()
	util.PrecacheSound("weapons/falcon2/Falcon2_pistolwhip_1.wav")
end

ScopeLevel = 0

/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------/*
function SWEP:PrimaryAttack()

	if(ScopeLevel == 0) then
		self.Primary.Recoil = 0.5
		self.Primary.Cone = 0.02
		self.Primary.Delay	= 0.1
	else
		self.Primary.Recoil = 0.5
		self.Primary.Cone = 0.005
		self.Primary.Delay = 0.1
	end

	self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
	if ( !self:CanPrimaryAttack() ) then return end
	
	// Play shoot sound
	self.Weapon:EmitSound( self.Primary.Sound )
	
	// Shoot the bullet
	self:CSShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.Primary.Cone )
	
	// Remove 1 bullet from our clip
	self:TakePrimaryAmmo( 1 )
	
	// Punch the player's view
	self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
	
end

/*---------------------------------------------------------
	SecondaryAttack
---------------------------------------------------------*/
function SWEP:SecondaryAttack()

	if(ScopeLevel == 0) then
	
		if(SERVER) then
			self.Owner:SetFOV( 45, 0 )
		end	
		
		ScopeLevel = 1
		
	else if(ScopeLevel == 1) then
	
		if(SERVER) then
			self.Owner:SetFOV( 100, 0 )
		end	
		
		ScopeLevel = 0
		
	else

		if(SERVER) then
			self.Owner:SetFOV( 0, 0 )
		end		
		
		ScopeLevel = 2
		
	end
	end
	
end

function SWEP:Holster()
	self.Owner:SetFOV( 0, 0 )
	ScopeLevel = 0
	
	return true
end