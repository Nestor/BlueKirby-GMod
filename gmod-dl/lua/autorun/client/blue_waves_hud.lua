local ughh = 0
local NPCskilled = 0
local TotalEnemys = 0

local function StartVar( data )
	NPCskilled = data:ReadFloat(1)
	TotalEnemys = data:ReadFloat(2)
end
usermessage.Hook( "GetEnemies", StartVar )

local function hud()
	local ply = LocalPlayer() -- Getting ourselfz noob
	
	if ughh == 0 then
		Health = ply:Health()
		Armor = ply:Armor()
		AmmoHeight = 50
		Money = 0
		ughh = 1
	end
	
	local Width = 7 * string.len(TotalEnemys - NPCskilled)
	local MoneyWidth = 3.5 * string.len(ply:GetNWInt("money"))
	local EnemyWidth = 3.5 * string.len(TotalEnemys - NPCskilled)
	
	Money = math.Approach(Money, ply:GetNWInt("money"), 10 * string.len(Money) )
	
	if (7 * string.len(ply:GetNWInt("money")) + 1) > Width then
		Width = ( 7 * string.len(ply:GetNWInt("money"))) + 1
	end
	
	//Money
	draw.RoundedBox(4, ScrW() / 2 - 25 - (Width / 2), ScrH() - 35, 65 + Width, 25, Color(0,0,0,80))
	draw.SimpleText("Money: $"..Money, "Trebuchet18", ScrW() / 2 - 18 - MoneyWidth, ScrH() - 31, Color(0,200,0,255))
	
	//Enemies
	draw.RoundedBox(4, ScrW() / 2 - 25 - (Width / 2), ScrH() - 60, 65 + Width, 25, Color(0,0,0,80))
	draw.SimpleText("Enemies: "..(TotalEnemys - NPCskilled), "Trebuchet18", ScrW() / 2 - 20 - EnemyWidth, ScrH() - 55, Color(200,0,0,255))
	
	//Health
	if !ply:Alive() then return end
	local MaxHealth = 100 -- Setting max health cuz we nubby
	Health = math.Approach(Health, ply:Health(), 1) -- Fading our health in
	local Width = Health / (math.floor(MaxHealth / 100)) -- Setting width for this crap
	if Width > MaxHealth then -- meh
		Width = MaxHealth
	end
	if Width < 20 then
		Width = 20
	end
	if Health < 0 then
		Health = 0
	end
	local Wadd = 8 * string.len(Health)
	if ply:Alive() then
		draw.RoundedBox(4, 12, ScrH() - 35, Width + 10 + Wadd, 26, Color(0,0,0,80))
		draw.RoundedBox(4, 17, ScrH() - 31, Width, 18, Color(255,0,0,200))
		draw.SimpleText(Health, "Trebuchet18", 19 + Width, ScrH() - 30, Color(255,255,255,200))
		draw.SimpleText("Health", "Trebuchet18", 50 + Width, ScrH() - 30, Color(255,255,255,200))
	end
	
	//Armor
	local MaxArmor = 100 -- Setting max health cuz we nubby
	Armor = math.Approach(Armor, ply:Armor(), 1) -- Getting our health
	local Width = Armor / (math.floor(MaxArmor / 100)) -- Setting width for this crap
	if Width > MaxArmor then -- meh
		Width = MaxArmor
	end
	if Width < 20 then
		Width = 20
	end
	if Armor < 0 then
		Armor = 0
	end
	local Wadd = 8 * string.len(Armor)
	if Armor != 0 then
		draw.RoundedBox(4, 12, ScrH() - 61, Width + 10 + Wadd, 26, Color(0,0,0,80))
		draw.RoundedBox(4, 17, ScrH() - 57, Width, 18, Color(0,0,255,200))
		draw.SimpleText(Armor, "Trebuchet18", 19 + Width, ScrH() - 57, Color(255,255,255,200))
		draw.SimpleText("Armor", "Trebuchet18", 50 + Width, ScrH() - 57, Color(255,255,255,200))
	end
	
	//Ammo
	if ply:GetActiveWeapon():IsValid() then
		local Ammo = ply:GetActiveWeapon():Clip1() // How much ammunition you have inside the current magazine
		local AmmoSide = ply:GetAmmoCount(ply:GetActiveWeapon():GetPrimaryAmmoType()) // How much ammunition you have outside the current magazine
		local AmmoSec = ply:GetAmmoCount(ply:GetActiveWeapon():GetSecondaryAmmoType())
		local AddHeight = -20
		local AmmoSideStr = tostring(AmmoSide)
		
		if AmmoSec != 0 then
			AddHeight = 10
		end
		
		if Ammo < 0 then
			AddHeight = -40
		end
		
		if ply:GetActiveWeapon():GetClass() == "weapon_crowbar" then
			AddHeight = -70
			AmmoSideStr = ""
		end
		
		AmmoHeight = math.Approach(AmmoHeight, 70 + AddHeight, 2.5)
		
		if Ammo > AmmoSide then
			Width = 50 + string.len(Ammo)
		else
			Width = 50 + string.len(AmmoSide)
		end
		
		if AmmoHeight >= 4 then
			draw.RoundedBox(4, ScrW() - 90, (ScrH() - 61) - (AmmoHeight - 50), Width + 10, AmmoHeight, Color(0,0,0,80))
		end
		
		if AmmoHeight >= 50 and Ammo >= 0 then
			draw.SimpleText(Ammo, "Trebuchet20", ScrW() - 20 - Width, ScrH() - 60, Color(255,255,175,200))
			draw.SimpleText("Primary Ammo", "Trebuchet18", ScrW() - 125 - Width, ScrH() - 60, Color(255,255,175,200))
		end
		
		if AmmoHeight >= 30 then
			draw.SimpleText(AmmoSideStr, "Trebuchet20", ScrW() - 20 - Width, ScrH() - 35, Color(255,255,175,200))
			draw.SimpleText("Side Ammo", "Trebuchet18", ScrW() - 105 - Width, ScrH() - 35, Color(255,255,175,200))
		end
		
		if AmmoHeight == (70 + AddHeight) and AmmoSec > 0 then
			draw.SimpleText(AmmoSec, "Trebuchet20", ScrW() - 20 - Width, ScrH() - 85, Color(255,255,175,200))
			draw.SimpleText("Secondary Ammo", "Trebuchet18", ScrW() - 140 - Width, ScrH() - 85, Color(255,255,175,200))
		end
	end
end 
hook.Add("HUDPaint", "BlueWavesHud", hud)
 
local function hidehud(name)
	for k, v in pairs({"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo"}) do
		if name == v then return false end
	end
end
hook.Add("HUDShouldDraw", "HideOldHud", hidehud)