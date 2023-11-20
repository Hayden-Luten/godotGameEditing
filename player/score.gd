extends Control

@onready var scoreLabel = $score
@onready var primary = $primaryOutline
@onready var melee = $meleeOutline
@onready var health = $health

func _process(_delta):
	scoreLabel.text = str(gv.score)
	if gv.equipped == "primary":
		primary.visible = true
		melee.visible = false
	elif gv.equipped == "melee":
		primary.visible = false
		melee.visible = true
	health.text = str(gv.health)
	
func on_hit():
	if gv.health < 1:
		get_tree().change_scene_to_file("res://scenes/start.tscn")
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
		gv.health = 3
