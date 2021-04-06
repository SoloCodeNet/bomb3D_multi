extends CanvasLayer
onready var _enemy   = preload("res://prepa/enemy.tscn")
onready var _player = preload("res://prepa/player.tscn")
onready var node_player   = get_parent().get_node("players")
onready var node_position = get_parent().get_node("positions")
onready var node_enemy    = get_parent().get_node("enemies")

var ip:= "localhost"
var txt_name:=""
var player_name:= ""
const PORT = 27015
const MAX_PLAYERS = 3
var nb_pl:=0
var nb_en:=3
var _err
var ii = 0

func _on_host_pressed() -> void:
	if txt_name.length()>2:
		player_name = txt_name
		create_server()
		#better to use unique id
		create_player(get_tree().get_network_unique_id())
		create_enemy(true)
	else:
		$UI/vb/pl_name.text = ""

func _on_join_pressed() -> void:
	if txt_name.length()>2:
		player_name = txt_name
		create_client()
	else:
		$UI/vb/pl_name.text = ""

func _on_pl_name_text_changed(new_text: String) -> void:
	txt_name = new_text

func create_server():
	_err= get_tree().connect("network_peer_connected",    self, "_on_peer_connected")
	_err= get_tree().connect("network_peer_disconnected", self, "_on_peer_disconnected")
	var network = NetworkedMultiplayerENet.new()
	network.create_server(PORT, MAX_PLAYERS)
	get_tree().set_network_peer(network)
	$UI.visible = false
	get_parent().is_running = true
	
func create_client():
	_err= get_tree().connect("connected_to_server", self, "_on_connected_to_server")
	var network = NetworkedMultiplayerENet.new()
	network.create_client(ip, PORT)
	get_tree().set_network_peer(network)
	$UI.visible = false
	get_parent().is_running = true
	
remotesync func create_player(id:int, new_player_name:String = player_name, new_nb_pl=nb_pl)->void:
	var p = _player.instance()
	p.name = str(id)
	$master.text = 'Master : ' + str(is_network_master())
	node_player.add_child(p)
	var pos = node_position.get_node("pos"+str(new_nb_pl)).global_transform.origin
	p.init(id, new_player_name, pos)
	
remotesync func create_enemy(is_master:bool)->void:
	var e = _enemy.instance()
	node_enemy.add_child(e)
	var pos = node_position.get_node("pos3").global_transform.origin
	e.initialize(pos, "enemy1", is_master)
	e.start()

master func register_player(id:int, new_player_name:String):
	if id in get_tree().get_network_connected_peers():
		#nb player must be sync too to get good pos
		nb_pl=(nb_pl+1)%4
		rpc("create_player",id,new_player_name,nb_pl)
		
func _on_peer_connected(id):
	#as master send players to new player to sync the game
	if is_network_master():
		for pl in get_tree().get_network_connected_peers():
			if pl!=id:
				rpc_id(id,"create_player",pl, node_player.get_node(str(pl)).pl_name)
		rpc_id(id,"create_player",get_tree().get_network_unique_id(),player_name)
		
func _on_connected_to_server():
	#Don't create user directly, ask master to be registered
	var id = get_tree().get_network_unique_id()
	rpc("register_player",id, player_name)
	# for the enemy
	rpc("create_enemy", false)
	$connected.text = "connected ! ID : " + str(id)

func _on_peer_disconnected(id):
	if node_player.has_node(str(id)):
		node_player.get_node(str(id)).queue_free()
		nb_pl-=1
