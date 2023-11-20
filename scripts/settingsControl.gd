extends Node2D


@onready var fovSlider = $fov
@onready var fovLabel = $fovLabel

func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/start.tscn")



func _on_fov_drag_ended(value_changed):
	gv.fov = fovSlider.value
	fovLabel.text = "FOV:" + str(fovSlider.value)
