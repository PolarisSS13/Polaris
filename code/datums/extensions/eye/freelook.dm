// For mobs connecting to the station's cameranet without needing AI procs.
/datum/extension/eye/cameranet
	eye_type = /mob/observer/eye/freelook/cameranet

// For mobs connecting to other visualnets. Pass visualnet as eye_args in look().
/datum/extension/eye/freelook
	eye_type = /mob/observer/eye/freelook

/datum/extension/eye/freelook/proc/set_visualnet(var/datum/visualnet/net)
	if(extension_eye)
		var/mob/observer/eye/freelook/fl = extension_eye
		if(istype(fl)) fl.visualnet = net