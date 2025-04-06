extends CanvasLayer

#func _ready() -> void:
	#get_viewport().size = DisplayServer.screen_get_size()
	

@onready var creditUI = preload("res://scenes/ui/credit.tscn") 



func _on_pressed() -> void:
	var instance = creditUI.instantiate()
	add_child(instance)



func _on_start_game_button_pressed() -> void:
	GameManager.start_game()
	queue_free()


func _on_exit_game_button_pressed() -> void:
	GameManager.exit_game()
