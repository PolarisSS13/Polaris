/world
	hub = "Exadv1.spacestation13"
	name = "Space Station 13"

/world/proc/update_hub_visibility(new_status)
	if (isnull(new_status))
		new_status = !config.hub_visible
	config.hub_visible = new_status
	if (config.hub_visible)
		hub_password = "kMZy3U5jJHSiBQjr"
	else
		hub_password = "SORRYNOPASSWORD"
