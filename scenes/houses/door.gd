extends StaticBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var interactable_component: InteractableComponent = $InteractableComponent
@onready var door_open_audio: AudioStreamPlayer2D = $doorOpenAudio
@onready var door_close_audio: AudioStreamPlayer2D = $doorCloseAudio


#interactable for entering door collision_layer = 1
func _ready() -> void:
	interactable_component.interactable_activated.connect(on_interactable_activated)
	interactable_component.interactable_deactivated.connect(on_interactable_deactivated) 
	collision_layer = 1

#for entering door and collision_layer = 2
func on_interactable_activated() -> void:
	animated_sprite_2d.play("open door")
	collision_layer = 2
	door_open_audio.play()
	print("activated")

#for entering door and collision_layer = 1
func on_interactable_deactivated() -> void:
	animated_sprite_2d.play("close door")
	collision_layer = 1
	door_close_audio.play()
	print("deactivated")
#end of interactable for entering door


func _on_door_open_audio_finished() -> void:
	pass # Replace with function body.


func _on_door_close_audio_finished() -> void:
	pass # Replace with function body.
