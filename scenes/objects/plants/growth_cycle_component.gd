class_name GrowthCycleComponent
extends Node

#there will be a Data management located in scripts, global in enum state there are all of the GrowthStates
@export var current_growth_state: DataTypes.GrowthStates = DataTypes.GrowthStates.Germination
@export_range(5, 365) var days_until_harvest: int = 7 #dito yong sukat kong ilang araw bago yong harvest nung wheat

signal crop_maturity 
signal crop_harvesting

var is_watered: bool
var starting_day: int
var current_day: int

#the day and night cycle will always communicating with the growth component
func _ready() -> void:
	DayAndNightCycleManager.time_tick_day.connect(on_time_tick_day)

#this function use kapag na water na yong plant don na papasok si growth_state
func on_time_tick_day(day: int) -> void:
	if is_watered:
		if starting_day == 0:
			starting_day = day
		
		growth_states(starting_day, day)#in growth states here is the stary of growing
		harvest_state(starting_day, day)#after the growth state the wheat scene will pup up the you can collect it


func growth_states(starting_day: int, current_day: int) -> void:
	if current_growth_state == DataTypes.GrowthStates.Maturity:
		return
	
	var num_states = 5 #bakit 5 kasi meong limang stages nang growing yong plant check mo sa data types enum
	
	var growth_days_passed = (current_day - starting_day) % num_states #dito na maga simula yong counting nong growing nong plant like i said 5 yong growing state niya pwede mo ei check don sa data type located in globals
	var state_index = growth_days_passed % num_states + 1
	
	current_growth_state = state_index
	
	var name = DataTypes.GrowthStates.keys()[current_growth_state] #pang debug ba makikita mo kong anong growth_state kana
	print("Current growth state: ", name, "State index: ", state_index)
	
	#if the wheat is mature you will call the maturity in data types
	if current_growth_state == DataTypes.GrowthStates.Maturity:
		crop_maturity.emit()


func harvest_state(starting_day: int, current_day: int) -> void:
	if current_growth_state == DataTypes.GrowthStates.Harvesting:#function of reaching the harvest
		return
	#here is the start of counting when the plant is wattered
	var days_passed = (current_day - starting_day) % days_until_harvest
	
	if days_passed == days_until_harvest - 1:
		current_growth_state = DataTypes.GrowthStates.Harvesting
		crop_harvesting.emit() #call the crop harvesting state


func get_current_growth_state() -> DataTypes.GrowthStates:
	return current_growth_state
