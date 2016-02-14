/*
Slimes rewrite! Planned features include customizable colors on slimes with uncolored sprites, Xenoflora DNA + interaction
Things that are currently planned:
- Xenoflora "DNA" integration (trait system)
- Different methods of consumption
- Holder plans (Devices that feed in a radius? Devices for manual feeding? Other ideas?)
- "Robust" reproductive system (How to split better? Mating + others?)
- Friendly list, similar to old friendly list implementation
- Pets! (Because slime breeding ranches might be something interesting prospect for the "future".)


Things that are currently implemented:
-
*/
/mob/living/xenomorphic/slime //Adult values are found here
	nameVar = "grey"		//When mutated, nameVar might change.
	desc = "A shifting, mass of goo."
	speak_emote = list("garbles", "chirps")
	maxHealth = 30
	moveTiming = 10 //Lower is faster
	colored = 1
	color = "#CACACA"
	icon = 'icons/mob/slimes.dmi'
	icon_state = "slime adult"
	icon_living = "slime adult"
	icon_dead = "slime adult dead"
	var/is_adult = 0
	var/cores = 1
	
	
	var/shiny = 1 // 1 = normal lighting, 0 = shiny, 2 = too shiny, -1 = no lighting
	
/mob/living/xenomorphic/slime/red
	nameVar = "red"
	color = "#FF0000"
	
/mob/living/xenomorphic/slime/green
	nameVar = "green"
	color = "#00FF00"
	
/mob/living/xenomorphic/slime/blue
	nameVar = "blue"
	color = "#2631FF"
	
/mob/living/xenomorphic/slime/gold
	nameVar = "gold"
	shiny = 0
	color = "#FFC300"
	
/mob/living/xenomorphic/slime/gold2
	nameVar = "gold"
	shiny = 2
	color = "#FFC300"

/mob/living/xenomorphic/slime/New(var/is_adult)
	..()
	overlays.Cut()
	
	if(!is_adult)
		name = "[nameVar] baby slime"
		real_name = " baby slime"
		desc = "A shifting blob of [nameVar] goo."
		icon_state = "slime baby"
		icon_living = "slime baby"
		icon_dead = "slime baby dead"
		maxHealth = 20
		health = maxHealth
		moveTiming = 15
	
	if(is_adult)
		name = "[nameVar] slime"
		real_name = "[nameVar] slime"
		desc = "A shifting mass of [nameVar] goo."
		//Hack and slash adventure game to make slimes have no color on light effects later
		color = ""
		icon_state = ""
		var/image/Img = new(src.icon)
		Img.icon_state = "slime adult"
		Img.color = colorVar
		Img.layer = src.layer
		overlays += Img
	
		health = maxHealth
	
		switch(shiny)
			if(0)
				var/image/I = new(src.icon)
				I.icon = src.icon
				I.icon_state = "slime shiny"
					I.layer = src.layer + 0.1
				I.color = "#FFFFFF"
				overlays += I
			if(1)
				var/image/I = new(src.icon)
				I.icon = src.icon
				I.icon_state = ""
				I.icon_state = "slime light"
				I.layer = src.layer + 0.1
				I.color = "#FFFFFF"
				overlays += I
			/*
			Uncommented until it is desired.
			if(2)
				var/image/I = new(src.icon)
				I.icon = src.icon
				I.icon_state = ""
				I.icon_state = "slime shiny2"
				I.layer = src.layer + 0.1
				I.color = "#FFFFFF"
				overlays += I
			*/
	return 1
	