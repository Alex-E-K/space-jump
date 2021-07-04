extends KinematicBody2D


signal gameOver(score, mode)


export var up = Vector2(0, -1)
export var flap = 200
export var maxFallspeed = 200
export var gravity = 10
export var gapRange = 550

var score = 0
var screenTapped = false
var holdButton = false
var motion = Vector2()
var wall = preload("res://Scenes/WallNode.tscn")
var wallUD = preload("res://Scenes/WallNode_upDown.tscn")
var wallLR = preload("res://Scenes/WallNode_leftRight.tscn")
var playerIdle = load("res://Assets/Player/player1.png")
var playerFlap = load("res://Assets/Player/player1_fire.png")


func _ready():
	randomize()


func _physics_process(delta):
	motion.y += gravity
	if motion.y > maxFallspeed:
		motion.y = maxFallspeed
	
	if screenTapped == true:
		motion.y = -flap
		screenTapped == false
		_on_FlapBtn_button_down()
	
	motion = move_and_slide(motion, up)
	
	get_parent().get_parent().get_node("Score").text = str(score)


func _on_WallDestroyer_body_entered(body):
	if body.name == "Walls":
		body.queue_free()


func _on_WallSpawner_body_entered(body):
	if body.name == "Walls":
		var randomFloat = randf()
		var newWall
		
		if randomFloat < 0.82:
			newWall = wall.instance()
		else:
			randomFloat = randf()
			
			if randomFloat < 0.5:
				newWall = wallUD.instance()
			else:
				newWall = wallLR.instance()
		
		newWall.position = Vector2(position.x + 2500, rand_range(-gapRange, gapRange))
		get_parent().call_deferred("add_child", newWall)


func _on_Detect_area_exited(area):
	if area.name == "PointArea":
		score += 1
	elif area.name == "Top" or area.name == "Bottom":
		gameOver()


func _on_Detect_area_entered(area):
	if area.name == "ItemUpDownArea":
		get_parent().get_parent().get_parent().get_node("Camera2D").scale.y = -1 * get_parent().get_parent().get_parent().get_node("Camera2D").scale.y
		up.y = -1 * up.y
		flap = -1 * flap
		gravity = -1 * gravity
		motion.y = -1 * motion.y
	elif area.name == "ItemLeftRightArea":
		get_parent().get_parent().get_parent().get_node("Camera2D").scale.x = -1 * get_parent().get_parent().get_parent().get_node("Camera2D").scale.x


func _on_Detect_body_entered(body):
	if body.name == "Walls":
		gameOver()


func gameOver():
	if up.y > 0:
		up.y = -1 * up.y
		flap = -1 * flap
		gravity = -1 * gravity
		motion.y = -1 * motion.y
		get_parent().get_parent().get_parent().get_node("Camera2D").scale.y = -1 * get_parent().get_parent().get_parent().get_node("Camera2D").scale.y
	if get_parent().get_parent().get_parent().get_node("Camera2D").scale.x < 0:
		get_parent().get_parent().get_parent().get_node("Camera2D").scale.x = -1 * get_parent().get_parent().get_parent().get_node("Camera2D").scale.x
	emit_signal("gameOver", score, "crazy")


func _on_FlapBtn_button_down():
	if holdButton == false:
		#print("HOLD")
		holdButton = true
		screenTapped = true
		get_node("Sprite").texture = playerFlap
	else:
		#print("ELSE")
		holdButton = true
		screenTapped = false
		get_node("Sprite").texture = playerFlap
	


func _on_FlapBtn_button_up():
	#print("GONE")
	screenTapped = false
	holdButton = false
	get_node("Sprite").texture = playerIdle
