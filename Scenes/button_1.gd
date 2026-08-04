extends TextureButton
@onready var parent = $".."
@onready var idle = preload("res://Sprites/Mole_normal.png")
@onready var bonked = preload("res://Sprites/Mole_hurt.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_pressed() -> void:
	if $".".texture_normal == idle:
		$".".texture_normal = bonked
		parent.buttons_pressed += 1
		await get_tree().create_timer(0.5).timeout
		hide()
