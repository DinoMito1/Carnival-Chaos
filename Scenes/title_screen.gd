extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Background/Carnival1.visible = true
	$Background/Carnival2.visible = false
	$Background/Carnival3.visible = false
	# timer for animation will auto start
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	if $Background/Carnival1.visible == true:
		$Background/Carnival2.visible = true
		$Background/Carnival1.visible = false
	
	elif $Background/Carnival2.visible == true:
		$Background/Carnival3.visible = true
		$Background/Carnival2.visible = false
	
	elif $Background/Carnival3.visible == true:
		$Background/Carnival1.visible = true
		$Background/Carnival3.visible = false

func _on_start_pressed() -> void:
	$"fade to black thing".visible = true
	var tween = get_tree().create_tween() #fades to black
	tween.tween_property($"fade to black thing", "modulate:a", 1, .35)
	await get_tree().create_timer(.6).timeout
	
	get_tree().change_scene_to_file("res://Scenes/level_scene.tscn")
	


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/settings_scene.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
