extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.timer.stop()
	
	if Global.time < 1000:
		$YourTimeText.text = str(Global.time) 
	else:
		$YourTimeText.text = "999.99"
	
	if Global.time < Global.best_time:
		Global.best_time = Global.time
		$BestTimeText.text = str(Global.time)
	else:
		$BestTimeText.text = str(Global.best_time)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_retry_button_mouse_entered() -> void:
	#makes button bigger when hovering
	var bigTween = get_tree().create_tween()
	bigTween.tween_property($RetryButton, "scale", Vector2(0.55,0.55), 0.5).set_trans(Tween.TRANS_EXPO)

func _on_retry_button_mouse_exited() -> void:
	#makes button smaller when hovering stops
	var smallTween = get_tree().create_tween()
	smallTween.tween_property($RetryButton, "scale", Vector2(.5,.5), 0.5).set_trans(Tween.TRANS_EXPO)

func _on_retry_button_button_down() -> void:
	Global.minigames_done = 0
	Global.lives = 5
	Global.lost_prev = false
		
	$"Fade to black thing".show()
	var fadeTween = get_tree().create_tween() 
	fadeTween.tween_property($"Fade to black thing", "modulate:a", 1, 1)
	await get_tree().create_timer(1.05).timeout
		
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")
