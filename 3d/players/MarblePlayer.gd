extends KinematicBody

onready var _camera =  $CameraPivot/Camera
onready var _camera_pivot = $CameraPivot
onready var _pivot = $Pivot
onready var _mesh = $Pivot/CSGMesh

const _SPEED:int = 1
const _FALL_ACCELERATION:int = 75
const _DECAY_PER_SECOND:float = 1.0

const _SPIN_DAMPENER:float = 0.15
const _CAMERA_ROTATION_SPEED:int = 100

var velocity = Vector3.ZERO

func _physics_process(delta):
	# We create a local variable to store the input direction.
	var direction = Vector3.ZERO
	# relative to CAMERA boi
	var camera_transform = _camera.get_global_transform()

	# We check for each move input and update the direction accordingly.
	if Input.is_action_pressed("ui_right"):
		direction += camera_transform.basis[0]
	if Input.is_action_pressed("ui_left"):
		direction -= camera_transform.basis[0]
	if Input.is_action_pressed("ui_down"):
		# Notice how we are working with the vector's x and z axes.
		# In 3D, the XZ plane is the ground plane.
		direction += camera_transform.basis[2]
	if Input.is_action_pressed("ui_up"):
		direction -= camera_transform.basis[2]

	if direction != Vector3.ZERO:
		direction = direction.normalized()
	
	_mesh.material.albedo_color = _current_ability.get_ability_color()
	
	# MOVE
	var multiplier = _current_ability.get_velocity_multiplier()
	velocity.x += direction.x * _SPEED * multiplier
	velocity.z += direction.z * _SPEED * multiplier
	velocity.y -= _FALL_ACCELERATION * delta	
	velocity = move_and_slide(velocity, Vector3.UP)
	
	# SLOW DOWN
	velocity.x -= velocity.x * _DECAY_PER_SECOND * delta
	velocity.z -= velocity.z * _DECAY_PER_SECOND * delta

	# SPIN
	var spin_vector = Vector3(velocity.z, 0, -velocity.x) * _SPIN_DAMPENER
	_pivot.rotation_degrees += _pivot.transform.origin + spin_vector

	# Sharp stop if slow enough
	if velocity.length() <= 0.1:
		velocity = Vector3.ZERO
	
func _process(delta):
	if Input.is_action_pressed("rotate_camera_clockwise"):
		_camera_pivot.rotation_degrees.y += _CAMERA_ROTATION_SPEED * delta
	elif Input.is_action_pressed("rotate_camera_counterclockwise"):
		_camera_pivot.rotation_degrees.y -= _CAMERA_ROTATION_SPEED * delta
	
