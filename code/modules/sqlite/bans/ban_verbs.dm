/client/proc/sqlite_ban_panel()
	set name = "Ban Panel"
	set category = "Admin"
	set desc = "Opens the ban panel."

	if(!holder)
		return

	holder.sqlite_ban_panel()

/datum/admins/proc/sqlite_ban_panel(var/filter_ckey, var/filter_ip, var/filter_cid, var/filter_admin)
	if(!usr.client)
		return

	if(!check_rights(R_BAN))
		return

	establish_sqlite_connection()
	if(!sqlite_db)
		usr << "<span class='danger'>Failed to establish database connection!</span>"
		return

	var/list/data = list(filter_ckey, filter_ip, filter_cid, filter_admin)
	var/encoded_data = json_encode(data)

	var/HTML = "<html><head><title>Ban Panel</title></head><body>"
	HTML += "<h1>Ban Panel</h1><br>"
	HTML += "<b>Add New Bans</b><br>"
	HTML += "<a href='?src=\ref[src];sqlite_topic_add_manual_ban=1'>\[Add Ban\]</a>"
	HTML += "<br>"
	HTML += "<b>Ban Filters</b><br>"
	if(filter_ckey || filter_ip || filter_cid || filter_admin)
		HTML += "Active filters: ckey=[filter_ckey], ip=[filter_ip], cid=[filter_cid], admin=[filter_admin]<br>"
	HTML += "<a href='?src=\ref[src];ban_panel_filter=ckey;ban_panel_data=[encoded_data]'>\[Filter Ckey\]</a> | "
	HTML += "<a href='?src=\ref[src];ban_panel_filter=ip;ban_panel_data=[encoded_data]'>\[Filter IP\]</a> | "
	HTML += "<a href='?src=\ref[src];ban_panel_filter=cid;ban_panel_data=[encoded_data]'>\[Filter Comp. ID\]</a> | "
	HTML += "<a href='?src=\ref[src];ban_panel_filter=banningadmin;ban_panel_data=[encoded_data]'>\[Filter Banning Admin\]</a> | "
	HTML += "<a href='?src=\ref[src];ban_panel_filter=reset;ban_panel_data=[encoded_data]'>\[Reset\]</a>"
	HTML += "<br>"
	HTML += "Below is a list of all the bans loaded.  Click on a link to see more information about the ban, or if you wish to \
	modify or lift the ban.<br>"
	HTML += "<br>"
	HTML += "Color Guide: <font color='800000'><b>Banned</b></font> | <font color='008000'><b>Lifted</b></font> | <font color='000080'><b>Expired</b></font><br>"
	HTML += "Position Guide: ID | Ckey | (Type) | Banning Admin<br>"

	for(var/datum/ban/B in allbans)
		if(filter_ckey && filter_ckey != B.data["ckey"])
			continue
		if(filter_ip && filter_ip != B.data["ip"])
			continue
		if(filter_cid && filter_cid != B.data["computerid"])
			continue
		if(filter_admin && filter_admin != B.data["banning_ckey"])
			continue
		var/line_color = "#800000" // Dark red
		if(B.lifted())
			line_color = "#008000" // Dark green
		else if(B.expired())
			line_color = "#000080" // Dark blue

		var/bantype_text = "[B.data["bantype"]]"
		if(B.data["bantype"] == BAN_JOBBAN)
			bantype_text = "[B.data["bantype"]]: [B.data["job"]]"
		var/line_text = "#[B.data["id"]] [B.data["ckey"]] ([bantype_text]) by [B.data["banning_ckey"]]"
		HTML += "<a href='?src=\ref[B];view_ban=1'><font color='[line_color]'>[line_text]</font></a><br>"

	HTML +="</body></html>"
	usr << browse(HTML, "window=log;size=400x444;border=1;can_resize=1;can_close=1;can_minimize=1")
