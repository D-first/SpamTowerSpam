extends Node

signal spam_text_pop(spam_text)

const CAMERA_OFFSET = -15
const SPAM_TEXT = preload("res://Bar/textures/384＊256_SPAMSPAM.png")

var total_count = 0
var spam_count = 0
var spam_meter = 0 setget set_spam_meter

var meter_down_speed = 7
var meter_down_time_speed = 1
var meter_up_speed = 3

var is_viking_left = false
var is_viking_right = false
var is_viking_song = false

func _ready():
	self.connect("spam_text_pop", self, "_on_spam_text_pop")
	$Gui/debug_spam_ratio_value.value = $ToppingSpawner.spam_ratio
	$Gui/debug_dish_value.value = $Dish.speed
	$Gui/debug_meter_down_value.value = meter_down_speed
	$Gui/debug_meter_up_value.value = meter_up_speed
	
func _physics_process(delta):
	self.spam_meter -= 1 * meter_down_time_speed * delta
	if spam_meter < -100: spam_meter = -100
	$Gui/SpamMeter/Niddle.rotation_degrees = spam_meter
	
	$Gui/Bba.frame = 1 if spam_meter <= -50 else 0
	$Gui/Kokku.frame = 1 if spam_meter >= 50 else 0
	$Gui/debug_camera_offset_value.text = str($Camera2D.offset.y)
	$Gui/debug_meter.text = str(spam_meter)
	
	if spam_meter == -100:
		$Vikings/LeftViking/voice.stop()
		$Vikings/LeftViking/song.stop()
		$Vikings/RightViking/voice.stop()
		$Vikings/RightViking/song.stop()
		get_tree().paused = true
		$Shalap.play()
		$Dish.position.x = 370
		yield(get_tree().create_timer(1), "timeout")
		$Camera2D.result()
		
	
	


func _on_ToppingSpawner_topping_spawned(topping, pos):
	topping.connect("on_dish", self, "_on_dish_topping", [], CONNECT_ONESHOT)
	add_child(topping)

func _on_dish_topping(topping):
	total_count += 1
	$Gui/debug_total_count.text = str(total_count)
	if topping.type == "spam":
		spam_count += 1
		$ToppingSpawner.speed_boost = spam_count * 4
		self.spam_meter += 1 * meter_up_speed
		if spam_meter > 100: spam_meter = 100
		var spam_text = Sprite.new()
		spam_text.texture = SPAM_TEXT
		spam_text.position = topping.position
		spam_text.scale = Vector2(0.5, 0.5)
		add_child(spam_text)
		emit_signal("spam_text_pop", spam_text)
		$Gui/SpamMeter/Niddle.rotation_degrees = spam_meter
		$Gui/debug_spam_count.text = str(spam_count)
	else:
		self.spam_meter -= 1 * meter_down_speed
		if spam_meter < -100: spam_meter = -100

	
	remove_child(topping)
	topping.position = Vector2(0, -16*total_count)
	$Dish/Toppings.add_child(topping)
	
	$Camera2D.offset.y += CAMERA_OFFSET
	$ToppingSpawner.position.y += CAMERA_OFFSET
	$Remover.position.y += CAMERA_OFFSET
	$Vikings.position.y += CAMERA_OFFSET

func _on_Remover_area_entered(area):
	if area.is_in_group("toppings") and !area.on_dish:
		area.queue_free()

func _on_Button_pressed():
	get_tree().change_scene("res://Bar/Bar.tscn")


func _on_debug_dish_value_value_changed(value):
	$Dish.speed = value


func _on_debug_dish_value2_value_changed(value):
	meter_down_time_speed = value


func _on_debug_meter_up_value_value_changed(value):
	meter_up_speed = value


func _on_debug_meter_down_value_value_changed(value):
	meter_down_speed = value


func _on_debug_spam_ratio_value_value_changed(value):
	$ToppingSpawner.spam_ratio = value


func set_spam_meter(new_value):
	spam_meter = new_value
	
	if new_value <= -60 and !is_viking_left:
		$Vikings/LeftViking/AnimationPlayer.play("40")
		$Vikings/LeftViking/voice.play()
		is_viking_left = true
	elif new_value > -60 and is_viking_left:
		$Vikings/LeftViking/AnimationPlayer.play_backwards("40")
		is_viking_left = false
	
	if new_value <= -70 and !is_viking_right:
		$Vikings/RightViking/AnimationPlayer.play("35")
		$Vikings/RightViking/voice.play()
		is_viking_right = true
	elif new_value > -70 and is_viking_right:
		$Vikings/RightViking/AnimationPlayer.play_backwards("35")
		is_viking_right = false
	
	if new_value < -75 and !is_viking_song:
		$Vikings/LeftViking/AnimationPlayer.play("30")
		$Vikings/RightViking/AnimationPlayer.play("30")
		$Vikings/LeftViking/song.play()
		$Vikings/RightViking/song.play()
		is_viking_song = true
	elif new_value >= -75 and is_viking_song:
		$Vikings/LeftViking/AnimationPlayer.play_backwards("30")
		$Vikings/RightViking/AnimationPlayer.play_backwards("30")
		$Vikings/LeftViking/song.stop()
		$Vikings/RightViking/song.stop()
		is_viking_song = false
			

func _on_Camera2D_goto_result():
	game.total = total_count
	get_tree().change_scene("res://Result/Result.tscn")
	get_tree().paused = false

func _on_spam_text_pop(spam_text):
	yield(get_tree().create_timer(0.5), "timeout")
	spam_text.queue_free()