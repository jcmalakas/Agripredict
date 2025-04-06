extends NonPlayableCharacter

@onready var timer: Timer = $Timer
@onready var cow_audio: AudioStreamPlayer2D = $cowAudio


func _ready() -> void:
	walk_cycles = randi_range(min_walk_cycle, max_walk_cycle)
	timer.start(randi_range(3,20))


func _on_timer_timeout() -> void:
	cow_audio.play()
	timer.start(randi_range(3,20))
	pass # Replace with function body.
