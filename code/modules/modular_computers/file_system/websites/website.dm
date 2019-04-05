////////////////////////////////////////
//  		Modular sites!			 //
//////////////////////////////////////

//--To make a site, either write the HTML in "content" or make a .txt file and rewrite "path" to point to it--//

var/global/list/websites = list()

/proc/instantiate_websites()
	for(var/instance in subtypesof(/datum/website))
		new instance

/datum/website
	var/name = "coolsite.biz" //The """"URL"""" they have to search for. CONTENT is any HTML you want to show on the site, anything that works with IE8 will work here, so go nuts.
	var/content = "<h1>A heading!</h1>\
	<h2>Any standard HTML works here!</h2>\
	<p>Sign our guestbook!</p>"
	var/x = 600
	var/y = 600 //Window size!
	var/path = null // If you want to load your site from a TXT, make a txt file in config/websites/ and edit path to point to it.
	var/password = null //Set this if you require a password.
	var/max_length = 1000 //Feel free to remove this. This limits your HTML to 1000 lines to prevent gigaspam.

/datum/website/proc/on_access(var/mob/user) //Special code for sites, this is used for the site making site.
	return TRUE

/datum/website/New()
	. = ..()
	websites += src
	if(path)
		content = file2text("[path]")

/datum/website/news
	name = "geminusstandard.nt"
	content = "<h1>The Geminus Standard</h1>\
	<h2>The home of everything Geminus!</h2>\
	<p>Come here for all your news...and stuff</p>"

/datum/website/syndiehub
	name = "syndi.cat"
	path = "config/websites/syndihub.txt"
	x = 1000
	y = 800

/datum/website/error
	name = "404"
	path = "config/websites/404.txt"
	x = 1000
	y = 800

/datum/website/creator
	name = "websitemaker.nt" //Allows you to make your own sites
	path = "config/websites/sitemaker.txt"
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
	var/datum/browser/popup = new(user, "[godaddy.name]", "NToogle search engine", godaddy.x, godaddy.y)
	popup.set_content(godaddy.content)
	popup.open()
	log_game("[user] published website: [toname]. With content: [new_content]")
	message_admins("[user] just published a website: [toname]. Check the logs for its HTML code.")

/obj/item/device/communicator/proc/browser_init(mob/user)
	var/datum/browser/popup = new(user, "nanosearch.nt", "NToogle search engine", 600, 600)
	var/content = "<img src='https://cdn.discordapp.com/attachments/509899434415620116/563094943418155028/unknown.png' usemap='#image-map'>\
	<map name='image-map'>\
	<area target='' alt='search' title='search' href='?src=\ref[src];search=1'coords='123,237,503,276' shape='rect'>\
	<area target='' alt='search' title='search' href='?src=\ref[src];search=1'coords='109,38,506,79' shape='rect'>\
	</map>"
	popup.set_content(content)
	popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
	popup.open()

/obj/item/device/communicator/proc/search(mob/user)
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
		var/datum/browser/popup = new(user, "[target.name]", "NToogle search engine", target.x, target.y)
		popup.set_content(target.content)
		popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
		popup.open()