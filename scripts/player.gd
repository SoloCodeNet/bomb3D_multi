extends StaticBody

var old_dir:=Vector3.FORWARD
var dir := Vector3.ZERO
var vel := Vector3.ZERO
var speed:= 8.0
var ang := 0.0
onready var _bomb = preload("res://prepa/bomb.tscn")
var bb:= false
var id:=0

var pl_name:= ""

func init(_id:int, _name:String,_pos:Vector3)->void:
	rotation_degrees.y = 180
	id = _id
	global_transform.origin = _pos
	pl_name = _name
	if id == get_tree().get_network_unique_id():
		$MeshInstance.mesh= load("res://vox/player" + str(1)+ ".vox")
	else:
		$MeshInstance.mesh= load("res://vox/player" + str(2)+ ".vox")

remote func _set_position(pos):
	global_transform.origin = pos
	
remote func _set_rotation(rot):
	$MeshInstance.rotation.y = rot

func skin()-> void:
	if name == "1":
		$MeshInstance.mesh= load("res://vox/player" + str(1)+ ".vox")
	else:
		$MeshInstance.mesh= load("res://vox/player" + str(2)+ ".vox")

func _process(_delta: float) -> void:
	if id == get_tree().get_network_unique_id():
		dir = Vector3.ZERO
		if Input.is_action_pressed("ui_right"):dir=Vector3.RIGHT
		if Input.is_action_pressed("ui_left") :dir=Vector3.LEFT
		if Input.is_action_pressed("ui_up")   :dir=Vector3.FORWARD
		if Input.is_action_pressed("ui_down") :dir=Vector3.BACK
		
		if dir != Vector3.ZERO and old_dir!= dir:
			old_dir = dir
			$ray.cast_to= old_dir *-2
			$ray.force_raycast_update()


#		if Input.is_action_just_pressed("action"):
#			var bomb= _bomb.instance()
#			get_parent().add_child(bomb)
#			var x: = (floor(self.translation.x /2) * 2) + 1.0
#			var z: = (floor(self.translation.z /2) * 2) + 1.0
#			bomb.translation = Vector3(x,0,z)
		
		if dir != Vector3.ZERO:
			ang = (Vector2(dir.x,-1 * dir.z).angle() -PI/2  )
		$MeshInstance.rotation.y = lerp_angle($MeshInstance.rotation.y, ang,0.35)
			
		if dir!= Vector3.ZERO and not $tw.is_active() and not $ray.is_colliding():
			var a = self.translation
			var b = a + (dir*2)
			$tw.interpolate_property(self, "translation", a,b,0.1,Tween.TRANS_LINEAR,Tween.EASE_OUT)
			$tw.start()
		
		rpc_unreliable("sync_player", global_transform.origin, $MeshInstance.rotation.y)

			
remote func sync_player(pos:Vector3, rot:float)->void:
	global_transform.origin = pos
	$MeshInstance.rotation.y = rot
	
func hit()-> void:
	print("dead")

