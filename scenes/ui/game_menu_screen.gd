extends CanvasLayer

#func _ready() -> void:
	#get_viewport().size = DisplayServer.screen_get_size()
	
func _on_start_game_button_pressed() -> void:
	GameManager.start_game()
	queue_free()


func _on_exit_game_button_pressed() -> void:
	GameManager.exit_game()
