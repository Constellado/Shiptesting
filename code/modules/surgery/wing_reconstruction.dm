/datum/surgery/wing_reconstruction
	name = "Wing Reconstruction"
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/wing_reconstruction,
		/datum/surgery_step/close)
	possible_locs = list(BODY_ZONE_CHEST)

/datum/surgery/wing_reconstruction/can_start(mob/user, mob/living/carbon/target)
	/*
	Condition - Target has moth_wings loaded to dna.species.mutant_bodyparts
		Note: Whatever wing variation the target had prior to the burning was overwrote by "Burnt Off" (Which is a variation of wings it seems)
	*/
	if("moth_wings" in target.dna.species.mutant_bodyparts)
		return TRUE //Yes surgery
	return FALSE //No surgery

/datum/surgery_step/wing_reconstruction
	name = "start wing reconstruction (hemostat)"
	//success chance per tool
	implements = list(
		TOOL_HEMOSTAT = 85,
		TOOL_SCREWDRIVER = 35,
		/obj/item/pen = 15)
	time = 20 SECONDS
	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/scalpel2.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'
	experience_given = MEDICAL_SKILL_ORGAN_FIX

/datum/surgery_step/wing_reconstruction/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		"<span class='notice'>You begin to fix [target]'s charred wing membranes...</span>",
		"<span class='notice'>[user] begins to fix [target]'s charred wing membranes.</span>",
		"<span class='notice'>[user] begins to perform surgery on [target]'s charred wing membranes.</span>")

/datum/surgery_step/wing_reconstruction/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(ishuman(target))
		display_results(
			user,
			target,
			span_notice("You succeed in reconstructing [target]'s wings."),
			span_notice("[user] successfully reconstructs [target]'s wings!"),
			span_notice("[user] completes the surgery on [target]'s wings."),
		)
		/*
		Condition 1 - List of wing types for new wings
		Condition 2 - Sets moth_wings to wing_type. This overrides previous wing variation - Including "Burnt Off"
		Condition 3 - Update target body
		*/
		var/wing_type = input( "Choose a new wing look:", "Wing Reconstruction") as anything in GLOB.moth_wings_list
		//if(wing_type == 22)
		//	target.dna.features["moth_wings"] = "Plain"
		//	target.update_body()
		//	return ..()
		target.dna.features["moth_wings"] = wing_type
		target.update_body()
	return ..()
