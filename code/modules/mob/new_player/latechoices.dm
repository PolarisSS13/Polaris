
/mob/new_player/proc/LateChoices()
	var/dat = "<div class='notice'>Round Duration: [roundduration2text()]</div>"

	if(emergency_shuttle)
		if(emergency_shuttle.going_to_centcom())
			dat += "<div class='notice red'>The city has been evacuated.</div><br>"
		if(emergency_shuttle.online())
			if(emergency_shuttle.evac)
				dat += "<div class='notice red'>The city is currently undergoing civilian evacuation procedures.</div><br>"

	var/available_job_count = 0
	for(var/datum/job/J in job_master.occupations)
		if(J && IsJobUnavailable(J.title, TRUE) == JOB_AVAILABLE)
			available_job_count++;
			break;

	if(!available_job_count)
		dat += "<div class='notice red'>There are currently no open positions!</div>"

	else

 	// if(length(SSjob.prioritized_jobs))
	// 	dat += "<div class='notice red'>The station has flagged these jobs as high priority:<br>"
	// 	for(var/datum/job/a in SSjob.prioritized_jobs)
	// 		dat += " [a.title], "
	// 	dat += "</div>"

		dat += "<div class='clearBoth'>Choose from the following open positions:</div><br>"
		var/list/categorizedJobs = list(
			"Council" = list(jobs = list(), titles = command_positions, color = "#aac1ee"),
			"Emergency" = list(jobs = list(), titles = engineering_positions, color = "#ffd699"),
			"Supply" = list(jobs = list(), titles = cargo_positions, color = "#ead4ae"),
			"Government" = list(jobs = list(),  titles = gov_positions, color = "#0F0F6F", colBreak = TRUE),
			"Misc" = list(jobs = list(), titles = list(), color = "#ffffff", colBreak = TRUE),
			"Synth" = list(jobs = list(), titles = nonhuman_positions, color = "#ccffcc"),
			"Service" = list(jobs = list(), titles = civilian_positions, color = "#cccccc"),
			"Hospital" = list(jobs = list(), titles = medical_positions, color = "#99ffe6", colBreak = TRUE),
			"Science" = list(jobs = list(), titles = science_positions, color = "#e6b3e6"),
			"Police" = list(jobs = list(), titles = security_positions, color = "#ff9999"),
		)
		for(var/datum/job/job in job_master.occupations)
			if(job && IsJobUnavailable(job.title, TRUE) == JOB_AVAILABLE)
				var/categorized = FALSE
				for(var/jobcat in categorizedJobs)
					var/list/jobs = categorizedJobs[jobcat]["jobs"]
					if(job.title in categorizedJobs[jobcat]["titles"])
						categorized = TRUE
						if(jobcat == "Council")
							if(job.title == "Mayor") // Put captain at top of command jobs
								jobs.Insert(1, job)
							else
								jobs += job
						else // Put heads at top of non-command jobs
							if(job.title in command_positions)
								jobs.Insert(1, job)
							else
								jobs += job
				if(!categorized)
					categorizedJobs["Misc"]["jobs"] += job

 		dat += "<table><tr><td valign='top'>"
		for(var/jobcat in categorizedJobs)
			if(categorizedJobs[jobcat]["colBreak"])
				dat += "</td><td valign='top'>"
			if(length(categorizedJobs[jobcat]["jobs"]) < 1)
				continue
			var/color = categorizedJobs[jobcat]["color"]
			dat += "<fieldset style='border: 2px solid [color]; display: inline'>"
			dat += "<legend align='center' style='color: [color]'>[jobcat]</legend>"
			for(var/datum/job/job in categorizedJobs[jobcat]["jobs"])
				var/position_class = "otherPosition"
				if(job.title in command_positions)
					position_class = "commandPosition"
				if(job in job_master.prioritized_jobs)
					dat += "<a class='[position_class]' style='display:block;width:170px' href='byond://?src=[REF(src)];SelectedJob=[job.title]'><font color='lime'><b>[job.title] ([job.current_positions])</b></font></a>"
				else
					dat += "<a class='[position_class]' style='display:block;width:170px' href='byond://?src=[REF(src)];SelectedJob=[job.title]'>[job.title] ([job.current_positions])</a>"
			dat += "</fieldset><br>"


 		dat += "</td></tr></table></center>"
		dat += "</div></div>"

 	// Removing the old window method but leaving it here for reference
	//src << browse(dat, "window=latechoices;size=300x640;can_close=1")

 	// Added the new browser window method
	var/datum/browser/popup = new(src, "latechoices", "Choose Profession", 680, 580)
	popup.add_stylesheet("playeroptions", 'html/browser/playeroptions.css')
	popup.set_content(dat)
	popup.open(FALSE) // 0 is passed to open so that it doesn't use the onclose() proc

