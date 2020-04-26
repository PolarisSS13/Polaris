// Metadata about specific spells.
// These live inside each Technomancer's core.
/datum/spell_metadata
	var/name = null // Shown in UIs.
	var/spell_path = null // The path to spawn when casting the spell.
	var/exclude_from_gambit = FALSE // If true, the Gambit spell isn't allowed to choose this spell. Empty names are also implicitly blocked.

	var/icon = null // Icon file to use for HUD elements.
	var/icon_state = null // Which icon to use in the icon file defined above.

	var/charges = null // If not null, the spell can only be used a certain number of times.
	var/charge_regen_rate = null // If not null, then charges regenerate based on this var. E.g. 20 SECONDS.

	var/cooldown = null // If not null, each spell cast is limited by this amount of time.
	var/last_cast_time = null // world.time of when the spell was last used.

// Returns an assoc list of various stats about a specific spell, e.g. "Range" = "7".
// This is used to display spell numbers in the spellbook.
/datum/spell_metadata/proc/get_spell_info()
	return list()