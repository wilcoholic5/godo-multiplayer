class_name PlayerRotation extends PacketInfo

var id: int
var rotation: float

static func create(id: int, rotation: float) -> PlayerRotation:
	var info: PlayerRotation = PlayerRotation.new()
	info.packet_type = PACKET_TYPE.PLAYER_ROTATION
	info.flag = ENetPacketPeer.FLAG_UNSEQUENCED
	info.id = id
	info.rotation = rotation
	return info

static func create_from_data(data: PackedByteArray) -> PlayerRotation:
	var info: PlayerRotation = PlayerRotation.new()
	info.decode(data)
	return info

func encode() -> PackedByteArray:
	var data: PackedByteArray = super.encode()
	data.resize(10)
	data.encode_u8(1, id)
	data.encode_float(2, rotation)
	return data
	
func decode(data: PackedByteArray) -> void:
	super.decode(data)
	id = data.decode_u8(1)
	rotation = data.decode_float(2)
	
