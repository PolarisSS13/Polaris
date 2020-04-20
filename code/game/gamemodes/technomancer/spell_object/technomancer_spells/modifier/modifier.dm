// Technomancer specific subtype which keeps track of spell power and gets targeted specificially by Dispel.
/datum/modifier/technomancer
	var/spell_power = null // Set by on_add_modifier.
	technomancer_dispellable = TRUE