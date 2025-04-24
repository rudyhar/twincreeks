extends CharacterBody3D

signal pitch_change
signal player_death

const GRAVITY = -24.8
const MAX_SPEED = 20
const JUMP_SPEED = 18
const ACCEL= 4.5

var dir = Vector3()

const DEACCEL= 16
const MAX_SLOPE_ANGLE = 40

var camera
var rotation_helper
var initial_position

var MOUSE_SENSITIVITY = 0.05

func _ready():
	initial_position = self.get_position()
	camera = $RotationHelper/Camera
	rotation_helper = $RotationHelper
	get_node("RotationHelper/Gun/AnimationPlayer").speed_scale = 3.0
	get_node("RotationHelper/Vape/Vape/AnimationPlayer").play("vape trick 1")



	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	process_input(delta)
	process_movement(delta)

	# Iterate through all collisions that occurred this frame
	for index in range(get_slide_collision_count()):
		# We get one of the collisions with the player
		var collision = get_slide_collision(index)

		# If there are duplicate collisions with a mob in a single frame
		# the mob will be deleted after the first collision, and a second call to
		# get_collider will return null, leading to a null pointer when calling
		# collision.get_collider().is_in_group("mob").
		# This block of code prevents processing duplicate collisions.
		if collision.get_collider() == null:
			continue
	

func death():
	$Death/DeathSound.play()
	$Death/DeathDistortSound.play()
	
	player_death.emit()
	
			
	

func process_input(delta):

	# ----------------------------------
	# Walking
	dir = Vector3()
	var cam_xform = camera.get_global_transform()

	var input_movement_vector = Vector2()

	if Input.is_action_pressed("move_forward"):
		input_movement_vector.y += 1
		
	if Input.is_action_pressed("move_back"):
		input_movement_vector.y -= 1
		emit_signal("pitch_change")

	if Input.is_action_pressed("move_left"):
		input_movement_vector.x -= 1

	if Input.is_action_pressed("move_right"):
		input_movement_vector.x = 1

	if Input.is_action_pressed("shoot"):
		shoot()
	if Input.is_action_pressed("reload"):
		reload()

	input_movement_vector = input_movement_vector.normalized()

	dir += -cam_xform.basis.z.normalized() * input_movement_vector.y
	dir += cam_xform.basis.x.normalized() * input_movement_vector.x
	# ----------------------------------

	# ----------------------------------
	# Jumping
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_SPEED
	# ----------------------------------

	# ----------------------------------
	# Capturing/Freeing the cursor
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# ----------------------------------

func process_movement(delta):
	dir.y = 0
	dir = dir.normalized()

	velocity.y += delta*GRAVITY

	var hvel = velocity
	hvel.y = 0

	var target = dir
	target *= MAX_SPEED

	var accel
	if dir.dot(hvel) > 0:
		accel = ACCEL
	else:
		accel = DEACCEL

	hvel = hvel.lerp(target, accel*delta)
	velocity.x = hvel.x
	velocity.z = hvel.z
	move_and_slide()

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotation_helper.rotate_x(deg_to_rad(event.relative.y * MOUSE_SENSITIVITY * -1))
		self.rotate_y(deg_to_rad(event.relative.x * MOUSE_SENSITIVITY * -1))

		var camera_rot = rotation_helper.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -70, 70)
		rotation_helper.rotation_degrees = camera_rot
		
		
	if event is InputEventMouseButton:
		if !event.is_pressed():
			print("JOE")
			get_node("RotationHelper/Vape/Vape/AnimationPlayer").play("Holding")
			
			
	

			
			
		
		
		
func shoot():
	get_node("RotationHelper/Gun/AnimationPlayer").stop()
	get_node("RotationHelper/Gun/AnimationPlayer").play("Shoot")
	get_node("RotationHelper/Gun/GunshotSound").play()
	
	get_node("RotationHelper/Vape/Vape/AnimationPlayer").play("smoke")

	
	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create($RotationHelper/Camera.global_position,
		$RotationHelper/Camera.global_position - $RotationHelper/Camera.global_transform.basis.z * 100)
	var collision = space.intersect_ray(query)
	
	if collision and collision.collider and collision.collider.name.contains("bird"):
		var bird = collision.collider
		bird.death()
		
	
	
	
func reload():
	get_node("RotationHelper/Gun/AnimationPlayer").stop()
	get_node("RotationHelper/Gun/AnimationPlayer").play("Reload")

	



func _on_death_box_area_entered(area: Area3D) -> void:
	
	
	death()
	pass # Replace with function body.


func _on_bird_collision_detector_body_entered(body: Node3D) -> void:
	death()
	pass # Replace with function body.
