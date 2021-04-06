extends Spatial
onready var _box=preload("res://prepa/box.tscn")
onready var _player = preload( "res://prepa/player.tscn")
var seed_id := 123456789
var is_running:= false
func _ready() -> void:
	pass
	
func initialize()->void:
	seed(seed_id)
	create_board()

func create_board()-> void:
	for cells in $GridMap2.get_used_cells():
		$GridMap2.set_cell_item(cells.x, cells.y, cells.z, randi()% 12)
		
	for z in range(3,24, 4):
		for x in range(5,34, 4):
			if x==5 and z==23:continue
			if x==5 and z==3:continue
			if x==33 and z==3:continue
			if x == 33 and z==23:continue
			if randi()%10 > 5:continue
			var b=_box.instance()
			$blocks.add_child(b)
			b.translation = Vector3(x , 0, z)

	for z in range(5,22, 4):
		for x in range(3,36, 4):
			if x==3 and z==21 :continue
			if x==3 and z==5 :continue
			if x==35 and z==5:continue
			if x==35 and z==21:continue
			if randi()%10 > 5:continue
			var b=_box.instance()
			$blocks.add_child(b)
			b.translation = Vector3(x , 0, z)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):var _err = get_tree().reload_current_scene()
	if ! is_running:return
	if $players.has_node(str(get_tree().get_network_unique_id())):
		var p = $players.get_node(str(get_tree().get_network_unique_id()))
		var ply = p.translation
		var start = Vector3(19, 0, 14)
		if (ply -start).length() > 1.5:
			var r = (ply - start).normalized()*1.5 + start
			$cam.translation = lerp($cam.translation, r, 0.015)
		else:
			$cam.translation = lerp($cam.translation, (ply -start)+start, 0.015)
	
	
#	print($blocks.get_child_count())

func get_box()->void:
	var b = $blocks.get_child_count()
	if b <= 0:
		print("end level")

