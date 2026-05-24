extends Marker2D


@export var character_name: String = ""
@export var balloon_color: Color = Color.WHITE
@export var text_color: Color = Color.BLACK


func _ready() -> void:
	add_to_group("dialogue_markers")
