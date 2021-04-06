extends Spatial

export(float) var lenght: = 2.0
onready var r = [$r_down, $r_left, $r_top, $r_right]
onready var m = [$m_down, $m_left, $m_top, $m_right]

func _ready() -> void:
	yield(get_tree(),"idle_frame")
	test()
	
func test()->void:
	for x in 4:
		var ray= r[x]
		var mesh = m[x]
		mesh.scale.z = lenght + 0.5
		ray.cast_to.x = lenght * 2
		ray.force_raycast_update()
		
		if ray.is_colliding():
			print("collide")
			var end = ray.get_collision_point()
			var start = ray.global_transform.origin
			var le = (Vector2(end.x, end.z) - Vector2(start.x, start.z)).length()
			mesh.scale.z = le / 2 + 0.5
			if ray.get_collider().is_in_group("box"):
				ray.get_collider().hit()
			if ray.get_collider().is_in_group("player"):
				ray.get_collider().hit()
			if ray.get_collider().is_in_group("enemy"):
				ray.get_collider().hit()
	yield(get_tree().create_timer(0.3), "timeout")
	queue_free()
