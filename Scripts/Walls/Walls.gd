extends StaticBody2D

export var movementPerTick = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	position += Vector2(-movementPerTick, 0)
