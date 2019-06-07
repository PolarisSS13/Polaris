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
	var/path = null // If you want to load your site from a TXT, make a txt file in websites/ and edit path to point to it.
	var/password = null //Set this if you require a password.
	var/max_length = 1000 //Feel free to remove this. This limits your HTML to 1000 lines to prevent gigaspam.
	var/interactive_website = 0 //If this is 1, the browser will search for the website in ntnet_explorer_website.tmpl

	var/searchable = 1 // If this is 1 it will appear on public search engines
	var/deepweb // If this is 1 this website can be found on the deepweb


/datum/website/proc/on_access(var/mob/user) //Special code for sites, this is used for the site making site.
	return TRUE

/datum/website/New()
	. = ..()
	websites += src
	if(path)
		content = file2text("[path]")

/datum/website/error
	name = "404"
	title = "Error - Page not found"
	path = "websites/404.txt"

/datum/website/ntoogle
	name = "ntoogle.nt"
	title = "Ntoogle Search"
	interactive_website = "ntoogle"
	var/search_query