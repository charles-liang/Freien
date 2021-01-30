extends Node

onready var viewport1 = $HBoxContainer/ViewportContainer1/Viewport
onready var viewport2 = $HBoxContainer/ViewportContainer2/Viewport
onready var camera1 = $HBoxContainer/ViewportContainer1/Viewport/Camera2D
onready var camera2 = $HBoxContainer/ViewportContainer2/Viewport/Camera2D
onready var world = $HBoxContainer/ViewportContainer2/Viewport/World
onready var tilemap = $HBoxContainer/ViewportContainer2/Viewport/World/TileMap

onready var sound_player1 = $HBoxContainer/ViewportContainer1/Viewport/Camera2D/sound_player1
onready var sound_player2 = $HBoxContainer/ViewportContainer2/Viewport/Camera2D/sound_player2

onready var player1 = world.get_node("Player1")
onready var player2 = world.get_node("Player2")
func _ready():
	viewport1.world_2d = viewport2.world_2d
	camera1.target = player1
	camera2.target = player2
	set_camera_limits()
	
	player1.connect("player_moved", sound_player1, "play_signal")
	player2.connect("player_moved", sound_player2, "play_signal")
	
	
	$LevelLabel.text = "Level: %d " % Global.level
	

func set_camera_limits():
	var map_limits = tilemap.get_used_rect()
	var map_cellsize = tilemap.cell_size
	for cam in [camera1, camera2]:
		cam.limit_left = map_limits.position.x * map_cellsize.x
		cam.limit_right = map_limits.end.x * map_cellsize.x
		cam.limit_top = map_limits.position.y * map_cellsize.y
		cam.limit_bottom = map_limits.end.y * map_cellsize.y
