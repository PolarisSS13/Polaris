// This is a defines file for card sprite stacks. If a new card set comes in, this file can just be disabled and a new one made to match the new sprites.
// Generally, if the icon file is card_xxx.dmi, this filename should be sprite_stacks_xxx.dm
// Please make sure that only the relevant sprite_stacks_xxx.file is included, if more are made.



/obj/item/weapon/card
	icon = 'icons/obj/card_new.dmi' // These are redefined here so that changing sprites is as easy as clicking the checkbox.
	base_icon = "icons/obj/card_new.dmi"

	// New sprite stacks can be defined here. You could theoretically change icon-states as well but right now this file compiles before station_ids.dm so those wouldn't be affected.
	id
		silver
			secretary
				initial_sprite_stack = list("base-stamp", "top-command", "letter-n-command")
			hop
				initial_sprite_stack = list("base-stamp-silver", "top-command", "letter-n-command", "pips-gold")
		medical
			chemist
				initial_sprite_stack = list("", "pips-engineering")
			geneticist
				initial_sprite_stack = list("base-stamp", "top-medical", "letter-n-science", "pips-science")
			head
				initial_sprite_stack = list("base-stamp-silver", "top-command-medical", "letter-n-command", "pips-medical")
		security
			warden
				initial_sprite_stack = list("", "pips-gold")
			head
				initial_sprite_stack = list("base-stamp-silver", "top-command-security", "letter-n-command", "pips-security")
		engineering
			atmos
				initial_sprite_stack = list("", "pips-medical")
			head
				initial_sprite_stack = list("base-stamp-silver", "top-command-engineering", "letter-n-command", "pips-engineering")
		science
			head
				initial_sprite_stack = list("base-stamp-silver", "top-command-science", "letter-n-command", "pips-science")
		cargo
			miner
				initial_sprite_stack = list("", "pips-science")
			head
				initial_sprite_stack = list("", "pips-gold")
		civilian
			chaplain
				initial_sprite_stack = list("base-stamp-silver", "top-dark", "letter-cross", "pips-mime")
			internal_affairs_agent
				initial_sprite_stack = list("base-stamp", "top-internal-affairs", "letter-n-command")
			clown
				initial_sprite_stack = list("base-stamp", "top-clown", "letter-n-clown")
			mime
				initial_sprite_stack = list("base-stamp", "top-mime", "letter-n-mime")
			head //Not used but I'm defining it anyway.
				initial_sprite_stack = list("base-stamp-silver", "top-command", "letter-n-command", "pips-civilian")

// The following are defined in southern_cross_jobs.dm for some reason. Despite being part of the main game now. Nonetheless, they stay here until folded in right.
/obj/item/weapon/card/id/medical/sar
	initial_sprite_stack = list("", "pips-science")
/obj/item/weapon/card/id/civilian/pilot
	initial_sprite_stack = list("", "pips-science")
/obj/item/weapon/card/id/science/explorer
	initial_sprite_stack = list("", "top-command-explorer")

//Ditto in southern_cross_jobs_vr.dm
/obj/item/weapon/card/id/science/head/pathfinder
	initial_sprite_stack = list("", "top-command-explorer", "pips-gold")