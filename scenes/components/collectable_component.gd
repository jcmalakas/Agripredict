class_name CollectableComponent
extends Area2D

@onready var audio_stream_player: AudioStreamPlayer = $"../AudioStreamPlayer"

#use for collecteable items
@export var collectable_name: String
var added:bool = false

func _on_body_entered(body: Node2D) -> void:
	if body is Player and not added:
		audio_stream_player.play()
		await audio_stream_player.finished
		#call inventory manager
		InventoryManager.add_collectable(collectable_name)
		added = true
		print("Collected: ", collectable_name)
		get_parent().queue_free()
