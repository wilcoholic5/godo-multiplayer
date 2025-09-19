class_name PlayerTransform extends PacketInfo

var id: int
var position: Vector2
var rotation: float
var data_map: Dictionary[String, int] = {
	"id" = 1,
	"pos_x" = 2,
	"pos_y" = 6,
	"rotation" = 10,
}

static func create(p_id: int, p_position: Vector2, p_rotation: float) -> PlayerTransform:
	var info: PlayerTransform = PlayerTransform.new()
	info.packet_type = PACKET_TYPE.PLAYER_TRANSFORM
	info.flag = ENetPacketPeer.FLAG_UNSEQUENCED
	info.id = p_id
	info.position = p_position
	info.rotation = p_rotation
	return info

static func create_from_data(data: PackedByteArray) -> PlayerTransform:
	var info: PlayerTransform = PlayerTransform.new()
	info.decode(data)
	return info

func encode() -> PackedByteArray:
	var data: PackedByteArray = super.encode()
	data = add_id(data, id)
	data = add_float(data, position.x)
	data = add_float(data, position.y)
	data = add_float(data, rotation)
	return data
	
func decode(data: PackedByteArray) -> void:
	super.decode(data)
	id = data.decode_u8(1)
	position = Vector2(data.decode_float(data_map["pos_x"]), data.decode_float(data_map["pos_y"]))
	rotation = data.decode_float(data_map["rotation"])
