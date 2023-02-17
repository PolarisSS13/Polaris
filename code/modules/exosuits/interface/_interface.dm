#define BAR_CAP 12

/mob/living/exosuit/proc/refresh_hud()
	if(LAZYLEN(pilots))
		for(var/thing in pilots)
			var/mob/pilot = thing
			if(pilot.client)
				pilot.client.screen |= hud_elements
	if(client)
		client.screen |= hud_elements

/mob/living/exosuit/proc/InitializeHud()
	zone_sel = new
	if(!LAZYLEN(hud_elements))
		var/i = 1
		for(var/hardpoint in hardpoints)
			var/obj/screen/movable/exosuit/hardpoint/H = new(src, hardpoint)
			H.screen_loc = "1:6,[15-i]" //temp
			hud_elements |= H
			hardpoint_hud_elements[hardpoint] = H
			i++

		var/list/additional_hud_elements = list(
			/obj/screen/movable/exosuit/toggle/maint,
			/obj/screen/movable/exosuit/eject,
			/obj/screen/movable/exosuit/toggle/hardpoint,
			/obj/screen/movable/exosuit/toggle/hatch,
			/obj/screen/movable/exosuit/toggle/hatch_open,
			/obj/screen/movable/exosuit/radio,
			/obj/screen/movable/exosuit/rename,
			/obj/screen/movable/exosuit/toggle/camera
			)
		if(body && body.pilot_coverage >= 100)
			additional_hud_elements += /obj/screen/movable/exosuit/toggle/air
		i = 0
		var/pos = 7
		for(var/additional_hud in additional_hud_elements)
			var/obj/screen/movable/exosuit/M = new additional_hud(src)
			M.screen_loc = "1:6,[pos]:[i * -12]"
			hud_elements |= M
			i++
			if(i == 3)
				pos--
				i = 0

		hud_health = new /obj/screen/movable/exosuit/health(src)
		hud_health.screen_loc = "EAST-1:28,CENTER-3:11"
		hud_elements |= hud_health
		hud_open = locate(/obj/screen/movable/exosuit/toggle/hatch_open) in hud_elements
		hud_power = new /obj/screen/movable/exosuit/power(src)
		hud_power.screen_loc = "EAST-1:12,CENTER-4:25"
		hud_elements |= hud_power

	refresh_hud()

/mob/living/exosuit/create_mob_hud(datum/hud/HUD)
	..()

	var/ui_style = 'icons/mob/screen1.dmi'
	if(HUD.ui_style)
		ui_style = HUD.ui_style
	var/ui_color = "#ffffff"
	var/ui_alpha = 255

	var/obj/screen/using
	//Intent Backdrop
	using = new /obj/screen()
	using.name = "act_intent"
	using.icon = ui_style
	using.icon_state = "intent_"+a_intent
	using.screen_loc = ui_acti
	using.color = ui_color
	using.alpha = ui_alpha
	HUD.adding += using
	HUD.action_intent = using

	hud_elements |= using

	//Small intent quarters
	var/icon/ico

	ico = new(ui_style, "black")
	ico.MapColors(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, -1,-1,-1,-1)
	ico.DrawBox(rgb(255,255,255,1),1,ico.Height()/2,ico.Width()/2,ico.Height())
	using = new /obj/screen()
	using.name = I_HELP
	using.icon = ico
	using.screen_loc = ui_acti
	using.alpha = ui_alpha
	using.layer = LAYER_HUD_ITEM //These sit on the intent box
	HUD.adding += using
	HUD.help_intent = using

	ico = new(ui_style, "black")
	ico.MapColors(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, -1,-1,-1,-1)
	ico.DrawBox(rgb(255,255,255,1),ico.Width()/2,ico.Height()/2,ico.Width(),ico.Height())
	using = new /obj/screen()
	using.name = I_DISARM
	using.icon = ico
	using.screen_loc = ui_acti
	using.alpha = ui_alpha
	using.layer = LAYER_HUD_ITEM
	HUD.adding += using
	HUD.disarm_intent = using

	ico = new(ui_style, "black")
	ico.MapColors(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, -1,-1,-1,-1)
	ico.DrawBox(rgb(255,255,255,1),ico.Width()/2,1,ico.Width(),ico.Height()/2)
	using = new /obj/screen()
	using.name = I_GRAB
	using.icon = ico
	using.screen_loc = ui_acti
	using.alpha = ui_alpha
	using.layer = LAYER_HUD_ITEM
	HUD.adding += using
	HUD.grab_intent = using

	ico = new(ui_style, "black")
	ico.MapColors(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, -1,-1,-1,-1)
	ico.DrawBox(rgb(255,255,255,1),1,1,ico.Width()/2,ico.Height()/2)
	using = new /obj/screen()
	using.name = I_HURT
	using.icon = ico
	using.screen_loc = ui_acti
	using.alpha = ui_alpha
	using.layer = LAYER_HUD_ITEM
	HUD.adding += using
	HUD.hurt_intent = using

	//Move intent (walk/run)
	using = new /obj/screen()
	using.name = "mov_intent"
	using.icon = ui_style
	using.icon_state = (m_intent == "run" ? "running" : "walking")
	using.screen_loc = ui_movi
	using.color = ui_color
	using.alpha = ui_alpha
	HUD.adding += using
	HUD.move_intent = using

	//Resist button
	using = new /obj/screen()
	using.name = "resist"
	using.icon = ui_style
	using.icon_state = "act_resist"
	using.screen_loc = ui_pull_resist
	using.color = ui_color
	using.alpha = ui_alpha
	HUD.hotkeybuttons += using

	//Pull button
	pullin = new /obj/screen()
	pullin.icon = ui_style
	pullin.icon_state = "pull0"
	pullin.name = "pull"
	pullin.screen_loc = ui_pull_resist
	HUD.hotkeybuttons += pullin
	hud_elements |= pullin

	zone_sel = new /obj/screen/zone_sel( null )
	zone_sel.icon = ui_style
	zone_sel.color = ui_color
	zone_sel.alpha = ui_alpha
	zone_sel.cut_overlays()
	zone_sel.add_overlay(image('icons/mob/zone_sel.dmi', "[zone_sel.selecting]"))
	hud_elements |= zone_sel

/mob/living/exosuit/handle_hud_icons()
	for(var/hardpoint in hardpoint_hud_elements)
		var/obj/screen/movable/exosuit/hardpoint/H = hardpoint_hud_elements[hardpoint]
		if(H) H.update_system_info()
	handle_hud_icons_health()
	var/obj/item/cell/C = get_cell()
	if(istype(C))
		hud_power.maptext = "[round(C.charge)]/[round(C.maxcharge)]"
	else hud_power.maptext = "CHECK POWER"
	refresh_hud()

/mob/living/exosuit/handle_hud_icons_health()

	hud_health.overlays.Cut()

	var/obj/item/cell/MyC = get_cell()
	if(!body || !MyC || (MyC.charge <= 0))
		return

	if(!body.diagnostics || !body.diagnostics.is_functional() || ((emp_damage>EMP_GUI_DISRUPT) && prob(emp_damage*2)))
		if(!GLOB.mech_damage_overlay_cache["critfail"])
			GLOB.mech_damage_overlay_cache["critfail"] = image(icon='icons/mob/mecha/mech_hud.dmi',icon_state="dam_error")
		hud_health.overlays |= GLOB.mech_damage_overlay_cache["critfail"]
		return

	var/list/part_to_state = list("legs" = legs,"body" = body,"head" = head,"arms" = arms)
	for(var/part in part_to_state)
		var/state = 0
		var/obj/item/mech_component/MC = part_to_state[part]
		if(MC)
			if((emp_damage>EMP_GUI_DISRUPT) && prob(emp_damage*3))
				state = rand(0,4)
			else
				state = MC.damage_state
		if(!GLOB.mech_damage_overlay_cache["[part]-[state]"])
			var/image/I = image(icon='icons/mob/mecha/mech_hud.dmi',icon_state="dam_[part]")
			switch(state)
				if(1)
					I.color = "#00ff00"
				if(2)
					I.color = "#f2c50d"
				if(3)
					I.color = "#ea8515"
				if(4)
					I.color = "#ff0000"
				else
					I.color = "#f5f5f0"
			GLOB.mech_damage_overlay_cache["[part]-[state]"] = I
		hud_health.overlays |= GLOB.mech_damage_overlay_cache["[part]-[state]"]
