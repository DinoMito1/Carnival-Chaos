extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_mouse_entered() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($".", "modulate:a", 1, .15 )

func _on_button_mouse_exited() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($".", "modulate:a", 0.3, .15 )
	

func _on_button_button_up() -> void:
	$".".modulate = Color(1,1,1, 1)
	get_tree().paused = true
	Global.paused = true
	
	var pauseTween = create_tween().set_trans(Tween.TRANS_EXPO)
	pauseTween.tween_property($"../Pause Menu", "position", Vector2(-600,135), 1) 
	$"../PauseButton".pitch_scale = 0.75
	$"../PauseButton".play()


func _on_button_button_down() -> void:
	$".".modulate = Color(.85,.85,.85, 1)


func _on_continue_button_button_up() -> void: #unpause the game
	get_tree().paused = false
	Global.paused = false
	$"../PauseButton".pitch_scale = 1.1
	$"../PauseButton".play()
	var unpauseTween = create_tween().set_trans(Tween.TRANS_EXPO)
	unpauseTween.tween_property($"../Pause Menu", "position", Vector2(-1388,-1014), 1) 


func _on_quit_button_button_up() -> void: # go back to menu
	get_tree().paused = false
	Global.paused = false
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")


func _on_continue_button_button_down() -> void:
	$"../Pause Menu/Continue Button".modulate = Color(.85,.85,.85,1)


func _on_quit_button_button_down() -> void:
	$"../Pause Menu/Quit Button".modulate = Color(.85,.85,.85,1)
