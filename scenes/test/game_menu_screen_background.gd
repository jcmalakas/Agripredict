extends Node2D

func _ready() -> void:
	call_deferred("set_scene_process_mode")
	
	await RenderingServer.frame_post_draw
	var image = get_viewport().get_texture().get_image()
	image.save_png("user://test.png")
	
func set_scene_process_mode() -> void:
	process_mode = PROCESS_MODE_DISABLED
	
	
