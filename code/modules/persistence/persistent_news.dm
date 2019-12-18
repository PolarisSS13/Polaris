var/global/datum/economy/news/news_data = new /datum/economy/news

/datum/feed_network/New()
	CreateFeedChannel("Geminus Standard", "NanoTrasen News Authority", 1, 1, "New Issue of Geminus Standard!", 1)
	CreateFeedChannel("City Announcements", "City Council", 1, 1, "New City Announcement Available", 0)

/datum/economy/news
	var/path = "data/persistent/news/news.sav"
//	var/img_path = "data/persistent/news/"
//Maybe needed? Not sure.
	var/datum/feed_channel/city_newspaper
	var/datum/feed_channel/save_data
	
	var/city_anchors = list()		// list of uids of editors for geminus standard
	var/city_anchor_managers = list()	// list of uids of managers for geminus standard
	
	var/photo_data_path = "data/persistent/news/images"

/datum/economy/news/New()
	..()
	for(var/datum/feed_channel/F in news_network.network_channels)
		if(F.channel_name == "Geminus Standard")
			city_newspaper = F
			break

	load_main_news()

/datum/economy/news/proc/news_edit_list()	// unique ids are stored in these vars
	return (city_anchors || city_anchor_managers)

/datum/economy/news/proc/save_main_news()
	if(!path)				return 0
	var/savefile/S = new /savefile(path)
	if(!fexists(path))			return 0
	if(!S)					return 0
	S.cd = "/"

	if(!news_network)
		return

	if(!city_newspaper)
		message_admins("Save: Could not find Geminus Standard.", 1)
		return

	//just in case.
	if(save_data)
		qdel(save_data)

	save_data = new /datum/feed_channel
	save_data.messages = city_newspaper.messages

	S["city_newspaper_articles"] << save_data

	return 1

/datum/economy/news/proc/load_main_news()
	if(!path)				return 0
	if(!fexists(path))
		save_main_news()
		return 0
	var/savefile/S = new /savefile(path)
	if(!S)					return 0
	S.cd = "/"

	if(!news_network)
		return

	if(!city_newspaper)
		message_admins("Load: Could not find Geminus Standard.", 1)
		return

	S["city_newspaper_articles"] >> save_data

	city_newspaper.messages = save_data.messages


	return 1
