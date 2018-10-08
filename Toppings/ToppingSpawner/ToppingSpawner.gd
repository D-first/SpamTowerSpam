extends Position2D

const topping = preload("res://Toppings/Topping.tscn")

signal topping_spawned(topping, pos)

export(int) var spam_ratio = 0
var speed_boost = 0

var types = [
	"spam",
	"beef",
	"bekon",
	"chees",
	"medama",
	"onion",
	"pikuru",
	"retasu",
	"tomato"
]

var sprites = {
	"spam" : preload("res://Toppings/textures/256_64_spam.png"),
	"beef" : preload("res://Toppings/textures/256_64_beef.png"),
	"bekon" : preload("res://Toppings/textures/256_64_bekon.png"),
	"chees" : preload("res://Toppings/textures/256_64_chees.png"),
	"medama" : preload("res://Toppings/textures/256_64_medama.png"),
	"onion" : preload("res://Toppings/textures/256_64_onion.png"),
	"pikuru" : preload("res://Toppings/textures/256_64_pikurusu.png"),
	"retasu" : preload("res://Toppings/textures/256_64_retasu.png"),
	"tomato" : preload("res://Toppings/textures/256_64_tomato.png"),
}

var sounds = {
	"spam" : preload("res://Toppings/sounds/spam.ogg"),
	"beef" : preload("res://Toppings/sounds/beafpate.ogg"),
	"bekon" : preload("res://Toppings/sounds/becon.ogg"),
	"chees" : preload("res://Toppings/sounds/cheez.ogg"),
	"medama" : preload("res://Toppings/sounds/egg.ogg"),
	"onion" : preload("res://Toppings/sounds/onion.ogg"),
	"pikuru" : preload("res://Toppings/sounds/voice_pickles.ogg"),
	"retasu" : preload("res://Toppings/sounds/lettuce.ogg"),
	"tomato" : preload("res://Toppings/sounds/voice_tomato.ogg")
}

func _ready():
	randomize()

func spawn():
	position.x = rand_range(10, 700)
	var candidate_types = types.duplicate()
	for x in range(spam_ratio):
		candidate_types.append("spam")
	
	var ins = topping.instance()
	var type = candidate_types[randi() % candidate_types.size()]
	var sound = sounds[type]
	var fall_speed = rand_range(400, 1200)
	
	ins.init(type, sprites[type], sound, fall_speed + speed_boost)
	ins.position = global_position
	
	emit_signal("topping_spawned",ins,global_position)

func _on_Timer_timeout():
	spawn()
