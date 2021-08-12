/obj/item
	var/list/tool_qualities

/atom/proc/get_tool_quality(tool_quality)
	return TOOL_QUALITY_NONE

/// Used to check for a specific tool quality on an item.
/// Returns the value of `tool_quality` if it is found, else 0.
/obj/item/get_tool_quality(quality)
	return LAZYFIND(tool_qualities, quality)

/obj/item/proc/set_tool_quality(tool, quality)
	tool_qualities[tool] = quality

/obj/item/proc/get_tool_speed(quality)
	return LAZYFIND(tool_qualities, quality)

/obj/item/proc/get_use_time(quality, base_time)
	return LAZYFIND(tool_qualities, quality) ? base_time / tool_qualities[quality] : -1