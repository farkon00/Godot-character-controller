extends KinematicBody2D

export var jump_height: float = 150
export var jump_time: float = 0.45
export var jump_scaler: Vector3 = Vector3(2, 0.4, 3)

export var min_gravity: float = 210
export var gravity_incr: float = 1.7

export var in_air_move_mult: float = 0.8
export var max_move: float = 450
export var move_incr: float = 4300
export var move_decr: float = 3500
export var start_move_vel: float = 50

export var jump_req_time: float = 0.2


var jump_vel: float = 0
var move_vel: float = 0
var jump_completed: float = 0

var left_released: bool = false
var right_released: bool = false
var on_floor: bool = false
var is_jumping: bool = false

var jump_mul: float = jump_scaler[0]
var gravity_mult: float = 1

var jump_req_left: float = 0

func check_move(delta: float) -> void:
	var inputXDir = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	var xDir = sign(move_vel)
	var air_mult: float = 1
	if not on_floor:
		air_mult = in_air_move_mult
	if inputXDir != 0:
		if move_vel == 0 or (xDir != sign(inputXDir)):
			move_vel = inputXDir * start_move_vel
		elif move_vel * inputXDir < max_move:
			move_vel = move_vel + (move_incr * delta * inputXDir)
	elif move_vel != 0:
		move_vel = move_vel - (move_decr * delta * xDir)
		if sign(move_vel) != xDir:
			move_vel = 0
	
	var	__ = move_and_collide(Vector2(move_vel * delta * air_mult, 0))

func check_gravity(delta: float) -> void:
	if is_jumping:
		return
	var collide = move_and_collide(Vector2(0, (gravity_mult + gravity_incr) * min_gravity * delta)) 
	on_floor = collide != null
	if on_floor:
		on_floor = collide.get_angle() == 0
	if on_floor:
		gravity_mult = 1

func check_jump(delta: float) -> void:
	if Input.is_action_just_pressed("jump") or jump_req_left > 0:
		if on_floor:
			jump_mul = jump_scaler[0]
			jump_completed = 0
			jump_vel = jump_height/jump_time*jump_mul
			on_floor = false
			is_jumping = true
		elif jump_req_left <= 0:
			jump_req_left = jump_req_time
	if is_jumping:
		jump_vel = jump_height/jump_time*jump_mul
		jump_completed += jump_height/jump_time*jump_mul*delta
		jump_mul -= jump_scaler[2]*delta
		if jump_mul < jump_scaler[1]:
			jump_mul = jump_scaler[1]
		if jump_completed > jump_height:
			jump_vel = 0
			is_jumping = false
		var __ = move_and_collide(Vector2(0, -jump_vel * delta)) 

		jump_req_left -= delta
		if jump_req_left < 0:
			jump_req_left = 0


func _process(delta: float) -> void:
	check_move(delta)
	check_gravity(delta)
	check_jump(delta)
