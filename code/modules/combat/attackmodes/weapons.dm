/*
If you want a weapon to have multiple attack methods, all you need to do is fill in an attackmodes list with
the attackmode datums you want it to have.  Remember to put 'new' in front of all of them.

If your weapon uses the material system, you /must/ use a /datum/attackmode/material datum, since those datums will deal
with how material weapons work.

It's recommended you put a /datum/attackmode/default or /datum/attackmode/material/default as the first option on the list.
It will hold the default values for your weapon.  You can even subclass default to change the name and icon if you want.

If you want a material weapon to do a specific amount of weapon (at least for steel), it requires a bit of math.
Just do this easy equation:

If your weapon is sharp or has an edge.
Your Desired Force / Material's 'Hardness' = force_divisor you want.
For steel weapons, hardness equals 60, and will probably be the most common material used for your weapon.

The attackmode datum looks like this;
/datum/attackmode
	name			 = Used to give feedback on what the user's weapon will do next.
	name_short		 = Shorter version used for the UI and a few other places.
	attack_verb		 = A list containing words to use when you hit someone, e.g. "stabs".  Make sure you define this as a list().
	force			 = How strong your weapon hits
	stagger			 = If this is higher than zero, it will try to stagger people you hit.  Higher numbers make it more potent.
	edge			 = If set to one, makes it likely your weapon will sever limbs.
	sharp			 = If set to one, makes bleeding occur easily.
	attack_delay	 = NYI
	attack_cooldown	 = NYI
	icon			 = Path to an icon file to use for the HUD.  Best you don't touch this.
	icon_state		 = String to use to determine which icon inside the icon variable is used for the HUD.

The material version has these in addition to the above;
/datum/attackmode/material
	force_divisor = 0.5
	thrown_force_divisor = 0.5

*/

