extends Spatial
onready var _explo = preload("res://prepa/explo.tscn")

func _ready() -> void:
	$Timer.start()

func _on_Timer_timeout() -> void:
	explode()
	
func hit()->void:
	explode()
	
func explode()->void:
	$Timer.stop()
	var e = _explo.instance()
	get_parent().add_child(e)
	e.translation= self.translation
	queue_free()

