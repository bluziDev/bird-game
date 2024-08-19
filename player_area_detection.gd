extends Area3D

@onready var bird : RigidBody3D = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("area_entered",bird._on_touch_spike)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
