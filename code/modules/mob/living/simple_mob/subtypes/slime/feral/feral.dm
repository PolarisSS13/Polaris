// These slimes lack certain xenobio features but get more combat-oriented goodies. Generally these are more oriented towards Explorers than Xenobiologists.

/mob/living/simple_mob/slime/feral
	name = "feral slime"
	desc = "The result of slimes escaping containment from some xenobiology lab."
	icon_scale = 2 // Twice as big as the xenobio variant.
	cores = 6 // Xenobio will love getting their hands on these.
	pixel_y = -10 // Since the base sprite isn't centered properly, the pixel auto-adjustment needs some help.
	description_info = "Note that processing this large slime will give six cores."

// Slimebatoning/xenotasing it just makes it mad at you (which can be good if you're heavily armored and your friends aren't).
/mob/living/simple_mob/slime/feral/slimebatoned(mob/living/user, amount)
	taunt(user, TRUE)