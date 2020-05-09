/datum/technomancer_catalog/spell/audible_deception
	name = "Audible Deception"
	cost = 25
	category = UTILITY_SPELLS
	spell_metadata_paths = list(/datum/spell_metadata/audible_deception)

/datum/spell_metadata/audible_deception
	name = "Audible Deception"
	desc = "Allows you to create a specific sound at a location of your choosing."
	enhancement_desc = "An extremely loud airhorn sound that costs a large amount of energy and instability becomes available, \
	which will deafen and can stun all who are near the targeted tile, including yourself if unprotected."
	aspect = ASPECT_AIR
	icon_state = "tech_audibledeception"
	spell_path = /obj/item/weapon/spell/technomancer/audible_deception
	var/selected_sound = null

/datum/spell_metadata/audible_deception/get_spell_info()
	var/obj/item/weapon/spell/technomancer/audible_deception/spell = spell_path
	. = list()
	.["Energy Cost"] = initial(spell.sound_energy_cost)
	.["Instability Cost"] = initial(spell.sound_instability_cost)
	.["Scepter Airhorn Instability Cost"] = initial(spell.sound_instability_cost) + initial(spell.airhorn_instability_cost)


/obj/item/weapon/spell/technomancer/audible_deception
	name = "audible deception"
	icon_state = "audible_deception"
	desc = "Make them all paranoid!"
	cast_methods = CAST_RANGED | CAST_USE
	var/sound_energy_cost = 100
	var/sound_instability_cost = 1
	var/airhorn_instability_cost = 49
	var/list/available_sounds = list(
		"Blade Slice"			=	'sound/weapons/bladeslice.ogg',
		"Energy Blade Slice"	=	'sound/weapons/blade1.ogg',
		"Explosions"			=	"explosion",
		"Distant Explosion"		=	'sound/effects/explosionfar.ogg',
		"Sparks"				=	"sparks",
		"Punches"				=	"punch",
		"Glass Shattering"		=	"shatter",
		"Grille Damage"			=	'sound/effects/grillehit.ogg',
		"Energy Pulse"			=	'sound/effects/EMPulse.ogg',
		"Airlock"				=	'sound/machines/airlock.ogg',
		"Airlock Creak"			=	'sound/machines/airlock_creaking.ogg',

		"Shotgun Pumping"		=	'sound/weapons/shotgunpump.ogg',
		"Flash"					=	'sound/weapons/flash.ogg',
		"Bite"					=	'sound/weapons/bite.ogg',
		"Gun Firing"			=	'sound/weapons/Gunshot1.ogg',
		"Desert Eagle Firing"	=	'sound/weapons/Gunshot_deagle.ogg',
		"Rifle Firing"			=	'sound/weapons/Gunshot_generic_rifle.ogg',
		"Sniper Rifle Firing"	=	'sound/weapons/Gunshot_sniper.ogg',
		"AT Rifle Firing"		=	'sound/weapons/Gunshot_cannon.ogg',
		"Shotgun Firing"		=	'sound/weapons/Gunshot_shotgun.ogg',
		"Handgun Firing"		=	'sound/weapons/Gunshot2.ogg',
		"Machinegun Firing"		=	'sound/weapons/Gunshot_machinegun.ogg',
		"Rocket Launcher Firing"=	'sound/weapons/rpg.ogg',
		"Taser Firing"			=	'sound/weapons/Taser.ogg',
		"Laser Gun Firing"		=	'sound/weapons/laser.ogg',
		"E-Luger Firing"		=	'sound/weapons/eLuger.ogg',
		"Xray Gun Firing"		=	'sound/weapons/laser3.ogg',
		"Pulse Gun Firing"		=	'sound/weapons/pulse.ogg',
		"Energy Sniper Firing"	=	'sound/weapons/gauss_shoot.ogg',
		"Emitter Firing"		=	'sound/weapons/emitter.ogg',
		"Energy Blade On"		=	'sound/weapons/saberon.ogg',
		"Energy Blade Off"		=	'sound/weapons/saberoff.ogg',
		"Wire Restraints"		=	'sound/weapons/cablecuff.ogg',
		"Handcuffs"				=	'sound/weapons/handcuffs.ogg',

		"Crowbar"				=	'sound/items/Crowbar.ogg',
		"Screwdriver"			=	'sound/items/Screwdriver.ogg',
		"Welding"				=	'sound/items/Welder.ogg',
		"Wirecutting"			=	'sound/items/Wirecutter.ogg',

		"Nymph Chirping"		=	'sound/misc/nymphchirp.ogg',
		"Sad Trombone"			=	'sound/misc/sadtrombone.ogg',
		"Honk"					=	'sound/items/bikehorn.ogg',
		"Bone Fracture"			=	"fracture",
		)

/obj/item/weapon/spell/technomancer/audible_deception/on_use_cast(mob/user)
	var/list/sound_options = available_sounds
	if(check_for_scepter())
		sound_options["!!AIR HORN!!"] = 'sound/items/AirHorn.ogg'
	var/new_sound = input("Select the sound you want to make.","Sounds") as null|anything in sound_options
	if(new_sound)
		var/datum/spell_metadata/audible_deception/audible_meta = meta
		audible_meta.selected_sound = sound_options[new_sound]

/obj/item/weapon/spell/technomancer/audible_deception/on_ranged_cast(atom/hit_atom, mob/living/user)
	var/turf/T = get_turf(hit_atom)
	var/datum/spell_metadata/audible_deception/audible_meta = meta
	if(audible_meta.selected_sound && pay_energy(sound_energy_cost))
		playsound(T, audible_meta.selected_sound, 80, 1, -1)
		adjust_instability(sound_instability_cost)
		// Air Horn time.
		if(audible_meta.selected_sound == 'sound/items/AirHorn.ogg' && check_for_scepter() && pay_energy(3900))
			adjust_instability(airhorn_instability_cost) // Pay for your sins.
			for(var/mob/living/carbon/M in ohearers(6, T))
				if(M.get_ear_protection() >= 2)
					continue
				M.sleeping = 0
				M.stuttering += 20
				M.ear_deaf += 30
				M.Weaken(3)
				if(prob(30))
					M.Stun(10)
					M.Paralyse(4)
				else
					M.make_jittery(50)
				to_chat(M, "<font color='red' size='7'><b>HONK</b></font>")
		return TRUE
	return FALSE
