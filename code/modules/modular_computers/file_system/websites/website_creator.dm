/datum/website/creator
	name = "websitemaker.nt" //Allows you to make your own sites
	title = "GoNT"
	path = "websites/sitemaker.txt"
	var/max_websites = 40 //To avoid killing the game.
	var/name_length_limit = 50 //Massivelongurltotryandcrashpoorcassieserver.co.uk
	var/max_html_limit = 500 //Change this as you see fit. This is to stop Rshoe from uploading 40 websites with 20,000 lines of POGCHAMP.jpg.

/datum/website/creator/on_access(user)
	if(websites.len >= max_websites)
		to_chat(user, "Your company has exceeded their allotted NT free server hosting space, please contact central comand to consider upgrading to the PRO package.")
		return
	var/toname = input("Welcome to the NT approved site creator! Please enter a domain for your site.", "NT site creator", null, null) as text
	toname = sanitize(toname) //let's try to not link your admins to pornhub everytime someone makes a site.
	if(!findtext(toname, "."))
		to_chat(user, "You need to specify a domain! (Eg, .nt, .info, .biz)")
		return FALSE
	if(length(toname) >= name_length_limit)
		to_chat(user, "You cannot make a site with a name longer than [name_length_limit] characters.")
		return FALSE
	for(var/X in websites)
		var/datum/website/check = X
		if(check.name == toname)
			to_chat(user, "This site [toname] has already been registered!")
			return FALSE
	var/new_content = input("Please write the HTML for your site here. (NB. All external links will be removed but any valid HTML will work here)", "Write", null, null) as message
	if(!new_content)
		return
	if(length(new_content) >= max_html_limit) //piss off RSHOE
		to_chat(user, "You are limited to [max_html_limit] lines of HTML per website on your company's plan. Please try again.")
		return
	//Now we're going to do some basic sanitization so you (hopefully) can't just link to an actual virus.
	new_content = replacetext(new_content, "https://", "{LINK EXPUNGED}")
	new_content = replacetext(new_content, "www.", "{LINK EXPUNGED}")
	new_content = replacetext(new_content, "http://", "{LINK EXPUNGED}")
	new_content = replacetext(new_content, "href", "{HREF REMOVED}") //HREF exploits are a pain in the ass.
	var/datum/website/godaddy = new /datum/website
	godaddy.name = toname
	godaddy.content = new_content
	var/datum/browser/popup = new(user, "[godaddy.name]", "NToogle search engine")
	popup.set_content(godaddy.content)
	popup.open()
	log_game("[user] published website: [toname]. With content: [new_content]")
	message_admins("[user] just published a website: [toname]. Check the logs for its HTML code.")
