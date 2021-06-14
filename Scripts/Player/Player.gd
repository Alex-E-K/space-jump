extends KinematicBody2D


signal gameOver(score)


export var up = Vector2(0, -1)
export var flap = 200
export var maxFallspeed = 200
export var gravity = 10

var score = 0
var motion = Vector2()
var wall = preload("res://Scenes/WallNode.tscn")
var playerIdle = load("res://Assets/Player/player1.png")
var playerFlap = load("res://Assets/Player/player1_fire.png")


func _physics_process(delta):
	motion.y += gravity
	if motion.y > maxFallspeed:
		motion.y = maxFallspeed
	
	if Input.is_action_just_pressed("flap"):
		motion.y = -flap
		get_node("Sprite").texture = playerFlap
	elif Input.is_action_just_released("flap"):
		get_node("Sprite").texture = playerIdle
	
	motion = move_and_slide(motion, up)
	
	get_parent().get_parent().get_node("Score").text = str(score)


func _on_WallDestroyer_body_entered(body):
	if body.name == "Walls":
		body.queue_free()


func _on_WallSpawner_body_entered(body):
	if body.name == "Walls":
		var newWall = wall.instance()
		newWall.position = Vector2(position.x + 2500, rand_range(-600, 600))
		get_parent().call_deferred("add_child", newWall)


func _on_Detect_area_exited(area):
	if area.name == "PointArea":
		score += 1
	elif area.name == "Top" or area.name == "Bottom":
		gameOver()


func _on_Detect_body_entered(body):
	if body.name == "Walls":
		gameOver()


func gameOver():
	emit_signal("gameOver", score)
