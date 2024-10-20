extends CharacterBody3D

@onready var Camera = $Camera3D
@onready var RayCast = $Camera3D/RayCast3D
const SPEED = 3.0
const JUMP_VELOCITY = 2.0
const SENSITIVITY = 1.0

var mouse_position:Vector2

const pick_distance:float = 1.5

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	# 启用 RayCast
	RayCast.enabled = true



func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	"""var movement_vector:Vector3
	
	var acc = b2i(Input.is_action_pressed("move_right")) - b2i(Input.is_action_pressed("move_left"))
	if is_on_floor() and acc:
		movement_vector.x += acc
	else:
		velocity.x *= 0.8
	
	acc = b2i(Input.is_action_pressed("move_back")) - b2i(Input.is_action_pressed("move_forward"))
	if is_on_floor() and acc:
		movement_vector.z += acc
	else:
		velocity.z *= 0.8
	
	velocity += movement_vector.normalized() *SPEED
	
	velocity.x = clamp(velocity.x, -SPEED * 2, SPEED * 2)  
	velocity.z = clamp(velocity.z, -SPEED * 2, SPEED * 2) """
	
	if is_on_floor():
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x *= 0.8
			velocity.z *= 0.8
			#velocity.x = move_toward(velocity.x, 0, SPEED)
			#velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.keycode == KEY_E:
		# 检查是否有碰撞
		if RayCast.is_colliding():
			var collider = RayCast.get_collider()
			# 获取相机的位置和朝向
			var collider_old_rotation = collider.rotation
			collider.look_at(Camera.rotation.normalized())
			collider.position = position + Vector3(0,0,1)
			collider.rotation = collider_old_rotation
			
			
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x *SENSITIVITY *0.2))
		Camera.rotate_x(deg_to_rad(-event.relative.y *SENSITIVITY *0.2))
		Camera.rotation.x = clamp(Camera.rotation.x, -PI/2, PI/2)
		
func b2i(boolvar) -> int:#bool to int
	if boolvar:
		return 1
	else:
		return 0
