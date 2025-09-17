extends Node

signal handle_player_position(peer_id: int, player_position: PlayerPosition)
signal handle_player_rotation(peer_id: int, player_rotation: PlayerRotation)

var peer_ids: Array[int]

func _ready() -> void:
	LowLevelNetwork.on_peer_connected.connect(on_peer_connected)
	LowLevelNetwork.on_peer_disconnected.connect(on_peer_disconnected)
	LowLevelNetwork.on_server_packet.connect(on_server_packet)
	
func on_peer_connected(peer_id: int) -> void:
	peer_ids.append(peer_id)
	IDAssignment.create(peer_id, peer_ids).broadcast(LowLevelNetwork.connection)

func on_peer_disconnected(peer_id: int) -> void:
	peer_ids.erase(peer_id)
	
func on_server_packet(peer_id: int, data: PackedByteArray) -> void:
	var packet_type: int = data.decode_u8(0)
	match packet_type:
		PacketInfo.PACKET_TYPE.PLAYER_POSITION:
			handle_player_position.emit(peer_id, PlayerPosition.create_from_data(data))
		PacketInfo.PACKET_TYPE.PLAYER_ROTATION:
			handle_player_rotation.emit(peer_id, PlayerRotation.create_from_data(data))
		_:
			push_error("Packet type unhandled")
