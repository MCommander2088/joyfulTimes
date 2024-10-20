extends Node2D

@onready var animp = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animp.play("author_show_hide")


func _input(event: InputEvent) -> void:
	if event is InputEventKey or event is InputEventMouseButton:
		get_tree().change_scene_to_file("res://maps/t_demo1/t_demo1.tscn")
