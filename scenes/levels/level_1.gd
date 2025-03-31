extends Node2D

@onready var LRCanvasLayer:PackedScene = preload("res://scenes/ui/linearRegressionCanvasLayer.tscn")
#var test = 0
#
#
func _ready() -> void:
	DayAndNightCycleManager.weekPassed.connect(showLinearRegression)

func showLinearRegression():
	if not WeeklyReport.dataFinalized:
		return
	
	var instance = LRCanvasLayer.instantiate()
	#LRCanvasLayer.show()
	add_child(instance)
	
	
