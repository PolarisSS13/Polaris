
//This is for the round end stats system.

//Bazinga is used for easy finding of the variables, if you ever want to delete all of this
var/cans_opened_bazinga = 0
var/lights_switched_on_bazinga = 0
var/trash_piles_searched_bazinga = 0
var/rare_trash_found_bazinga = 0
var/turbo_lift_floors_moved_bazinga = 0
var/lost_limbs_shift_bazinga = 0
var/mouse_spawned_shift_bazinga = 0
var/seed_planted_shift_bazinga = 0
var/step_taken_shift_bazinga = 0
var/number_people_walked_over_bazinga = 0
var/destroyed_research_items_bazinga = 0
var/items_sold_shift_bazinga = 0
var/disposals_flush_shift_bazinga = 0
var/rocks_drilled_bazinga = 0

/hook/roundend/proc/RoundEnd()

	var/cans_opened = cans_opened_bazinga
	var/lights_switched_on = lights_switched_on_bazinga
	/*var/trash_piles_searched = trash_piles_searched_bazinga //Those two are only relevant to :b:irgo
	var/rare_trash_found = rare_trash_found_bazinga*/
	var/turbo_lift_floors_moved = turbo_lift_floors_moved_bazinga
	var/lost_limbs_shift = lost_limbs_shift_bazinga
	//var/mouse_spawned_shift = mouse_spawned_shift_bazinga //Virgo
	var/seed_planted_shift = seed_planted_shift_bazinga
	var/step_taken_shift = step_taken_shift_bazinga
	//var/number_people_walked_over = number_people_walked_over_bazinga //Also virgo
	var/destroyed_research_items = destroyed_research_items_bazinga
	var/items_sold_shift = items_sold_shift_bazinga
	var/disposals_flush_shift = disposals_flush_shift_bazinga
	var/rocks_drilled = rocks_drilled_bazinga

	world << "<B>Shift facts!</B>"
	if(cans_opened > 0)
		world << "[cans_opened] cans were drank today!"
	if(lights_switched_on > 0)
		world << "[lights_switched_on] light switches were flipped today!"
/*	if(trash_piles_searched > 0)
		world << "People rummaged through [trash_piles_searched] trash piles today. Ech."
	if(rare_trash_found > 0)
		world << "[rare_trash_found] rare objects were found in the bowels of the station today."*/
	if(turbo_lift_floors_moved > 0)
		world << "The elevator moved up [turbo_lift_floors_moved] floors today!"
	if(lost_limbs_shift > 0)
		world << "[lost_limbs_shift] limbs left their owners bodies this shift, oh no!"
	/*if(mouse_spawned_shift > 0)
		world << "The mice population grew by [mouse_spawned_shift] according to our sensors. How unhygienic!"*/
	if(seed_planted_shift > 0)
		world << "[seed_planted_shift] were planted according to our sensors this shift."
	if(step_taken_shift > 0)
		world << "The employees walked a total of [step_taken_shift] steps for this shift! It should put them on the road to fitness!"
	/*if(number_people_walked_over > 0)
		world << "About [number_people_walked_over] people were trodden upon, look both ways!"*/
	if(destroyed_research_items > 0)
		world << "[destroyed_research_items] objects were destroyed in the name of Science! Keep it up!"
	if(items_sold_shift > 0)
		world << "The vending machines sold [items_sold_shift] items today."
	if(disposals_flush_shift > 0)
		world << "The disposal system flushed a whole [disposals_flush_shift] times for this shift. We should really invest in waste treatement."
	if(rocks_drilled > 0)
		world << "Our strong miners pulverized a whole [rocks_drilled] piles of pathetic rubble."