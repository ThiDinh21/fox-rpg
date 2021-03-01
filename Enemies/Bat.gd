extends KinematicBody2D

export(int) var ACCELERATION = 300
export(int) var MAX_SPEED = 50
export(int) var FRICTION = 200

enum {
	IDLE,
	WANDER,
	CHASE,
}

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

onready var stats = $Stats
onready var sprite = $Sprite
onready var hurtbox = $Hurtbox
onready var softCollisions = $SoftCollision
onready var wanderController = $WanderController

var state = IDLE
var target = null

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			if wanderController.get_time_left() == 0:
				renew_state()
		WANDER:
			if wanderController.get_time_left() == 0:
				renew_state()
			var wander_target = wanderController.target_position
			move_toward_target(wander_target, delta)
			if global_position.distance_to(wander_target) <= 4:
				renew_state()
		CHASE:
			if target != null:
				move_toward_target(target.global_position, delta)
			else:
				state = IDLE
	sprite.flip_h = (velocity.x < 0)
	if softCollisions.is_colliding():
		velocity += softCollisions.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()
	
func renew_state():
	state = pick_random_state([IDLE, WANDER])
	wanderController.set_wander_timer(rand_range(1, 3))

func move_toward_target(target, delta):
	var direction = global_position.direction_to(target)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 100
	hurtbox.create_hit_effect()

func _on_Stats_no_health():
	queue_free()
	var enemtDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemtDeathEffect)
	enemtDeathEffect.position = position

func _on_PlayerDetectionZone_body_entered(body):
	state = CHASE
	target = body

func _on_PlayerDetectionZone_body_exited(_body):
	state = IDLE
	target = null
