extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VolumeValue.text = str( int(Global.volume*25) ) + '%'
	$VolumeBar.value = Global.volume*25

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
	Global.volume = 1
	$VolumeBar.value = 25
