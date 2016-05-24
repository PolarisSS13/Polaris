/*
	Global associative list for caching humanoid icons.
	Index format m or f, followed by a string of 0 and 1 to represent bodyparts followed by husk fat hulk skeleton 1 or 0.
	TODO: Proper documentation
	icon_key is [species.race_key][g][husk][fat][hulk][skeleton]
*/
var/global/list/human_icon_cache = list()
var/global/list/tail_icon_cache = list() //key is [species.race_key][r_skin][g_skin][b_skin]
var/global/list/light_overlay_cache = list()

	///////////////////////
	//UPDATE_ICONS SYSTEM//
	///////////////////////
/*
Calling this  a system is perhaps a bit trumped up. It is essentially update_clothing dismantled into its
core parts. The key difference is that when we generate overlays we do not generate either lying or standing
versions. Instead, we generate both and store them in two fixed-length lists, both using the same list-index
(The indexes are in update_icons.dm): Each list for humans is (at the time of writing) of length 19.
This will hopefully be reduced as the system is refined.

	var/overlays_lying[19]			//For the lying down stance
	var/overlays_standing[19]		//For the standing stance

When we call update_icons, the 'lying' variable is checked and then the appropriate list is assigned to our overlays!
That in itself uses a tiny bit more memory (no more than all the ridiculous lists the game has already mind you).

On the other-hand, it should be very CPU cheap in comparison to the old system.
In the old system, we updated all our overlays every life() call, even if we were standing still inside a crate!
or dead!. 25ish overlays, all generated from scratch every second for every xeno/human/monkey and then applied.
More often than not update_clothing was being called a few times in addition to that! CPU was not the only issue,
all those icons had to be sent to every client. So really the cost was extremely cumulative. To the point where
update_clothing would frequently appear in the top 10 most CPU intensive procs during profiling.

Another feature of this new system is that our lists are indexed. This means we can update specific overlays!
So we only regenerate icons when we need them to be updated! This is the main saving for this system.

In practice this means that:
	everytime you fall over, we just switch between precompiled lists. Which is fast and cheap.
	Everytime you do something minor like take a pen out of your pocket, we only update the in-hand overlay
	etc...


There are several things that need to be remembered:

>	Whenever we do something that should cause an overlay to update (which doesn't use standard procs
	( i.e. you do something like l_hand = /obj/item/something new(src) )
	You will need to call the relevant update_inv_* proc:
		update_inv_head()
		update_inv_wear_suit()
		update_inv_gloves()
		update_inv_shoes()
		update_inv_w_uniform()
		update_inv_glasse()
		update_inv_l_hand()
		update_inv_r_hand()
		update_inv_belt()
		update_inv_wear_id()
		update_inv_ears()
		update_inv_s_store()
		update_inv_pockets()
		update_inv_back()
		update_inv_handcuffed()
		update_inv_wear_mask()

	All of these are named after the variable they update from. They are defined at the mob/ level like
	update_clothing was, so you won't cause undefined proc runtimes with usr.update_inv_wear_id() if the usr is a
	slime etc. Instead, it'll just return without doing any work. So no harm in calling it for slimes and such.


>	There are also these special cases:
		update_mutations()	//handles updating your appearance for certain mutations.  e.g TK head-glows
		UpdateDamageIcon()	//handles damage overlays for brute/burn damage //(will rename this when I geta round to it)
		update_body()	//Handles updating your mob's icon to reflect their gender/race/complexion etc
		update_hair()	//Handles updating your hair overlay (used to be update_face, but mouth and
																			...eyes were merged into update_body)
		update_targeted() // Updates the target overlay when someone points a gun at you

>	All of these procs update our overlays_lying and overlays_standing, and then call update_icons() by default.
	If you wish to update several overlays at once, you can set the argument to 0 to disable the update and call
	it manually:
		e.g.
		update_inv_head(0)
		update_inv_l_hand(0)
		update_inv_r_hand()		//<---calls update_icons()

	or equivillantly:
		update_inv_head(0)
		update_inv_l_hand(0)
		update_inv_r_hand(0)
		update_icons()

>	If you need to update all overlays you can use regenerate_icons(). it works exactly like update_clothing used to.

>	I reimplimented an old unused variable which was in the code called (coincidentally) var/update_icon
	It can be used as another method of triggering regenerate_icons(). It's basically a flag that when set to non-zero
	will call regenerate_icons() at the next life() call and then reset itself to 0.
	The idea behind it is icons are regenerated only once, even if multiple events requested it.

This system is confusing and is still a WIP. It's primary goal is speeding up the controls of the game whilst
reducing processing costs. So please bear with me while I iron out the kinks. It will be worth it, I promise.
If I can eventually free var/lying stuff from the life() process altogether, stuns/death/status stuff
will become less affected by lag-spikes and will be instantaneous! :3

If you have any questions/constructive-comments/bugs-to-report/or have a massivly devestated butt...
Please contact me on #coderbus IRC. ~Carn x
*/

//Human Overlays Indexes/////////
#define MUTATIONS_LAYER			1
#define DAMAGE_LAYER			2
#define SURGERY_LEVEL			3		//bs12 specific.
#define UNIFORM_LAYER			4
#define ID_LAYER				5
#define SHOES_LAYER				6
#define GLOVES_LAYER			7
#define BELT_LAYER				8
#define SUIT_LAYER				9
#define ORGAN_OVERLAY_LAYER		10		//for any organs that are bigger than a standard human (Blend() crops images)
#define WINGS_LAYER				11
#define TAIL_LAYER				12		//bs12 specific. this hack is probably gonna come back to haunt me
#define GENITALS_LAYER			13
#define GLASSES_LAYER			14
#define BELT_LAYER_ALT			15
#define SUIT_STORE_LAYER		16
#define BACK_LAYER				17
#define HAIR_LAYER				18		//TODO: make part of head layer?
#define NATURAL_EARS_LAYER		19
#define EARS_LAYER				20
#define FACEMASK_LAYER			21
#define HEAD_LAYER				22
#define COLLAR_LAYER			23
#define HANDCUFF_LAYER			24
#define LEGCUFF_LAYER			25
#define L_HAND_LAYER			26
#define R_HAND_LAYER			27
#define FIRE_LAYER				28		//If you're on fire
#define TARGETED_LAYER			29		//BS12: Layer for the target overlay from weapon targeting system
#define TOTAL_LAYERS			29
//////////////////////////////////

/mob/living/carbon/human
	var/list/overlays_standing[TOTAL_LAYERS]
	var/previous_damage_appearance // store what the body last looked like, so we only have to update it if something changed

//UPDATES OVERLAYS FROM OVERLAYS_LYING/OVERLAYS_STANDING
//this proc is messy as I was forced to include some old laggy cloaking code to it so that I don't break cloakers
//I'll work on removing that stuff by rewriting some of the cloaking stuff at a later date.
/mob/living/carbon/human/update_icons()
	lying_prev = lying	//so we don't update overlays for lying/standing unless our stance changes again
	update_hud()		//TODO: remove the need for this
	overlays.Cut()

	if (icon_update)
		icon = stand_icon
		for(var/image/I in overlays_standing)
			overlays += I

	if(lying && !species.prone_icon) //Only rotate them if we're not drawing a specific icon for being prone.
		var/matrix/M = matrix()
		M.Turn(90)
		M.Scale(size_multiplier)
		M.Translate(1,-6)
		src.transform = M
	else
		var/matrix/M = matrix()
		M.Scale(size_multiplier)
		M.Translate(0, 16*(size_multiplier-1))
		src.transform = M

var/global/list/damage_icon_parts = list()

//DAMAGE OVERLAYS
//constructs damage icon for each organ from mask * damage field and saves it in our overlays_ lists
/mob/living/carbon/human/UpdateDamageIcon(var/update_icons=1)
	// first check whether something actually changed about damage appearance
	var/damage_appearance = ""

	for(var/obj/item/organ/external/O in organs)
		if(O.is_stump())
			continue
		damage_appearance += O.damage_state

	if(damage_appearance == previous_damage_appearance)
		// nothing to do here
		return

	previous_damage_appearance = damage_appearance

	var/icon/standing = new /icon(species.damage_overlays, "00")

	var/image/standing_image = new /image("icon" = standing)

	// blend the individual damage states with our icons
	for(var/obj/item/organ/external/O in organs)
		if(O.is_stump())
			continue

		O.update_icon()
		if(O.damage_state == "00") continue
		var/icon/DI
		var/cache_index = "[O.damage_state]/[O.icon_name]/[species.get_blood_colour(src)]/[species.get_bodytype(src)]"
		if(damage_icon_parts[cache_index] == null)
			DI = new /icon(species.get_damage_overlays(src), O.damage_state)			// the damage icon for whole human
			DI.Blend(new /icon(species.get_damage_mask(src), O.icon_name), ICON_MULTIPLY)	// mask with this organ's pixels
			DI.Blend(species.get_blood_colour(src), ICON_MULTIPLY)
			damage_icon_parts[cache_index] = DI
		else
			DI = damage_icon_parts[cache_index]

		standing_image.overlays += DI

	overlays_standing[DAMAGE_LAYER]	= standing_image

	if(update_icons)   update_icons()

//BASE MOB SPRITE
/mob/living/carbon/human/proc/update_body(var/update_icons=1)
	overlays_standing[ORGAN_OVERLAY_LAYER] = null
	var/husk_color_mod = rgb(96,88,80)
	var/hulk_color_mod = rgb(48,224,40)

	var/husk = (HUSK in src.mutations)
	var/fat = (FAT in src.mutations)
	var/hulk = (HULK in src.mutations)
	var/skeleton = (SKELETON in src.mutations)

	//CACHING: Generate an index key from visible bodyparts.
	//0 = destroyed, 1 = normal, 2 = robotic, 3 = necrotic.

	//Create a new, blank icon for our mob to use.
	if(stand_icon)
		qdel(stand_icon)
	stand_icon = new(species.icon_template ? species.icon_template : 'icons/mob/human.dmi',"blank")

	var/g = "male"
	if(gender == FEMALE)
		g = "female"

	var/icon_key = "[species.get_race_key(src)][g][r_skin][g_skin][b_skin]"
	if(lip_style)
		icon_key += "[lip_style]"
	else
		icon_key += "nolips"
	var/obj/item/organ/internal/eyes/eyes = internal_organs_by_name[O_EYES]
	if(eyes)
		icon_key += "[rgb(eyes.eye_colour[1], eyes.eye_colour[2], eyes.eye_colour[3])]"
	else
		icon_key += "#000000"

	for(var/organ_tag in species.has_limbs)
		var/obj/item/organ/external/part = organs_by_name[organ_tag]
		if(isnull(part) || part.is_stump())
			icon_key += "0"
		else if(part.status & ORGAN_ROBOT)
			icon_key += "2[part.model ? "-[part.model]": ""]"
		else if(part.status & ORGAN_DEAD)
			icon_key += "3"
		else
			icon_key += "1"
		if(part)
			icon_key += "[part.species.get_race_key(part.owner)]"
			icon_key += "[part.dna.GetUIState(DNA_UI_GENDER)]"
			if(part.s_col && part.s_col.len >= 3)
				icon_key += "[rgb(part.s_col[1],part.s_col[2],part.s_col[3])]"
			if(part.body_hair && part.h_col && part.h_col.len >= 3)
				icon_key += "[rgb(part.h_col[1],part.h_col[2],part.h_col[3])]"
			else
				icon_key += "#000000"

	icon_key = "[icon_key][husk ? 1 : 0][fat ? 1 : 0][hulk ? 1 : 0][skeleton ? 1 : 0]"

	var/icon/base_icon
	if(human_icon_cache[icon_key])
		base_icon = human_icon_cache[icon_key]
	else
		//BEGIN CACHED ICON GENERATION.
		var/obj/item/organ/external/chest = get_organ(BP_TORSO)
		base_icon = chest.get_icon()

		for(var/obj/item/organ/external/part in organs)
			var/icon/temp = part.get_icon(skeleton)
			//That part makes left and right legs drawn topmost and lowermost when human looks WEST or EAST
			//And no change in rendering for other parts (they icon_position is 0, so goes to 'else' part)
			if(part.icon_position&(LEFT|RIGHT))
				var/icon/temp2 = new('icons/mob/human.dmi',"blank")
				temp2.Insert(new/icon(temp,dir=NORTH),dir=NORTH)
				temp2.Insert(new/icon(temp,dir=SOUTH),dir=SOUTH)
				if(!(part.icon_position & LEFT))
					temp2.Insert(new/icon(temp,dir=EAST),dir=EAST)
				if(!(part.icon_position & RIGHT))
					temp2.Insert(new/icon(temp,dir=WEST),dir=WEST)
				base_icon.Blend(temp2, ICON_OVERLAY)
				if(part.icon_position & LEFT)
					temp2.Insert(new/icon(temp,dir=EAST),dir=EAST)
				if(part.icon_position & RIGHT)
					temp2.Insert(new/icon(temp,dir=WEST),dir=WEST)
				base_icon.Blend(temp2, ICON_UNDERLAY)
			else
				if(!part.no_blend)
					base_icon.Blend(temp, ICON_OVERLAY)

		if(!skeleton)
			if(husk)
				base_icon.ColorTone(husk_color_mod)
			else if(hulk)
				var/list/tone = ReadRGB(hulk_color_mod)
				base_icon.MapColors(rgb(tone[1],0,0),rgb(0,tone[2],0),rgb(0,0,tone[3]))

		//Handle husk overlay.
		if(husk && ("overlay_husk" in icon_states(species.icobase)))
			var/icon/mask = new(base_icon)
			var/icon/husk_over = new(species.icobase,"overlay_husk")
			mask.MapColors(0,0,0,1, 0,0,0,1, 0,0,0,1, 0,0,0,1, 0,0,0,0)
			husk_over.Blend(mask, ICON_ADD)
			base_icon.Blend(husk_over, ICON_OVERLAY)

		human_icon_cache[icon_key] = base_icon

	//END CACHED ICON GENERATION.
	stand_icon.Blend(base_icon,ICON_OVERLAY)

	//Underwear
	if(underwear_top && species.appearance_flags & HAS_UNDERWEAR)
		stand_icon.Blend(new /icon('icons/mob/human.dmi', underwear_top), ICON_OVERLAY)
	if(underwear_bottom && species.appearance_flags & HAS_UNDERWEAR)
		stand_icon.Blend(new /icon('icons/mob/human.dmi', underwear_bottom), ICON_OVERLAY)

	if(undershirt && species.appearance_flags & HAS_UNDERWEAR)
		stand_icon.Blend(new /icon('icons/mob/human.dmi', undershirt), ICON_OVERLAY)

	if(socks && species.appearance_flags & HAS_UNDERWEAR)
		stand_icon.Blend(new /icon('icons/mob/human.dmi', socks), ICON_OVERLAY)

	for(var/obj/item/organ/external/E in organs)
		if(E.no_blend)
			var/image/S = image("icon" = E.get_icon(skeleton), "icon_state" = E.mob_icon_state, "pixel_x" = E.offset_x, "pixel_y" = E.offset_y)
			overlays_standing[ORGAN_OVERLAY_LAYER] = S

	if(update_icons)
		update_icons()


//HAIR OVERLAY
/mob/living/carbon/human/proc/update_hair(var/update_icons=1)
	//Reset our hair
	overlays_standing[HAIR_LAYER]	= null

	var/obj/item/organ/external/head/head_organ = get_organ(BP_HEAD)
	if(!head_organ || head_organ.is_stump() )
		if(update_icons)   update_icons()
		return

	//masks and helmets can obscure our hair.
	if( (head && (head.flags_inv & BLOCKHAIR)) || (wear_mask && (wear_mask.flags_inv & BLOCKHAIR)))
		if(update_icons)   update_icons()
		return

	//base icons
	var/icon/face_standing	= new /icon('icons/mob/human_face.dmi',"bald_s")

	if(f_style)
		var/datum/sprite_accessory/facial_hair_style = facial_hair_styles_list[f_style]
		if(facial_hair_style && facial_hair_style.species_allowed && (src.species.get_bodytype(src) in facial_hair_style.species_allowed))
			var/icon/facial_s = new/icon("icon" = facial_hair_style.icon, "icon_state" = "[facial_hair_style.icon_state]_s")
			if(facial_hair_style.do_colouration)
				facial_s.Blend(rgb(r_facial, g_facial, b_facial), ICON_MULTIPLY)

			face_standing.Blend(facial_s, ICON_OVERLAY)

	if(h_style && !(head && (head.flags_inv & BLOCKHEADHAIR)))
		var/datum/sprite_accessory/hair_style = hair_styles_list[h_style]
		if(hair_style && (src.species.get_bodytype(src) in hair_style.species_allowed))
			var/icon/hair_s = new/icon("icon" = hair_style.icon, "icon_state" = "[hair_style.icon_state]_s")
			if(hair_style.do_colouration)
				hair_s.Blend(rgb(r_hair, g_hair, b_hair), ICON_MULTIPLY)

			face_standing.Blend(hair_s, ICON_OVERLAY)

	if(head_organ.nonsolid)
		face_standing += rgb(,,,120)

	overlays_standing[HAIR_LAYER]	= image(face_standing)

	if(update_icons)   update_icons()

/mob/living/carbon/human/update_mutations(var/update_icons=1)
	var/fat
	if(FAT in mutations)
		fat = "fat"

	var/image/standing	= image("icon" = 'icons/effects/genetics.dmi')
	var/add_image = 0
	var/g = "m"
	if(gender == FEMALE)	g = "f"
	// DNA2 - Drawing underlays.
	for(var/datum/dna/gene/gene in dna_genes)
		if(!gene.block)
			continue
		if(gene.is_active(src))
			var/underlay=gene.OnDrawUnderlays(src,g,fat)
			if(underlay)
				standing.underlays += underlay
				add_image = 1
	for(var/mut in mutations)
		switch(mut)
			/*
			if(HULK)
				if(fat)
					standing.underlays	+= "hulk_[fat]_s"
				else
					standing.underlays	+= "hulk_[g]_s"
				add_image = 1
			if(COLD_RESISTANCE)
				standing.underlays	+= "fire[fat]_s"
				add_image = 1
			if(TK)
				standing.underlays	+= "telekinesishead[fat]_s"
				add_image = 1
			*/
			if(LASER)
				standing.overlays	+= "lasereyes_s"
				add_image = 1
	if(add_image)
		overlays_standing[MUTATIONS_LAYER]	= standing
	else
		overlays_standing[MUTATIONS_LAYER]	= null
	if(update_icons)   update_icons()

/* --------------------------------------- */
//For legacy support.
/mob/living/carbon/human/regenerate_icons()
	..()
	if(transforming)		return

	update_mutations(0)
	update_body(0)
	update_hair(0)
	update_inv_w_uniform(0)
	update_inv_wear_id(0)
	update_inv_gloves(0)
	update_inv_glasses(0)
	update_inv_ears(0)
	update_inv_shoes(0)
	update_inv_s_store(0)
	update_inv_wear_mask(0)
	update_inv_head(0)
	update_inv_belt(0)
	update_inv_back(0)
	update_inv_wear_suit(0)
	update_inv_r_hand(0)
	update_inv_l_hand(0)
	update_inv_handcuffed(0)
	update_inv_legcuffed(0)
	update_inv_pockets(0)
	update_fire(0)
	update_surgery(0)
	UpdateDamageIcon()
	update_icons()
	//Hud Stuff
	update_hud()

/* --------------------------------------- */
//vvvvvv UPDATE_INV PROCS vvvvvv

/mob/living/carbon/human/update_inv_w_uniform(var/update_icons=1)
	if(w_uniform && istype(w_uniform, /obj/item/clothing/under) )
		w_uniform.screen_loc = ui_iclothing

		//determine the icon to use
		var/icon/under_icon
		if(w_uniform.icon_override)
			under_icon = w_uniform.icon_override
		else if(w_uniform.sprite_sheets && w_uniform.sprite_sheets[species.get_bodytype(src)])
			under_icon = w_uniform.sprite_sheets[species.get_bodytype(src)]
		else if(w_uniform.item_icons && w_uniform.item_icons[slot_w_uniform_str])
			under_icon = w_uniform.item_icons[slot_w_uniform_str]
		else
			under_icon = INV_W_UNIFORM_DEF_ICON

		//determine state to use
		var/under_state
		if(w_uniform.item_state_slots && w_uniform.item_state_slots[slot_w_uniform_str])
			under_state = w_uniform.item_state_slots[slot_w_uniform_str]
		else if(w_uniform.item_state)
			under_state = w_uniform.item_state
		else
			under_state = w_uniform.icon_state

		//need to append _s to the icon state for legacy compatibility
		var/image/standing = image(icon = under_icon, icon_state = "[under_state]_s")
		standing.color = w_uniform.color

		//apply blood overlay
		if(w_uniform.blood_DNA)
			var/image/bloodsies	= image(icon = species.get_blood_mask(src), icon_state = "uniformblood")
			bloodsies.color		= w_uniform.blood_color
			standing.overlays	+= bloodsies

		//accessories
		var/obj/item/clothing/under/under = w_uniform
		if(under.accessories.len)
			for(var/obj/item/clothing/accessory/A in under.accessories)
				standing.overlays |= A.get_mob_overlay()

		overlays_standing[UNIFORM_LAYER]	= standing
	else
		overlays_standing[UNIFORM_LAYER]	= null

	update_genitals_showing(0)

	//hiding/revealing shoes if necessary
	update_inv_shoes(0)

	if(update_icons)
		update_icons()

/mob/living/carbon/human/update_inv_wear_id(var/update_icons=1)
	if(wear_id)
		wear_id.screen_loc = ui_id	//TODO
		if(w_uniform && w_uniform:displays_id)
			var/image/standing
			if(wear_id.icon_override)
				standing = image("icon" = wear_id.icon_override, "icon_state" = "[icon_state]")
			else if(wear_id.sprite_sheets && wear_id.sprite_sheets[species.get_bodytype(src)])
				standing = image("icon" = wear_id.sprite_sheets[species.get_bodytype(src)], "icon_state" = "[icon_state]")
			else
				standing = image("icon" = 'icons/mob/mob.dmi', "icon_state" = "id")
			overlays_standing[ID_LAYER] = standing
		else
			overlays_standing[ID_LAYER]	= null
	else
		overlays_standing[ID_LAYER]	= null

	BITSET(hud_updateflag, ID_HUD)
	BITSET(hud_updateflag, WANTED_HUD)

	if(update_icons)   update_icons()

/mob/living/carbon/human/update_inv_gloves(var/update_icons=1)
	if(gloves)
		var/t_state = gloves.item_state
		if(!t_state)	t_state = gloves.icon_state

		var/image/standing
		if(gloves.icon_override)
			standing = image("icon" = gloves.icon_override, "icon_state" = "[t_state]")
		else if(gloves.sprite_sheets && gloves.sprite_sheets[species.get_bodytype(src)])
			standing = image("icon" = gloves.sprite_sheets[species.get_bodytype(src)], "icon_state" = "[t_state]")
		else
			standing = image("icon" = 'icons/mob/hands.dmi', "icon_state" = "[t_state]")

		if(gloves.blood_DNA)
			var/image/bloodsies	= image("icon" = species.get_blood_mask(src), "icon_state" = "bloodyhands")
			bloodsies.color = gloves.blood_color
			standing.overlays	+= bloodsies
		gloves.screen_loc = ui_gloves
		standing.color = gloves.color
		overlays_standing[GLOVES_LAYER]	= standing
	else
		if(blood_DNA)
			var/image/bloodsies	= image("icon" = species.get_blood_mask(src), "icon_state" = "bloodyhands")
			bloodsies.color = hand_blood_color
			overlays_standing[GLOVES_LAYER]	= bloodsies
		else
			overlays_standing[GLOVES_LAYER]	= null
	if(update_icons)   update_icons()


/mob/living/carbon/human/update_inv_glasses(var/update_icons=1)
	if(glasses)
		var/image/standing
		if(glasses.icon_override)
			standing = image("icon" = glasses.icon_override, "icon_state" = "[glasses.icon_state]")
		else if(glasses.sprite_sheets && glasses.sprite_sheets[species.get_bodytype(src)])
			standing = image("icon" = glasses.sprite_sheets[species.get_bodytype(src)], "icon_state" = "[glasses.icon_state]")
		else
			standing = image("icon" = 'icons/mob/eyes.dmi', "icon_state" = "[glasses.icon_state]")
		standing.color = glasses.color
		overlays_standing[GLASSES_LAYER] = standing

	else
		overlays_standing[GLASSES_LAYER]	= null
	if(update_icons)   update_icons()

/mob/living/carbon/human/update_inv_ears(var/update_icons=1)
	overlays_standing[EARS_LAYER] = null
	if( (head && (head.flags_inv & (BLOCKHAIR | BLOCKHEADHAIR))) || (wear_mask && (wear_mask.flags_inv & (BLOCKHAIR | BLOCKHEADHAIR))))
		if(update_icons)   update_icons()
		return

	if(l_ear || r_ear)
		var/image/both = image("icon" = 'icons/effects/effects.dmi', "icon_state" = "nothing")

		if(l_ear)
			var/image/standing
			var/t_type = l_ear.icon_state
			if(l_ear.icon_override)
				t_type = "[t_type]_l"
				standing = image("icon" = l_ear.icon_override, "icon_state" = "[t_type]")
			else if(l_ear.sprite_sheets && l_ear.sprite_sheets[species.get_bodytype(src)])
				t_type = "[t_type]_l"
				standing = image("icon" = l_ear.sprite_sheets[species.get_bodytype(src)], "icon_state" = "[t_type]")
			else
				standing = image("icon" = 'icons/mob/ears.dmi', "icon_state" = "[t_type]")
			standing.color = l_ear.color
			both.overlays += standing

		if(r_ear)
			var/image/standing
			var/t_type = r_ear.icon_state
			if(r_ear.icon_override)
				t_type = "[t_type]_r"
				standing = image("icon" = r_ear.icon_override, "icon_state" = "[t_type]")
			else if(r_ear.sprite_sheets && r_ear.sprite_sheets[species.get_bodytype(src)])
				t_type = "[t_type]_r"
				standing = image("icon" = r_ear.sprite_sheets[species.get_bodytype(src)], "icon_state" = "[t_type]")
			else
				standing = image("icon" = 'icons/mob/ears.dmi', "icon_state" = "[t_type]")
			standing.color = r_ear.color
			both.overlays += standing

		overlays_standing[EARS_LAYER] = both

	else
		overlays_standing[EARS_LAYER]	= null
	update_ears(0)
	if(update_icons)   update_icons()

/mob/living/carbon/human/update_inv_shoes(var/update_icons=1)
	if(shoes && !((wear_suit && wear_suit.flags_inv & HIDESHOES) || (w_uniform && w_uniform.flags_inv & HIDESHOES)))

		var/image/standing
		if(shoes.icon_override)
			standing = image("icon" = shoes.icon_override, "icon_state" = "[shoes.icon_state]")
		else if(shoes.sprite_sheets && shoes.sprite_sheets[species.get_bodytype(src)])
			standing = image("icon" = shoes.sprite_sheets[species.get_bodytype(src)], "icon_state" = "[shoes.icon_state]")
		else
			standing = image("icon" = 'icons/mob/feet.dmi', "icon_state" = "[shoes.icon_state]")

		if(shoes.blood_DNA)
			var/image/bloodsies = image("icon" = species.get_blood_mask(src), "icon_state" = "shoeblood")
			bloodsies.color = shoes.blood_color
			standing.overlays += bloodsies
		standing.color = shoes.color
		overlays_standing[SHOES_LAYER] = standing
	else
		if(feet_blood_DNA)
			var/image/bloodsies = image("icon" = species.get_blood_mask(src), "icon_state" = "shoeblood")
			bloodsies.color = feet_blood_color
			overlays_standing[SHOES_LAYER] = bloodsies
		else
			overlays_standing[SHOES_LAYER] = null
	if(update_icons)   update_icons()

/mob/living/carbon/human/update_inv_s_store(var/update_icons=1)
	if(s_store)
		var/t_state = s_store.item_state
		if(!t_state)	t_state = s_store.icon_state
		overlays_standing[SUIT_STORE_LAYER]	= image("icon" = 'icons/mob/belt_mirror.dmi', "icon_state" = "[t_state]")
		s_store.screen_loc = ui_sstore1		//TODO
	else
		overlays_standing[SUIT_STORE_LAYER]	= null
	if(update_icons)   update_icons()


/mob/living/carbon/human/update_inv_head(var/update_icons=1)
	if(head)
		head.screen_loc = ui_head		//TODO

		//Determine the icon to use
		var/t_icon
		if(head.icon_override)
			t_icon = head.icon_override
		else if(head.sprite_sheets && head.sprite_sheets[species.get_bodytype(src)])
			t_icon = head.sprite_sheets[species.get_bodytype(src)]

		else if(head.item_icons && (slot_head_str in head.item_icons))
			t_icon = head.item_icons[slot_head_str]
		else
			t_icon = INV_HEAD_DEF_ICON

		//Determine the state to use
		var/t_state
		if(istype(head, /obj/item/weapon/paper))
			/* I don't like this, but bandaid to fix half the hats in the game
			   being completely broken without re-breaking paper hats */
			t_state = "paper"
		else
			if(head.item_state_slots && head.item_state_slots[slot_head_str])
				t_state = head.item_state_slots[slot_head_str]
			else if(head.item_state)
				t_state = head.item_state
			else
				t_state = head.icon_state

		//Create the image
		var/image/standing = image(icon = t_icon, icon_state = t_state)

		if(head.blood_DNA)
			var/image/bloodsies = image("icon" = species.get_blood_mask(src), "icon_state" = "helmetblood")
			bloodsies.color = head.blood_color
			standing.overlays	+= bloodsies

		if(istype(head,/obj/item/clothing/head))
			var/obj/item/clothing/head/hat = head
			var/cache_key = "[hat.light_overlay]_[species.get_bodytype(src)]"
			if(hat.on && light_overlay_cache[cache_key])
				standing.overlays |= light_overlay_cache[cache_key]

		standing.color = head.color
		overlays_standing[HEAD_LAYER] = standing

	else
		overlays_standing[HEAD_LAYER]	= null
	if(update_icons)   update_icons()

/mob/living/carbon/human/update_inv_belt(var/update_icons=1)
	if(belt)
		belt.screen_loc = ui_belt	//TODO
		var/t_state = belt.item_state
		if(!t_state)	t_state = belt.icon_state
		var/image/standing	= image("icon_state" = "[t_state]")

		if(belt.icon_override)
			standing.icon = belt.icon_override
		else if(belt.sprite_sheets && belt.sprite_sheets[species.get_bodytype(src)])
			standing.icon = belt.sprite_sheets[species.get_bodytype(src)]
		else
			standing.icon = 'icons/mob/belt.dmi'

		var/belt_layer = BELT_LAYER
		if(istype(belt, /obj/item/weapon/storage/belt))
			var/obj/item/weapon/storage/belt/ubelt = belt
			if(ubelt.show_above_suit)
				overlays_standing[BELT_LAYER] = null
				belt_layer = BELT_LAYER_ALT
			else
				overlays_standing[BELT_LAYER_ALT] = null
			if(belt.contents.len)
				for(var/obj/item/i in belt.contents)
					var/i_state = i.item_state
					if(!i_state) i_state = i.icon_state
					standing.overlays	+= image("icon" = 'icons/mob/belt.dmi', "icon_state" = "[i_state]")

		standing.color = belt.color

		overlays_standing[belt_layer] = standing
	else
		overlays_standing[BELT_LAYER] = null
		overlays_standing[BELT_LAYER_ALT] = null
	if(update_icons)   update_icons()


/mob/living/carbon/human/update_inv_wear_suit(var/update_icons=1)

	if( wear_suit && istype(wear_suit, /obj/item/) )
		wear_suit.screen_loc = ui_oclothing

		var/image/standing

		var/t_icon = INV_SUIT_DEF_ICON
		if(wear_suit.icon_override)
			t_icon = wear_suit.icon_override
		else if(wear_suit.sprite_sheets && wear_suit.sprite_sheets[species.get_bodytype(src)])
			t_icon = wear_suit.sprite_sheets[species.name]
		else if(wear_suit.item_icons && wear_suit.item_icons[slot_wear_suit_str])
			t_icon = wear_suit.item_icons[slot_wear_suit_str]

		standing = image("icon" = t_icon, "icon_state" = "[wear_suit.icon_state]")
		standing.color = wear_suit.color

		if( istype(wear_suit, /obj/item/clothing/suit/straight_jacket) )
			drop_from_inventory(handcuffed)
			drop_l_hand()
			drop_r_hand()

		if(wear_suit.blood_DNA)
			var/obj/item/clothing/suit/S = wear_suit
			if(istype(S)) //You can put non-suits in your suit slot (diona nymphs etc).
				var/image/bloodsies = image("icon" = species.get_blood_mask(src), "icon_state" = "[S.blood_overlay_type]blood")
				bloodsies.color = wear_suit.blood_color
				standing.overlays	+= bloodsies

		overlays_standing[SUIT_LAYER]	= standing

	else
		overlays_standing[SUIT_LAYER]	= null

	update_inv_shoes(0)
	update_tail_showing(0)
	update_genitals_showing(0)
	update_wings(0)
	update_ears(0)
	update_collar(0)
	//hide/show shoes if necessary
	update_inv_shoes(0)

	if(update_icons)   update_icons()

/mob/living/carbon/human/update_inv_pockets(var/update_icons=1)
	if(l_store)			l_store.screen_loc = ui_storage1	//TODO
	if(r_store)			r_store.screen_loc = ui_storage2	//TODO
	if(update_icons)	update_icons()


/mob/living/carbon/human/update_inv_wear_mask(var/update_icons=1)
	if( wear_mask && ( istype(wear_mask, /obj/item/clothing/mask) || istype(wear_mask, /obj/item/clothing/accessory) || istype(wear_mask, /obj/item/weapon/grenade) ) && !(head && head.flags_inv & HIDEMASK))
		wear_mask.screen_loc = ui_mask	//TODO

		var/image/standing
		if(wear_mask.icon_override)
			standing = image("icon" = wear_mask.icon_override, "icon_state" = "[wear_mask.icon_state]")
		else if(wear_mask.sprite_sheets && wear_mask.sprite_sheets[species.get_bodytype(src)])
			standing = image("icon" = wear_mask.sprite_sheets[species.get_bodytype(src)], "icon_state" = "[wear_mask.icon_state]")
		else
			standing = image("icon" = 'icons/mob/mask.dmi', "icon_state" = "[wear_mask.icon_state]")
		standing.color = wear_mask.color

		if( !istype(wear_mask, /obj/item/clothing/mask/smokable/cigarette) && wear_mask.blood_DNA )
			var/image/bloodsies = image("icon" = species.get_blood_mask(src), "icon_state" = "maskblood")
			bloodsies.color = wear_mask.blood_color
			standing.overlays	+= bloodsies
		overlays_standing[FACEMASK_LAYER]	= standing
	else
		overlays_standing[FACEMASK_LAYER]	= null
	if(update_icons)   update_icons()


/mob/living/carbon/human/update_inv_back(var/update_icons=1)
	if(back)
		back.screen_loc = ui_back	//TODO

		//determine the icon to use
		var/icon/overlay_icon
		if(back.icon_override)
			overlay_icon = back.icon_override
		else if(istype(back, /obj/item/weapon/rig))
			//If this is a rig and a mob_icon is set, it will take species into account in the rig update_icon() proc.
			var/obj/item/weapon/rig/rig = back
			overlay_icon = rig.mob_icon
		else if(back.sprite_sheets && back.sprite_sheets[species.get_bodytype(src)])
			overlay_icon = back.sprite_sheets[species.get_bodytype(src)]
		else if(back.item_icons && (slot_back_str in back.item_icons))
			overlay_icon = back.item_icons[slot_back_str]
		else
			overlay_icon = INV_BACK_DEF_ICON

		//determine state to use
		var/overlay_state
		if(back.item_state_slots && back.item_state_slots[slot_back_str])
			overlay_state = back.item_state_slots[slot_back_str]
		else if(back.item_state)
			overlay_state = back.item_state
		else
			overlay_state = back.icon_state

		//apply color
		var/image/standing = image(icon = overlay_icon, icon_state = overlay_state)
		standing.color = back.color

		//create the image
		overlays_standing[BACK_LAYER] = standing
	else
		overlays_standing[BACK_LAYER] = null

	if(update_icons)
		update_icons()


/mob/living/carbon/human/update_hud()	//TODO: do away with this if possible
	if(client)
		client.screen |= contents
		if(hud_used)
			hud_used.hidden_inventory_update() 	//Updates the screenloc of the items on the 'other' inventory bar


/mob/living/carbon/human/update_inv_handcuffed(var/update_icons=1)
	if(handcuffed)
		drop_r_hand()
		drop_l_hand()
		stop_pulling()	//TODO: should be handled elsewhere

		var/image/standing
		if(handcuffed.icon_override)
			standing = image("icon" = handcuffed.icon_override, "icon_state" = "handcuff1")
		else if(handcuffed.sprite_sheets && handcuffed.sprite_sheets[species.get_bodytype(src)])
			standing = image("icon" = handcuffed.sprite_sheets[species.get_bodytype(src)], "icon_state" = "handcuff1")
		else
			standing = image("icon" = 'icons/mob/mob.dmi', "icon_state" = "handcuff1")
		overlays_standing[HANDCUFF_LAYER] = standing

	else
		overlays_standing[HANDCUFF_LAYER]	= null
	if(update_icons)   update_icons()

/mob/living/carbon/human/update_inv_legcuffed(var/update_icons=1)
	if(legcuffed)

		var/image/standing
		if(legcuffed.icon_override)
			standing = image("icon" = legcuffed.icon_override, "icon_state" = "legcuff1")
		else if(legcuffed.sprite_sheets && legcuffed.sprite_sheets[species.get_bodytype(src)])
			standing = image("icon" = legcuffed.sprite_sheets[species.get_bodytype(src)], "icon_state" = "legcuff1")
		else
			standing = image("icon" = 'icons/mob/mob.dmi', "icon_state" = "legcuff1")
		overlays_standing[LEGCUFF_LAYER] = standing

		if(src.m_intent != "walk")
			src.m_intent = "walk"
			if(src.hud_used && src.hud_used.move_intent)
				src.hud_used.move_intent.icon_state = "walking"

	else
		overlays_standing[LEGCUFF_LAYER]	= null
	if(update_icons)   update_icons()


/mob/living/carbon/human/update_inv_r_hand(var/update_icons=1)
	if(r_hand)
		r_hand.screen_loc = ui_rhand	//TODO

		//determine icon state to use
		var/t_state
		if(r_hand.item_state_slots && r_hand.item_state_slots[slot_r_hand_str])
			t_state = r_hand.item_state_slots[slot_r_hand_str]
		else if(r_hand.item_state)
			t_state = r_hand.item_state
		else
			t_state = r_hand.icon_state

		//determine icon to use
		var/icon/t_icon
		if(r_hand.item_icons && (slot_r_hand_str in r_hand.item_icons))
			t_icon = r_hand.item_icons[slot_r_hand_str]
		else if(r_hand.icon_override)
			t_state += "_r"
			t_icon = r_hand.icon_override
		else
			t_icon = INV_R_HAND_DEF_ICON

		//apply color
		var/image/standing = image(icon = t_icon, icon_state = t_state)
		standing.color = r_hand.color

		overlays_standing[R_HAND_LAYER] = standing

		if (handcuffed) drop_r_hand() //this should be moved out of icon code
	else
		overlays_standing[R_HAND_LAYER] = null

	if(update_icons) update_icons()


/mob/living/carbon/human/update_inv_l_hand(var/update_icons=1)
	if(l_hand)
		l_hand.screen_loc = ui_lhand	//TODO

		//determine icon state to use
		var/t_state
		if(l_hand.item_state_slots && l_hand.item_state_slots[slot_l_hand_str])
			t_state = l_hand.item_state_slots[slot_l_hand_str]
		else if(l_hand.item_state)
			t_state = l_hand.item_state
		else
			t_state = l_hand.icon_state

		//determine icon to use
		var/icon/t_icon
		if(l_hand.item_icons && (slot_l_hand_str in l_hand.item_icons))
			t_icon = l_hand.item_icons[slot_l_hand_str]
		else if(l_hand.icon_override)
			t_state += "_l"
			t_icon = l_hand.icon_override
		else
			t_icon = INV_L_HAND_DEF_ICON

		//apply color
		var/image/standing = image(icon = t_icon, icon_state = t_state)
		standing.color = l_hand.color

		overlays_standing[L_HAND_LAYER] = standing

		if (handcuffed) drop_l_hand() //This probably should not be here
	else
		overlays_standing[L_HAND_LAYER] = null

	if(update_icons) update_icons()


//Adds a collar overlay above the helmet layer if the suit has one
//	Suit needs an identically named sprite in icons/mob/collar.dmi
/mob/living/carbon/human/proc/update_collar(var/update_icons=1)
	var/icon/C = new('icons/mob/collar.dmi')
	var/image/standing = null

	if(wear_suit)
		if(wear_suit.icon_state in C.IconStates())
			standing = image("icon" = C, "icon_state" = "[wear_suit.icon_state]")

	overlays_standing[COLLAR_LAYER]	= standing

	if(update_icons)   update_icons()


/mob/living/carbon/human/update_fire(var/update_icons=1)
	overlays_standing[FIRE_LAYER] = null
	if(on_fire)
		overlays_standing[FIRE_LAYER] = image("icon"='icons/mob/OnFire.dmi', "icon_state"="Standing", "layer"=FIRE_LAYER)

	if(update_icons)   update_icons()

/mob/living/carbon/human/proc/update_surgery(var/update_icons=1)
	overlays_standing[SURGERY_LEVEL] = null
	var/image/total = new
	for(var/obj/item/organ/external/E in organs)
		if(E.open)
			var/image/I = image("icon"='icons/mob/surgery.dmi', "icon_state"="[E.name][round(E.open)]", "layer"=-SURGERY_LEVEL)
			total.overlays += I
	overlays_standing[SURGERY_LEVEL] = total
	if(update_icons)   update_icons()

//Eros Stuff

/mob/living/carbon/human/proc/update_genitals_showing(var/update_icons=1)
	overlays_standing[GENITALS_LAYER] = null
	if(species.appearance_flags & HAS_UNDERWEAR)
		var/datum/sprite_accessory/breasts = body_breast_list[c_type]
		var/datum/sprite_accessory/vaginas = body_vaginas_list[v_type]
		var/datum/sprite_accessory/dicks = body_dicks_list[d_type]
		var/icon/genitals_standing	=new /icon('icons/mob/human_face.dmi',"bald_s") //blank icon by excelency
		if(breasts && breasts.species_allowed && (src.species.get_bodytype() in breasts.species_allowed))
			if(!(w_uniform && (w_uniform.body_parts_covered & UPPER_TORSO)) && !(wear_suit && (wear_suit.body_parts_covered & UPPER_TORSO)))
				var/icon/breasts_s = new/icon("icon" = breasts.icon, "icon_state" = breasts.icon_state)
				if(breasts.do_colouration)
					breasts_s.Blend(rgb(r_skin, g_skin, b_skin), ICON_MULTIPLY)
				genitals_standing.Blend(breasts_s, ICON_OVERLAY)
		if(vaginas && vaginas.species_allowed && (src.species.get_bodytype() in vaginas.species_allowed))
			if(!(w_uniform && (w_uniform.body_parts_covered & LOWER_TORSO)) && !(wear_suit && (wear_suit.body_parts_covered & LOWER_TORSO)))
				var/icon/vaginas_s = new/icon("icon" = vaginas.icon, "icon_state" = vaginas.icon_state)
				if(vaginas.do_colouration)
					vaginas_s.Blend(rgb(r_genital, g_genital, b_genital), ICON_MULTIPLY)
				genitals_standing.Blend(vaginas_s, ICON_OVERLAY)
		if(dicks && dicks.species_allowed && (src.species.get_bodytype() in dicks.species_allowed))
			if(!(w_uniform && (w_uniform.body_parts_covered & LOWER_TORSO)) && !(wear_suit && (wear_suit.body_parts_covered & LOWER_TORSO)))
				var/icon/dicks_s = new/icon("icon" = dicks.icon, "icon_state" = dicks.icon_state)
				if(dicks.do_colouration)
					dicks_s.Blend(rgb(r_genital, g_genital, b_genital), ICON_MULTIPLY)
				genitals_standing.Blend(dicks_s, ICON_OVERLAY)
		overlays_standing[GENITALS_LAYER] = image(genitals_standing)
	if(update_icons)
		update_icons()

/mob/living/carbon/human/proc/update_tail_showing(var/update_icons=1)
	overlays_standing[TAIL_LAYER] = null

	if(species.appearance_flags & HAS_UNDERWEAR) //change has underwear to a more sane flag when needed
		var/icon/tail_standing	=new /icon('icons/mob/human_face.dmi',"bald_s")
		var/datum/sprite_accessory/tail = body_tails_list[tail_type]
		if (wear_suit && wear_suit.flags_inv & HIDETAIL)
		else
			if(tail && tail.species_allowed && (src.species.get_bodytype() in tail.species_allowed))
				var/icon/tail_s = new/icon("icon" = tail.icon, "icon_state" = tail.icon_state)
				if(tail.do_colouration)
					tail_s.Blend(rgb(r_tail, g_tail, b_tail), ICON_MULTIPLY)
				tail_standing.Blend(tail_s, ICON_OVERLAY)
		overlays_standing[TAIL_LAYER] = image(tail_standing)

	if(update_icons)
		update_icons()

/mob/living/carbon/human/proc/update_ears(var/update_icons=1)
	overlays_standing[NATURAL_EARS_LAYER] = null
	if(species.appearance_flags & HAS_UNDERWEAR) //change to different flag when justified.
		var/icon/ears_standing	=new /icon('icons/mob/human_face.dmi',"bald_s")
		var/datum/sprite_accessory/ears = body_ears_list[ears_type]
		if( (head && (head.flags_inv & (BLOCKHAIR | BLOCKHEADHAIR))) || (wear_mask && (wear_mask.flags_inv & (BLOCKHAIR | BLOCKHEADHAIR))))
			if(update_icons)   update_icons()
			return
		if(ears && ears.species_allowed && (src.species.get_bodytype() in ears.species_allowed))
			var/icon/ears_s = new/icon("icon" = ears.icon, "icon_state" = ears.icon_state)
			if(ears.do_colouration)
				ears_s.Blend(rgb(r_ears, g_ears, b_ears), ICON_MULTIPLY)
			ears_standing.Blend(ears_s, ICON_OVERLAY)
		overlays_standing[NATURAL_EARS_LAYER] = image(ears_standing)
	if(update_icons)
		update_icons()

/mob/living/carbon/human/proc/update_wings(var/update_icons=1)
	overlays_standing[WINGS_LAYER] = null
	if(species.appearance_flags & HAS_UNDERWEAR) //change to different flag when justified.
		var/icon/wings_standing	=new /icon('icons/mob/human_face.dmi',"bald_s")
		var/datum/sprite_accessory/wings = body_wings_list[wings_type]
		if(wings && wings.species_allowed && (src.species.get_bodytype() in wings.species_allowed))
			var/icon/wings_s = new/icon("icon" = wings.icon, "icon_state" = wings.icon_state)
			if(wings.do_colouration)
				wings_s.Blend(rgb(r_wings, g_wings, b_wings), ICON_MULTIPLY)
			wings_standing.Blend(wings_s, ICON_OVERLAY)
		overlays_standing[WINGS_LAYER] = image(wings_standing)
	if(update_icons)
		update_icons()


//Human Overlays Indexes/////////
#undef MUTATIONS_LAYER
#undef DAMAGE_LAYER
#undef SURGERY_LEVEL
#undef UNIFORM_LAYER
#undef ID_LAYER
#undef SHOES_LAYER
#undef GLOVES_LAYER
#undef NATURAL_EARS_LAYER
#undef EARS_LAYER
#undef SUIT_LAYER
#undef WINGS_LAYER
#undef TAIL_LAYER
#undef GENITALS_LAYER
#undef GLASSES_LAYER
#undef FACEMASK_LAYER
#undef BELT_LAYER
#undef SUIT_STORE_LAYER
#undef BACK_LAYER
#undef HAIR_LAYER
#undef HEAD_LAYER
#undef COLLAR_LAYER
#undef HANDCUFF_LAYER
#undef LEGCUFF_LAYER
#undef L_HAND_LAYER
#undef R_HAND_LAYER
#undef TARGETED_LAYER
#undef FIRE_LAYER
#undef TOTAL_LAYERS
