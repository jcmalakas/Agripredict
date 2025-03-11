extends PanelContainer

@onready var log_label: Label = $MarginContainer/VBoxContainer/Wheat/WheatLabel

func _ready() -> void:
	InventoryManager.inventory_changed.connect(on_inventory_change)
	
func on_inventory_change() -> void:
	var inventory: Dictionary = InventoryManager.inventory
	
	#use to count the specific var
	if inventory.has("wheat"):
		log_label.text = str(inventory["wheat"])
