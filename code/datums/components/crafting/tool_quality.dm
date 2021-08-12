/obj/item
	var/list/tool_qualities

/atom/proc/get_tool_quality(tool_quality)
	return TOOL_QUALITY_NONE

/// Used to check for a specific tool quality on an item.
/// Returns the value of `tool_quality` if it is found, else 0.
/obj/item/get_tool_quality(tool_quality)
	return LAZYFIND(tool_qualities, tool_quality)