extends Area3D


signal body_part_hit()


func hit():
	emit_signal("body_part_hit")
