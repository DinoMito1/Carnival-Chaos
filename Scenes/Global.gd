extends Node

@onready var timer = $Timer

var minigames_done = 0
var lives = 5
var lost_prev = false
var best_time = 999.99
var time = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time = snapped(4096 -timer.time_left, 0.01)
