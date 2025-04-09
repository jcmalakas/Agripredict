extends Node2D

@onready var LRCanvasLayer:PackedScene = preload("res://scenes/ui/linearRegressionCanvasLayer.tscn")
@onready var audioDayPassed = $anotherDayAudio
#var test = 0
#
#
func _ready() -> void:
	DayAndNightCycleManager.weekPassed.connect(showLinearRegression)
	DayAndNightCycleManager.dayPassed.connect(playDayPassedAudio)
	
	
	Dialogic.start("timeline")
func playDayPassedAudio():
	audioDayPassed.play()

func showLinearRegression():
	if not WeeklyReport.dataFinalized:
		return
	
	var instance = LRCanvasLayer.instantiate()
	#LRCanvasLayer.show()
	add_child(instance)
	get_tree().paused = true
	
	
