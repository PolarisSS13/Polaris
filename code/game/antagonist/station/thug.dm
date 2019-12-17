var/datum/antagonist/thug/thugs

/datum/antagonist/thug
	id = MODE_THUG
	role_type = BE_RENEGADE
	role_text = "Thug"
	role_text_plural = "Thugs"
	bantype = "renegade"
	restricted_jobs = list("AI", "Cyborg","Mayor","Chief of Police","Police Officer",\
	"Prison Warden","Detective","Chief Medical Officer","Chief Engineer","Research Director","Judge")
	welcome_text = "Sometimes, people just need to get messed up.Luckily, that's what you're here to do."
	antag_text = "You are a <b>thug</b>! Within the server rules, do whatever it is \
		that you came to the city to do, be it violence, drug dealing, theft, or \
		just extreme self-defense. Try to make sure other players have <i>fun</i>! \
		This role is for <b>crime breaking gang antics not murderboning.</b><br> \
		<br>This is a <b>teamwork role</b>, roleplay with your fellow gang members \
		and brainstorm what you will do. <b>AOOC</b> may be used."
	flags = ANTAG_SUSPICIOUS | ANTAG_IMPLANT_IMMUNE | ANTAG_RANDSPAWN | ANTAG_VOTABLE
	can_speak_aooc = TRUE
	can_hear_aooc = TRUE
	antaghud_indicator = "thug"
	antag_indicator = "thug"
	initial_spawn_req = 2
	initial_spawn_target = 4

	//Thugs get their own universal outfit, each round.
	var/gang_gimmick = "biker_gang"
	var/nick

	var/hat
	var/uniform
	var/suit
	var/shoes
	var/gloves
	var/accessory
	var/weapon

/datum/antagonist/thug/New()
	..()
	pick_outfit()

/datum/antagonist/thug/proc/get_gang(var/mob/living/carbon/human/gang_mob)
	var/msg

	msg += "<b>Your gang:</b><br>"
	for (var/mob/living/carbon/human/C in mob_list)
		if(C.mind.special_role == "Thug")
			msg += "[nick] <b>[C.name]</b>, the [C.job]. <br>"

	gang_mob << "[msg]"


/datum/antagonist/thug/proc/pick_outfit()
	//Picks a random outfit each round, so thugs have their identity.

	gang_gimmick = pick("skull_crew", "biker_gang", "bandit")

	switch(gang_gimmick)
		if("skull_crew")
			hat = /obj/item/clothing/mask/bandana/skull
			uniform = /obj/item/clothing/under/assistantformal
			suit = /obj/item/clothing/suit/storage/flannel
			shoes = /obj/item/clothing/shoes/hitops/black
			accessory = /obj/item/clothing/accessory/scarf/zebra
			gloves = /obj/item/clothing/gloves/knuckledusters
			weapon = /obj/item/weapon/gun/projectile/pirate
			nick = "Comrade"

		if("biker_gang")
			hat = /obj/item/clothing/mask/bandana/red
			uniform = /obj/item/clothing/under/pants/greyjeans
			suit = /obj/item/clothing/suit/storage/bomber/alt
			shoes = /obj/item/clothing/shoes/boots/combat
			accessory = /obj/item/clothing/accessory/bracelet/material/gold
			gloves = /obj/item/clothing/gloves/fingerless
			weapon = /obj/item/weapon/gun/projectile/luger/brown
			nick = "Biker"

		if("bandit")
			hat = /obj/item/clothing/mask/bandana/gold
			uniform = /obj/item/clothing/under/pants/ripped
			suit = /obj/item/clothing/suit/storage/greyjacket
			shoes = /obj/item/clothing/shoes/boots/combat
			accessory = /obj/item/clothing/mask/balaclava
			gloves = /obj/item/clothing/gloves/brown
			weapon = /obj/item/weapon/gun/projectile/pirate/thug
			nick = "Bandit"

/datum/antagonist/thug/equip(var/mob/living/carbon/human/player)

	if(!..())
		return

	player << "<span class='danger'>You remember that you brought your uniform and weapons in a box with you - as discussed from a meeting with your gang...</span>"

	var/obj/item/weapon/storage/box/kit = new(get_turf(player))
	kit.max_storage_space = 35
	kit.max_w_class = 8
	kit.name = "large strange kit"
	kit.color = "#808080"
	new hat(kit)
	new uniform(kit)
	new suit(kit)
	new shoes(kit)
	new accessory(kit)
	new gloves(kit)
	new weapon(kit)

	// Attempt to put into a container.
	if(player.equip_to_storage(kit))
		return

	// If that failed, attempt to put into any valid non-handslot
	if(player.equip_to_appropriate_slot(kit))
		return

	// If that failed, then finally attempt to at least let the player carry the weapon
	player.put_in_hands(kit)



