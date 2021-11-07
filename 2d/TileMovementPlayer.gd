###
# A player that moves from tile-to-tile. With walk animation.
# It collides with any solid tiles/entities (e.g. StaticBody2D)
# that are on the first collision layer.
###
extends Area2D

export var tile_size:int = 32
# Time to move from tile to tile; should match animation time.
export var movement_seconds:float = 0.6

const _INPUT_DIRECTIONS:Dictionary = {
	"ui_right": Vector2.RIGHT,
	"ui_left": Vector2.LEFT,
	"ui_up": Vector2.UP,
	"ui_down": Vector2.DOWN
}

# Used to detect if we're touching anything solid
onready var _ray:RayCast2D = $RayCast2D

onready var _tween:Tween = $Tween
onready var _animation_player = $AnimationPlayer # walk animation

func _process(_delta):
	if _tween.is_active(): # currently moving
		return
		
	for action in _INPUT_DIRECTIONS.keys():
		
		if Input.is_action_pressed(action):
			self._move(action)
			break

func _move(action:String):
	_ray.cast_to = _INPUT_DIRECTIONS[action] * tile_size
	# Calculate now, not the next physics frame.
	_ray.force_raycast_update()
	
	if !_ray.is_colliding():
		var destination = self.position + (_INPUT_DIRECTIONS[action] * tile_size)
		# Sine + ease: start moving slowly and then snap into position
		_tween.interpolate_property(self, "position", self.position, destination, movement_seconds, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		_tween.start()
		
		var animation_name = action.substr(action.find("ui_") + 3)
		_animation_player.stop()
		# Expections an animation like walk_up
		_animation_player.play("walk_%s" % animation_name)
