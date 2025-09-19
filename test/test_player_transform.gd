extends GutTest

func test_create_player_transform() -> void:
	var player_transform: PlayerTransform = PlayerTransform.create(5, Vector2(5, 10), 321.32)
	assert_is(player_transform, PlayerTransform)
	
func test_encode() -> void:
	var player_transform: PlayerTransform = PlayerTransform.create(5, Vector2(5, 10), 321.32)
	var encoded: PackedByteArray = player_transform.encode()
	assert_eq(encoded[0], PacketInfo.PACKET_TYPE.PLAYER_TRANSFORM)

func test_create_from_data() -> void:
	var player_transform_raw: PlayerTransform = PlayerTransform.create(5, Vector2(5, 10), 321.51)
	var player_transform: PlayerTransform = PlayerTransform.create_from_data(player_transform_raw.encode())
	assert_eq(player_transform.id, 5)
	assert_eq(player_transform.position, Vector2(5, 10))
	assert_eq(snapped(player_transform.rotation, 0.01), 321.51)
