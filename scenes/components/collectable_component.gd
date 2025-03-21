class_name CollectableComponent
extends Area2D

#use for collecteable items
@export var collectable_name: String
var added:bool = false

func _on_body_entered(body: Node2D) -> void:
	if body is Player and not added:
		#call inventory manager
		InventoryManager.add_collectable(collectable_name)
		added = true
		print("Collected: ", collectable_name)
		get_parent().queue_free()
