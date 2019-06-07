// See websites.dm for websites list


/datum/computer_file/program/nt_explorer
	filename = "nt_explorer"					// File name, as shown in the file browser program.
	filedesc = "NT Explorer"				// User-Friendly name. In this case, we will generate a random name in constructor.
	extended_desc = "The go-to browser for your everyday NTnet browsing."		// A nice description.
	size = 5								// Size in GQ. Integers only. Smaller sizes should be used for utility/low use programs (like this one), while large sizes are for important programs.
	requires_ntnet = 1
	available_on_ntnet = 1					// ... but we want it to be available for download.
	nanomodule_path = /datum/nano_module/nt_explorer/	// Path of relevant nano module. The nano module is defined further in the file.
	usage_flags = PROGRAM_ALL

/datum/nano_module/nt_explorer
	var/datum/website/current_website
	var/homepage = "ntoogle.nt"


	var/browser_content
	var/browser_title
	var/browser_url
	var/interactive_website

	var/party_cost



/datum/nano_module/nt_explorer/New()
	..()
	if(!websites.len)
		instantiate_websites()
	current_website = locate(/datum/website/ntoogle) in websites
	fetch_website_data()

/datum/nano_module/nt_explorer/proc/fetch_website_data()
	if(current_website)
		browser_content = current_website.content
		browser_title = current_website.title
		browser_url = current_website.name
		interactive_website = current_website.interactive_website

/datum/nano_module/nt_explorer/proc/browse_url(var/url)
	current_website = locate(url) in websites
	fetch_website_data()

/datum/nano_module/nt_explorer/proc/search(mob/user)
	if(!websites.len)
		instantiate_websites()
	var/search = input("Enter a URL", "NT search engine", null, null)  as text
	if(!search)
		return
	var/datum/website/target
	for(var/datum/website/current in websites)
		if(findtext(search, "[current.name]"))
			target = current
			break
	if(!target)
		target = locate(/datum/website/error) in websites
	if(target.on_access(user))
		browser_content = target.content
		browser_title = target.title
		browser_url = target.name
		current_website = target
		interactive_website = target.interactive_website

/datum/nano_module/nt_explorer/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
	var/list/data = list()
	if(program)
		data = program.get_header_data()

	data["website_content"] = browser_content
	data["website_title"] = browser_title
	data["website_url"] = browser_url
	data["interactive_website"] = interactive_website

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "ntnet_explorer.tmpl", "NtNet Explorer", 690, 680, state = state)
		ui.add_template("Website", "ntnet_explorer_website.tmpl") // Main body
		if(program.update_layout())
			ui.auto_update_layout = 1
		ui.set_auto_update(1)
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/nt_explorer/Topic(href, href_list)
	if(..())
		return 1
	if(href_list["Browse"])
		. = 1
		search()

	if(href_list["Refresh"])
		. = 1
		fetch_website_data()

