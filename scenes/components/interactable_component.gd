class_name InteractableComponent
extends Area2D

#code to enter the door
signal interactable_activated
signal interactable_deactivated

func _on_body_entered(body: Node2D) -> void:
	interactable_activated.emit()
func _on_body_exited(body: Node2D) -> void:
	interactable_deactivated.emit()
	
#end of enter the door
