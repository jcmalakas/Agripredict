extends Node2D

@onready var LRCanvasLayer:PackedScene = preload("res://scenes/ui/linearRegressionCanvasLayer.tscn")
var test = 0


func _ready() -> void:
	WeeklyReport.weekPassed.connect(showLinearRegression)

func showLinearRegression():
	
	if not WeeklyReport.weeklyReportInstantiated:
		var instance = LRCanvasLayer.instantiate()
		#LRCanvasLayer.show()
		add_child(instance)
		WeeklyReport.weeklyReportInstantiated = true
		get_tree().paused = true
		print("Testing" + str(test))
		test += 1
