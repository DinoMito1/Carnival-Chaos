extends CharacterBody2D
var time = 0
var finish = false
const SPEED = 90.0

func _physics_process(delta: float) -> void:
	if time >= .6 and finish == false:
		velocity.x += -75
		time = 0
		
	velocity.x += (velocity.x * -4 * delta)
		
	time += delta
	move_and_slide()


func _on_node_2d_good_hit() -> void:
	velocity.x += 375


func _on_node_2d_bad_hit() -> void:
	if finish == false:
		velocity.x -= 75


func _on_win_zone_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	finish = true
	velocity.x += 250
	#when finish is true the rope will stop being pulled


func _on_lose_zone_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	finish = true 
	velocity.x -= 200
	#when finish is true the rope will stop being pulled
