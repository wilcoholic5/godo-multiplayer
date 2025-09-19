extends Control

func _on_client_pressed() -> void:
	LowLevelNetwork.start_client($buttons/ip_address.text, int($buttons/port.text))

func _on_server_pressed() -> void:
	LowLevelNetwork.start_server($buttons/ip_address.text, int($buttons/port.text))
