extends InteractibleObject
class_name Door

const DoorOpenSound = preload("res://Audio/DoorOpenSound.tscn")
const DoorCloseSound = preload("res://Audio/DoorCloseSound.tscn")
const LockedDoorSound = preload("res://Audio/LockedDoorSound.tscn")

enum DoorState {
	LOCKED,
	UNLOCKED,
	OPEN
}

export(DoorState) var STARTING_STATE = DoorState.LOCKED
export(String) var LOCKED_MESSAGE = "The door is locked"
export(bool) var UNLOCK_WITH_KEY = true

var state = DoorState.LOCKED setget set_state


func _ready():
	self.state = STARTING_STATE


func is_locked():
	return self.state == DoorState.LOCKED


func unlock():
	self.state = DoorState.UNLOCKED


func enable_collide():
	# Do it this way instead of disabling the collision
	# shape so that interaction still works. For a door,
	# that means we can open and close it.
	set_collision_layer_bit(0, true)  # World layer
	set_collision_layer_bit(9, true)  # WorldObjects layer


func disable_collide():
	set_collision_layer_bit(0, false)  # World layer
	set_collision_layer_bit(9, false)  # WorldObjects layer


func set_state(value):
	state = value
	
	match state:
		DoorState.LOCKED:
			enable_collide()
			occluder.light_mask = 1
			sprite.frame = 0
		DoorState.UNLOCKED:
			enable_collide()
			occluder.light_mask = 1
			sprite.frame = 1
		DoorState.OPEN:
			disable_collide()
			occluder.light_mask = 0
			sprite.frame = 2


func interact():
	.interact()
	
	match self.state:
		DoorState.LOCKED:
			Utils.instance_scene_on_main(LockedDoorSound, global_position)
			Utils.say_dialog(LOCKED_MESSAGE)
		DoorState.UNLOCKED:
			Utils.instance_scene_on_main(DoorOpenSound, global_position)
			self.state = DoorState.OPEN
		DoorState.OPEN:
			Utils.instance_scene_on_main(DoorCloseSound, global_position)
			self.state = DoorState.UNLOCKED


func save_data():
	return {
		pos = {
			x = global_position.x,
			y = global_position.y
		},
		state = self.state
	}


func load_data(data):
	if self.state == DoorState.LOCKED and data.state != DoorState.LOCKED:
		unlock()
