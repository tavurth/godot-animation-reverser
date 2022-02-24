extends Reference

static func default_name(old_name: String):
	return "{anim_name}-reversed".format({ "anim_name": old_name })


static func build_new_name(anim_player: AnimationPlayer, old_name: String):
	var to_return = old_name

	if "backwards" in old_name:
		to_return = old_name.replace("backwards", "forwards")

	elif "forwards" in old_name:
		to_return = old_name.replace("forwards", "backwards")

	else:
		to_return = old_name

	# That animation already exists
	# We will just return the `-reversed` name
	if anim_player.has_animation(to_return):
		return default_name(old_name)

	return to_return


static func reverse(animation_player: AnimationPlayer, anim_name: String, new_name: String = ""):
	var anim = animation_player.get_animation(anim_name)
	if not anim:
		push_error("Animation %s could not be read" % anim_name)
		return

	var new_anim = anim.duplicate(true)

	# Extend the track to the right
	new_anim.set_length(new_anim.length * 2)

	for track_idx in new_anim.get_track_count():
		var key_items = []

		for key_idx in range(anim.track_get_key_count(track_idx) - 1, -1, -1):
			key_items.append([
				anim.track_get_key_time(track_idx, key_idx),
				anim.track_get_key_value(track_idx, key_idx),
				anim.track_get_key_transition(track_idx, key_idx),
			])

			# Now we'll move the tracks over to the right
			# This is to prevent them from overriding each others time
			new_anim.track_set_key_time(
				track_idx,
				key_idx,
				anim.track_get_key_time(track_idx, key_idx) + anim.get_length()
			)

		assert(anim.track_get_key_count(track_idx) == len(key_items), "Not all tracks were saved!")

		# Now we'll start to setup the tracks on the new animation
		for key_idx in range(len(key_items)):
			var key_item = key_items[key_idx]
			new_anim.track_set_key_time(track_idx, key_idx, key_item[0])
			new_anim.track_set_key_value(track_idx, key_idx, key_item[1])
			new_anim.track_set_key_transition(track_idx, key_idx, key_item[2])

	# Now set the track back to the original length
	new_anim.set_length(anim.length)

	if not len(new_name):
		new_name = build_new_name(animation_player, anim_name)

	animation_player.add_animation(new_name, new_anim)
	animation_player.set_current_animation(new_name)

	return new_anim


static func reverse_current(animation_player: AnimationPlayer, new_name: String = ""):
	if not animation_player:
		push_error("No AnimationPlayer passed!")
		return

	var anim_name = animation_player.get_current_animation()
	if not len(anim_name):
		push_error('No "Current animation" selected for animation player!')
		return

	return reverse(animation_player, anim_name, new_name)
