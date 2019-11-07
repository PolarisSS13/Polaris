/datum/record
  var/name = "generic record"
  var/author = "unnamed author"
  var/author_ckey = "unknown"			// Ckey of the person who created this record.
  var/creation_date								// Date record was created OOC'ly.
  var/date_added									// Date record was created IC'ly.
  
  var/details											// Bulk of the record.
  
/datum/record/New(r_name, r_author, r_ckey, r_creation_date, r_date_added, r_details)
  name = r_name
  author = r_author
  author_ckey = r_ckey
  creation_date = r_creation_date
  date_added = r_date_added
  details = r_details
      
  ..()
