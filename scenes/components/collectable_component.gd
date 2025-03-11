class_name CollectableComponent
extends Area2D

#use for collecteable items
@export var collectable_name: String

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		#call inventory manager
		InventoryManager.add_collectable(collectable_name)
		print("Collected: ", collectable_name)
		get_parent().queue_free()
