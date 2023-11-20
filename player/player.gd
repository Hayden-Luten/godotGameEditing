extends CharacterBody3D


const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.001
@onready var head = $head
@onready var camera = $head/camera
@onready var gun_anim = $head/camera/gun/shoot
@onready var gun_barrel = $head/camera/gun/RayCast3D
@onready var gun = $head/camera/gun
@onready var knife = $head/camera/knife
@onready var knife_anim = $head/camera/knife/Swing
@onready var pauseMenu = $CanvasLayer/pause
var interval = false


var bullets = load("res://gun/bullet.tscn")
var instance

# Get the gravity from the project settings to be synced with RigidBody nodes
var gravity = 9.8

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera.fov = float(gv.fov)
	pauseMenu.hide()

	

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		self.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * gv.speed
		velocity.z = direction.z * gv.speed
	else:
		velocity.x = 0
		velocity.z = 0

	move_and_slide()
	
	if gun.visible == true:
		if Input.is_action_pressed("click"):
			if !gun_anim.is_playing():
				gun_anim.play("shoot")
				instance = bullets.instantiate()
				instance.position = gun_barrel.global_position
				instance.transform.basis = gun_barrel.global_transform.basis
				get_parent().add_child(instance) 
	
	if knife.visible == true:
		if Input.is_action_pressed("click"):
			if !knife_anim.is_playing(): 
				knife_anim.play("cleaverSwing")
	
	if Input.is_action_just_pressed("melee") or Input.is_action_just_pressed("MWdown"):
		gun.visible = false
		knife.visible = true
		gv.speed = 8
		gv.equipped = "melee"
	if Input.is_action_just_pressed("primary") or Input.is_action_just_pressed("MWup"):
		knife.visible = false
		gun.visible = true
		gv.speed = 5
		gv.equipped = "primary"


func _on_main_gp_toggle(paused):
	camera.fov = float(gv.fov)
	if paused == true:
		pauseMenu.show()
	if paused == false:
		pauseMenu.hide()


func _on_menu_button_pressed():
	gv.health = 0

func _on_btg_button_pressed():
	Input.action_press("escape")
