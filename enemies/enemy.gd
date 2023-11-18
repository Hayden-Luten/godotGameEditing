extends CharacterBody3D

var player = null

@onready var gravity = 9.8
@export var player_path := "/root/main/NavigationRegion3D/character"
var speed = 8
var hitRange = 1
@onready var nav_agent = $NavigationAgent3D
var interval = true
var double = 0


func _ready():
	player = get_node(player_path)
	
func _physics_process(delta):
	
	
	if not is_on_floor():
		velocity.y -= gravity * delta

	move_and_slide()


func _on_area_3d_body_part_hit():
	gv.score += 1
	queue_free()

func _process(delta):
	velocity = Vector3.ZERO
	nav_agent.set_target_position(player.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * speed
	move_and_slide()
	if global_position.distance_to(player.global_position) < hitRange == true and interval == true:
		gv.health -= 1
		player.get_child("CanvasLayer").get_child("ui").on_hit()
		interval = false
	elif global_position.distance_to(player.global_position) < hitRange == true and interval == false and double == 0:
		double = 1
		await get_tree().create_timer(2.0).timeout
		interval = true
		double = 0
