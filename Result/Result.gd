extends Control

func _ready():
	$Score.text = str(game.total)


func _on_Retry_pressed():
	get_tree().change_scene("res://Bar/Bar.tscn")
