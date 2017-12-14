#define GRAB_NORMAL        "normal"
#define GRAB_NAB           "nab"

#define NORM_PASSIVE       "normal passive"
#define NORM_AGGRESSIVE    "normal aggressive"
#define NORM_NECK          "normal neck"
#define NORM_KILL          "normal kill"

#define NAB_PASSIVE        "nab passive"
#define NAB_AGGRESSIVE     "nab aggressive"
#define NAB_KILL           "nab kill"

/mob/living
	var/obj/item/grab/current_grab_type     // What type of grab they use when they grab someone.
