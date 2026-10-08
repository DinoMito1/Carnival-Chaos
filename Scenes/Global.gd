extends Node

@onready var timer = $Timer

var minigames_done = 0
var lives = 5
var lost_prev = false
var best_time = 999.99
var time = 0
var volume = 1.6
var paused = false
var on_mobile = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if OS.has_feature("web_android") or OS.has_feature("web_ios"):
		on_mobile = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if paused == true:
		get_tree().paused = true
	else: #if pause is false
		get_tree().paused = false
	time = snapped(4096 -timer.time_left, 0.01)
