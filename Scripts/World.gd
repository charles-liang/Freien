extends Node2D


#func _process(delta):
#	$Player3/Sprite.modulate = Color(0, 0, 0, 0)
	
#	var distance2Hero = $Player.global_position.distance_to($Player2.global_position)
#	print($Player3.position)
#	if distance2Hero == 0 :
#		$Player3/Sprite.modulate = Color(0, 0, 0, 1)
#		$Player3.position = $Player.position
#		$Player/Sprite.modulate = Color(0, 0, 0, 0)
#		$Player2/Sprite.modulate = Color(0, 0, 0, 0)
#	else:
#		$Player3/Sprite.modulate = Color(0, 0, 0, 0)
#		$Player/Sprite.modulate = Color(255, 255, 255, 1)
#		$Player2/Sprite.modulate = Color(255, 255, 255, 1)

signal level_change(level)



var border = Rect2()



onready var init_x = 38
onready var init_y = 22
onready var exit = $ExitDoor
onready var tileMap = $TileMap
onready var player1 = $Player1
onready var player2 = $Player2
onready var player3 = $Player3
func _ready():
	randomize()
	init_level()
	generate_level()
	
	
			
func init_level():
	tileMap.clear()
	
	border = Rect2(1,1, init_x * Global.level, init_y * Global.level)
	
	for x in range(0,border.size.x + 2):
		for y in range(0,border.size.y + 2):
			tileMap.set_cell(x,y, 0)

func generate_level():
	var walker = Walker.new(Vector2( border.size.x /2,  border.size.y/2), border)
	var map = walker.walk( border.size.x * border.size.y / 2) 
	 
	 
	player1.position = walker.get_random_position() * 32 
	player2.position = walker.get_random_position() * 32
	

	exit.position = walker.get_end_room().position * 32
	exit.connect("leaving_level",self,"next_level")

	walker.queue_free()
	for location in border.position:
		tileMap.set_cellv(location, 1)
	for location in map:
		tileMap.set_cellv(location, -1)
	tileMap.update_bitmask_region(border.position, border.end)
	
	var sounds =  ["C3","D3","E3","G3","A3","B3","C4"]
	sounds.shuffle()
	for i in range(1, sounds.size()):
		if i % 2:
			player2.add_sound(sounds[i])
		else:
			player1.add_sound(sounds[i])
			
	
func next_level():
	up_level()
	reload_level()
	
func reload_level():
	get_tree().reload_current_scene()	

func _input(event):
	if event.is_action_pressed("ui_accept"):
		reload_level()

func up_level():
	Global.level += 1
	emit_signal("level_change", Global.level)
	
var hidded = false
func _process(delta):
	if player1.position.distance_to(player2.position) < 64 and !hidded:
		player1.visible = false
		player2.visible = false
		hidded = true

		player3.visible = true
	elif player1.position.distance_to(player2.position) >= 64 and hidded :
		player1.visible = true
		player2.visible = true
		hidded = false
		player3.visible = false
		
	player3.position = (player1.position + player2.position) / 2
		
