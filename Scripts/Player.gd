extends KinematicBody2D

export var id = 0
export var texutre: Texture
var tile_size = 32
var inputs
var last_input
var sounds = []
var files

onready var ray = $RayCast2D

signal player_moved(id, sound)

func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size/2

	
	inputs = {
		"up_%s" % id : Vector2.UP,
		"down_%s" % id : Vector2.DOWN,
		"left_%s" % id : Vector2.LEFT,
		"right_%s" % id : Vector2.RIGHT
	}
	$Sprite.texture = texutre
	
var inputting = []

func set_sounds(sounds):
	sounds = sounds

func add_sound(sound):
	sounds.append(sound)

func _unhandled_input(event):
	for dir in inputs:
		if event.is_action_pressed(dir):
			move(dir)

func move(dir):
	var next = inputs[dir] * tile_size
	ray.cast_to = next
	ray.force_raycast_update()

	if !ray.is_colliding():
		position += next
		emit_signal("player_moved",id,sounds[inputs.keys().find(dir)-1])
