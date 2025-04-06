extends Node2D

@onready var rainParticle:GPUParticles2D = $"../rain"
@onready var no_damage_audio: AudioStreamPlayer = $noDamageAudio
@onready var mild_audio: AudioStreamPlayer = $mildAudio
@onready var storm_audio: AudioStreamPlayer = $stormAudio


var totalCropLoss:int

func _ready() -> void:
	DayAndNightCycleManager.dayPassed.connect(rainCheck)

#func _process(delta: float) -> void:
	#rainCheck()

func rainCheck():
	print("Next day, rain component")
#region checks if the button has been pushed
	#if not WeeklyReport.shown:
		##WeeklyReport.shown = true
		#return

#endregion
	
#region checks if it would rain
	var rng:RandomNumberGenerator = RandomNumberGenerator.new()
	rng.randomize()  # Ensure randomness
	var raining:bool = rng.randi() % 2 == 0
	
	#this makes it always rain after the first day
	#raining = true
	
	if not raining:
		print("Not raining")
		WeeklyReport.dataFinalized = true
		rainParticle.emitting = false
		
		no_damage_audio.stop()
		mild_audio.stop()
		storm_audio.stop()
		return
	WeeklyReport.rainCount += 1
#endregion
		
#region checks the strenght of the rain
	rng.randomize()
	var rainStrenght:int = rng.randi_range(0,100)
	var typhoonDamageThreshold:int = 85
	var mildDamageThreshold:Vector2 = Vector2(30,84)
	
	rng.randomize()
	var multiplierRNG:float
	
	var damagePercentage
	
	if rainStrenght >= typhoonDamageThreshold:
		multiplierRNG = rng.randf_range(0.3, 0.5)
		damagePercentage = WeeklyReport.currentlyPlanted * multiplierRNG
		rainParticle.amount_ratio = 1
		
		
		storm_audio.play()
		no_damage_audio.stop()
		mild_audio.stop()
		
		print("Typhoon")
	elif rainStrenght <= mildDamageThreshold.y and rainStrenght >= mildDamageThreshold.x:
		multiplierRNG = rng.randf_range(0.2, 0.3)
		damagePercentage = WeeklyReport.currentlyPlanted * multiplierRNG
		rainParticle.amount_ratio = 0.5
		
		mild_audio.play()
		no_damage_audio.stop()
		storm_audio.stop()
		
		print("Mild")
	else:
		multiplierRNG = rng.randf_range(0.0, 0.1)
		damagePercentage = WeeklyReport.currentlyPlanted * multiplierRNG
		rainParticle.amount_ratio = 0.1
		no_damage_audio.play()
		mild_audio.stop()
		storm_audio.stop()
		
		print("No damage")
	
	damagePercentage = int(damagePercentage)
	
	rainParticle.emitting = true
	
	
	WeeklyReport.cropLoss = damagePercentage
	WeeklyReport.cropLosses.append(damagePercentage)
	WeeklyReport.rainStrenghts.append(rainStrenght)
	WeeklyReport.dataFinalized = true
	WeeklyReport.justRained = true
	
	print("damage: " + str(damagePercentage))
	print("CropLoss: " + str(WeeklyReport.cropLosses))
	print("rainStrenght: " + str(WeeklyReport.rainStrenghts))
#endregiond
