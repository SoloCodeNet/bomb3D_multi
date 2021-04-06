extends Node2D

func _ready() -> void:
	var _e = get_tree().connect("network_peer_connected", self, "player_connected")
	pass

func _on_btn_host_pressed() -> void:
	var net = NetworkedMultiplayerENet.new()
	net.create_server(7070, 4)
	get_tree().set_network_peer(net)
	print("hosting")

func _on_btn_join_pressed() -> void:
	var net = NetworkedMultiplayerENet.new()
	net.create_client("127.0.0.1", 7070)
	get_tree().set_network_peer(net)
	print("join")
	
func player_connected(id:int)->void:
	GLOBAL.player2id = id
	var game = preload("res://prepa/scene0.tscn").instance()
	get_tree().get_root().add_child(game)
	hide()
	

