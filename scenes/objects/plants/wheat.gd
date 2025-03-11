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


func _ready() -> void:
	watering_particles.emitting = false
	flowering_particles.emitting = false
	
	hurt_component.hurt.connect(on_hurt) #kapag nag water ka sa plant unang tatawagin is si on_hurt 
	growth_cycle_component.crop_maturity.connect(on_crop_maturity) #this function connect to crop maturity 
	growth_cycle_component.crop_harvesting.connect(on_crop_harvesting) #this function connect to harvesting


func _process(delta: float) -> void:
	growth_state = growth_cycle_component.get_current_growth_state()
	sprite_2d.frame = growth_state
	
	if growth_state == DataTypes.GrowthStates.Maturity:
		flowering_particles.emitting = true

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
	var wheat_harvest_instance = wheat_harvest_scene.instantiate() as Node2D
	wheat_harvest_instance.global_position = global_position
	get_parent().add_child(wheat_harvest_instance)
	queue_free()
