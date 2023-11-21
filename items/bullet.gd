extends Node3D

const speed = 100

@onready var mesh = $MeshInstance3D
@onready var raycast = $bulletCast
@onready var particles = $GPUParticles3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.basis * Vector3(0, 0, -speed) * delta
	if raycast.is_colliding():
		mesh.visible = false
		particles.emitting = true
		if raycast.get_collider().is_in_group("enemy"):
			raycast.get_collider().hit()
		queue_free()

func _on_timer_timeout():
	queue_free()
