/datum/




/datum/supply_pack
	var/name = null
	var/list/contains = list() // Typepaths, used to actually spawn the contents
	var/list/manifest = list() // Object names, used to compile manifests
	var/cost = null
	var/containertype = null
	var/containername = null
	var/access = null
	var/contraband = 0
	var/num_contained = 0		//number of items picked to be contained in a /randomised crate
	var/group = "Miscellaneous"

/datum/supply_pack/New()
	for(var/path in contains)
		if(!path || !ispath(path, /atom))
			continue
		var/atom/O = path
		manifest += "\proper[initial(O.name)]"

/datum/supply_pack/proc/get_html_manifest()
	var/dat = ""
	if(num_contained)
		dat +="Contains any [num_contained] of:"
	dat += "<ul>"
	for(var/O in manifest)
		dat += "<li>[O]</li>"
	dat += "</ul>"
	return dat

// Keeping this subtype here for posterity, so it's more apparent that this is the subtype to use if making new randomised packs
/datum/supply_pack/randomised
	num_contained = 1