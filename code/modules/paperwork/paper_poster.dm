/obj/item/sticky_pad/poster
	name = "adhesive poster stack"
	desc = "A stack of A3 papers with adhesive strips for attaching to walls."
	icon = 'icons/obj/stickyposter.dmi'
	color = COLOR_WHITE
	icon_state = "poster_full"
	description_info = "Click to remove an adhesive poster from the pile. Click-drag to yourself to pick up the stack. Sticky posters stuck to surfaces/objects will persist for 50 rounds."
	paper_type = /obj/item/paper/sticky/poster
	papername = "adhesive poster"

/obj/item/sticky_pad/poster/update_icon()
	if(papers <= 15)
		icon_state = "poster_empty"
	else if(papers <= 50)
		icon_state = "poster_used"
	else
		icon_state = "poster_full"
	if(written_text)
		icon_state = "[icon_state]_writing"

/obj/item/sticky_pad/poster/yellow
	color = COLOR_YELLOW

/obj/item/sticky_pad/poster/blue
	color = COLOR_BABY_BLUE

/obj/item/sticky_pad/poster/command
	color = COLOR_COMMAND_BLUE

/obj/item/paper/sticky/poster
	name = "adhesive poster"
	desc = "An A3 sheet of paper with adhesive strips for attaching to walls."
	icon = 'icons/obj/stickyposter.dmi'
	color = COLOR_WHITE
	stickytype = /datum/persistent/paper/sticky/poster