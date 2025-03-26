extends StaticBody2D

var inside:bool = false
@onready var hint:Label = $Label
@export var riceMultiplier:float = 23
@onready var animation:AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	if inside and Input.is_action_just_pressed("interact"):
		#para di mag multiply kapag walang wheat which would reset money to zero
		if InventoryManager.inventory["wheat"] != 0:
			InventoryManager.money = InventoryManager.money + (InventoryManager.inventory["wheat"] * riceMultiplier)
			InventoryManager.inventory["wheat"] = 0
			InventoryManager.inventory_changed.emit()
			print("Money is: ")
			print(InventoryManager.money)


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		inside = true
		if inside:
			hint.show()
			animation.play("chest_open")
	pass # Replace with function body.

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		inside = false
		if not inside:
			hint.hide()
			animation.play("chest_close")
