
AddCSLuaFile( "shared.lua" )

SWEP.Category 		= "Other"
SWEP.PrintName		= "Alyxgun"	
SWEP.Author		= "VALVe"


SWEP.ViewModelFOV	= 55
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/v_alyxgun.mdl"
SWEP.WorldModel		= "models/weapons/w_Alyx_Gun.mdl"
SWEP.AnimPrefix		= "pistol"
SWEP.HoldType		= "pistol"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true
SWEP.Slot			= 2

SWEP.Primary.ClipSize		= 30			// Size of a clip
SWEP.Primary.DefaultClip	= 150			// Default number of bullets in a clip
SWEP.Primary.Automatic		= true			// Automatic/Semi Auto
SWEP.Primary.Delay		= 0.2
SWEP.Primary.Ammo		= "AlyxGun"

SWEP.Secondary.ClipSize		= -1			// Size of a clip
SWEP.Secondary.DefaultClip	= -1			// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false			// Automatic/Semi Auto
SWEP.Secondary.Ammo		= "SMG1"

FireMode = 0

/*---------------------------------------------------------
	Initialize
---------------------------------------------------------*/
function SWEP:Initialize()

end

/*---------------------------------------------------------
	Holster
---------------------------------------------------------*/
function SWEP:Holster()

	return true
end



/*---------------------------------------------------------
	Reload
---------------------------------------------------------*/
function SWEP:Reload()
	if self:DefaultReload( ACT_VM_RELOAD ) then 
		self:EmitSound(Sound("weapons/smg2/smg2_reload.wav")) 
	end
end


/*---------------------------------------------------------
   Think
---------------------------------------------------------*/
function SWEP:Think()
end


/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()

	// Make sure we can shoot first
	if ( !self:CanPrimaryAttack() ) then return end
	if ( self:Clip1() < 3 && self:Ammo1() > 0 && FireMode == 1 ) then
		self:Reload()
		return
	end
	//Set Delay and Fire
	if (FireMode == 0 || self:Clip1() < 3 ) then
		// Shoot 1 bullet, 10 damage, 0.07 aimcone
		self:ShootBullet( 7, 1, 0.055 )
		// Delay Attack
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.08 )
		// Play shoot sound
		self:EmitSound( Sound("weapons/alyxgun/alyx_gun_fire3.wav") )
		// Remove 1 bullet from our clip
		self:TakePrimaryAmmo( 1 )
	else
		// Shoot 1 bullet, 10 damage, 0.07 aimcone
		self:ShootBullet( 7, 1, 0.015 )
		timer.Create("FireBurstShot1" .. tostring(self.Owner),0.08,1,BurstFire,self,7,1,0.015)
		timer.Create("FireBurstShot2" .. tostring(self.Owner),0.16,1,BurstFire,self,7,1,0.015)
		// Delay Attack
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 )
		// Play shoot sound
		self:EmitSound( Sound("weapons/alyxgun/alyx_gun_fire4.wav") )
		// Remove 1 bullet from our clip
		self:TakePrimaryAmmo( 1 )
	end
	
end

function BurstFire( self, damage, number, accuracy)
	if ( !self:CanPrimaryAttack() ) then return end
	self:ShootBullet( damage, number, accuracy )
	self:EmitSound( Sound("weapons/smg2/smg2_fire2.wav") )
	self:TakePrimaryAmmo( 1 )
end

/*---------------------------------------------------------
	SecondaryAttack
---------------------------------------------------------*/
function SWEP:SecondaryAttack()	

	if(FireMode == 0) then
		self:EmitSound("weapons/smg2/switch_burst.wav")
		FireMode = 1
	else
		self:EmitSound("weapons/smg2/switch_single.wav")
		FireMode = 0
	end
end

// Add to Weapon List
list.Set("NPCWeapons","weapon_alyxgun","Alyxgun");

// These tell the NPC how to use the weapon
AccessorFunc( SWEP, "fNPCMinBurst", 	2 )
AccessorFunc( SWEP, "fNPCMaxBurst", 	5 )
AccessorFunc( SWEP, "fNPCFireRate", 	0.08 )
AccessorFunc( SWEP, "fNPCMinRestTime", 	1 )
AccessorFunc( SWEP, "fNPCMaxRestTime", 	2 )

/*---------------------------------------------------------
	Capabilities
---------------------------------------------------------*/
function SWEP:GetCapabilities()

	return CAP_WEAPON_RANGE_ATTACK1 | CAP_INNATE_RANGE_ATTACK1

end