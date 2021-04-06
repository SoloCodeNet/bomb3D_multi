extends StaticBody
var dir := Vector3.ZERO
var old_dir:=Vector3.ZERO
var ang:=0.0
var lst:=[]
var tm := 0.4

var master_clone:= false

func _ready() -> void:
	randomize()
	set_process(false)

func initialize(_pos, _name, is_master)->void:
	self.global_transform.origin = _pos
	set_name(_name)
	master_clone = is_master
	
func start():
	set_process(true)

func _process(_delta: float) -> void:
	if master_clone:
		movement()
		if dir != Vector3.ZERO:
			ang = (Vector2(dir.x*-1,dir.z).angle() -PI/2  )
		$MeshInstance.rotation.y = lerp_angle($MeshInstance.rotation.y, ang,0.35)
		rpc_unreliable("sync_enemy", global_transform.origin, $MeshInstance.rotation.y)
	
	
func movement()->void:
		$ray_d.force_raycast_update()
		$ray_l.force_raycast_update()
		$ray_r.force_raycast_update()
		$ray_u.force_raycast_update()
		
		if $tw.is_active() == false:
			if lst.size()>0 : lst.clear()
			if ! $ray_d.is_colliding():lst.append($ray_d.cast_to)
			if ! $ray_l.is_colliding():lst.append($ray_l.cast_to)
			if ! $ray_u.is_colliding():lst.append($ray_u.cast_to)
			if ! $ray_r.is_colliding():lst.append($ray_r.cast_to)
			
			if lst.size()>1:
				if lst.has(old_dir):
					var i = lst.find(old_dir)
					lst.remove(i)
					
			if lst.size()>0:
				dir= lst[randi()% lst.size()]
				old_dir = dir * -1

			var a = self.translation
			var b = a + dir
			$tw.interpolate_property(self, "translation", a,b, tm,Tween.TRANS_LINEAR,Tween.EASE_OUT)
			$tw.start()

remote func sync_enemy(pos:Vector3, rot:float)->void:
	global_transform.origin = pos
	$MeshInstance.rotation.y = rot
	
func hit()-> void:
	print("dead")
	call_deferred("queue_free")
