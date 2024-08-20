extends Node

var paused : bool = false
@onready var pause_menu : Control = get_parent().get_node("PauseMenu")
@onready var main_menu = load("res://addons/EasyMenus/Scenes/main_menu.tscn") as PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pause_menu.close_pause_menu()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		if !paused:
			pause_menu.open_pause_menu()
			paused = true
		else:
			pause_menu.close_pause_menu()
			paused = false
	pass

func _load_main_menu():
	var new_scene = main_menu.instantiate()
	get_tree().root.add_child(new_scene)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = new_scene
