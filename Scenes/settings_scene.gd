extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VolumeValue.text = str( int(Global.volume*25) ) + '%'
	$VolumeBar.value = Global.volume*25
	
	if Global.on_mobile == true:
		$"Mobile Control Toggle".icon = load("res://Sprites/Toggle_checked.png")
	else:
		$"Mobile Control Toggle".icon = load("res://Sprites/Toggle_NOT_checked.png")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")


func _on_volume_bar_value_changed(value: float) -> void:
	#changes volume
	Global.volume = value / 25
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), Global.volume)
	$VolumeValue.text = ' ' + str( int(value) ) + '%'
	$volumeAdjustSound.play()


func _on_volume_reset_button_down() -> void:
	$VolumeReset.modulate = Color(.85,.85,.85,1)
	

func _on_mobile_control_toggle_button_up() -> void:
	$"Mobile Control Toggle".modulate = Color(1,1,1,1)
	if Global.on_mobile == true:
		Global.on_mobile = false
		$"Mobile Control Toggle".icon = load("res://Sprites/Toggle_NOT_checked.png")
		$ButtonToggleSound.pitch_scale = 0.75
		$ButtonToggleSound.play()
	else: # on_mobile is already false
		Global.on_mobile = true
		$"Mobile Control Toggle".icon = load("res://Sprites/Toggle_checked.png")
		$ButtonToggleSound.pitch_scale = 1.1
		$ButtonToggleSound.play()

func _on_mobile_control_toggle_button_down() -> void:
	$"Mobile Control Toggle".modulate = Color(.85,.85,.85,1)


func _on_volume_reset_button_up() -> void:
	Global.volume = 1
	$VolumeBar.value = 40
	$VolumeReset.modulate = Color(1,1,1,1)
