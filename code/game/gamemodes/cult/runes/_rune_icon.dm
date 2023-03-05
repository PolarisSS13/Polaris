/obj/effect/newrune/update_icon()
	assemble_icon()
	. = ..()

/obj/effect/newrune/proc/assemble_icon()
	var/vocab = cult?.vocabulary
	if (circle_words.len == 3 && vocab)
		icon = get_uristrune_cult(vocab[circle_words[1]], vocab[circle_words[2]], vocab[circle_words[3]])
