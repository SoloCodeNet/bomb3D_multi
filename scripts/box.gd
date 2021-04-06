extends StaticBody

func hit()-> void:
	$CollisionShape.disabled = true
	$tw.interpolate_property($mesh,"scale", Vector3.ONE, Vector3.ZERO, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$tw.start()
	yield($tw,"tween_all_completed")
	queue_free()
	

