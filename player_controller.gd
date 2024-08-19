extends RigidBody3D

@onready var mesh = $Mesh
@onready var cam = get_parent().get_node("Camera")
@export var flap_strength : float = 0.01
@export var max_flap_speed : float = 3
@onready var flapping : bool = false
@onready var cam_ray : RayCast3D = get_node("CamRay")
@onready var spawn_pad : AnimatableBody3D
@onready var fragments : int = 0
@export var frag_spawn_speed_offset : float = 1
@onready var frag_scene = load("res://fragment.tscn") as PackedScene
@onready var frag_counter = get_tree().get_nodes_in_group("frag_counter")[0]

func _ready():
	cam.target = get_node("Mesh")
	cam_ray.target = cam
	cam.cam_ray = cam_ray
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var turn : int = int(Input.is_action_pressed("turn_left")) - int(Input.is_action_pressed("turn_right"))
	mesh.rotation_degrees += Vector3(0,turn,0) * 100 * delta
	if Input.is_action_just_pressed("flap") && linear_velocity.y < max_flap_speed && !flapping:
		linear_velocity = mesh.global_transform.basis.z * -3 + Vector3(0,linear_velocity.y,0)
		flapping = true
	if flapping:
		linear_velocity = Vector3(linear_velocity.x,lerp(linear_velocity.y,max_flap_speed,flap_strength * delta * 1000),linear_velocity.z)
		if linear_velocity.y >= max_flap_speed - 0.1:
			flapping = false
	pass
	
func _on_touch_spike(obj):
	if obj.is_in_group("kill"):
		if fragments > 0:
			var frag_origin = global_transform.origin - linear_velocity * frag_spawn_speed_offset
			var frag = frag_scene.instantiate()
			var level = get_tree().get_nodes_in_group("Level")[0]
			level.add_child.call_deferred(frag)
			frag.global_transform.origin = frag_origin
			frag.quantity = fragments
			fragments = 0
			frag_counter.text = str(fragments)
		global_transform.origin = spawn_pad.global_transform.origin + Vector3(0,spawn_pad.spawn_height,0)
	if obj.is_in_group("pad"):
		spawn_pad._remove_checkpoint()
		spawn_pad = obj.get_parent()
		spawn_pad._set_checkpoint()
	if obj.is_in_group("fragment"):
		fragments = obj.quantity
		frag_counter.text = str(fragments)
		obj.queue_free()
