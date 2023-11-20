extends Node3D

var enemy = load("res://enemies/enemy.tscn")
@onready var spawns = $spawns
@onready var nav = $NavigationRegion3D
var instance

signal GPToggle(paused : bool)

var gamePaused : bool = false:
	get:
		return gamePaused
	set(value):
		get_tree().paused = !gamePaused
		gamePaused = value
		emit_signal("GPToggle", gamePaused)


func _ready():
	randomize()



func _get_random_child(parent_node):
	var random_id = randi() % parent_node.get_child_count()
	return parent_node.get_child(random_id)


func _on_timer_timeout():
	var spawn_point = _get_random_child(spawns).global_position
	instance = enemy.instantiate()
	instance.position = spawn_point
	nav.add_child(instance)
	
func _input(event : InputEvent):
	if (event.is_action_pressed("escape")):
		gamePaused = !gamePaused
		if gamePaused == true:
			Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
		elif gamePaused == false:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
