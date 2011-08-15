
if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType			= "pistol"
	
end

if ( CLIENT ) then

	SWEP.PrintName			= "Perfect dark silenced pistol"			
	SWEP.Author				= "Lune66"

	SWEP.Slot				= 1
	SWEP.SlotPos			= 1
	SWEP.IconLetter			= "f"
	
	killicon.AddFont( "weapon_deagle", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )

end

SWEP.Base				= "weapon_cs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModelFlip	= false
SWEP.ViewModel			= "models/weapons/v_falcon2silenced.mdl"
SWEP.WorldModel			= "models/weapons/w_pistol.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "weapons/falcon2/Falcon2_fire_silenced.wav" )
SWEP.Primary.Recoil			= 0.3
SWEP.Primary.Damage			= 17
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.02
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

function SWEP:SecondaryAttack()
self.Weapon:SetNextSecondaryFire(CurTime() + 0.65)

local trace = self.Owner:GetEyeTrace()

if trace.HitPos:Distance(self.Owner:GetShootPos()) <= 75 then
self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
	bullet = {}
	bullet.Num    = 1
	bullet.Src    = self.Owner:GetShootPos()
	bullet.Dir    = self.Owner:GetAimVector()
	bullet.Spread = Vector(0, 0, 0)
	bullet.Tracer = 0
	bullet.Force  = 35
	bullet.Damage = 50
self.Owner:FireBullets(bullet)
self.Owner:SetAnimation( PLAYER_ATTACK1 );
self.Weapon:EmitSound("physics/flesh/flesh_impact_bullet" .. math.random( 3, 5 ) .. ".wav")
else
	self.Weapon:EmitSound("weapons/falcon2/Falcon2_pistolwhip_1.wav")
	self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
end

end
