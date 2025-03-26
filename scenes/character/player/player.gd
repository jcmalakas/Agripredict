class_name Player
extends CharacterBody2D

@onready var hit_component: HitComponent = $HitComponent

@export var current_tool: DataTypes.Tools = DataTypes.Tools.None
@onready var rainParticles = $rain
var player_direction: Vector2
	
func _ready() -> void:
	ToolManager.tool_selected.connect(on_tool_selected)
	get_viewport().size = DisplayServer.screen_get_size()
func on_tool_selected(tool: DataTypes.Tools) -> void:
	current_tool = tool
	hit_component.current_tool = tool
func _process(delta: float) -> void:
	if DayAndNightCycleManager.rain == true:
		rainParticles.set_emitting(true)
	else:
		rainParticles.set_emitting(false)
		
		
	if Input.is_action_just_pressed("interact"):
		print("Im printed on player")
		print("Rain Chances Array " + str(WeeklyReport.rainChances))
		print("Crop loss Array " + str(WeeklyReport.cropLosses))
		print("Crop total loss " + str(WeeklyReport.croploss))
		print("total planted " + str(WeeklyReport.currentlyPlanted))
