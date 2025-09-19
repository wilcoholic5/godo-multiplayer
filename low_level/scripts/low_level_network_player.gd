extends CharacterBody2D

const SPEED: float = 500

var owner_id: int
var previous_pos: Vector2
var is_authority: bool:
	get: return !LowLevelNetwork.is_server && owner_id == ClientNetworkGlobals.id
var should_update_player_transform = false

func _enter_tree() -> void:
	ClientNetworkGlobals.handle_player_transform.connect(client_handle_player_transform)
	ServerNetworkGlobals.handle_player_transform.connect(server_handle_player_transform)
	$Label.text = str(owner_id)

func _exit_tree() -> void:
	ClientNetworkGlobals.handle_player_transform.disconnect(client_handle_player_transform)
	ServerNetworkGlobals.handle_player_transform.disconnect(server_handle_player_transform)

func _physics_process(delta: float) -> void:
	if !is_authority:
		return
		
	velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * SPEED
	if Input.is_action_pressed("rotate"):
		print('rotating?')
		rotation_degrees += 500*delta
		should_update_player_transform = true
	
	move_and_slide()
	if global_position != previous_pos:
		should_update_player_transform = true
		
	if should_update_player_transform:
		PlayerTransform.create(owner_id, global_position, rotation_degrees).send(LowLevelNetwork.server_peer)
	
	previous_pos = global_position
	should_update_player_transform = false
	
func server_handle_player_transform(peer_id: int, player_transform: PlayerTransform) -> void:
	if owner_id != peer_id:
		return
	rotation_degrees = player_transform.rotation
	global_position = player_transform.position
	PlayerTransform.create(owner_id, global_position, rotation_degrees).broadcast(LowLevelNetwork.connection)

func client_handle_player_transform(player_transform: PlayerTransform) -> void:
	if is_authority || owner_id != player_transform.id:
		return
	rotation_degrees = player_transform.rotation
	global_position = player_transform.position
