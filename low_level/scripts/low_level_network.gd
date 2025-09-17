extends Node

# Server signals
signal on_peer_connected(peer_id: int)
signal on_peer_disconnected(peer_id: int)
signal on_server_packet(peer_id: int, data: PackedByteArray)

# Client Signals
signal on_connected_to_server()
signal on_disconnected_from_server()
signal on_client_packet(data: PackedByteArray)

# Server variables
var available_peer_ids: Array = range(255, -1, -1)
var client_peers: Dictionary[int, ENetPacketPeer]

# Client Variables
var server_peer: ENetPacketPeer

# General Variables
var connection: ENetConnection
var is_server: bool = false

func _process(delta: float) -> void:
	if connection == null:
		return
	#print("listening for updates. is server = ", is_server)
	handle_events()

func handle_events() -> void:
	var packet_event: Array = connection.service()
	var event_type: ENetConnection.EventType = packet_event[0]
	
	while event_type != ENetConnection.EVENT_NONE:
		var peer: ENetPacketPeer = packet_event[1]
		match event_type:
			ENetConnection.EVENT_ERROR:
				push_warning("Unknown error")
				return
			ENetConnection.EVENT_CONNECT:
				if is_server:
					peer_connected(peer)
				else:
					connected_to_server()
			ENetConnection.EVENT_DISCONNECT:
				if is_server:
					peer_disconnected(peer)
				else:
					disconnected_from_server()
					return
			ENetConnection.EVENT_RECEIVE:
				if is_server:
					#print('skip')
					on_server_packet.emit(peer.get_meta("id"), peer.get_packet())
				else:
					print('skip')
					on_client_packet.emit(peer.get_packet())
		packet_event = connection.service()
		event_type = packet_event[0]
		
func peer_connected(peer: ENetPacketPeer) -> void:
	var peer_id: int = available_peer_ids.pop_back()
	peer.set_meta("id", peer_id)
	client_peers[peer_id] = peer
	print("Peer connected with assigned id: ", peer_id)
	on_peer_connected.emit(peer_id)
	
func peer_disconnected(peer: ENetPacketPeer) -> void:
	var peer_id: int = peer.get_meta("id")
	available_peer_ids.push_back(peer_id)
	client_peers.erase(peer_id)
	print("Successfully disconnected: ", peer_id, " from server")
	on_peer_disconnected.emit()
	
func connected_to_server() -> void:
	print("Successfully connected to server")
	on_connected_to_server.emit()
	
func disconnected_from_server() -> void:
	print("Disconnected from server")
	on_disconnected_from_server.emit()
	connection = null

func start_server(ip_address: String = "127.0.0.1", port: int = 42069) -> void:
	connection = ENetConnection.new()
	var error: Error = connection.create_host_bound(ip_address, port)
	if error:
		print("Server starting failed: ", error_string(error))
	
	print("Server started")
	is_server = true
	
func start_client(ip_address: String = "127.0.0.1", port: int = 42069) -> void:
	connection = ENetConnection.new()
	var error: Error = connection.create_host(1)
	if error:
		print("Client starting failed: ", error_string(error))
		connection = null
		return
	
	print("Client Started")
	server_peer = connection.connect_to_host(ip_address, port)

func disconnect_client() -> void:
	if is_server:
		return
		
	server_peer.peer_disconnect()
