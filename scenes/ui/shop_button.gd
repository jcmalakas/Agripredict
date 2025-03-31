extends Button

var shopUI:PackedScene = preload("res://scenes/ui/shopUIComponent.tscn")

func _on_pressed() -> void:
	var shopInstance = shopUI.instantiate()
	get_parent().get_parent().add_child(shopInstance)
	pass # Replace with function body.
