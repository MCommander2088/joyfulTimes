extends CharacterBody3D

@onready var Camera = $Camera3D
@onready var RayCast = $Camera3D/RayCast3D
@onready var TestingLabel = $TestGui/Label
@onready var audioplayer1 = $PlayerUi/mouseclick
@onready var audioplayer2 = $PlayerUi/mouserelease

const SPEED = 3.0
const JUMP_VELOCITY = 2.0
const SENSITIVITY = 1.0

var mouse_position:Vector2

var collider = null
var is_catching = false
var pick_distance:float = 1.0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	# 启用 RayCast
	RayCast.enabled = true

# Change TestGUI Label
func _process(delta: float) -> void:
	TestingLabel.text = "position: x:{0} y:{1} z:{2}\nrotation: x:{3} y:{4} z:{5}\nRayCast is Catching: {6}\nBool IS_CATCHING: {7}".format([position.x,position.y,position.z,Camera.rotation.x,rotation.y,rotation.z,collider,is_catching])

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("action_pick"):
		if is_catching:
			audioplayer2.play()
			if collider is RigidBody3D:
				collider.simplebox_set_gravity_scale(collider.GRAVITY_SCALE)
			collider = null
			is_catching = not is_catching
		elif RayCast.get_collider() != null:
			if collider_statue(RayCast.get_collider()):
				collider = RayCast.get_collider()
				print("\nAn Object is Picked.Information:")
				print("Camera Position:"+str(Camera.position))
				print("Type of Collider:"+str(typeof(collider)))
				print("Collider Position:"+str(collider.global_transform.origin))
				pick_distance = get_collider_distance(collider)/2
				print("Pick Distance:"+str(pick_distance))
				audioplayer1.play()
				is_catching = not is_catching
	
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

	if is_catching:
		if collider is RigidBody3D:
			collider.simplebox_set_gravity_scale(0.0)
		
		var old_rotation:Vector3 = collider.rotation
		# 获取摄像机的位置  
		var camera_position = Camera.global_transform.origin  
		  
		# 获取摄像机的前方向量（通常是它的Z轴负方向，取决于摄像机的朝向）  
		# 注意：这里我们假设摄像机是面向玩家的，即它的-Z轴是前方  
		# 在Godot中，摄像机的forward方向通常是它的-Z轴  
		var camera_forward:Vector3 = -Camera.global_transform.basis.z  # 获取Z轴并取反，因为Godot中摄像机面向-Z  
		  
		# 计算目标位置：摄像机位置 + 摄像机前方向量 * 距离  
		var target_position:Vector3 = camera_position + camera_forward.normalized() * pick_distance
		
		var target_rotation:Vector3 = target_position-collider.position
		# 现在你可以使用target_position来做一些事情，比如移动一个节点到那里  
		# 例如，如果你有一个StaticBody3D节点，你可以这样设置它的位置：  
		collider.global_transform.origin += (target_position - collider.global_transform.origin)*0.1

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x *SENSITIVITY *0.2))
		Camera.rotate_x(deg_to_rad(-event.relative.y *SENSITIVITY *0.2))
		Camera.rotation.x = clamp(Camera.rotation.x, -PI/2, PI/2)
		
func b2i(boolvar) -> int:#bool to int
	if boolvar:
		return 1
	else:
		return 0

func collider_statue(collider):
	if collider != null and not collider is CharacterBody3D and not collider is StaticBody3D and not collider is CollisionShape3D:
		return true
	else:
		return false

func get_collider_distance(object) -> float:
	var distance = (object.position - Camera.position).length()
	if distance <= 2:
		distance = 2
	return distance
