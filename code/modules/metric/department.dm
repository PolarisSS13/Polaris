/datum/metric/proc/guess_job(var/mob/M)
	if(!M)
		return null
	var/result = get_job_from_records(M)
	if(result)
		return result
	if(M.mind)
		return M.mind.assigned_role
	return M.job


// This proc tries to find the department of an arbitrary mob.
/datum/metric/proc/guess_department(var/mob/M)
	if(!M)
		return null
	var/list/found_roles = list()

	// We do this first because borgs exist.
	found_roles = M.get_department_from_mob()
	if(check_if_finished(found_roles))
		return found_roles

	// Records are usually the most reliable way to get what job someone is.
	found_roles = get_department_from_records()
	if(check_if_finished(found_roles))
		return found_roles

	// They have a custom title, aren't crew, or someone deleted their record, so we need a fallback method.
	// Let's check the mind.
	found_roles = get_department_from_mind()
	if(check_if_finished(found_roles))
		return found_roles

	// At this point, they don't have a mind, or for some reason assigned_role didn't work.
	found_roles = role_name_to_department(M.job)
	if(check_if_finished(found_roles))
		return found_roles

	return list(ROLE_UNKNOWN) // Welp.

/datum/metric/proc/get_department_from_records(var/mob/M)
	var/datum/data/record/R = find_general_record("name", M.real_name)
	if(R) // We found someone with a record.
	//	var/recorded_rank = R.fields["real_rank"]
		var/recorded_rank = make_list_rank(R.fields["real_rank"]) // Make titles like Acting Chief Engineer count as Chief Engineer.

		return role_name_to_department(recorded_rank)
	return list(ROLE_UNKNOWN)

/datum/metric/proc/get_job_from_records(var/mob/M)
	var/datum/data/record/R = find_general_record("name", M.real_name)
	if(R)
		var/recorded_rank = make_list_rank(R.fields["real_rank"]) // Make titles like Acting Chief Engineer count as Chief Engineer.

		return recorded_rank
	return null

/datum/metric/proc/get_department_from_mind(var/mob/M)
	if(M.mind)
		return role_name_to_department(M.mind.assigned_role)
	return list(ROLE_UNKNOWN)

/datum/metric/proc/check_if_finished(var/list/roles)
	if(!roles.len || ROLE_UNKNOWN in roles)
		return FALSE
	return TRUE

// Feed this proc the name of a job, and it will try to figure out what department they are apart of.
// Note that this returns a list, as some jobs are in more than one department, like Command.  The 'primary' department is the first
// in the list, e.g. a HoS has Security as first, Command as second in the returned list.
/datum/metric/proc/role_name_to_department(var/role_name)
	var/list/result = list()

	if(role_name in security_positions)
		result += ROLE_SECURITY

	if(role_name in engineering_positions)
		result += ROLE_ENGINEERING

	if(role_name in medical_positions)
		result += ROLE_MEDICAL

	if(role_name in science_positions)
		result += ROLE_RESEARCH

	if(role_name in cargo_positions)
		result += ROLE_CARGO

	if(role_name in civilian_positions)
		result += ROLE_CIVILIAN

	if(role_name in nonhuman_positions)
		result += ROLE_SYNTHETIC

	if(role_name in command_positions) // We do Command last, since we consider command to only be a primary department for hop/admin.
		result += ROLE_COMMAND

	if(!result.len) // No department was found.
		result += ROLE_UNKNOWN
	return result

// Feed a name to this to hopefully get back the job datum that is desired.
/datum/metric/proc/role_name_to_job_datum(var/role_name)
	role_name = make_list_rank(role_name) // Make titles like Acting Chief Engineer count as Chief Engineer.
	var/list/jobs = get_job_datums()
	for(var/datum/job/J in jobs)
		if(J.title == role_name)
			return J

/datum/metric/proc/count_people_in_department(var/department)
	if(!department)
		return
	for(var/mob/M in player_list)
		if(guess_department(M) != department) // Ignore people outside the department we're counting.
			continue
		. += 1