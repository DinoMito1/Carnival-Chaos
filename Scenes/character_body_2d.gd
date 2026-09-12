extends CharacterBody2D
var time = 0

const SPEED = 90.0

func _physics_process(delta: float) -> void:
	if time >= .75:
		velocity.x += -100
		time = 0
	
	velocity.x += (velocity.x * -4 * delta)
		
	time += delta
	move_and_slide()


func _on_node_2d_good_hit() -> void:
	velocity.x += 400


func _on_node_2d_bad_hit() -> void:
	velocity.x -= 100
