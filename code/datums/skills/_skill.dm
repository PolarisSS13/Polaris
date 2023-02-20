/// Represents an arbitrary level of competence in an arbitrary subject.
/// Most skills are purely for fluff, but infrastructure's in place that lets them be checked for mechanical purposes too.
/// Skills are tied to mind datums, not the mobs they're inside (an exception is made for silicons, whose skills are dependent on their module.)
/// Skill datums are data-only; they don't have any functionality on their own.
/datum/new_skill
	var/name /// The name of this skill, as shown in user-facing menus.
	var/desc /// The description of this skill, as shown in user-facing menus.
	var/rank /// Some skills have extra ranks. Though the vast majority of skills will be rank 1, other skills can have additional ranks to represent higher competence.
	var/sp_cost /// Every job affords some free skills; others are bought in character creation. This is a cost for that chargen, and is increased for each additional rank. A non-positive value can't be bought.
	var/datum/new_skill/tree /// The tree that this skill is a part of. Medical skills go in the medical tree, and so on.
	var/tree_parent /// If positive, this skill functions as the parent of its `tree`, and unlocking it is required to pick up any skills in that tree.
	var/visible = TRUE /// If non-positive, this skill won't appear in chargen or the skill list unless you already own it.
	var/list/additional_ranks /// If applicable, string descriptions for additional ranks go here.
	var/list/freebies /// When a skill is unlocked, any other skills defined in this list will be unlocked as well.
