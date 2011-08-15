if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
	AddCSLuaFile( "cl_init.lua" )
	SWEP.HoldType		= "pistol"
end

if ( CLIENT ) then
	SWEP.Category 		= "Halo Weapons"
	SWEP.PrintName		= "Halo M6D"
	SWEP.Author			= "Blackops7799"
	SWEP.Contact		= "blackops777999@gmail.com"
	SWEP.Purpose		= ""
	SWEP.Instructions		= "Shoot with primary fire. Melee with secondary fire. (use+secondary = zoom)"
	SWEP.CSMuzzleFlashes    = true
	SWEP.ViewModelFOV		= 70
	SWEP.Slot			= 1
	SWEP.SlotPos		= 0
end

SWEP.HoldType		= "pistol"

--function SWEP:Precache()
--	util.PrecacheSound("weapons/pistol_fire.wav")
--	util.PrecacheSound("weapons/pistol_melee.wav")
--	util.PrecacheSound("weapons/pistol_impact.wav")
--	util.PrecacheSound("weapons/pistol_reload.wav")
--	util.PrecacheSound("weapons/pistol_ready.wav")
--	util.PrecacheModel("models/Weapons/v_m6d.mdl")
--	util.PrecacheModel("models/Weapons/w_m6d.mdl")
--end

SWEP.data = {}
SWEP.data.newclip			= false

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/Weapons/v_m6d.mdl"
SWEP.WorldModel			= "models/Weapons/w_m6d.mdl"
SWEP.ViewModelFlip		= false

SWEP.Drawammo 			= true
SWEP.DrawCrosshair 		= false

SWEP.Weight				= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound		= Sound( "weapons/pistol_fire.wav" )
SWEP.Primary.Recoil		= 0.03
SWEP.Primary.Damage		= 19
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone		= 0.01
SWEP.Primary.ClipSize		= 12
SWEP.Primary.Delay		= 0.30
SWEP.Primary.DefaultClip	= 80
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "pistol"

SWEP.Secondary.ClipSize		= 1
SWEP.Secondary.DefaultClip	= 1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"

local bZoomed = false

function SWEP:Initialize()
	if (SERVER) then
		self:SetWeaponHoldType(self.HoldType)
	end
end

function SWEP:SecondaryAttack()
	if self.Owner:KeyDown(IN_USE) then
		if not bZoomed then
			if (SERVER) then
				self.Weapon:GetOwner():SetFOV(45,0.35)
				self.Owner:DrawViewModel(false)
			end
			self.Weapon:EmitSound(Sound("weapons/zoom.wav"))
			bZoomed = true
			else
			bZoomed = false
			if (SERVER) then
				self.Owner:SetFOV( 0, 0.35 )
				self.Owner:DrawViewModel(true)
			end
			self.Weapon:EmitSound(Sound("weapons/zoom.wav"))
		end
	else

		bZoomed = false
		self.Owner:SetFOV( 0, 0.35 )

		self.Weapon:SetNextSecondaryFire(CurTime() + 1.5)
		self.Weapon:SetNextPrimaryFire(CurTime() + 1.5)

		if SERVER then self.Owner:EmitSound(Sound("weapons/pistol_melee.wav")) end
		if SERVER then self.Owner:EmitSound(Sound("weapons/pistol_impact.wav")) end

		local ang = self.Owner:GetAimVector()
		local spos = self.Owner:GetShootPos()

		local trace = {}
		trace.start = spos
		trace.endpos = spos + (ang * 150)
		trace.filter = self.Owner

		local tr = util.TraceLine(trace)

		if tr.HitNonWorld then
			local bullet = {}
			bullet.Num=5
			bullet.Src = self.Owner:GetShootPos()
			bullet.Dir= self.Owner:GetAimVector()
			bullet.Spread = Vector(0.15,0.15,0.15)
			bullet.Tracer = 0
			bullet.Force = 0
			bullet.Damage = 8
			self.Owner:FireBullets(bullet)
			self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
			self.Owner:SetAnimation( PLAYER_ATTACK1 )

			else if tr.HitWorld then
				self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
				self.Owner:SetAnimation( PLAYER_ATTACK1 )
				else if !tr.Hit then
					self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
					self.Owner:SetAnimation( PLAYER_ATTACK1 )
				end
			end
		end
	end
end


function SWEP:PrimaryAttack()
	if ( !self:CanPrimaryAttack() ) then return end
	self.Weapon:EmitSound(self.Primary.Sound)
	self:ShootBullet( 0, self.Primary.NumShots, self.Primary.Cone )
	self:TakePrimaryAmmo( self.Primary.NumShots )
	--self.Owner:ViewPunch( Angle( -0.50, 0, 0 ) )
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

end

function SWEP:ShootBullet( damage, num_bullets, aimcone )	
	local bullet = {}
	bullet.Num 		= num_bullets
	bullet.Src 		= self.Owner:GetShootPos()
	bullet.Dir 		= self.Owner:GetAimVector()
	bullet.Spread 		= Vector( aimcone, aimcone, 0 )
	bullet.Tracer		= 5
	bullet.Force		= 0
	bullet.Damage		= 19
	bullet.AmmoType 	= self.Primary.Ammo
	self.Owner:FireBullets( bullet )
	self:ShootEffects()
	
end

function SWEP:ShootEffects()
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self.Owner:MuzzleFlash()
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
end

function SWEP:Reload()
	--if self.Owner:GetActiveWeapon():Clip1() == 0 then return end
	if self.Owner:GetActiveWeapon():Clip1() == 12 then return end
	if self.Reloading || self.Owner:GetAmmoCount( "smg1" ) == 0 then return end
	if self.Weapon:Clip1() < 12 then
		bZoomed = false
		if (SERVER) then
			self.Owner:SetFOV( 0, 0.35 )
			self.Owner:DrawViewModel(true)
		end
		self.data.oldclip = self.Weapon:Clip1()
		self.Weapon:EmitSound(Sound("weapons/pistol_reload.wav"))
		self.Weapon:DefaultReload(ACT_VM_RELOAD)
		self.data.newclip = 1
	end
end

function SWEP:Deploy()
	self.Weapon:EmitSound(Sound("weapons/pistol_ready.wav"))
end