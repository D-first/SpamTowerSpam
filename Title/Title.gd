extends Control

func _ready():
	pass

func _on_PlayButton_pressed():
	get_tree().change_scene("res://Bar/Bar.tscn")


func _on_HowToPlay_pressed():
	$HowToPlay.visible = false


func _on_HowToPlayButton_pressed():
	$HowToPlay.visible = true
