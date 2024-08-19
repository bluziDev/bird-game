extends AnimatableBody3D

@export var spawns_fragment : bool = false
@export var spawns_player : bool = false
var bird_scene = load("res://bird.tscn") as PackedScene
var fragment_scene = load("res://fragment.tscn") as PackedScene
@export var spawn_height : float = 0.5
var transparent_bird_mesh = load("res://bird_mesh_transparent.tscn") as PackedScene
var transparent_bird
var camera = load("res://camera.tscn") as PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	if spawns_player:
		var player_instance = bird_scene.instantiate()
		var camera_instance = camera.instantiate()
		var level = get_tree().get_nodes_in_group("Level")[0]
		level.add_child.call_deferred(camera_instance)
		camera_instance.name = "Camera"
		level.add_child.call_deferred(player_instance)
		player_instance.global_transform.origin = global_transform.origin + Vector3(0,spawn_height,0)
		player_instance.spawn_pad = self
	if spawns_fragment:
		var fragment_instance = fragment_scene.instantiate()
		var level = get_tree().get_nodes_in_group("Level")[0]
		level.add_child.call_deferred(fragment_instance)
		fragment_instance.global_transform.origin = global_transform.origin + Vector3(0,spawn_height,0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _set_checkpoint():
	transparent_bird = transparent_bird_mesh.instantiate()
	add_child(transparent_bird)
	transparent_bird.global_transform.origin = global_transform.origin + Vector3(0,spawn_height,0)
	
func _remove_checkpoint():
	if transparent_bird:
		transparent_bird.queue_free()
