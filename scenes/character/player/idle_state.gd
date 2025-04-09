extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D

var canMove:bool = false

func _ready() -> void:
	Dialogic.signal_event.connect(dialogicSignals)
	
func dialogicSignals(argument:String):
	if argument == "canMove":
		print("Dialogue signal")
		canMove = not canMove

func _on_process(_delta : float) -> void:
	pass

#idle player animation
func _on_physics_process(_delta : float) -> void:	

	
	if player.player_direction == Vector2.UP:
		animated_sprite_2d.play("idle_back")
	elif player.player_direction == Vector2.RIGHT:
		animated_sprite_2d.play("idle_right")
	elif player.player_direction == Vector2.DOWN:
		animated_sprite_2d.play("idle_front")
	elif player.player_direction == Vector2.LEFT:
		animated_sprite_2d.play("idle_left")
	else:
		animated_sprite_2d.play("idle_front")
#End of idle player animation

#back to idle 
func _on_next_transitions() -> void:
	GameInputEvents.movement_input()
	
#transition to walk
	if GameInputEvents.is_movement_input():
		if not canMove:
			return
		transition.emit("Walk")
#end of transition

#transition from chopping
	if player.current_tool == DataTypes.Tools.AxeWood && GameInputEvents.use_tool():
		transition.emit("Chopping")
#end of chopping 

#transition from tilling
	if player.current_tool == DataTypes.Tools.Tillground && GameInputEvents.use_tool():
		transition.emit("Tilling")
#end of tilling 

#transition from watering
	if player.current_tool == DataTypes.Tools.WaterCrops && GameInputEvents.use_tool():
		transition.emit("Watering")
#end of watering 

func _on_enter() -> void:
	pass


func _on_exit() -> void:
	animated_sprite_2d.stop()
#end back to idle 
