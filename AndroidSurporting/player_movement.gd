extends Control

# 摇杆的灵敏度和最大偏移范围
var sensitivity: float = 100.0
var max_offset: float = 40.0

# 当前摇杆的位置
var input_vector: Vector2 = Vector2.ZERO

func _ready():
	# 初始化手柄位置
	$JoyStick.position = Vector2.ZERO

func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		# 开始拖动摇杆
		_start_drag(event.position)
	elif event is InputEventScreenDrag:
		# 拖动摇杆
		_drag(event.position)
	elif event is InputEventScreenTouch and not event.pressed:
		# 释放摇杆
		_release()

func _start_drag(touch_position: Vector2) -> void:
	# 计算并限制手柄位置
	var offset = touch_position - $JoyStick.position
	offset = offset.clamped(max_offset)  # 限制最大偏移
	$Handle.position = offset
	input_vector = offset / max_offset  # 规范化输入向量

func _drag(touch_position: Vector2) -> void:
	# 继续拖动
	var offset = touch_position - $JoyStick.position
	offset = offset.clamped(max_offset)  # 限制最大偏移
	$Handle.position = offset
	input_vector = offset / max_offset  # 规范化输入向量

func _release() -> void:
	# 重置摇杆位置
	$Handle.position = Vector2.ZERO
	input_vector = Vector2.ZERO  # 重置输入向量
