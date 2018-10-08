extends Area2D

signal on_dish

var on_dish

var type
var speed = 300

func _ready():
	pass

func init(type, tex, sound, speed):
	self.type = type
	self.speed = speed
	$Sprite.texture = tex
	$Se.stream = sound

func _physics_process(delta):
	position.y = position.y + speed * delta

	var areas = get_overlapping_areas()
	
	if areas and areas[0].name == "Dish" or (areas and areas[0].is_in_group("toppings") and areas[0].on_dish):
		on_dish = true
		$Se.play()
		emit_signal("on_dish", self)
		set_physics_process(false)