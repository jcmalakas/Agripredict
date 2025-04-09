extends StaticBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
func _ready() -> void:
	animated_sprite_2d.play("default")
	Dialogic.signal_event.connect(dialogicSignal)
	return

func dialogicSignal(arguement):
	if arguement == "merchant leaves":
		queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		Dialogic.start("timeline","merchant")
