
//This is for the round end stats system.

//roundstat is used for easy finding of the variables, if you ever want to delete all of this,
//just search roundstat and you'll find everywhere this thing reaches into.
//It used to be bazinga but it only fly with microwaves.

GLOBAL_VAR_INIT(lights_switched_on_roundstat, 0)
GLOBAL_VAR_INIT(cans_opened_roundstat, 0)
GLOBAL_VAR_INIT(turbo_lift_floors_moved_roundstat, 0)
GLOBAL_VAR_INIT(lost_limbs_shift_roundstat, 0)
GLOBAL_VAR_INIT(seed_planted_shift_roundstat, 0)
GLOBAL_VAR_INIT(step_taken_shift_roundstat, 0)
GLOBAL_VAR_INIT(destroyed_research_items_roundstat, 0)
GLOBAL_VAR_INIT(items_sold_shift_roundstat, 0)
GLOBAL_VAR_INIT(disposals_flush_shift_roundstat, 0)
GLOBAL_VAR_INIT(rocks_drilled_roundstat, 0)

//Virgo specific
//GLOBAL_VAR_INIT(mouse_spawned_shift_roundstat, 0)
//GLOBAL_VAR_INIT(number_people_walked_over_roundstat, 0)
//GLOBAL_VAR_INIT(trash_piles_searched_roundstat, 0)
//GLOBAL_VAR_INIT(rare_trash_found_roundstat, 0)


/hook/roundend/proc/RoundEnd()

	var/lights_switched_on = GLOB.lights_switched_on_roundstat
	var/cans_opened = GLOB.cans_opened_roundstat
	var/turbo_lift_floors_moved = GLOB.turbo_lift_floors_moved_roundstat
	var/lost_limbs_shift = GLOB.lost_limbs_shift_roundstat
	var/seed_planted_shift = GLOB.seed_planted_shift_roundstat
	var/step_taken_shift = GLOB.step_taken_shift_roundstat
	var/destroyed_research_items = GLOB.destroyed_research_items_roundstat
	var/items_sold_shift = GLOB.items_sold_shift_roundstat
	var/disposals_flush_shift = GLOB.disposals_flush_shift_roundstat
	var/rocks_drilled = GLOB.rocks_drilled_roundstat

	//virgo specific too
	//var/mouse_spawned_shift = GLOB.mouse_spawned_shift_roundstat //Virgo
	//var/number_people_walked_over = GLOB.number_people_walked_over_roundstat //Also virgo
	//var/trash_piles_searched = GLOB.trash_piles_searched_roundstat //Those two are only relevant to :b:irgo
	//var/rare_trash_found = GLOB.rare_trash_found_roundstat

	to_world("<B>Shift facts!</B>")

	if(cans_opened > 0)
		to_world("[cans_opened] cans were drank today!")
	if(lights_switched_on > 0)
		to_world("[lights_switched_on] light switches were flipped today!")
	if(turbo_lift_floors_moved > 0)
		to_world("The elevator moved up [turbo_lift_floors_moved] floors today!")
	if(lost_limbs_shift > 0)
		to_world("[lost_limbs_shift] limbs left their owners bodies this shift, oh no!")
	if(seed_planted_shift > 0)
		to_world("[seed_planted_shift] were planted according to our sensors this shift.")
	if(step_taken_shift > 0)
		to_world("The employees walked a total of [step_taken_shift] steps for this shift! It should put them on the road to fitness!")
	if(destroyed_research_items > 0)
		to_world("[destroyed_research_items] objects were destroyed in the name of Science! Keep it up!")
	if(items_sold_shift > 0)
		to_world("The vending machines sold [items_sold_shift] items today.")
	if(disposals_flush_shift > 0)
		to_world("The disposal system flushed a whole [disposals_flush_shift] times for this shift. We should really invest in waste treatement.")
	if(rocks_drilled > 0)
		to_world("Our strong miners pulverized a whole [rocks_drilled] piles of pathetic rubble.")

	//virgo specific aswell
	/*
	if(number_people_walked_over > 0)
		to_world("About [number_people_walked_over] people were trodden upon, look both ways!")
	if(mouse_spawned_shift > 0)
		to_world("The mice population grew by [mouse_spawned_shift] according to our sensors. How unhygienic!")
	if(trash_piles_searched > 0)
		to_world("People rummaged through [trash_piles_searched] trash piles today. Ech.")
	if(rare_trash_found > 0)
		to_world("[rare_trash_found] rare objects were found in the bowels of the station today.")
	*/