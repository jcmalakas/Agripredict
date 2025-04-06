extends CanvasLayer
@onready var menu:PackedScene = preload("res://scenes/ui/menu.tscn")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("game_menu"):
		var instance = menu.instantiate()
		add_child(instance)
		get_tree().paused = true
