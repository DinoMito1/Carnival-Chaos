extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Background/Carnival1.show()
	$Background/Carnival2.hide()
	$Background/Carnival3.hide()
	# timer for animation will auto start
	
	$"fade to black thing".show()
	var fadeTween = get_tree().create_tween() 
	fadeTween.tween_property($"fade to black thing", "modulate:a", 0, .5)
	await get_tree().create_timer(.5).timeout
	$"fade to black thing".hide()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	if $Background/Carnival1.visible == true:
		$Background/Carnival2.show()
		$Background/Carnival1.hide()
	
	elif $Background/Carnival2.visible == true:
		$Background/Carnival3.show()
		$Background/Carnival2.hide()
	
	elif $Background/Carnival3.visible == true:
		$Background/Carnival1.show()
		$Background/Carnival3.hide()

func _on_start_pressed() -> void:
	$SelectSound.play()
	# dont forget to set the fading thing to not visible when not working on scene
	$"fade to black thing".show()
	var tween = get_tree().create_tween() #fades to black
	tween.tween_property($"fade to black thing", "modulate:a", 1, .35)
	await get_tree().create_timer(.45).timeout
	
	Global.timer.start()
	get_tree().change_scene_to_file("res://Scenes/level_scene.tscn")

func _on_settings_pressed() -> void:
	$SelectSound.volume_linear = Global.volume
	$SelectSound.play()
	get_tree().change_scene_to_file("res://Scenes/settings_scene.tscn")


func _on_quit_pressed() -> void:
	$"fade to black thing".show()
	$"fade to black thing".modulate.a = 255
	get_tree().quit()
