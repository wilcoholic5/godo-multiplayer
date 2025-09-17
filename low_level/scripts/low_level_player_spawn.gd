extends Node
const LOW_LEVEL_NETWORK_PLAYER = preload("uid://ds0fi1qymms48")

func _ready() -> void:
	LowLevelNetwork.on_peer_connected.connect(spawn_player)
	ClientNetworkGlobals.handle_local_id_assignment.connect(spawn_player)
	ClientNetworkGlobals.handle_remote_id_assignment.connect(spawn_player)

func spawn_player(id: int) -> void:
	var player = LOW_LEVEL_NETWORK_PLAYER.instantiate()
	player.owner_id = id
	player.name = str(id)
	
	call_deferred("add_child", player)
