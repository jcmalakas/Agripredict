extends Label
func _process(delta: float) -> void:
	self.text = "Money: " + str(InventoryManager.money)
