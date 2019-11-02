/*
 * Home of the New (NOV 1st, 2019) library books.
 */

/obj/item/weapon/book/custom_library
	name = "Book"
	desc = "A hardbound book."
	description_info = "This book is printed from the custom repo. If you can see this, something went wrong."

	icon = 'icons/obj/custom_books.dmi'
	icon_state = "book"

	// This is the ckey of the book's author.
	var/origkey = null
	author = "UNKNOWN"
