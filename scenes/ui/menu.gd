extends Control
@onready var musicBus = AudioServer.get_bus_index("music")
@onready var SFXBus = AudioServer.get_bus_index("SFX")
@onready var music_slider: HSlider = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/dataAudioContainer/musicSlider
@onready var sfx_slider: HSlider = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/dataAudioContainer/SFXSlider
@onready var creditUI:PackedScene = preload("res://scenes/ui/credit.tscn")

var current_db
var linear_value

func _ready() -> void:
	# Get the current bus volume in dB
	current_db = AudioServer.get_bus_volume_db(musicBus)
	linear_value = db_to_linear(current_db)
	music_slider.value = linear_value
	
	current_db = AudioServer.get_bus_volume_db(SFXBus)
	linear_value = db_to_linear(current_db)
	sfx_slider.value = linear_value


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("game_menu"):
		get_tree().paused = false
		queue_free()

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_resume_pressed() -> void:
	get_tree().paused = false
	queue_free()

func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(musicBus,linear_to_db(value))
	AudioServer.set_bus_mute(musicBus,value < 0.05)
	pass # Replace with function body.

func _on_sfx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(SFXBus,linear_to_db(value))
	AudioServer.set_bus_mute(SFXBus,value < 0.05)


func _on_credit_pressed() -> void:
	add_child(creditUI.instantiate())
