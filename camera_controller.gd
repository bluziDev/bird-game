extends Node3D
@export var target : MeshInstance3D
@export var follow_distance : float = 2
@export var rotation_speed : float = 2.0  # Speed of rotation interpolation
@export var follow_speed_h : float = 2.0  # Speed of rotation interpolation
@export var follow_speed_v : float = 2.0  # Speed of rotation interpolation
@export var min_distance : float = 0.5
@export var cam_ray : RayCast3D
@onready var camera : Camera3D = get_node("Camera")
@export var collision_lerp : float = 0.25

func _onready():
	pass

func _process(delta):
	if target:
		#slerp position
		var offset_direction = target.global_transform.basis.z.normalized()
		var target_origin = target.global_transform.origin + offset_direction * follow_distance
		var target_h = target_origin
		target_h.y = global_transform.origin.y
		global_transform.origin = global_transform.origin.slerp(target_h,follow_speed_h * delta)
		var target_v = global_transform.origin
		target_v.y = target_origin.y
		global_transform.origin = global_transform.origin.slerp(target_v,follow_speed_v * delta)
		# Calculate the direction to the target
		var direction = (target.global_transform.origin - global_transform.origin).normalized()
		
		# Calculate the target rotation
		var target_basis = Basis().looking_at(direction, Vector3.UP)
		
		# Interpolate the rotation
		var current_basis = global_transform.basis
		#var new_basis = current_basis.slerp(target_basis, rotation_speed * delta)
		var new_basis = target_basis
		global_transform.basis = new_basis
		if cam_ray.is_colliding():
			var cam_origin = camera.global_transform.origin
			camera.global_transform.origin = lerp(cam_origin,cam_ray.get_collision_point(),collision_lerp)
