extends RigidBody3D

const GRAVITY_SCALE = 1.0

func _ready() -> void:
	self.gravity_scale = GRAVITY_SCALE

func simplebox_set_gravity_scale(SCALE:float):
	self.gravity_scale = float(SCALE)
