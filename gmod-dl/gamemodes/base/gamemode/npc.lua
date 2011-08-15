
/*---------------------------------------------------------
   Name: gamemode:OnNPCKilled( entity, attacker, inflictor )
   Desc: The NPC has died
---------------------------------------------------------*/
function GM:OnNPCKilled( ent, attacker, inflictor )
	
	entdrops = {}
	entdrops[1] = "item_ammo_357"
	entdrops[2] = "item_ammo_357_large"
	entdrops[3] = "item_ammo_ar2"
	entdrops[4] = "item_ammo_ar2_altfire"
	entdrops[5] = "item_ammo_ar2_large"
	entdrops[6] = "item_ammo_pistol"
	entdrops[7] = "item_ammo_crossbow"
	entdrops[8] = "item_ammo_pistol_large"
	entdrops[9] = "item_ammo_smg1"
	entdrops[10] = "item_ammo_smg1_grenade"
	entdrops[11] = "item_ammo_smg1_large"
	
	--full list of entities
	/*item_ammo_357
	item_ammo_357_large
    item_ammo_ar2
    item_ammo_ar2_altfire
    item_ammo_ar2_large
    item_ammo_crate
    item_ammo_crossbow
    item_ammo_pistol
    item_ammo_pistol_large
	item_ammo_smg1
    item_ammo_smg1_grenade
    item_ammo_smg1_large
    item_battery
    item_box_buckshot
    item_dynamic resupply
    item_healthcharger
	item_healthkit
    item_healthvial
    item_item_crate
    item_rpg_round
    item_suit
    item_suitcharger
	weapon_357
    weapon_alyxgun
    weapon_annabelle
    weapon_ar2
    weapon_brickbat
    weapon_bugbait
    weapon_citizenpackage
    weapon_citizensuitcase
    weapon_crossbow
    weapon_crowbar
    weapon_extinguisher
    weapon_frag
    weapon_physcannon
    weapon_physgun
    weapon_pistol
    weapon_rpg
    weapon_shotgun
    weapon_smg1
    weapon_stunstick
	*/
	
	local NPCPos = ent:GetPos()
	local SpawnHeight = 35
	local chanceofdrop = math.floor(math.random( 1, 20 ))
	local entnumber = math.floor(math.random( 1, table.Count(entdrops) ))
	
	if chanceofdrop == 20 then
		local Drop = ents.Create( entdrops[entnumber] )
		Drop:SetPos(NPCPos+Vector(0,0,SpawnHeight))
		Drop:Spawn()
		Drop:Activate()
	end
	
	
	// Convert the inflictor to the weapon that they're holding if we can.
	if ( inflictor && inflictor != NULL && attacker == inflictor && (inflictor:IsPlayer() || inflictor:IsNPC()) ) then
	
		inflictor = inflictor:GetActiveWeapon()
		if ( attacker == NULL ) then inflictor = attacker end
	
	end
	
	local InflictorClass = "World"
	local AttackerClass = "World"
	
	if ( inflictor && inflictor != NULL ) then InflictorClass = inflictor:GetClass() end
	if ( attacker  && attacker != NULL ) then AttackerClass = attacker:GetClass() end

	if ( attacker && attacker != NULL && attacker:IsPlayer() ) then
	
		umsg.Start( "PlayerKilledNPC" )
		
			umsg.String( ent:GetClass() )
			umsg.String( InflictorClass )
			umsg.Entity( attacker )
		
		umsg.End()
		
	return end
	
	umsg.Start( "NPCKilledNPC" )
	
		umsg.String( ent:GetClass() )
		umsg.String( InflictorClass )
		umsg.String( AttackerClass )
	
	umsg.End()

end


/*---------------------------------------------------------
   Name: gamemode:ScaleNPCDamage( ply, hitgroup, dmginfo )
   Desc: Scale the damage based on being shot in a hitbox
---------------------------------------------------------*/
function GM:ScaleNPCDamage( npc, hitgroup, dmginfo )

	// More damage if we're shot in the head
	 if ( hitgroup == HITGROUP_HEAD ) then
	 
		dmginfo:ScaleDamage( 0.45 )
	 
	 end
	 
	// Less damage if we're shot in the arms or legs
	if ( hitgroup == HITGROUP_LEFTARM ||
		 hitgroup == HITGROUP_RIGHTARM || 
		 hitgroup == HITGROUP_LEFTLEG ||
		 hitgroup == HITGROUP_RIGHTLEG ||
		 hitgroup == HITGROUP_GEAR ) then
	 
		dmginfo:ScaleDamage( 0.15 )
	 
	 end

end

