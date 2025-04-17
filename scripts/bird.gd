extends CharacterBody3D

# Minimum speed of the mob in meters per second.
@export var min_speed = 10
# Maximum speed of the mob in meters per second.
@export var max_speed = 18

var attacking = false
var random_speed;
var dead = false
var initial_position


func attack_initiate():
	attacking = true
	if is_instance_valid($Squak):
		$Squak.play()
	# get pos of player
	# face player with z axis
	# move towards player doing sin and cos move on its X and Y axis
	random_speed = randi_range(min_speed, max_speed)
	



func attack():
	if !dead:
		var player_position = get_node("../Player").position
		look_at_from_position(position, player_position, Vector3.UP)
		var timered = Time.get_unix_time_from_system()
				
		position = position + global_transform.basis.y * (0.1*sin(2*timered))
		position = position + global_transform.basis.x * (0.1*sin(2*timered))

		#translate(strafe)
		velocity = -global_transform.basis.z.normalized() * random_speed

		move_and_slide()
		# We then rotate the velocity vector based on the mob's Y rotation
		# in order to move in the direction the mob is looking.
	
	
func death():
	dead = true
	$DeathAnim.play("death")
	$DeathDelay.start()
	if is_instance_valid($Squak):
		$Squak.queue_free()
	$DeathSound.play(0.0)
	
	position = initial_position
	

func _physics_process(_delta):
	
	if attacking:
		attack()
		

func _ready() -> void:
	initial_position = self.get_position()



func _on_timer_timeout() -> void:
	attack_initiate()
	
	pass # Replace with function body.


func _on_squak_finished() -> void:
	$SquakDelay.start()
	pass # Replace with function body.


func _on_squak_delay_timeout() -> void:
	if is_instance_valid($Squak):
		$Squak.play(0.0)
	pass # Replace with function body.


func _on_death_delay_timeout() -> void:
	queue_free()
	pass # Replace with function body.
	
	
