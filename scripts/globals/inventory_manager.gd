extends Node

#use for counting how many item you collect
var inventory: Dictionary = {"wheat" : 0}
var money:int = 0

signal inventory_changed

var riceCount:int = 10

func _process(delta: float) -> void:
	if money >= 99999:
		money = 99999

func add_collectable(collectable_name: String) -> void:
	inventory.get_or_add(collectable_name)


	if inventory[collectable_name] == null:
		inventory[collectable_name] = 1
	else:
		inventory[collectable_name] += 1
		
	inventory_changed.emit()
