extends Control

func _on_client_pressed() -> void:
	LowLevelNetwork.start_client()

func _on_server_pressed() -> void:
	LowLevelNetwork.start_server()
