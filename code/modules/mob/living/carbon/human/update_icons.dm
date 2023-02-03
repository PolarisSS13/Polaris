/*
	Global associative list for caching humanoid icons.
	Index format m or f, followed by a string of 0 and 1 to represent bodyparts followed by husk fat hulk skeleton 1 or 0.
*/
var/global/list/human_icon_cache = list() //key is incredibly complex, see update_icons_body()
var/global/list/tail_icon_cache = list() //key is [species.race_key][r_skin][g_skin][b_skin]
var/global/list/wing_icon_cache = list() // See tail.
var/global/list/damage_icon_parts = list() //see UpdateDamageIcon()

var/global/list/_index_extended_clothing_icon_cache= list()
/proc/overlay_image(icon, icon_state, color, layer, flags)
	// Polaris has a system for extending clothing icons for suits and uniforms by an index,
	// which requires us to identify an icon string being passed in as the previous system
	// used icon() universally. This is pretty problematic as a method but unpicking it is
	// going to be a big job and this will work for now.
	if(istext(icon))
		if(!global._index_extended_clothing_icon_cache[icon])
			global._index_extended_clothing_icon_cache[icon] = new /icon(icon)
		icon = global._index_extended_clothing_icon_cache[icon]
	// End string icon path hack.

	var/image/ret = image(icon, icon_state)
	ret.color = color
	ret.appearance_flags = flags
	ret.layer = layer
	return ret

////////////////////////////////////////////////////////////////////////////////////////////////
// # Human Icon Updating System
//
// This system takes care of the "icon" for human mobs.  Of course humans don't just have a single
// icon+icon_state, but a combination of dozens of little sprites including including the body,
// clothing, equipment, in-universe HUD images, etc.
//
// # Basic Operation
// Whenever you do something that should update the on-mob appearance of a worn or held item, You
// will need to call the relevant update_inv_* proc. All of these are named after the variable they
// update from. They are defined at the /mob level so you don't even need to cast to carbon/human.
//
// The new system leverages SSoverlays to actually add/remove the overlays from mob.overlays
// Since SSoverlays already manages batching updates to reduce apperance churn etc, we don't need
// to worry about that.  (In short, you can call add/cut overlay as many times as you want, it will
// only get assigned to the mob once per tick.)
// As a corrolary, this means users of this system do NOT need to tell the system when you're done
// making changes.
//
// There are also these special cases:
//  update_icons_body()	//Handles updating your mob's icon to reflect their gender/race/complexion etc
//  UpdateDamageIcon()	//Handles damage overlays for brute/burn damage //(will rename this when I geta round to it) ~Carn
//  update_skin()		//Handles updating skin for species that have a skin overlay.
//  update_bloodied()	//Handles adding/clearing the blood overlays for hands & feet.  Call when bloodied or cleaned.
//  update_underwear()	//Handles updating the sprite for underwear.
//  update_hair()		//Handles updating your hair and eyes overlay
//  update_mutations()	//Handles updating your appearance for certain mutations.  e.g TK head-glows
//  update_fire()		//Handles overlay from being on fire.
//  update_water()		//Handles overlay from being submerged.
//  update_surgery()	//Handles overlays from open external organs.
//
// # History (i.e. I'm used to the old way, what is different?)
// You used to have to call update_icons(FALSE) if you planned to make more changes, and call update_icons(TRUE)
// on the final update.  All that is gone, just call update_inv_whatever() and it handles the rest.
//
////////////////////////////////////////////////////////////////////////////////////////////////

//Add an entry to overlays, assuming it exists
/mob/living/carbon/human/proc/apply_layer(cache_index)
	if((. = overlays_standing[cache_index]))
		add_overlay(.)

//Remove an entry from overlays, and from the list
/mob/living/carbon/human/proc/remove_layer(cache_index)
	var/I = overlays_standing[cache_index]
	if(I)
		cut_overlay(I)
		overlays_standing[cache_index] = null

// These are used as the layers for the icons, as well as indexes in a list that holds onto them.
// Technically the layers used are all -100+layer to make them FLOAT_LAYER overlays.
//Human Overlays Indexes/////////
#define MUTATIONS_LAYER			1		//Mutations like fat, and lasereyes
#define SKIN_LAYER				2		//Skin things added by a call on species
#define BLOOD_LAYER				3		//Bloodied hands/feet/anything else
#define MOB_DAM_LAYER			4		//Injury overlay sprites like open wounds
#define SURGERY_LAYER			5		//Overlays for open surgical sites
#define UNDERWEAR_LAYER  		6		//Underwear/bras/etc
#define TAIL_SOUTH_LAYER		7		//Tail as viewed from the south
#define SHOES_LAYER_ALT			8		//Shoe-slot item (when set to be under uniform via verb)
#define UNIFORM_LAYER			9		//Uniform-slot item
#define ID_LAYER				10		//ID-slot item
#define SHOES_LAYER				11		//Shoe-slot item
#define GLOVES_LAYER			12		//Glove-slot item
#define BELT_LAYER				13		//Belt-slot item
#define SUIT_LAYER				14		//Suit-slot item
#define TAIL_NORTH_LAYER		15		//Some species have tails to render (As viewed from the N, E, or W)
#define GLASSES_LAYER			16		//Eye-slot item
#define BELT_LAYER_ALT			17		//Belt-slot item (when set to be above suit via verb)
#define SUIT_STORE_LAYER		18		//Suit storage-slot item
#define BACK_LAYER				19		//Back-slot item
#define HAIR_LAYER				20		//The human's hair
#define EARS_LAYER				21		//Both ear-slot items (combined image)
#define EYES_LAYER				22		//Mob's eyes (used for glowing eyes)
#define FACEMASK_LAYER			23		//Mask-slot item
#define HEAD_LAYER				24		//Head-slot item
#define HANDCUFF_LAYER			25		//Handcuffs, if the human is handcuffed, in a secret inv slot
#define LEGCUFF_LAYER			26		//Same as handcuffs, for legcuffs
#define L_HAND_LAYER			27		//Left-hand item
#define R_HAND_LAYER			28		//Right-hand item
#define WING_LAYER				29		//Wings or protrusions over the suit.
#define MODIFIER_EFFECTS_LAYER	30		//Effects drawn by modifiers
#define FIRE_LAYER				31		//'Mob on fire' overlay layer
#define MOB_WATER_LAYER			32		//'Mob submerged' overlay layer
#define TARGETED_LAYER			33		//'Aimed at' overlay layer
#define TOTAL_LAYERS			33//<---- KEEP THIS UPDATED, should always equal the highest number here, used to initialize a list.
//////////////////////////////////

#define GET_TAIL_LAYER (dir == NORTH ? TAIL_NORTH_LAYER : TAIL_SOUTH_LAYER)

/mob/living/carbon/human
	var/list/overlays_standing[TOTAL_LAYERS]
	var/previous_damage_appearance // store what the body last looked like, so we only have to update it if something changed

//UPDATES OVERLAYS FROM OVERLAYS_LYING/OVERLAYS_STANDING
//I'll work on removing that stuff by rewriting some of the cloaking stuff at a later date.
/mob/living/carbon/human/update_icons()
	if(QDESTROYING(src))
		return

	crash_with("CANARY: Old human update_icons was called.")

	update_hud()		//TODO: remove the need for this

	//Do any species specific layering updates, such as when hiding.
	update_icon_special()

/mob/living/carbon/human/update_transform()
	// First, get the correct size.
	var/desired_scale_x = icon_scale_x
	var/desired_scale_y = icon_scale_y

	desired_scale_x *= species.icon_scale_x
	desired_scale_y *= species.icon_scale_y

	for(var/datum/modifier/M in modifiers)
		if(!isnull(M.icon_scale_x_percent))
			desired_scale_x *= M.icon_scale_x_percent
		if(!isnull(M.icon_scale_y_percent))
			desired_scale_y *= M.icon_scale_y_percent

	// Regular stuff again.
	var/matrix/M = matrix()
	var/anim_time = 3

	//Due to some involuntary means, you're laying now
	if(lying && !resting && !sleeping)
		anim_time = 1 //Thud

	if(lying && !species.prone_icon) //Only rotate them if we're not drawing a specific icon for being prone.
		var/randn = rand(1, 2)
		if(randn <= 1) // randomly choose a rotation
			M.Turn(-90)
		else
			M.Turn(90)
		M.Scale(desired_scale_x, desired_scale_y)
		M.Translate(1,-6)
		layer = MOB_LAYER -0.01 // Fix for a byond bug where turf entry order no longer matters
	else
		M.Scale(desired_scale_x, desired_scale_y)
		M.Translate(0, 16*(desired_scale_y-1))
		layer = MOB_LAYER // Fix for a byond bug where turf entry order no longer matters

	animate(src, transform = M, time = anim_time)
	update_icon_special() //May contain transform-altering things

//DAMAGE OVERLAYS
//constructs damage icon for each organ from mask * damage field and saves it in our overlays_ lists
/mob/living/carbon/human/UpdateDamageIcon()
	if(QDESTROYING(src))
		return

	remove_layer(MOB_DAM_LAYER)

	// first check whether something actually changed about damage appearance
	var/damage_appearance = ""

	for(var/obj/item/organ/external/O in organs)
		if(isnull(O) || O.is_stump())
			continue
		damage_appearance += O.damage_state

	if(damage_appearance == previous_damage_appearance)
		// nothing to do here
		return

	previous_damage_appearance = damage_appearance

	var/image/standing_image = image(icon = species.damage_overlays, icon_state = "00", layer = BODY_LAYER+MOB_DAM_LAYER)

	// blend the individual damage states with our icons
	for(var/obj/item/organ/external/O in organs)
		if(isnull(O) || O.is_stump() || O.is_hidden_by_tail())
			continue

		O.update_icon()
		if(O.damage_state == "00") continue
		var/icon/DI
		var/cache_index = "[O.damage_state]/[O.icon_name]/[species.get_blood_colour(src)]/[species.get_bodytype(src)]"
		if(damage_icon_parts[cache_index] == null)
			DI = icon(species.get_damage_overlays(src), O.damage_state)			// the damage icon for whole human
			DI.Blend(icon(species.get_damage_mask(src), O.icon_name), ICON_MULTIPLY)	// mask with this organ's pixels
			DI.Blend(species.get_blood_colour(src), ICON_MULTIPLY)
			damage_icon_parts[cache_index] = DI
		else
			DI = damage_icon_parts[cache_index]

		standing_image.add_overlay(DI)

	overlays_standing[MOB_DAM_LAYER]	= standing_image
	apply_layer(MOB_DAM_LAYER)

//BASE MOB SPRITE
/mob/living/carbon/human/update_icons_body()
	if(QDESTROYING(src))
		return

	var/husk_color_mod = rgb(96,88,80)
	var/hulk_color_mod = rgb(48,224,40)

	var/husk = (HUSK in src.mutations)
	var/fat = (FAT in src.mutations)
	var/hulk = (HULK in src.mutations)
	var/skeleton = (SKELETON in src.mutations)

	robolimb_count = 0 //TODO, here, really tho?
	robobody_count = 0

	//CACHING: Generate an index key from visible bodyparts.
	//0 = destroyed, 1 = normal, 2 = robotic, 3 = necrotic.

	//Create a new, blank icon for our mob to use.
	var/icon/stand_icon = new(species.icon_template ? species.icon_template : 'icons/mob/human.dmi', icon_state = "blank")

	var/g = (gender == MALE ? "male" : "female")
	var/icon_key = "[species.get_race_key(src)][g][s_tone][r_skin][g_skin][b_skin]"
	if(lip_style)
		icon_key += "[lip_style]"
	else
		icon_key += "nolips"
	var/obj/item/organ/internal/eyes/eyes = internal_organs_by_name[O_EYES]
	if(eyes)
		icon_key += "[rgb(eyes.eye_colour[1], eyes.eye_colour[2], eyes.eye_colour[3])]"
	else
		icon_key += "[r_eyes], [g_eyes], [b_eyes]"
	var/obj/item/organ/external/head/head = organs_by_name[BP_HEAD]
	if(head)
		if(!istype(head, /obj/item/organ/external/stump))
			icon_key += "[head.eye_icon]"
	for(var/organ_tag in species.has_limbs)
		var/obj/item/organ/external/part = organs_by_name[organ_tag]
		if(isnull(part) || part.is_stump())
			icon_key += "0"
			continue
		if(part)
			icon_key += "[part.species.get_race_key(part.owner)]"
			icon_key += "[part.dna.GetUIState(DNA_UI_GENDER)]"
			icon_key += "[part.s_tone]"
			if(part.s_col && part.s_col.len >= 3)
				icon_key += "[rgb(part.s_col[1],part.s_col[2],part.s_col[3])]"
			if(part.body_hair && part.h_col && part.h_col.len >= 3)
				icon_key += "[rgb(part.h_col[1],part.h_col[2],part.h_col[3])]"
				icon_key += "[species?.limb_blend || ICON_ADD]"
			else
				icon_key += "#000000"

			for(var/M in part.markings)
				icon_key += "[M][part.markings[M]["color"]]"

			if(part.robotic >= ORGAN_ROBOT)
				icon_key += "2[part.model ? "-[part.model]": ""]"
				robolimb_count++
				if((part.robotic == ORGAN_ROBOT || part.robotic == ORGAN_LIFELIKE) && (part.organ_tag == BP_HEAD || part.organ_tag == BP_TORSO || part.organ_tag == BP_GROIN))
					robobody_count ++
			else if(part.status & ORGAN_DEAD)
				icon_key += "3"
			else
				icon_key += "1"

			if(part.transparent)
				icon_key += "_t"

	icon_key = "[icon_key][husk ? 1 : 0][fat ? 1 : 0][hulk ? 1 : 0][skeleton ? 1 : 0]"
	var/icon/base_icon
	if(human_icon_cache[icon_key])
		base_icon = human_icon_cache[icon_key]
	else
		//BEGIN CACHED ICON GENERATION.
		var/obj/item/organ/external/chest = get_organ(BP_TORSO)
		base_icon = chest.get_icon()

		var/icon/Cutter = null

		for(var/obj/item/organ/external/part in organs)
			if(isnull(part) || part.is_stump())
				continue
			var/icon/temp = part.get_icon(skeleton)

			if((part.organ_tag in list(BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT)) && Cutter)
				temp.Blend(Cutter, ICON_AND, x = -16)

			//That part makes left and right legs drawn topmost and lowermost when human looks WEST or EAST
			//And no change in rendering for other parts (they icon_position is 0, so goes to 'else' part)
			if(part.icon_position & (LEFT | RIGHT))
				var/icon/temp2 = new(species.icon_template ? species.icon_template : 'icons/mob/human.dmi', icon_state = "blank")
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
			else if(part.icon_position & UNDER)
				base_icon.Blend(temp, ICON_UNDERLAY)
			else
				base_icon.Blend(temp, ICON_OVERLAY)

		if(!skeleton)
			if(husk)
				base_icon.ColorTone(husk_color_mod)
			else if(hulk)
				var/list/tone = ReadRGB(hulk_color_mod)
				base_icon.MapColors(rgb(tone[1],0,0),rgb(0,tone[2],0),rgb(0,0,tone[3]))

		//Handle husk overlay.
		if(husk && ("overlay_husk" in cached_icon_states(species.icobase)))
			var/icon/mask = new(base_icon)
			var/icon/husk_over = new(species.icobase,"overlay_husk")
			mask.MapColors(0,0,0,1, 0,0,0,1, 0,0,0,1, 0,0,0,1, 0,0,0,0)
			husk_over.Blend(mask, ICON_ADD)
			base_icon.Blend(husk_over, ICON_OVERLAY)

		human_icon_cache[icon_key] = base_icon

	//END CACHED ICON GENERATION.
	stand_icon.Blend(base_icon,ICON_OVERLAY)
	icon = stand_icon

	//tail
	update_tail_showing()
	update_wing_showing()


/mob/living/carbon/human/proc/update_skin()
	if(QDESTROYING(src))
		return

	remove_layer(SKIN_LAYER)

	var/image/skin = species.update_skin(src)
	if(skin)
		skin.layer = BODY_LAYER+SKIN_LAYER
		overlays_standing[SKIN_LAYER] = skin
		apply_layer(SKIN_LAYER)

/mob/living/carbon/human/update_bloodied()
	if(QDESTROYING(src))
		return

	remove_layer(BLOOD_LAYER)
	if(!blood_DNA && !feet_blood_DNA)
		return

	var/image/both = image(icon = 'icons/effects/effects.dmi', icon_state = "nothing", layer = BODY_LAYER+BLOOD_LAYER)

	//Bloody hands
	if(blood_DNA)
		var/image/bloodsies	= image(icon = species.get_blood_mask(src), icon_state = "bloodyhands", layer = BODY_LAYER+BLOOD_LAYER)
		bloodsies.color = hand_blood_color
		both.add_overlay(bloodsies)

	//Bloody feet
	if(feet_blood_DNA)
		var/image/bloodsies = image(icon = species.get_blood_mask(src), icon_state = "shoeblood", layer = BODY_LAYER+BLOOD_LAYER)
		bloodsies.color = feet_blood_color
		both.add_overlay(bloodsies)

	overlays_standing[BLOOD_LAYER] = both

	apply_layer(BLOOD_LAYER)

//UNDERWEAR OVERLAY
/mob/living/carbon/human/proc/update_underwear()
	if(QDESTROYING(src))
		return

	remove_layer(UNDERWEAR_LAYER)

	if(species.appearance_flags & HAS_UNDERWEAR)
		overlays_standing[UNDERWEAR_LAYER] = list()
		for(var/category in all_underwear)
			if(hide_underwear[category])
				continue
			var/datum/category_item/underwear/UWI = all_underwear[category]
			var/image/wear = UWI.generate_image(all_underwear_metadata[category], layer = BODY_LAYER+UNDERWEAR_LAYER)
			overlays_standing[UNDERWEAR_LAYER] += wear

		apply_layer(UNDERWEAR_LAYER)

//HAIR OVERLAY
/mob/living/carbon/human/proc/update_hair()
	if(QDESTROYING(src))
		return

	//Reset our hair
	remove_layer(HAIR_LAYER)
	update_eyes() //Pirated out of here, for glowing eyes.

	var/obj/item/organ/external/head/head_organ = get_organ(BP_HEAD)
	if(!head_organ || head_organ.is_stump() )
		return

	//masks and helmets can obscure our hair.
	if( (head && (head.flags_inv & BLOCKHAIR)) || (wear_mask && (wear_mask.flags_inv & BLOCKHAIR)))
		return

	//base icons
	var/icon/face_standing = icon(icon = 'icons/mob/human_face.dmi', icon_state = "bald_s")

	if(f_style)
		var/datum/sprite_accessory/facial_hair_style = facial_hair_styles_list[f_style]
		if(facial_hair_style && facial_hair_style.species_allowed && (src.species.get_bodytype(src) in facial_hair_style.species_allowed))
			var/icon/facial_s = new/icon("icon" = facial_hair_style.icon, "icon_state" = "[facial_hair_style.icon_state]_s")
			if(facial_hair_style.do_colouration)
				facial_s.Blend(rgb(r_facial, g_facial, b_facial), facial_hair_style.color_blend_mode)

			face_standing.Blend(facial_s, ICON_OVERLAY)

	if(h_style)
		var/datum/sprite_accessory/hair/hair_style = hair_styles_list[h_style]
		if(head && (head.flags_inv & BLOCKHEADHAIR))
			if(!(hair_style.flags & HAIR_VERY_SHORT))
				hair_style = hair_styles_list["Short Hair"]

		if(hair_style && (src.species.get_bodytype(src) in hair_style.species_allowed))
			var/icon/grad_s = null
			var/icon/hair_s = new/icon("icon" = hair_style.icon, "icon_state" = "[hair_style.icon_state]_s")
			var/icon/hair_s_add = new/icon("icon" = hair_style.icon_add, "icon_state" = "[hair_style.icon_state]_s")
			if(hair_style.do_colouration)
				if(grad_style)
					grad_s = new/icon("icon" = 'icons/mob/hair_gradients.dmi', "icon_state" = GLOB.hair_gradients[grad_style])
					grad_s.Blend(hair_s, ICON_AND)
					grad_s.Blend(rgb(r_grad, g_grad, b_grad), ICON_MULTIPLY)
				hair_s.Blend(rgb(r_hair, g_hair, b_hair), ICON_MULTIPLY)
				hair_s.Blend(hair_s_add, ICON_ADD)
				if(!isnull(grad_s))
					hair_s.Blend(grad_s, ICON_OVERLAY)

			face_standing.Blend(hair_s, ICON_OVERLAY)

	if(head_organ.nonsolid || head_organ.transparent)
		face_standing += rgb(,,,120)

	var/icon/ears_s = get_ears_overlay()
	if(ears_s)
		face_standing.Blend(ears_s, ICON_OVERLAY)

	overlays_standing[HAIR_LAYER] = image(face_standing, layer = BODY_LAYER+HAIR_LAYER, "pixel_y" = head_organ.head_offset)
	apply_layer(HAIR_LAYER)
	return

/mob/living/carbon/human/update_eyes()
	if(QDESTROYING(src))
		return

	//Reset our eyes
	remove_layer(EYES_LAYER)

	//TODO: Probably redo this. I know I wrote it, but...

	//This is ONLY for glowing eyes for now. Boring flat eyes are done by the head's own proc.
	if(!species.has_glowing_eyes)
		return

	//Our glowy eyes should be hidden if some equipment hides them.
	if(!should_have_organ(O_EYES) || (head && (head.flags_inv & BLOCKHAIR)) || (wear_mask && (wear_mask.flags_inv & BLOCKHAIR)))
		return

	//Get the head, we'll need it later.
	var/obj/item/organ/external/head/head_organ = get_organ(BP_HEAD)
	if(!head_organ || head_organ.is_stump() )
		return

	//The eyes store the color themselves, funny enough.
	var/obj/item/organ/internal/eyes/eyes = internal_organs_by_name[O_EYES]
	if(!head_organ.eye_icon)
		return

	var/icon/eyes_icon = new/icon(head_organ.eye_icon_location, head_organ.eye_icon)
	if(eyes)
		eyes_icon.Blend(rgb(eyes.eye_colour[1], eyes.eye_colour[2], eyes.eye_colour[3]), ICON_ADD)
	else
		eyes_icon.Blend(rgb(128,0,0), ICON_ADD)

	var/image/eyes_image = image(eyes_icon)
	eyes_image.plane = PLANE_LIGHTING_ABOVE
	eyes_image.appearance_flags = appearance_flags

	overlays_standing[EYES_LAYER] = eyes_image
	apply_layer(EYES_LAYER)

/mob/living/carbon/human/update_mutations()
	if(QDESTROYING(src))
		return

	remove_layer(MUTATIONS_LAYER)

	if(!LAZYLEN(mutations))
		return //No mutations, no icons.

	//TODO: THIS PROC???
	var/fat
	if(FAT in mutations)
		fat = "fat"

	var/image/standing	= image(icon = 'icons/effects/genetics.dmi', layer = BODY_LAYER+MUTATIONS_LAYER)
	var/g = gender == FEMALE ? "f" : "m"

	for(var/datum/dna/gene/gene in dna_genes)
		if(!gene.block)
			continue
		if(gene.is_active(src))
			var/underlay = gene.OnDrawUnderlays(src,g,fat)
			if(underlay)
				standing.underlays += underlay

	for(var/mut in mutations)
		if(mut == LASER)
			standing.add_overlay("lasereyes_s")

	overlays_standing[MUTATIONS_LAYER]	= standing
	apply_layer(MUTATIONS_LAYER)

/* --------------------------------------- */
//Recomputes every icon on the mob. Expensive.
//Useful if the species changed, or there's some
//other drastic body-shape change, but otherwise avoid.
/mob/living/carbon/human/regenerate_icons()
	..()
	if(transforming || QDELETED(src))
		return

	update_icons_body()
	UpdateDamageIcon()
	update_mutations()
	update_skin()
	update_underwear()
	update_hair()
	update_inv_w_uniform()
	update_inv_wear_id()
	update_inv_gloves()
	update_inv_glasses()
	update_inv_ears()
	update_inv_shoes()
	update_inv_s_store()
	update_inv_wear_mask()
	update_inv_head()
	update_inv_belt()
	update_inv_back()
	update_inv_wear_suit()
	update_inv_r_hand()
	update_inv_l_hand()
	update_inv_handcuffed()
	update_inv_legcuffed()
	//update_inv_pockets() //Doesn't do anything
	update_fire()
	update_water()
	update_surgery()

/* --------------------------------------- */
//vvvvvv UPDATE_INV PROCS vvvvvv

/mob/living/carbon/human/update_inv_w_uniform()
	if(QDESTROYING(src))
		return

	remove_layer(UNIFORM_LAYER)

	//Shoes can be affected by uniform being drawn onto them
	update_inv_shoes()

	if(!w_uniform)
		return

	if(wear_suit && (wear_suit.flags_inv & HIDEJUMPSUIT) && !istype(wear_suit, /obj/item/clothing/suit/space/rig))
		return //Wearing a suit that prevents uniform rendering

	var/obj/item/clothing/under/under = w_uniform

	var/uniform_sprite

	if(under.index)
		uniform_sprite = "[INV_W_UNIFORM_DEF_STRING]_[under.index].dmi"
	else
		uniform_sprite = INV_W_UNIFORM_DEF_ICON

	//Build a uniform sprite
	var/icon/c_mask = tail_style?.clip_mask
	if(c_mask)
		if((wear_suit?.flags_inv & HIDETAIL)) // Reason to not mask: You're wearing a suit that hides the tail
			c_mask = null
	overlays_standing[UNIFORM_LAYER] = w_uniform.get_worn_overlay(wearer = src, body_type = species.get_bodytype(src), slot_name = slot_w_uniform_str, default_icon = uniform_sprite, default_layer = UNIFORM_LAYER, clip_mask = c_mask)
	apply_layer(UNIFORM_LAYER)

/mob/living/carbon/human/update_inv_wear_id()
	if(QDESTROYING(src))
		return

	remove_layer(ID_LAYER)

	if(!wear_id)
		return //Not wearing an ID

	//Only draw the ID on the mob if the uniform allows for it
	if(w_uniform && istype(w_uniform, /obj/item/clothing/under))
		var/obj/item/clothing/under/U = w_uniform
		if(U.displays_id)
			overlays_standing[ID_LAYER] = wear_id.get_worn_overlay(wearer = src, body_type = species.get_bodytype(src), slot_name = slot_wear_id_str, default_icon = INV_WEAR_ID_DEF_ICON, default_layer = ID_LAYER)

	apply_layer(ID_LAYER)

/mob/living/carbon/human/update_inv_gloves()
	if(QDESTROYING(src))
		return

	remove_layer(GLOVES_LAYER)

	if(!gloves)
		return //No gloves, no reason to be here.

	overlays_standing[GLOVES_LAYER]	= gloves.get_worn_overlay(wearer = src, body_type = species.get_bodytype(src), slot_name = slot_gloves_str, default_icon = INV_GLOVES_DEF_ICON, default_layer = GLOVES_LAYER)

	apply_layer(GLOVES_LAYER)

/mob/living/carbon/human/update_inv_glasses()
	if(QDESTROYING(src))
		return

	remove_layer(GLASSES_LAYER)

	if(!glasses)
		return //Not wearing glasses, no need to update anything.

	overlays_standing[GLASSES_LAYER] = glasses.get_worn_overlay(wearer = src, body_type = species.get_bodytype(src), slot_name = slot_gloves_str, default_icon = INV_EYES_DEF_ICON, default_layer = GLASSES_LAYER)

	apply_layer(GLASSES_LAYER)

/mob/living/carbon/human/update_inv_ears()
	if(QDESTROYING(src))
		return

	remove_layer(EARS_LAYER)

	if((head && head.flags_inv & (BLOCKHAIR | BLOCKHEADHAIR)) || (wear_mask && wear_mask.flags_inv & (BLOCKHAIR | BLOCKHEADHAIR)))
		return //Ears are blocked (by hair being blocked, overloaded)

	if(!l_ear && !r_ear)
		return //Why bother, if no ear sprites

	// Blank image upon which to layer left & right overlays.
	var/image/both = image(icon = 'icons/effects/effects.dmi', icon_state = "nothing", layer = BODY_LAYER+EARS_LAYER)

	if(l_ear)
		var/image/standing = l_ear.get_worn_overlay(wearer = src, body_type = species.get_bodytype(src), slot_name = slot_l_ear_str, default_icon = INV_EARS_DEF_ICON, default_layer = EARS_LAYER)
		both.add_overlay(standing)

	if(r_ear)
		var/image/standing = r_ear.get_worn_overlay(wearer = src, body_type = species.get_bodytype(src), slot_name = slot_r_ear_str, default_icon = INV_EARS_DEF_ICON, default_layer = EARS_LAYER)
		both.add_overlay(standing)

	overlays_standing[EARS_LAYER] = both
	apply_layer(EARS_LAYER)

/mob/living/carbon/human/update_inv_shoes()
	if(QDESTROYING(src))
		return

	remove_layer(SHOES_LAYER)
	remove_layer(SHOES_LAYER_ALT) //Dumb alternate layer for shoes being under the uniform.

	if(!shoes || (wear_suit && wear_suit.flags_inv & HIDESHOES) || (w_uniform && w_uniform.flags_inv & HIDESHOES))
		return //Either nothing to draw, or it'd be hidden.

	for(var/f in list(BP_L_FOOT, BP_R_FOOT))
		var/obj/item/organ/external/foot/foot = get_organ(f)
		if(istype(foot) && foot.is_hidden_by_tail()) //If either foot is hidden by the tail, don't render footwear.
			return

	//Allow for shoe layer toggle nonsense
	var/shoe_layer = SHOES_LAYER
	if(istype(shoes, /obj/item/clothing/shoes))
		var/obj/item/clothing/shoes/ushoes = shoes
		if(ushoes.shoes_under_pants == 1)
			shoe_layer = SHOES_LAYER_ALT

	//NB: the use of a var for the layer on this one
	overlays_standing[shoe_layer] = shoes.get_worn_overlay(wearer = src, body_type = species.get_bodytype(src), slot_name = slot_shoes_str, default_icon = INV_FEET_DEF_ICON, default_layer = shoe_layer)

	apply_layer(SHOES_LAYER)
	apply_layer(SHOES_LAYER_ALT)

/mob/living/carbon/human/update_inv_s_store()
	if(QDESTROYING(src))
		return

	remove_layer(SUIT_STORE_LAYER)

	if(!s_store)
		return //Why bother, nothing there.

	//TODO, this is unlike the rest of the things
	//Basically has no variety in slot icon choices at all. WHY SPECIES ONLY??
	var/t_state = s_store.item_state
	if(!t_state)
		t_state = s_store.icon_state
	overlays_standing[SUIT_STORE_LAYER]	= image(icon = species.suit_storage_icon, icon_state = t_state, layer = BODY_LAYER+SUIT_STORE_LAYER)

	apply_layer(SUIT_STORE_LAYER)

/mob/living/carbon/human/update_inv_head()
	if(QDESTROYING(src))
		return

	remove_layer(HEAD_LAYER)

	if(!head)
		return //No head item, why bother.

	overlays_standing[HEAD_LAYER] = head.get_worn_overlay(wearer = src, body_type = species.get_bodytype(src), slot_name = slot_head_str, default_icon = INV_HEAD_DEF_ICON, default_layer = HEAD_LAYER)

	apply_layer(HEAD_LAYER)

/mob/living/carbon/human/update_inv_belt()
	if(QDESTROYING(src))
		return

	remove_layer(BELT_LAYER)
	remove_layer(BELT_LAYER_ALT) //Because you can toggle belt layer with a verb

	if(!belt)
		return //No belt, why bother.

	//Toggle for belt layering with uniform
	var/belt_layer = BELT_LAYER
	if(istype(belt, /obj/item/storage/belt))
		var/obj/item/storage/belt/ubelt = belt
		if(ubelt.show_above_suit)
			belt_layer = BELT_LAYER_ALT

	//NB: this uses a var from above
	overlays_standing[belt_layer] = belt.get_worn_overlay(wearer = src, body_type = species.get_bodytype(src), slot_name = slot_belt_str, default_icon = INV_BELT_DEF_ICON, default_layer = belt_layer)

	apply_layer(belt_layer)

/mob/living/carbon/human/update_inv_wear_suit()
	if(QDESTROYING(src))
		return

	remove_layer(SUIT_LAYER)

	//Hide/show other layers if necessary
	update_inv_w_uniform()
	update_inv_shoes()
	update_tail_showing()
	update_wing_showing()

	if(!wear_suit)
		return //No point, no suit.

	var/obj/item/clothing/suit/suit = wear_suit
	var/suit_sprite

	if(istype(suit) && suit.index)
		suit_sprite = "[INV_SUIT_DEF_STRING]_[suit.index].dmi"
	else if(istype(suit, /obj/item/clothing) && !isnull(suit.update_icon_define))
		suit_sprite = suit.update_icon_define
	else
		suit_sprite = INV_SUIT_DEF_ICON

	var/icon/c_mask = null
	overlays_standing[SUIT_LAYER] = wear_suit.get_worn_overlay(wearer = src, body_type = species.get_bodytype(src), slot_name = slot_wear_suit_str, default_icon = suit_sprite, default_layer = SUIT_LAYER, clip_mask = c_mask)

	apply_layer(SUIT_LAYER)

/mob/living/carbon/human/update_inv_pockets()
	crash_with("Someone called update_inv_pockets even though it's dumb")

/mob/living/carbon/human/update_inv_wear_mask()
	if(QDESTROYING(src))
		return

	remove_layer(FACEMASK_LAYER)

	if(!wear_mask || (head && head.flags_inv & HIDEMASK))
		return //Why bother, nothing in mask slot.

	overlays_standing[FACEMASK_LAYER] = wear_mask.get_worn_overlay(wearer = src, body_type = species.get_bodytype(src), slot_name = slot_wear_mask_str, default_icon = INV_MASK_DEF_ICON, default_layer = FACEMASK_LAYER)

	apply_layer(FACEMASK_LAYER)

/mob/living/carbon/human/update_inv_back()
	if(QDESTROYING(src))
		return

	remove_layer(BACK_LAYER)

	if(!back)
		return //Why do anything

	overlays_standing[BACK_LAYER] = back.get_worn_overlay(wearer = src, body_type = species.get_bodytype(src), slot_name = slot_back_str, default_icon = INV_BACK_DEF_ICON, default_layer = BACK_LAYER)

	apply_layer(BACK_LAYER)

//TODO: Carbon procs in my human update_icons??
/mob/living/carbon/human/update_hud()	//TODO: do away with this if possible
	if(QDESTROYING(src))
		return

	if(client)
		client.screen |= contents
		if(hud_used)
			hud_used.hidden_inventory_update() 	//Updates the screenloc of the items on the 'other' inventory bar

//update whether handcuffs appears on our hud.
/mob/living/carbon/proc/update_hud_handcuffed()
	if(QDESTROYING(src))
		return

	if(hud_used && hud_used.l_hand_hud_object && hud_used.r_hand_hud_object)
		hud_used.l_hand_hud_object.update_icon()
		hud_used.r_hand_hud_object.update_icon()

/mob/living/carbon/human/update_inv_handcuffed()
	if(QDESTROYING(src))
		return

	remove_layer(HANDCUFF_LAYER)
	update_hud_handcuffed() //TODO

	if(!handcuffed)
		return //Not cuffed, why bother

	overlays_standing[HANDCUFF_LAYER] = handcuffed.get_worn_overlay(wearer = src, body_type = species.get_bodytype(src), slot_name = slot_handcuffed_str, default_icon = INV_HCUFF_DEF_ICON, default_layer = HANDCUFF_LAYER)

	apply_layer(HANDCUFF_LAYER)

/mob/living/carbon/human/update_inv_legcuffed()
	if(QDESTROYING(src))
		return

	clear_alert("legcuffed")
	remove_layer(LEGCUFF_LAYER)

	if(!legcuffed)
		return //Not legcuffed, why bother.

	throw_alert("legcuffed", /obj/screen/alert/restrained/legcuffed, new_master = legcuffed)

	overlays_standing[LEGCUFF_LAYER] = legcuffed.get_worn_overlay(wearer = src, body_type = species.get_bodytype(src), slot_name = slot_legcuffed_str, default_icon = INV_LCUFF_DEF_ICON, default_layer = LEGCUFF_LAYER)

	apply_layer(LEGCUFF_LAYER)

/mob/living/carbon/human/update_inv_r_hand()
	if(QDESTROYING(src))
		return

	remove_layer(R_HAND_LAYER)

	if(!r_hand)
		return //No hand, no bother.

	overlays_standing[R_HAND_LAYER] = r_hand.get_worn_overlay(wearer = src, inhands = TRUE, slot_name = slot_r_hand_str, default_layer = R_HAND_LAYER)

	apply_layer(R_HAND_LAYER)

/mob/living/carbon/human/update_inv_l_hand()
	if(QDESTROYING(src))
		return

	remove_layer(L_HAND_LAYER)

	if(!l_hand)
		return //No hand, no bother.

	overlays_standing[L_HAND_LAYER] = l_hand.get_worn_overlay(wearer = src, inhands = TRUE, slot_name = slot_l_hand_str, default_icon = INV_L_HAND_DEF_ICON, default_layer = L_HAND_LAYER)

	apply_layer(L_HAND_LAYER)

/mob/living/carbon/human/proc/update_tail_showing()
	if(QDESTROYING(src))
		return

	remove_layer(TAIL_NORTH_LAYER)
	remove_layer(TAIL_SOUTH_LAYER)

	var/tail_layer = GET_TAIL_LAYER

	var/image/tail_image = get_tail_image()
	if(tail_image)
		tail_image.layer = BODY_LAYER+tail_layer
		overlays_standing[tail_layer] = tail_image
		apply_layer(tail_layer)
		return

	var/species_tail = species.get_tail(src) // Species tail icon_state prefix.

	//This one is actually not that bad I guess.
	if(species_tail && !(wear_suit && wear_suit.flags_inv & HIDETAIL))
		var/icon/tail_s = get_tail_icon()
		overlays_standing[tail_layer] = image(icon = tail_s, icon_state = "[species_tail]_s", layer = BODY_LAYER+tail_layer)
		animate_tail_reset()

//TODO: Is this the appropriate place for this, and not on species...?
/mob/living/carbon/human/proc/get_tail_icon()
	var/icon_key = "[species.get_race_key(src)][r_skin][g_skin][b_skin][r_hair][g_hair][b_hair]"
	var/icon/tail_icon = tail_icon_cache[icon_key]
	if(!tail_icon)
		//generate a new one
		var/species_tail_anim = species.get_tail_animation(src)
		if(!species_tail_anim && species.icobase_tail) species_tail_anim = species.icobase //Allow override of file for non-animated tails
		if(!species_tail_anim) species_tail_anim = 'icons/effects/species.dmi'
		tail_icon = new/icon(species_tail_anim)
		tail_icon.Blend(rgb(r_skin, g_skin, b_skin), species?.tail_blend || ICON_ADD)
		// The following will not work with animated tails.
		var/use_species_tail = species.get_tail_hair(src)
		if(use_species_tail)
			var/icon/hair_icon = icon('icons/effects/species.dmi', "[species.get_tail(src)]_[use_species_tail]")
			hair_icon.Blend(rgb(r_hair, g_hair, b_hair), species?.tail_hair_blend || ICON_ADD)
			tail_icon.Blend(hair_icon, ICON_OVERLAY)
		tail_icon_cache[icon_key] = tail_icon

	return tail_icon

/mob/living/carbon/human/proc/set_tail_state(var/t_state)
	var/tail_layer = GET_TAIL_LAYER
	var/image/tail_overlay = overlays_standing[tail_layer]

	remove_layer(TAIL_NORTH_LAYER)
	remove_layer(TAIL_SOUTH_LAYER)

	if(tail_overlay)
		overlays_standing[tail_layer] = tail_overlay
		if(species.get_tail_animation(src))
			tail_overlay.icon_state = t_state
			. = tail_overlay

	apply_layer(tail_layer)

//Not really once, since BYOND can't do that.
//Update this if the ability to flick() images or make looping animation start at the first frame is ever added.
//You can sort of flick images now with flick_overlay -Aro
/mob/living/carbon/human/proc/animate_tail_once()
	if(QDESTROYING(src))
		return

	var/t_state = "[species.get_tail(src)]_once"
	var/tail_layer = GET_TAIL_LAYER

	var/image/tail_overlay = overlays_standing[tail_layer]
	if(tail_overlay && tail_overlay.icon_state == t_state)
		return //let the existing animation finish

	tail_overlay = set_tail_state(t_state) // Calls remove_layer & apply_layer
	if(tail_overlay)
		spawn(20)
			//check that the animation hasn't changed in the meantime
			if(overlays_standing[tail_layer] == tail_overlay && tail_overlay.icon_state == t_state)
				animate_tail_stop()

/mob/living/carbon/human/proc/animate_tail_start()
	if(QDESTROYING(src))
		return

	set_tail_state("[species.get_tail(src)]_slow[rand(0,9)]")

/mob/living/carbon/human/proc/animate_tail_fast()
	if(QDESTROYING(src))
		return

	set_tail_state("[species.get_tail(src)]_loop[rand(0,9)]")

/mob/living/carbon/human/proc/animate_tail_reset()
	if(QDESTROYING(src))
		return

	if(stat != DEAD)
		set_tail_state("[species.get_tail(src)]_idle[rand(0,9)]")
	else
		set_tail_state("[species.get_tail(src)]_static")
		toggle_tail(FALSE) //So tails stop when someone dies. TODO - Fix this hack ~Leshana

/mob/living/carbon/human/proc/animate_tail_stop()
	if(QDESTROYING(src))
		return

	set_tail_state("[species.get_tail(src)]_static")

/mob/living/carbon/human/proc/update_wing_showing()
	if(QDESTROYING(src))
		return

	remove_layer(WING_LAYER)

	var/image/wing_image = get_wing_image()
	if(wing_image)
		wing_image.layer = BODY_LAYER+WING_LAYER
		overlays_standing[WING_LAYER] = wing_image

	apply_layer(WING_LAYER)

/mob/living/carbon/human/update_modifier_visuals()
	if(QDESTROYING(src))
		return

	remove_layer(MODIFIER_EFFECTS_LAYER)

	if(!LAZYLEN(modifiers))
		return //No modifiers, no effects.

	var/image/effects = new()
	for(var/datum/modifier/M in modifiers)
		if(M.mob_overlay_state)
			var/image/I = image(icon = 'icons/mob/modifier_effects.dmi', icon_state = M.mob_overlay_state)
			effects.add_overlay(I)

	overlays_standing[MODIFIER_EFFECTS_LAYER] = effects

	apply_layer(MODIFIER_EFFECTS_LAYER)

/mob/living/carbon/human/update_fire()
	if(QDESTROYING(src))
		return

	remove_layer(FIRE_LAYER)

	if(!on_fire)
		return

	overlays_standing[FIRE_LAYER] = image(icon = 'icons/mob/OnFire.dmi', icon_state = get_fire_icon_state(), layer = BODY_LAYER+FIRE_LAYER)

	apply_layer(FIRE_LAYER)

/mob/living/carbon/human/update_water()
	if(QDESTROYING(src))
		return

	remove_layer(MOB_WATER_LAYER)

	var/depth = check_submerged()
	if(!depth || lying)
		return

	var/atom/A = loc // We'd better be swimming and on a turf
	var/image/I = image(icon = 'icons/mob/submerged.dmi', icon_state = "human_swimming_[depth]", layer = BODY_LAYER+MOB_WATER_LAYER) //TODO: Improve
	I.color = A.color
	overlays_standing[MOB_WATER_LAYER] = I

	apply_layer(MOB_WATER_LAYER)

/mob/living/carbon/human/proc/update_surgery()
	if(QDESTROYING(src))
		return

	remove_layer(SURGERY_LAYER)

	var/image/total = new
	for(var/obj/item/organ/external/E in organs)
		if(E.open)
			var/image/I = image(icon = 'icons/mob/surgery.dmi',  icon_state = "[E.icon_name][round(E.open)]", layer = BODY_LAYER+SURGERY_LAYER)
			total.add_overlay(I)

	if(total.overlays.len)
		overlays_standing[SURGERY_LAYER] = total
		apply_layer(SURGERY_LAYER)

/mob/living/carbon/human/proc/get_wing_image()
	if(QDESTROYING(src))
		return

	//If you are FBP with wing style and didn't set a custom one
	if(synthetic && synthetic.includes_wing && !wing_style)
		var/icon/wing_s = new/icon("icon" = synthetic.icon, "icon_state" = "wing") //I dunno. If synths have some custom wing?
		wing_s.Blend(rgb(src.r_skin, src.g_skin, src.b_skin), species?.limb_blend || ICON_ADD) // Are wings even used on Polaris? This might need an additional blend mode var.
		return image(wing_s)

	//If you have custom wings selected
	if(wing_style && !(wear_suit && wear_suit.flags_inv & HIDETAIL))
		var/icon/wing_s = new/icon("icon" = wing_style.icon, "icon_state" = flapping && wing_style.ani_state ? wing_style.ani_state : wing_style.icon_state)
		if(wing_style.do_colouration)
			wing_s.Blend(rgb(src.r_wing, src.g_wing, src.b_wing), wing_style.color_blend_mode)
		if(wing_style.extra_overlay)
			var/icon/overlay = new/icon("icon" = wing_style.icon, "icon_state" = wing_style.extra_overlay)
			overlay.Blend(rgb(src.r_wing2, src.g_wing2, src.b_wing2), wing_style.color_blend_mode)
			wing_s.Blend(overlay, ICON_OVERLAY)
			qdel(overlay)
		if(wing_style.extra_overlay2)
			var/icon/overlay = new/icon("icon" = wing_style.icon, "icon_state" = wing_style.extra_overlay2)
			if(wing_style.ani_state)
				overlay = new/icon("icon" = wing_style.icon, "icon_state" = wing_style.extra_overlay2_w)
				overlay.Blend(rgb(src.r_wing3, src.g_wing3, src.b_wing3), wing_style.color_blend_mode)
				wing_s.Blend(overlay, ICON_OVERLAY)
				qdel(overlay)
			else
				overlay.Blend(rgb(src.r_wing3, src.g_wing3, src.b_wing3), wing_style.color_blend_mode)
				wing_s.Blend(overlay, ICON_OVERLAY)
				qdel(overlay)
		return image(wing_s)

/mob/living/carbon/human/proc/get_ears_overlay()
	if(ear_style && !(head && (head.flags_inv & BLOCKHEADHAIR)))
		var/icon/ears_s = new/icon("icon" = ear_style.icon, "icon_state" = ear_style.icon_state)
		if(ear_style.do_colouration)
			ears_s.Blend(rgb(src.r_ears, src.g_ears, src.b_ears), ear_style.color_blend_mode)
		if(ear_style.extra_overlay)
			var/icon/overlay = new/icon("icon" = ear_style.icon, "icon_state" = ear_style.extra_overlay)
			overlay.Blend(rgb(src.r_ears2, src.g_ears2, src.b_ears2), ear_style.color_blend_mode)
			ears_s.Blend(overlay, ICON_OVERLAY)
			qdel(overlay)
		if(ear_style.extra_overlay2) //MORE COLOURS IS BETTERER
			var/icon/overlay = new/icon("icon" = ear_style.icon, "icon_state" = ear_style.extra_overlay2)
			overlay.Blend(rgb(src.r_ears3, src.g_ears3, src.b_ears3), ear_style.color_blend_mode)
			ears_s.Blend(overlay, ICON_OVERLAY)
			qdel(overlay)
		return ears_s
	return null


/mob/living/carbon/human/proc/get_tail_image()
	//If you are FBP with tail style and didn't set a custom one
	var/datum/robolimb/model = isSynthetic()
	if(istype(model) && model.includes_tail && !tail_style)
		var/icon/tail_s = new/icon("icon" = synthetic.icon, "icon_state" = "tail")
		tail_s.Blend(rgb(src.r_skin, src.g_skin, src.b_skin), species?.tail_blend || ICON_ADD)
		return image(tail_s)

	//If you have a custom tail selected
	if(tail_style && !(wear_suit && wear_suit.flags_inv & HIDETAIL))
		var/icon/tail_s = new/icon("icon" = tail_style.icon, "icon_state" = wagging && tail_style.ani_state ? tail_style.ani_state : tail_style.icon_state)
		if(tail_style.do_colouration)
			tail_s.Blend(rgb(src.r_tail, src.g_tail, src.b_tail), tail_style.color_blend_mode)
		if(tail_style.extra_overlay)
			var/icon/overlay = new/icon("icon" = tail_style.icon, "icon_state" = tail_style.extra_overlay)
			if(wagging && tail_style.ani_state)
				overlay = new/icon("icon" = tail_style.icon, "icon_state" = tail_style.extra_overlay_w)
				overlay.Blend(rgb(src.r_tail2, src.g_tail2, src.b_tail2), tail_style.color_blend_mode)
				tail_s.Blend(overlay, ICON_OVERLAY)
				qdel(overlay)
			else
				overlay.Blend(rgb(src.r_tail2, src.g_tail2, src.b_tail2), tail_style.color_blend_mode)
				tail_s.Blend(overlay, ICON_OVERLAY)
				qdel(overlay)

		if(tail_style.extra_overlay2)
			var/icon/overlay = new/icon("icon" = tail_style.icon, "icon_state" = tail_style.extra_overlay2)
			if(wagging && tail_style.ani_state)
				overlay = new/icon("icon" = tail_style.icon, "icon_state" = tail_style.extra_overlay2_w)
				overlay.Blend(rgb(src.r_tail3, src.g_tail3, src.b_tail3), tail_style.color_blend_mode)
				tail_s.Blend(overlay, ICON_OVERLAY)
				qdel(overlay)
			else
				overlay.Blend(rgb(src.r_tail3, src.g_tail3, src.b_tail3), tail_style.color_blend_mode)
				tail_s.Blend(overlay, ICON_OVERLAY)
				qdel(overlay)

		return image(tail_s)
	return null

// TODO - Move this to where it should go ~Leshana
/mob/living/proc/stop_flying()
	if(QDESTROYING(src))
		return
	flying = FALSE
	return 1

/mob/living/carbon/human/stop_flying()
	if((. = ..()))
		update_wing_showing()

//Human Overlays Indexes/////////
#undef MUTATIONS_LAYER
#undef SKIN_LAYER
#undef MOB_DAM_LAYER
#undef SURGERY_LAYER
#undef UNDERWEAR_LAYER
#undef SHOES_LAYER_ALT
#undef UNIFORM_LAYER
#undef ID_LAYER
#undef SHOES_LAYER
#undef GLOVES_LAYER
#undef BELT_LAYER
#undef SUIT_LAYER
#undef TAIL_NORTH_LAYER
#undef TAIL_SOUTH_LAYER
#undef GET_TAIL_LAYER
#undef GLASSES_LAYER
#undef BELT_LAYER_ALT
#undef SUIT_STORE_LAYER
#undef BACK_LAYER
#undef HAIR_LAYER
#undef EARS_LAYER
#undef EYES_LAYER
#undef FACEMASK_LAYER
#undef HEAD_LAYER
#undef HANDCUFF_LAYER
#undef LEGCUFF_LAYER
#undef L_HAND_LAYER
#undef R_HAND_LAYER
#undef MODIFIER_EFFECTS_LAYER
#undef FIRE_LAYER
#undef WATER_LAYER
#undef TARGETED_LAYER
#undef TOTAL_LAYERS
