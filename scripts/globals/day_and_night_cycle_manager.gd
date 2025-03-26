extends Node
#Time management code
const MINUTES_PER_DAY: int = 24 * 60
const MINUTES_PER_HOUR: int = 60
const GAME_MINUTE_DURATION: float = TAU / MINUTES_PER_DAY

#the lower, the frequent
const rainThreshold:int = 40

var game_speed: float = 5.0

var initial_day: int = 1
var initial_hour: int = 12
var initial_minute: int = 30

var time: float = 0.0
var current_minute: int = -1
var current_day: int = 0

signal game_time(time: float)
signal time_tick(day: int, hour: int, minute: int)
signal time_tick_day(day: int)

signal justRained
signal dayPassed

var rain = false

func _ready() -> void:
	set_initial_time()

func _process(delta: float) -> void:
	time += delta * game_speed * GAME_MINUTE_DURATION
	game_time.emit(time)
	
	recalculate_time()


func set_initial_time() -> void:
	var initial_total_minutes = initial_day * MINUTES_PER_DAY + (initial_hour * MINUTES_PER_HOUR) + initial_minute
	
	time = initial_total_minutes * GAME_MINUTE_DURATION

func recalculate_time() -> void:
	var total_minutes: int = int(time / GAME_MINUTE_DURATION)
	#@warning_ignore("integer_division")
	var day: int = int(total_minutes / MINUTES_PER_DAY)
	var current_day_minutes: int = total_minutes % MINUTES_PER_DAY
	#@warning_ignore("integer_division")
	var hour: int = int(current_day_minutes / MINUTES_PER_HOUR)
	var minute: int = int(current_day_minutes % MINUTES_PER_HOUR)
	
	if current_minute != minute:
		current_minute = minute
		time_tick.emit(day, hour, minute)
	
	if current_day != day:
#region this makes it rain
		var rng = RandomNumberGenerator.new()
		rng.randomize()

		# Define the step and max value
		var step = 10
		var max_value = 100

		# Generate a random value with the specified step
		var rainChance = rng.randi_range(0, max_value / step) * step

		# The lower the more chance it rains
		if rainChance > rainThreshold and not current_day == 0:
			emit_signal("justRained")
			
			#emit_signal("rainChance", rainChance)
			#print("Emitted")
			rain = true
			
		else:
			rain = false
#endregion
		
		current_day = day
		time_tick_day.emit(day)
		
		WeeklyReport.rainChances.append(rainChance)
		dayPassed.emit()
	
