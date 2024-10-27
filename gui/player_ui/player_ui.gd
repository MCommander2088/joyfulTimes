extends Control

@onready var parent = $"../"
@onready var RayCast = $"../Camera3D/RayCast3D"
@onready var animplayer = $AnimationPlayer

var is_showed = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var collider = RayCast.get_collider()
	var collider_s = collider_statue(collider)
	if collider_s and not is_showed:
		animplayer.play("pick_show")
		is_showed = not is_showed
	if collider_s and is_showed:
		animplayer.play("pick_hide")
		is_showed = not is_showed
		
func collider_statue(collider):
	if collider != null and not collider is CharacterBody3D and not collider is StaticBody3D and not parent.is_catching:
		return true
	else:
		return false
