extends Node3D



func _process(delta):
	var timered = Time.get_unix_time_from_system()
	$sky.rotate_y(0.001* sin(0.5*timered))
	#print(timered)
