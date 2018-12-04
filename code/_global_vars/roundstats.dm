
//This is for the round end stats system.

//roundstat is used for easy finding of the variables, if you ever want to delete all of this,
//just search roundstat and you'll find everywhere this thing reaches into.
//It used to be bazinga but it only fly with microwaves.

GLOBAL_VAR_INIT(cans_opened_roundstat, 0)
GLOBAL_VAR_INIT(lights_switched_on_roundstat, 0)
GLOBAL_VAR_INIT(turbo_lift_floors_moved_roundstat, 0)
GLOBAL_VAR_INIT(lost_limbs_shift_roundstat, 0)
GLOBAL_VAR_INIT(seed_planted_shift_roundstat, 0)
GLOBAL_VAR_INIT(step_taken_shift_roundstat, 0)
GLOBAL_VAR_INIT(destroyed_research_items_roundstat, 0)
GLOBAL_VAR_INIT(items_sold_shift_roundstat, 0)
GLOBAL_VAR_INIT(disposals_flush_shift_roundstat, 0)
GLOBAL_VAR_INIT(rocks_drilled_roundstat, 0)

/hook/roundend/proc/RoundEnd()//bazinga

	to_world("<B>Shift facts!</B>")

	if(GLOB.cans_opened_roundstat > 0)
		to_world("[GLOB.cans_opened_roundstat] cans were drank today!")
	if(GLOB.lights_switched_on_roundstat > 0)
		to_world("[GLOB.lights_switched_on_roundstat] light switches were flipped today!")
	if(GLOB.turbo_lift_floors_moved_roundstat > 0)
		to_world("The elevator moved up [GLOB.turbo_lift_floors_moved_roundstat] floors today!")
	if(GLOB.lost_limbs_shift_roundstat > 0)
		to_world("[GLOB.lost_limbs_shift_roundstat] limbs left their owners bodies this shift, oh no!")
	if(GLOB.seed_planted_shift_roundstat > 0)
		to_world("[GLOB.seed_planted_shift_roundstat] were planted according to our sensors this shift.")
	if(GLOB.step_taken_shift_roundstat > 0)
		to_world("The employees walked a total of [GLOB.step_taken_shift_roundstat] steps for this shift! It should put them on the road to fitness!")
	if(GLOB.destroyed_research_items_roundstat > 0)
		to_world("[GLOB.destroyed_research_items_roundstat] objects were destroyed in the name of Science! Keep it up!")
	if(GLOB.items_sold_shift_roundstat > 0)
		to_world("The vending machines sold [GLOB.items_sold_shift_roundstat] items today.")
	if(GLOB.disposals_flush_shift_roundstat > 0)
		to_world("The disposal system flushed a whole [GLOB.disposals_flush_shift_roundstat] times for this shift. We should really invest in waste treatement.")
	if(GLOB.rocks_drilled_roundstat > 0)
		to_world("Our strong miners pulverized a whole [GLOB.rocks_drilled_roundstat] piles of pathetic rubble.")