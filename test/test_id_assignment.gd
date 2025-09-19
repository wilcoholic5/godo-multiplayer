extends GutTest

func test_create_id_assignment() -> void:
	var id_assignment: IDAssignment = IDAssignment.create(5, [1,2,3])
	assert_is(id_assignment, IDAssignment)
	
func test_encode() -> void:
	var id_assignment: IDAssignment = IDAssignment.create(5, [1,2,100])
	var encoded: PackedByteArray = id_assignment.encode()
	assert_eq(encoded[0], PacketInfo.PACKET_TYPE.ID_ASSIGNMENT)
	assert_eq(encoded[1], 5)
	assert_eq(encoded[2], 1)
	assert_eq(encoded[3], 2)
	assert_eq(encoded[4], 100)
	assert_eq(encoded.size(), 5)

func test_create_from_data() -> void:
	var id_assignment: IDAssignment = IDAssignment.create_from_data([0, 10, 1, 255])
	assert_eq(id_assignment.id, 10)
	assert_eq(id_assignment.remoted_ids, [1,255])
