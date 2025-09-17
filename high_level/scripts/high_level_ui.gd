extends Control


func _on_client_pressed() -> void:
	print('clickeddd')
	HighLevelNetwork.start_client()


func _on_server_pressed() -> void:
	HighLevelNetwork.start_server()
