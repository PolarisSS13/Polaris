/obj/item/mecha_parts/mecha_equipment/tool/syringe_gun
	name = "syringe gun"
	desc = "Exosuit-mounted chem synthesizer with syringe gun. Reagents inside are held in stasis, so no reactions will occur. (Can be attached to: Medical Exosuits)"
	icon = 'icons/obj/gun.dmi'
	icon_state = "syringegun"
	var/list/syringes
	var/list/known_reagents
	var/list/processed_reagents
	var/max_syringes = 10
	var/max_volume = 75 //max reagent volume
	var/synth_speed = 5 //[num] reagent units per cycle
	energy_drain = 10
	var/mode = 0 //0 - fire syringe, 1 - analyze reagents.
	var/datum/global_iterator/mech_synth/synth
	range = MELEE|RANGED
	equip_cooldown = 10
	origin_tech = list(TECH_MATERIAL = 3, TECH_BIO = 4, TECH_MAGNET = 4, TECH_DATA = 3)
	required_type = list(/obj/mecha/medical)

/obj/item/mecha_parts/mecha_equipment/tool/syringe_gun/New()
	..()
	flags |= NOREACT
	syringes = new
	known_reagents = list("inaprovaline"="Inaprovaline","anti_toxin"="Dylovene")
	processed_reagents = new
	create_reagents(max_volume)
	synth = new (list(src),0)

/obj/item/mecha_parts/mecha_equipment/tool/syringe_gun/detach()
	synth.stop()
	return ..()

/obj/item/mecha_parts/mecha_equipment/tool/syringe_gun/critfail()
	..()
	flags &= ~NOREACT
	return

/obj/item/mecha_parts/mecha_equipment/tool/syringe_gun/get_equip_info()
	var/output = ..()
	if(output)
		return "[output] \[<a href=\"?src=\ref[src];toggle_mode=1\">[mode? "Analyze" : "Launch"]</a>\]<br />\[Syringes: [syringes.len]/[max_syringes] | Reagents: [reagents.total_volume]/[reagents.maximum_volume]\]<br /><a href='?src=\ref[src];show_reagents=1'>Reagents list</a>"
	return

/obj/item/mecha_parts/mecha_equipment/tool/syringe_gun/action(atom/movable/target)
	if(!action_checks(target))
		return
	if(istype(target,/obj/item/weapon/reagent_containers/syringe))
		return load_syringe(target)
	if(istype(target,/obj/item/weapon/storage))//Loads syringes from boxes
		for(var/obj/item/weapon/reagent_containers/syringe/S in target.contents)
			load_syringe(S)
		return
	if(mode)
		return analyze_reagents(target)
	if(!syringes.len)
		occupant_message("<span class=\"alert\">No syringes loaded.</span>")
		return
	if(reagents.total_volume<=0)
		occupant_message("<span class=\"alert\">No available reagents to load syringe with.</span>")
		return
	set_ready_state(0)
	chassis.use_power(energy_drain)
	var/turf/trg = get_turf(target)
	var/obj/item/weapon/reagent_containers/syringe/S = syringes[1]
	S.forceMove(get_turf(chassis))
	reagents.trans_to_obj(S, min(S.volume, reagents.total_volume))
	syringes -= S
	S.icon = 'icons/obj/chemical.dmi'
	S.icon_state = "syringeproj"
	playsound(chassis, 'sound/items/syringeproj.ogg', 50, 1)
	log_message("Launched [S] from [src], targeting [target].")
	spawn(-1)
		src = null //if src is deleted, still process the syringe
		for(var/i=0, i<6, i++)
			if(!S)
				break
			if(step_towards(S,trg))
				var/list/mobs = new
				for(var/mob/living/carbon/M in S.loc)
					mobs += M
				var/mob/living/carbon/M = safepick(mobs)
				if(M)
					S.icon_state = initial(S.icon_state)
					S.icon = initial(S.icon)
					S.reagents.trans_to_mob(M, S.reagents.total_volume, CHEM_BLOOD)
					M.take_organ_damage(2)
					S.visible_message("<span class=\"attack\"> [M] was hit by the syringe!</span>")
					break
				else if(S.loc == trg)
					S.icon_state = initial(S.icon_state)
					S.icon = initial(S.icon)
					S.update_icon()
					break
			else
				S.icon_state = initial(S.icon_state)
				S.icon = initial(S.icon)
				S.update_icon()
				break
			sleep(1)
	do_after_cooldown()
	return 1


/obj/item/mecha_parts/mecha_equipment/tool/syringe_gun/Topic(href,href_list)
	..()
	var/datum/topic_input/top_filter = new (href,href_list)
	if(top_filter.get("toggle_mode"))
		mode = !mode
		update_equip_info()
		return
	if(top_filter.get("select_reagents"))
		processed_reagents.len = 0
		var/m = 0
		var/message
		for(var/i=1 to known_reagents.len)
			if(m>=synth_speed)
				break
			var/reagent = top_filter.get("reagent_[i]")
			if(reagent && (reagent in known_reagents))
				message = "[m ? ", " : null][known_reagents[reagent]]"
				processed_reagents += reagent
				m++
		if(processed_reagents.len)
			message += " added to production"
			synth.start()
			occupant_message(message)
			occupant_message("Reagent processing started.")
			log_message("Reagent processing started.")
		return
	if(top_filter.get("show_reagents"))
		chassis.occupant << browse(get_reagents_page(),"window=msyringegun")
	if(top_filter.get("purge_reagent"))
		var/reagent = top_filter.get("purge_reagent")
		if(reagent)
			reagents.del_reagent(reagent)
		return
	if(top_filter.get("purge_all"))
		reagents.clear_reagents()
		return
	return

/obj/item/mecha_parts/mecha_equipment/tool/syringe_gun/proc/get_reagents_page()
	var/output = {"<html>
						<head>
						<title>Reagent Synthesizer</title>
						<script language='javascript' type='text/javascript'>
						[js_byjax]
						</script>
						<style>
						h3 {margin-bottom:2px;font-size:14px;}
						#reagents, #reagents_form {}
						form {width: 90%; margin:10px auto; border:1px dotted #999; padding:6px;}
						#submit {margin-top:5px;}
						</style>
						</head>
						<body>
						<h3>Current reagents:</h3>
						<div id="reagents">
						[get_current_reagents()]
						</div>
						<h3>Reagents production:</h3>
						<div id="reagents_form">
						[get_reagents_form()]
						</div>
						</body>
						</html>
						"}
	return output

/obj/item/mecha_parts/mecha_equipment/tool/syringe_gun/proc/get_reagents_form()
	var/r_list = get_reagents_list()
	var/inputs
	if(r_list)
		inputs += "<input type=\"hidden\" name=\"src\" value=\"\ref[src]\">"
		inputs += "<input type=\"hidden\" name=\"select_reagents\" value=\"1\">"
		inputs += "<input id=\"submit\" type=\"submit\" value=\"Apply settings\">"
	var/output = {"<form action="byond://" method="get">
						[r_list || "No known reagents"]
						[inputs]
						</form>
						[r_list? "<span style=\"font-size:80%;\">Only the first [synth_speed] selected reagent\s will be added to production</span>" : null]
						"}
	return output

/obj/item/mecha_parts/mecha_equipment/tool/syringe_gun/proc/get_reagents_list()
	var/output
	for(var/i=1 to known_reagents.len)
		var/reagent_id = known_reagents[i]
		output += {"<input type="checkbox" value="[reagent_id]" name="reagent_[i]" [(reagent_id in processed_reagents)? "checked=\"1\"" : null]> [known_reagents[reagent_id]]<br />"}
	return output

/obj/item/mecha_parts/mecha_equipment/tool/syringe_gun/proc/get_current_reagents()
	var/output
	for(var/datum/reagent/R in reagents.reagent_list)
		if(R.volume > 0)
			output += "[R]: [round(R.volume,0.001)] - <a href=\"?src=\ref[src];purge_reagent=[R.id]\">Purge Reagent</a><br />"
	if(output)
		output += "Total: [round(reagents.total_volume,0.001)]/[reagents.maximum_volume] - <a href=\"?src=\ref[src];purge_all=1\">Purge All</a>"
	return output || "None"

/obj/item/mecha_parts/mecha_equipment/tool/syringe_gun/proc/load_syringe(obj/item/weapon/reagent_containers/syringe/S)
	if(syringes.len<max_syringes)
		if(get_dist(src,S) >= 2)
			occupant_message("The syringe is too far away.")
			return 0
		for(var/obj/structure/D in S.loc)//Basic level check for structures in the way (Like grilles and windows)
			if(!(D.CanPass(S,src.loc)))
				occupant_message("Unable to load syringe.")
				return 0
		for(var/obj/machinery/door/D in S.loc)//Checks for doors
			if(!(D.CanPass(S,src.loc)))
				occupant_message("Unable to load syringe.")
				return 0
		S.reagents.trans_to_obj(src, S.reagents.total_volume)
		S.forceMove(src)
		syringes += S
		occupant_message("Syringe loaded.")
		update_equip_info()
		return 1
	occupant_message("The [src] syringe chamber is full.")
	return 0

/obj/item/mecha_parts/mecha_equipment/tool/syringe_gun/proc/analyze_reagents(atom/A)
	if(get_dist(src,A) >= 4)
		occupant_message("The object is too far away.")
		return 0
	if(!A.reagents || istype(A,/mob))
		occupant_message("<span class=\"alert\">No reagent info gained from [A].</span>")
		return 0
	occupant_message("Analyzing reagents...")
	for(var/datum/reagent/R in A.reagents.reagent_list)
		if(R.reagent_state == 2 && add_known_reagent(R.id,R.name))
			occupant_message("Reagent analyzed, identified as [R.name] and added to database.")
			send_byjax(chassis.occupant,"msyringegun.browser","reagents_form",get_reagents_form())
	occupant_message("Analysis complete.")
	return 1

/obj/item/mecha_parts/mecha_equipment/tool/syringe_gun/proc/add_known_reagent(r_id,r_name)
	set_ready_state(0)
	do_after_cooldown()
	if(!(r_id in known_reagents))
		known_reagents += r_id
		known_reagents[r_id] = r_name
		return 1
	return 0


/obj/item/mecha_parts/mecha_equipment/tool/syringe_gun/update_equip_info()
	if(..())
		send_byjax(chassis.occupant,"msyringegun.browser","reagents",get_current_reagents())
		send_byjax(chassis.occupant,"msyringegun.browser","reagents_form",get_reagents_form())
		return 1
	return

/obj/item/mecha_parts/mecha_equipment/tool/syringe_gun/on_reagent_change()
	..()
	update_equip_info()
	return

/datum/global_iterator/mech_synth
	delay = 100

/datum/global_iterator/mech_synth/process(var/obj/item/mecha_parts/mecha_equipment/tool/syringe_gun/S)
	if(!S.chassis)
		return stop()
	var/energy_drain = S.energy_drain*10
	if(!S.processed_reagents.len || S.reagents.total_volume >= S.reagents.maximum_volume || !S.chassis.has_charge(energy_drain))
		S.occupant_message("<span class=\"alert\">Reagent processing stopped.</span>")
		S.log_message("Reagent processing stopped.")
		return stop()
	var/amount = S.synth_speed / S.processed_reagents.len
	for(var/reagent in S.processed_reagents)
		S.reagents.add_reagent(reagent,amount)
		S.chassis.use_power(energy_drain)
	return 1
