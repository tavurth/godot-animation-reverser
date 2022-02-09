tool
extends EditorPlugin

var enabled = false
var edited_animation_player: AnimationPlayer

func handles(object: Object) -> bool:
	var does_handle = object is AnimationPlayer

	if does_handle:
		if not enabled:
			enabled = true
			add_tool_menu_item("Reverse animation", self, "activate")
	elif enabled:
		enabled = false
		remove_tool_menu_item("Reverse animation")

	return does_handle

func edit(object: Object) -> void:
	edited_animation_player = object

func activate(ud = null):
	if not edited_animation_player:
		return

	var anim_name = edited_animation_player.get_current_animation()
	if not len(anim_name):
		return

	var anim = edited_animation_player.get_animation(anim_name)
	if not anim:
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

	var new_name = "{anim_name}-reversed".format({ "anim_name": anim_name })
	edited_animation_player.add_animation(new_name, new_anim)
	edited_animation_player.set_current_animation(new_name)

func _exit_tree():
	remove_tool_menu_item("Reverse animation")
