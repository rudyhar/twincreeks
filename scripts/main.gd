extends Node



func _ready():
	get_node("Cloud/CloudBright/AnimationPlayer").play("Icosphere_012Action")
	
	
#func _process(delta: float) -> void:
	#var timered = Time.get_unix_time_from_system()
	#var interval = timered % 10
	#if interval == 0.0:
		#var remainder = timered % 5 * 0.1
		#get_node("Background").pitch_scale = remainder


var rng = RandomNumberGenerator.new() 

func _on_player_pitch_change() -> void:
	var my_random_number = rng.randf_range(0.0, 1.0)
	get_node("Background").pitch_scale = my_random_number
	pass # Replace with function body.


func _on_player_player_death() -> void:
	reset_game()
	pass # Replace with function body.

func reset_game():
	print("hi")
	
	#for node in get_tree().get_nodes_in_group("Birds"):
		#node.queue_free()
	var _reload = get_tree().reload_current_scene()	
	
	
