extends Camera2D

signal goto_result

func _ready():
	set_physics_process(false)

func result():
	set_physics_process(true)

func _physics_process(delta):
	if offset.y >= 0:
		set_physics_process(false)
		yield(get_tree().create_timer(2), "timeout")
		emit_signal("goto_result")

	offset.y += 400 * delta