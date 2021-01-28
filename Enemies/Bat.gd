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
var state = IDLE
var target = null

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		WANDER:
			pass
		CHASE:
			if target != null:
				var direction = (target.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	
	sprite.flip_h = (velocity.x < 0)
	velocity = move_and_slide(velocity)

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 100

func _on_Stats_no_health():
	queue_free()
	var enemtDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemtDeathEffect)
	enemtDeathEffect.position = position

func _on_PlayerDetectionZone_body_entered(body):
	state = CHASE
	target = body

func _on_PlayerDetectionZone_body_exited(body):
	state = IDLE
	target = null
