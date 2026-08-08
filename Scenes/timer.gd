extends Node2D
@onready var timer: RichTextLabel = $timer

var time: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer.text = str(snapped(time,0.10))
	
func Timer(start_time: float):
	time = start_time
	
	while time > 0.1:
		await get_tree().create_timer(0.1).timeout
		time -= 0.1
	
	return

func Stop():
	time = 999
	
