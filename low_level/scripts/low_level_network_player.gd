extends CharacterBody2D

const SPEED: float = 500

var owner_id: int
var previous_pos: Vector2
var is_authority: bool:
	get: return !LowLevelNetwork.is_server && owner_id == ClientNetworkGlobals.id

func _enter_tree() -> void:
	ServerNetworkGlobals.handle_player_position.connect(server_handle_player_position)
	ClientNetworkGlobals.handle_player_position.connect(client_handle_player_position)
	ServerNetworkGlobals.handle_player_rotation.connect(server_handle_player_rotation)
	ClientNetworkGlobals.handle_player_rotation.connect(client_handle_player_rotation)
	$Label.text = str(owner_id)

func _exit_tree() -> void:
	ServerNetworkGlobals.handle_player_position.disconnect(server_handle_player_position)
	ClientNetworkGlobals.handle_player_position.disconnect(client_handle_player_position)

func _physics_process(delta: float) -> void:
	if !is_authority:
		return
		
	velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * SPEED
	if Input.is_action_pressed("rotate"):
		print('rotating?')
		rotation_degrees += 10*delta
		PlayerRotation.create(owner_id, rotation_degrees).send(LowLevelNetwork.server_peer)
	
	move_and_slide()
	#if not velocity.is_zero_approx():
	if global_position != previous_pos:
		PlayerPosition.create(owner_id, global_position).send(LowLevelNetwork.server_peer)
	previous_pos = global_position
	
func server_handle_player_position(peer_id: int, player_position: PlayerPosition) -> void:
	if owner_id != peer_id:
		return
	global_position = player_position.position
	PlayerPosition.create(owner_id, global_position).broadcast(LowLevelNetwork.connection)

func client_handle_player_position(player_position: PlayerPosition) -> void:
	if is_authority || owner_id != player_position.id:
		return
	global_position = player_position.position
	
func server_handle_player_rotation(peer_id: int, player_rotation: PlayerRotation) -> void:
	if owner_id != peer_id:
		return
	rotation_degrees = player_rotation.rotation
	PlayerRotation.create(owner_id, rotation_degrees).broadcast(LowLevelNetwork.connection)

func client_handle_player_rotation(player_rotation: PlayerRotation) -> void:
	if is_authority || owner_id != player_rotation.id:
		return
	rotation_degrees = player_rotation.rotation
