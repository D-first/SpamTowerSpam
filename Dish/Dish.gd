extends Area2D

export(int) var speed = 1000

func _ready():
	pass

func _physics_process(delta):
	if position.x < 0:
		position.x = 0
	
	if position.x > 720:
		position.x = 720
	if Input.is_action_pressed("ui_left"):
		position.x = position.x - speed * delta

	if Input.is_action_pressed("ui_right"):
		position.x = position.x + speed * delta
		