extends Node2D
#call the wheat_harvest dahil after nong growing nun pag ei harvest na lalabas na yong collectable na wheat
var wheat_harvest_scene = preload("res://scenes/objects/plants/wheat_harvest.tscn")

#call every parts of the wheat
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var watering_particles: GPUParticles2D = $WateringParticles
@onready var flowering_particles: GPUParticles2D = $FloweringParticles
@onready var growth_cycle_component: GrowthCycleComponent = $GrowthCycleComponent
@onready var hurt_component: HurtComponent = $HurtComponent

var growth_state: DataTypes.GrowthStates = DataTypes.GrowthStates.Seed 
#the higher the threshold, the less likely it would get destroyed
@export var destroyThreshold:int = 80
var destroyChance
var rng 
var justRained:bool = false

#signal cropDestroyed

func _ready() -> void:
	watering_particles.emitting = false
	flowering_particles.emitting = false
	
	hurt_component.hurt.connect(on_hurt) #kapag nag water ka sa plant unang tatawagin is si on_hurt 
	growth_cycle_component.crop_maturity.connect(on_crop_maturity) #this function connect to crop maturity 
	growth_cycle_component.crop_harvesting.connect(on_crop_harvesting) #this function connect to harvesting
	
	WeeklyReport.currentlyPlanted = WeeklyReport.currentlyPlanted + 1
	
	
#region Initialize the chances of crops getting destroyed
	rng =  RandomNumberGenerator.new()
	rng.randomize()
	destroyChance = rng.randi_range(0,100)
	print("This is the destroy chance of the wheat"+str(destroyChance))
	DayAndNightCycleManager.justRained.connect(rainSwitch)
#endregion

func _process(delta: float) -> void:
	growth_state = growth_cycle_component.get_current_growth_state()
	sprite_2d.frame = growth_state
	
	if growth_state == DataTypes.GrowthStates.Maturity:
		flowering_particles.emitting = true
			
#region this checks whether crops will get destroyed via rain
	if DayAndNightCycleManager.rain and destroyChance > destroyThreshold:
		#print("Chance")
		#print(destroyChance)
		#print("Threshold")
		#print(destroyThreshold)
		#print(destroyChance > destroyThreshold)
		#emit_signal("cropDestroyed")
		
		#apparently, when using globals you cant direct += it
		WeeklyReport.croploss = WeeklyReport.croploss + 1
		WeeklyReport.currentlyPlanted = WeeklyReport.currentlyPlanted - 1
		print("I go, bye bye~")
		print(str((destroyChance > destroyThreshold)) + " = DC: " + str(destroyChance) + " DT: " + str(destroyThreshold))
		queue_free()
	
	#Re-roll the rng of destroy chance ng rice
	if justRained:
		destroyChance = rng.randi_range(0,100)
		
		#print("Chance")
		#print(destroyChance)
		print("new destroy chance of the rice"+str(destroyChance))
		justRained = false
		


#endregion
	

func rainSwitch() -> void:
	justRained = true

# here is the function of on_hurt component
func on_hurt(hit_damage: int) -> void:
	if !growth_cycle_component.is_watered:
		watering_particles.emitting = true #this function work when you wattered the plant
		await get_tree().create_timer(5.0).timeout #timer kong hanggang ilang seconds yong particles maga show ba
		watering_particles.emitting = false #false to stop the function of particles
		growth_cycle_component.is_watered = true


func on_crop_maturity() -> void:
	flowering_particles.emitting = true #this function ay nag papakita na nag activate na yong particle na nang yayari lang pag na deligan mona yong plant


func on_crop_harvesting() -> void:
	WeeklyReport.currentlyPlanted = WeeklyReport.currentlyPlanted - 1
	var wheat_harvest_instance = wheat_harvest_scene.instantiate() as Node2D
	wheat_harvest_instance.global_position = global_position
	get_parent().add_child(wheat_harvest_instance)
	queue_free()
