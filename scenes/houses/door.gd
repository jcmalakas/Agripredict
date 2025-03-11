extends StaticBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var interactable_component: InteractableComponent = $InteractableComponent

#interactable for entering door collision_layer = 1
func _ready() -> void:
	interactable_component.interactable_activated.connect(on_interactable_activated)
	interactable_component.interactable_deactivated.connect(on_interactable_deactivated) 
	collision_layer = 1

#for entering door and collision_layer = 2
func on_interactable_activated() -> void:
	animated_sprite_2d.play("open door")
	collision_layer = 2
	print("activated")

#for entering door and collision_layer = 1
func on_interactable_deactivated() -> void:
	animated_sprite_2d.play("close door")
	collision_layer = 1
	print("deactivated")
#end of interactable for entering door
