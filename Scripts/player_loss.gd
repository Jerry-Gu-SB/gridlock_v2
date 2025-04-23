extends Control

signal retry_requested

func _on_button_pressed() -> void:
	retry_requested.emit()
	self.visible = false
