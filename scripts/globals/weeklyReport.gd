extends Node

var cropLosses:Array[int]
var croploss:int = 0
var cropAppended:bool = false

var rainChances:Array[int] = []
var rainCount:int
var currentlyPlanted:int
var done:bool = false

var previousMoney:float
var currentMoney:float
var profitPerHarvest:int = 23

var weeklyReportInstantiated:bool = false
signal weekPassed

#Todo list
#total planted per week
#linear regression
#crop loss is X
#rainfall chance is Y

#increment the total crops and decrease when lost


func _ready() -> void:
	DayAndNightCycleManager.time_tick.connect(appendTheDestroyedCrops)
	DayAndNightCycleManager.dayPassed.connect(cropAppendedSwitch)
	DayAndNightCycleManager.justRained.connect(incrementRainCount)
	InventoryManager.money = previousMoney

func appendTheDestroyedCrops(day: int, hour: int, minute: int) -> void:
	if hour > 11 and not cropAppended and not day == 0:
		cropLosses.append(croploss)
		croploss = 0
		cropAppended = true
		#print("Appended")
	
	#checks if its been a week and the player hasnt triggered the done button on linear regression UI
	if day % 2 == 0 and not done:
		#print("Week has passed")
		weekPassed.emit()
		get_tree().paused = true
		
	
	if DayAndNightCycleManager.current_day != day:
		done = false

func cropAppendedSwitch():
	cropAppended = false
	return

#func _process(delta: float) -> void:
	##dont print on globals, it will give you the instantiated values and the real time values
	##if Input.is_action_just_pressed("interact"):
		##print("Rain Chances Array " + str(rainChances))
		##print("Crop loss Array " + str(cropLosses))
		##print("Crop total loss " + str(croploss))

func updatePreviousMoney():
	previousMoney = currentMoney 

func incrementRainCount():
	rainCount += 1
