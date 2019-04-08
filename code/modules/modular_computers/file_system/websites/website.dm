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
	var/title
	var/content = "<h1>A heading!</h1>\
	<h2>Any standard HTML works here!</h2>\
	<p>Sign our guestbook!</p>"
	var/x = 600
	var/y = 600 //Window size!
	var/path = null // If you want to load your site from a TXT, make a txt file in websites/ and edit path to point to it.
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
	title = "The Geminus Standard"
	content = "<h1>The Geminus Standard</h1>\
	<h2>The home of everything Geminus!</h2>\
	<p>Come here for all your news...and stuff</p>"

/datum/website/syndiehub
	name = "syndi.cat"
	title = "Website Seized"
	path = "websites/syndihub.txt"
	x = 1000
	y = 800

/datum/website/error
	name = "404"
	title = "Error - Page not found"
	path = "websites/404.txt"
	x = 1000
	y = 800

/datum/website/ntoogle
	name = "ntoogle.nt"
	title = "Ntoogle Search"
	x = 640
	y = 405

/datum/website/ntoogle/New()
	..()
	content = "<img src = 'ntoogle.png' usemap='#image-map'>\
	<map name='image-map'>\
	<area target='' alt='search' title='search' href='?src=\ref[src];operation=search'coords='123,237,503,276' shape='rect'>\
	</map>"

/obj/item/device/communicator/proc/browser_init(mob/user)
	var/datum/browser/popup = new(user, "nanosearch.nt", "NToogle search engine", 600, 600)
	var/content = "<img src = 'ntoogle.png' usemap='#image-map'>\
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