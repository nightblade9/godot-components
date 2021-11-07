###
# A player that moves freely from place to place (like Chrono Trigger).
# Collides with anything solid (e.g. RigidBody2D).
# Incomplete: doesn't have per-direction animations yet.
###
extends KinematicBody2D

const SPEED:int = 100 # pixels per second

var _can_move = true
var _input_handler:Object = Input # Injectable and unit-testable

func initialize(input_handler):
	self._input_handler = input_handler

func freeze():
	_can_move = false
	$AnimationPlayer.stop()

func unfreeze():
	_can_move = true

func _physics_process(delta):
	if not _can_move:
		return
		
	var vx:int = 0
	var vy:int = 0
	
	if _input_handler.is_action_pressed("ui_left"):
		vx = -1
	elif _input_handler.is_action_pressed("ui_right"):
		vx = 1
	
	if _input_handler.is_action_pressed("ui_up"):
		vy = -1
	elif _input_handler.is_action_pressed("ui_down"):
		vy = 1
	
	self.move_and_slide(Vector2(vx, vy) * SPEED)
	if vx == 0 and vy == 0:
		$AnimationPlayer.stop()
	elif not $AnimationPlayer.is_playing():
		# TODO: needs per-direction animation
		$AnimationPlayer.play("walk")
